import 'package:angular2/core.dart';
import 'package:code_steps/action/lesson.dart';
import 'package:code_steps/action/step.dart';
import 'package:code_steps/lesson_io.dart';
import 'dart:async';
import 'package:observable/observable.dart';

@Injectable()
class StepContextService extends Injectable {
  LessonIO _lessonIO;
  StepContextService(LessonIO this._lessonIO);
  StreamController<PropertyChangeRecord<Step>> _stepChangeController =
      new StreamController<PropertyChangeRecord<Step>>.broadcast();
  Stream<PropertyChangeRecord<Step>> get onStepChange =>
      _stepChangeController.stream;

  // FIXME invert dependency to lessonIO
  Future selectLesson(lesson_name, [initial_step_index=0]) {
    print(lesson_name);
    return _lessonIO.smartLoadData(lesson_name).then((Lesson lesson) {
      if (lesson == null) {
        print("Error: could not load lesson data");
      }
      stepIndex = initial_step_index;
      currentLesson = lesson;
    });
  }

  Lesson currentLesson;
  int _stepIndex = 0;

  dynamic _onChangeStepIndex(newValue) {
    _stepChangeController.add(new PropertyChangeRecord(this, #step,
        currentLesson.getStep(_stepIndex), currentLesson.getStep(newValue)));
    return newValue;
  }

  void gotoNext() {
    stepIndex = _stepIndex + 1;
  }

  bool get _isLessonLoaded => currentLesson != null;
  bool hasNext() => _isLessonLoaded && _stepIndex < currentLesson.length - 1;

  void gotoPrevious() {
    stepIndex = _stepIndex - 1;
  }

  bool hasPrevious() => _isLessonLoaded && _stepIndex > 0;
  int get stepIndex => _stepIndex;

  /**
   * Sets the step index to a desired value. If a string is passed in, it is converted to an integer automatically
   */
  set stepIndex(new_stepIndex) {
    if (new_stepIndex is String) new_stepIndex = int.parse(new_stepIndex);
    _stepIndex = _onChangeStepIndex(new_stepIndex);
  }

  Step get currentStep => currentLesson.getStep(_stepIndex);
}
