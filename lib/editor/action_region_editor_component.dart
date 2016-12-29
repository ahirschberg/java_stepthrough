import 'dart:async';
import 'dart:developer';
import 'package:angular2/core.dart';
import 'package:code_steps/action/action_region.dart';
import 'package:code_steps/editor/lesson_code_editor_component.dart';
import 'package:code_steps/lesson_serializer.dart';
import 'package:code_steps/action/step_action.dart';
import 'package:code_steps/step_context_service.dart';
import 'package:observable/observable.dart';

@Component(
    selector: 'action-region-editor',
    templateUrl: 'html/action_region_editor_component.html',
    directives: const [],
    styles: const [
      '''
    :host { display: block; }
    :host .steps-picker {
        overflow-x: hidden;
        text-overflow: ellipsis;
        overflow-y: scroll;
    }
    :host .steps-picker > option {
        overflow: hidden;
        text-overflow: ellipsis;
    }
    :host .step-actions-picker {
        display: block;
    }
    '''
    ])
class ActionRegionEditorComponent implements OnChanges {
  @Output()
  EventEmitter onDelete;
  @Output()
  EventEmitter onDataChange;

  @Input()
  Stream<PropertyChangeRecord<AceRegionBundle>> activeRegionOnChange;
  StreamSubscription activeRegionChangeListener;
  AceRegionBundle activeRegion;

  StepContextService stepContextService;
  EnumStringHelper<StepActionType> esh;

  ActionRegionEditorComponent(this.stepContextService) {
    onDelete = new EventEmitter();
    onDataChange = new EventEmitter();
    esh = new EnumStringHelper<StepActionType>();
  }

  void deleteRegion() {
    onDelete.emit(activeRegion);
    activeRegion = null;
  }

  Set<StepActionType> get regionActions => activeRegion.region.actions;

  @override
  ngOnChanges(Map<String, SimpleChange> changes) {
    print('Got an ngOnChanges event in ActionRegionEditor: $changes');
    if (changes['activeRegionOnChange'] != null) {
      activeRegionChangeListener?.cancel();
      activeRegionChangeListener = activeRegionOnChange.listen((pc) => activeRegion = pc.newValue);
    }
  }
}
