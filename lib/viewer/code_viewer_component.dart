import 'package:angular2/core.dart';
import 'package:code_steps/action/action_region.dart';
import 'package:code_steps/action/step_actions_provider.dart';
import 'package:code_steps/lesson_serializer.dart';
import 'package:code_steps/action/step_action.dart';
import 'package:code_steps/step_context_service.dart';
import 'package:ace/ace.dart' as ace;
import 'package:observe/observe.dart';
import 'package:code_steps/viewer/highlightjs_interop.dart' as highlighter;
import 'dart:html';

@Component(
    selector: 'code-viewer',
    template: '',
    styleUrls: const ['css/code_viewer_component.css'])
class CodeViewerComponent implements OnInit {
  final NodeValidatorBuilder _codeViewerValidator = new NodeValidatorBuilder()
    ..allowElement('pre')
    ..allowElement('cs-region', attributes: const ["class"]);

  final StepContextService stepContextService;
  ElementRef _elementRef;
  StepActionsProvider stepActionsProvider;

  CodeViewerComponent(
      this.stepContextService, this.stepActionsProvider, this._elementRef);

  ngOnInit() {
    stepContextService.onStepChange.listen((PropertyChangeRecord change) =>
        _addCodeHtml(_addHtmlRegions(stepContextService.currCodeHtml,
            stepContextService.loadedRegions, stepContextService.stepIndex)));
  }

  _addCodeHtml(String codeHtml) {
    // why is nativeElement dynamic :(
    Element root = _elementRef.nativeElement as Element;

    root.setInnerHtml("<pre>${codeHtml}</pre>",
        validator: _codeViewerValidator);
    try {
      highlighter.highlightBlock(root.firstChild);
    } catch (exception) {
      print("WARN: Failed to highlight the code viewer.\n$exception");
    }
  }

  String _addHtmlRegions(String code, List<ActionRegion> regions, int step) {
    List<RegionInsert> rows = code
        .split('\n')
        .map((row) => new RegionInsert([row]))
        .toList(growable: false);
    regions.forEach((ActionRegion region) {
      Set<StepActionType> actions = region.stepData[step];
      actions?.forEach((actionType) => stepActionsProvider
          .transformers[actionType](rows, region.range));
    });
    return rows.join('\n');
  }
}