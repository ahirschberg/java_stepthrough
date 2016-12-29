library action_region;

import 'package:code_steps/editor/ace_facade.dart';
import 'package:code_steps/editor/lesson_code_editor_component.dart';
import 'package:code_steps/lesson_serializer.dart';
import 'package:code_steps/action/step_action.dart';

class ActionRegion {
  Set<StepActionType> actions;
  AceRange range;

  ActionRegion(this.range, [this.actions]) {
    if (this.actions == null) this.actions = new Set<StepActionType>();
  }

  String toString() => "ActionRegion($range, $actions)";

  Map toJson() {
    var obj = {
      'range': range,
      'actions': actions
          .map((type) =>
              LessonSerializer.stepActionTypeHelper.stringFromEnum(type))
          .toList()
    };
    return obj;
  }

  static ActionRegion deserialize(Map data) {
    return new ActionRegion(
        data['range'],
        data['actions']
            .map((action_str) => LessonSerializer.stepActionTypeHelper
                .enumFromString(action_str))
            .toSet());
  }

  Map<StepActionType, bool> getActionStates() {
    return new Map.fromIterable(StepActionType.values,
        value: (state) => actions?.contains(state) == true);
  }
}
