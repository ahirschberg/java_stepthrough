import 'dart:async';

import 'dart:developer';
import 'dart:html';
import 'package:angular2/core.dart';
import 'package:code_steps/action/lesson.dart';
import 'package:code_steps/lesson_serializer.dart';

@Injectable()
class LessonIO {
  static const String LESSON_PREFIX = 'lesson-';

  Future<Lesson> smartLoadData(lesson_name) {
    Future<String> loadStrategy;
    if (window.localStorage[LESSON_PREFIX + lesson_name] != null)
      loadStrategy = new Future.value(window.localStorage[LESSON_PREFIX + lesson_name]);
    else {
      loadStrategy = _loadLessonString(lesson_name);
    }
    return loadStrategy.then((String value) {
      print(value);
      return Lesson.deserialize(LessonSerializer.decode(value));
    });
  }

  Future<String> _loadLessonString(lesson_name) =>
      HttpRequest.getString('static/$LESSON_PREFIX$lesson_name.json');

  void saveLesson(String lesson_name, var lesson) {
    String encoded = LessonSerializer.encode(lesson);
    _saveLessonString(lesson_name, encoded);
  }

  _saveLessonString(lesson_name, encoded) {
    print(encoded);
    window.localStorage[LESSON_PREFIX + lesson_name] = encoded;
  }
}
