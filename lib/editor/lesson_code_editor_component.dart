import 'dart:async';
import 'dart:developer';
import 'dart:js';
import 'package:angular2/core.dart';
import 'package:code_steps/action/step_action.dart';
import 'package:code_steps/js_map.dart';
import 'package:code_steps/action/action_region.dart';
import 'package:code_steps/action/step.dart';
import 'package:code_steps/editor/ace_editor_component.dart';
import 'jss_interop.dart' as jss;
import 'package:code_steps/editor/ace_facade.dart';
import 'package:code_steps/step_context_service.dart';
import 'package:fff/color.dart';
import 'package:js/js.dart';
import 'package:observable/observable.dart';

@Component(selector: 'ace-code-edit', template: '', styles: const [
  '''
    :host .cs-mark {
        background-color: rgba(132,132,132,0.25);
        position: absolute;
    }
    '''
], styleUrls: const [
  'css/ace_editor_component.css'
])
class LessonCodeEditorComponent extends AceEditorComponent implements OnInit {
  static const String code_edit_id = 'lesson-code-edit';
  @Input()
  StreamController<PropertyChangeRecord<AceRegionBundle>>
      activeRegionChangeController;
  @Output('onInit')
  get init => super.init; // workaround for annotations not inheriting properly

  AceRegionBundle _activeRegion = new AceRegionBundle(null, null, null);
  AceRegionBundle get activeRegion => _activeRegion;

  Map<int, AceRegionBundle> _aceRegionBundles = new Map();
  Set<ActionRegion> get regions =>
      _aceRegionBundles.values.map((bundle) => bundle.region).toSet();
  set regions(Set<ActionRegion> newRegions) {
    _clearEditorRegions();
    newRegions.forEach((region) => _addRegionToEditor(region));
  }

  StepContextService stepContextService;
  LessonCodeEditorComponent(ElementRef elementRef, this.stepContextService)
      : super(elementRef) {
    super.dom_id = code_edit_id;
  }

  @override
  ngOnInit() {
    super.ngOnInit();
    this.aceController.selection.on("changeCursor", allowInterop(onData));
  }

  _clearEditorRegions() {
    _aceRegionBundles.keys.toSet().forEach((id) => removeActionMarker(id));
    _aceRegionBundles.clear();
  }

  _addRegionToEditor(ActionRegion r) {
    AceRegionBundle guiRegion = new AceRegionBundle(null, 'cs-mark', r);
    return _insertMarker(guiRegion);
  }

  removeActionMarker(int id) {
    aceController.session.removeMarker(id);
  }

  int nextUniq = 0;
  _insertMarker(AceRegionBundle aceBundle) {
    String uniqClass = 'mark-${nextUniq++}'; // Hack to get unique classes for jss to work with
    int id = aceController.session.addMarker(aceBundle.region.range,
        aceBundle.css_class + ' $uniqClass', "text", false);
    Marker obj = new JsMap<Marker>(aceController.session.getMarkers(false))[id];
    aceBundle.marker = obj;
    _aceRegionBundles[id] = aceBundle;
    if (!aceBundle.region.actions.isEmpty) recolorRegion(aceBundle);
    return id;
  }

  void onData(event, Selection s) {
    AceRegionBundle oldRegion = _activeRegion;
    _activeRegion = getRegionAtCursor();
    activeRegionChangeController.add(new PropertyChangeRecord(
        this, #activeRegion, oldRegion, _activeRegion));
  }

  AceRegionBundle getRegionAtCursor() {
    Iterable<AceRegionBundle> regions = _aceRegionBundles.values.where(
        (region) =>
            region.marker.clazz.contains('cs-mark') &&
            region.marker.range
                    .comparePoint(aceController.selection.getCursor()) ==
                0);
    if (regions.isNotEmpty) {
      return regions.fold(
          regions.first,
          (smallest, e) => smallest.marker.range.containsRange(e.marker.range)
              ? e
              : smallest);
    }
    return null;
  }

  static const green = const Color(80, 131, 30, 0.35);
  static const blue = const Color(53, 191, 188, 0.2);
  static const red = const Color(126, 13, 13, 0.68);
  static const purple = const Color(197, 23, 158, 0.25);
  static const yellow = const Color(79, 76, 15, 0.66);
  recolorRegion(AceRegionBundle aceBundle) {
    Color to_color;
    Function has_action = aceBundle.region.actions.contains;
    if (has_action(StepActionType.Fail)) to_color = red;
    else if (has_action(StepActionType.Pass)) to_color = green;
    else if (has_action(StepActionType.Show)) to_color = yellow;
    else to_color = purple;
    jss.set('.' + aceBundle.marker.clazz.replaceAll(new RegExp(r'\s'), '.'),
        new JsObject.jsify({'background-color': to_color.toString()}));
  }

  void addActionMarker() {
    Selection selection = aceController.session.getSelection();
    print(
        "selection text: ${aceController.session.getTextRange(selection.getRange())}");
    _addRegionToEditor(new ActionRegion(selection.getRange()));
  }
}

class AceRegionBundle {
  Marker marker;
  String css_class;
  ActionRegion region;
  AceRegionBundle(this.marker, this.css_class, this.region);

  String toString() => "Bundle: ${marker.id}, $region";
}
