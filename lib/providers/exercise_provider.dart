import 'package:bg/providers/session_provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:bg/models/exercise.dart';
import 'package:bg/models/user.dart';
import 'package:bg/models/session.dart';
import 'package:bg/providers/timer_provider.dart';

class ExerciseProvider extends ChangeNotifier {
  late SessionProvider _sessionProvider;

  void updateProviders(SessionProvider sessionProvider) {
    _sessionProvider = sessionProvider;
  }

  List<Exercise> _exercises = [];

  List<Exercise> get exercises => _exercises;

  // گرفتن تمرینات از جلسه روز جاری
  Future<void> fetchExercisesFromCurrentSession() async {
    print("Fetching exercises from the current session...");

    // اطمینان از باز شدن باکس sessionBox
    await _sessionProvider.openBox();
    print("Session box opened successfully.");

    // گرفتن شناسه جلسه جاری
    int currentSessionId = _sessionProvider.getCurrentSessionId();
    print("Current session ID: $currentSessionId");

    // دریافت تمرینات از جلسه
    _exercises = _sessionProvider.getExercisesFromSession(currentSessionId);
    print("Exercises loaded: ${_exercises.length}");

    notifyListeners();
    print('Listeners notified after fetching exercises.');
  }


  // ثبت تمرین در Hive

  Future<int> generateExerciseId() async {
    var box = await Hive.openBox<Exercise>('exerciseBox');
    if (box.isNotEmpty) {
      return box.values.map((exercise) => exercise.id).reduce((a, b) =>
      a > b
          ? a
          : b) + 1;
    }
    return 1;
  }


  // گرفتن همه تمرین‌ها از Hive
  Future<void> fetchExercises() async {
    print("Fetching all exercises from Hive...");
    var box = await Hive.openBox<Exercise>('exerciseBox');
    _exercises = box.values.toList();
    print('Total exercises stored: ${_exercises.length}');
    notifyListeners();
  }

  // حذف تمرین
  Future<void> deleteExercise(User user, int sessionId, int exerciseId) async {
    var box = await Hive.openBox<Exercise>('exerciseBox');
    await box.delete(exerciseId);

    _exercises.removeWhere((exercise) => exercise.id == exerciseId);

    notifyListeners(); // برای بروزرسانی UI
  }

  // اضافه کردن تمرین به جلسه
  Future<void> addExerciseToSession(int sessionId, Exercise exercise) async {
    print('Attempting to add exercise with ID ${exercise.id} to session with ID $sessionId.');

    var sessionBox = await Hive.openBox<Session>('sessionBox');
    print('Session box opened successfully.');

    // دریافت جلسه از Hive
    Session? session = sessionBox.get(sessionId);
    if (session == null) {
      print('Error: Session with ID $sessionId not found.');
      return;
    }

    print('Session with ID $sessionId found. Current exercises count: ${session.exercises.length}');

    // اضافه کردن تمرین به لیست تمرینات جلسه
    session.exercises.add(exercise);
    print('Exercise added locally to session. New exercises count: ${session.exercises.length}');

    // بازنویسی و ذخیره مجدد جلسه در Hive
    await sessionBox.put(sessionId, session);
    print('Session with ID $sessionId updated in Hive with new exercises.');

    // بازیابی مجدد برای تأیید ذخیره شدن تمرینات در Hive
    Session? savedSession = sessionBox.get(sessionId);
    if (savedSession != null) {
      print('Verified from Hive: Session ID ${savedSession.id}, Exercises count: ${savedSession.exercises.length}');
    } else {
      print('Error: Unable to retrieve session with ID $sessionId from Hive.');
    }

    notifyListeners();
  }


  Future<Box<T>> openTypedBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<T>(boxName);
    } else {
      return Hive.box<T>(boxName);
    }
  }
  Future<void> fetchAllExercisesFromSessions() async {
    print("Fetching all exercises from sessions in Hive...");

    var sessionBox = await Hive.openBox<Session>('sessionBox');
    List<Session> allSessions = sessionBox.values.toList();
    print("Total sessions retrieved: ${allSessions.length}");

    _exercises.clear();
    print("Local exercises list cleared.");

    for (Session session in allSessions) {
      print('Adding exercises from session ID: ${session.id}, Exercises count: ${session.exercises.length}');
      _exercises.addAll(session.exercises);
    }

    print('Total exercises loaded: ${_exercises.length}');
    notifyListeners();
    print('Listeners notified after fetching all exercises.');
  }

}

