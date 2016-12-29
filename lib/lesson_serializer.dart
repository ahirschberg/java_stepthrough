library lesson_serializer;

import 'package:code_steps/action/step.dart';
import 'package:code_steps/action/step_action.dart' show StepActionType;

import 'package:jsonx/jsonx.dart' as jsonx;
import 'package:code_steps/editor/ace_facade.dart';

@MirrorsUsed(targets: 'step_action.StepActionType.values')
import 'dart:mirrors';


class EnumStringHelper<T> {
  T enumFromString(String value) {
    return (reflectType(T) as ClassMirror)
        .getField(#values)
        .reflectee
        .firstWhere((e) =>
            e.toString().split('.')[1].toUpperCase() == value.toUpperCase());
  }

  String stringFromEnum(T value) => value.toString().split('.')[1];
}

class LessonSerializer {
  static final Function identity = (v) => v;
  static final Function stringify = (v) => v.toString();
  static final Function destringifyInt = (String s) => int.parse(s);
  static Map transformMap(Map m, {Function key: null, Function value: null}) {
    key ??= stringify; // json keys must be strings.
    value ??= identity;
    return new Map.fromIterables(m.keys.map(key), m.values.map(value));
  }

  static final EnumStringHelper<StepActionType> stepActionTypeHelper =
      new EnumStringHelper<StepActionType>();

  static String encode(var obj) {
    jsonx.objectToJsons[Position] = // TODO fix these because interops don't work well with runtimeType
        (Position p) => {'row': p.row, 'column': p.column};
    jsonx.objectToJsons[AceRange] = (AceRange r) => {'from': r.start, 'to': r.end};
    jsonx.objectToJsons[new Set().runtimeType] = (Set s) => s.toList(growable: false); // hack to get sets to convert correctly
    return jsonx.encode(obj);
  }

  static Function stepActionTypeTransformer = (StepActionType t) =>
      stepActionTypeHelper.stringFromEnum(t).toLowerCase();

  static Map decode(String jsonData) {
    var decoded = jsonx.decode(jsonData, reviver: (var key, var val) {
      if (key == 'from' || key == 'to') {
        return new Position(row: val['row'], column: val['column']);
      } else if (key == 'range') {
        return AceRange.fromPoints(val['from'], val['to']);
      } else if (key == 'steps') {
        return (val).map((s) => Step.deserialize(s));
      } else {
        return val;
      }
    });
    return decoded;
  }
}

