import 'package:angular2/core.dart';
import 'package:code_steps/action/step_action.dart';
import 'package:code_steps/editor/ace_facade.dart';
import 'package:code_steps/lesson_serializer.dart';

@Injectable()
class StepActionsProvider extends Injectable {
  Map<StepActionType, Function> transformers;

  StepActionsProvider() {
    transformers = new Map.fromIterable(StepActionType.values,
        value: (t) => _generateTagWrap(t));

    // transformers[StepActionType.Pass](
    //     [new RegionInsert([])], new Range(0, 0, 0, 0));

    // override default tag actions for certain types
    transformers.addAll({
      StepActionType.Hide: _hide
    });
  }

  static final Function _hide = (List<RegionInsert> lines, AceRange range) {
    RegionInsert startLine = lines[range.start.row];
    if (range.start.row == range.end.row) {
      startLine.delete(range.start.column, range.end.column);
    } else {
      lines[range.start.row]
          .delete(range.start.column, lines[range.start.row].length);
      if (range.end.row - range.start.row > 1) {
        lines.fillRange(
            range.start.row + 1, range.end.row, new RegionInsert([]));
      }
      lines[range.end.row].delete(0, range.end.column);
    }
  };

  static Function _generateTagWrap(StepActionType t) {
    String typeString = LessonSerializer.stepActionTypeHelper.stringFromEnum(t);
    String openTag = '<cs-region class="action-${typeString.toLowerCase()}">';
    String closeTag = '</cs-region>';
    return (List<RegionInsert> lines, AceRange range) {
      if (range.isEmpty()) {
        print('WARN: empty range $range');
        return;
      }
      int openIndex = lines[range.start.row].split(range.start.column);
      lines[range.start.row].insertShadow(openIndex + 1, openTag);
      int closeIndex = lines[range.end.row].split(range.end.column);
      lines[range.end.row].insertShadow(closeIndex + 1, closeTag);
    };
  }
}

class StringShadow {
  String val;

  StringShadow(this.val);

  int get length => 0;
  String toString() => val;
  StringShadow substring(int a, [int b]) =>
      new StringShadow(val.substring(a, b));
}

class StringFiller {
  var val;
  bool show;
  StringFiller(this.val, [this.show = false]);
  String toString() => show ? "{{$val}}" : "";
  StringFiller substring(int a, [int b]) =>
      new StringFiller(val.substring(a, b), this.show);
  int get length => val.length;
}

class RegionInsert {
  List parts;

  RegionInsert(this.parts);

  int split(int col) {
    int traversed = 0;
    int i = 0;
    bool go = true;
    parts = parts.expand((s) {
      if (go) {
        if (col >= traversed && col <= traversed + s.length) {
          go = false;
          var split = [
            s.substring(0, col - traversed),
            s.substring(col - traversed)
          ];
          return split;
        }
        i++;
        traversed += s.length;
      }
      return [s];
    }).toList();
    return i;
  }

  void insertShadow(int index, String s) =>
      parts.insert(index, new StringShadow(s));

  void delete(int from, int to) {
    split(from);
    int toIndex = split(to);
    StringFiller filler = new StringFiller(parts.elementAt(toIndex));
    parts.removeAt(toIndex);
    parts.insert(toIndex, filler);
  }

  String toString() {
    return parts.join();
  }

  bool isEmpty() =>
    parts.every((e) => e.runtimeType == StringFiller || e.length == 0);

  get length => parts.fold(0, (int memo, var part) => memo += part.length);
}
