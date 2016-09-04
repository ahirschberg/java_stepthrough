import 'dart:async';
import 'dart:html';
import 'package:angular2/core.dart';
import 'package:ace/ace.dart' as ace;
import 'package:ace/proxy.dart';
import 'package:angular2/router.dart';
import 'package:code_steps/editor/ace_editor_component.dart';
import 'package:code_steps/editor/action_region_editor_component.dart';
import 'package:code_steps/editor/lesson_code_editor_component.dart';
import 'package:code_steps/lesson_io.dart';
import 'package:code_steps/lesson_serializer.dart';
import 'package:code_steps/code_guide_component.dart';
import 'package:code_steps/step_context_service.dart';
import 'package:observe/observe.dart';

@Component(
    selector: 'lesson-editor',
    templateUrl: 'html/lesson_editor_component.html',
    directives: const [
      ActionRegionEditorComponent,
      CodeGuideComponent,
      AceEditorComponent,
      LessonCodeEditorComponent
    ])
class LessonEditorComponent implements OnInit {
  StepContextService stepContextService;
  AceEditorComponent markdownEditor;
  LessonCodeEditorComponent codeEditor;
  StreamController editorInitStreamController = new StreamController.broadcast();
  List<String> explanations = [''];
  String lessonName;
  LessonIO _lessonIO;
  RouteParams _routeParams;

  LessonEditorComponent(this.stepContextService, this._routeParams, this._lessonIO);

  @override
  ngOnInit() {
    ace.implementation = ACE_PROXY_IMPLEMENTATION;
    editorInitStreamController.stream..listen((ace.Editor aceController) {
      aceController.theme = new ace.Theme.named(ace.Theme.SOLARIZED_DARK);
      aceController.keyboardHandler =
          new ace.KeyboardHandler.named(ace.KeyboardHandler.VIM);
    });
    editorInitStreamController.stream.take(2).drain().then((_) {
      lessonName = _routeParams.get('lesson_name');
      if (lessonName != null) serializedRetrieve();
    });
    stepContextService.onStepChange.listen((PropertyChangeRecord data) {
      explanations[data.oldValue] = markdownEditor.aceController.value;
      if (explanations.length <= data.newValue) {
        explanations.add(markdownEditor.aceController.value);
      } else {
        markdownEditor.aceController.setValue(explanations[data.newValue]);
      }
    });
  }

  // TODO clean up!
  void reset() {
    explanations = [''];
    codeEditor.cleanRegions();
  }

  Iterable getSavedLessons() {
    return window.localStorage.keys
        .where((k) => k.startsWith('lesson-'))
        .map((k) => [k, window.localStorage[k]]);
  }

  void initFromMap(Map serializedEditData) {
    reset();
    codeEditor.aceController.setValue(serializedEditData['code']);
    explanations = serializedEditData['expl'];
    markdownEditor.aceController
        .setValue(explanations[stepContextService.stepIndex]);
    codeEditor.addSerializedRegions(serializedEditData['regions']);
    codeEditorFilepath = serializedEditData['meta']['code_filename'];
  }

  setupMarkdownEditor(AceEditorComponent editor) {
    editor.aceController.session.mode = new ace.Mode.named(ace.Mode.MARKDOWN);
    markdownEditor = editor;
    editorInitStreamController.add(editor.aceController);
  }

  setupCodeEditor(LessonCodeEditorComponent code_editor) {
    codeEditor = code_editor;
    editorInitStreamController.add(codeEditor.aceController);
  }

  String _codeEditorFilepath;
  get codeEditorFilepath => _codeEditorFilepath;
  set codeEditorFilepath(String newPath) {
    _updateCodeEditorFiletype(newPath);
    _codeEditorFilepath = newPath;
  }

  _updateCodeEditorFiletype(String filepath) {
    codeEditor.aceController.session.mode = new ace.Mode.forFile(filepath);
  }

  serializedSave() {
    if (lessonName == null || lessonName.length == 0) {
      print('Cannot save an empty lesson name!');
    } else {
      _lessonIO.saveLesson(lessonName, this);
    }
  }

  serializedRetrieve() =>
    _lessonIO.smartLoadData(lessonName).then((decoded) => initFromMap(decoded));

  Map toJson() => {
        'code': codeEditor.aceController.value,
        'expl': explanations,
        'regions': codeEditor.actionRegions.values.toList(growable: false),
        'meta': {
          'code_filename': _codeEditorFilepath
        }
      };
}


