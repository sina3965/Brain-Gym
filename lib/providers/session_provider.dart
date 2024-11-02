import 'package:bg/models/user.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:bg/models/session.dart';
import 'package:bg/models/exercise.dart';
import 'package:bg/models/test.dart';



class SessionProvider extends ChangeNotifier {
  List<Session> _sessions = [];

  List<Session> get sessions => _sessions;

  Box<Session>? sessionBox;

  SessionProvider() {
    openBox();
  }
// تابع برای بررسی اینکه آیا باید تست‌ها ثبت شوند یا نه
  Future<bool> shouldAddTest(User user) async {
    await openBox(); // مطمئن شوید که باکس باز شده است
    int sessionCount = user.sessions.length;

    // اگر تعداد جلسات ثبت‌شده برای کاربر مضربی از 5 بود، تست ثبت شود
    return sessionCount > 0 && sessionCount % 5 == 0;
  }

  // تابع برای باز کردن باکس Hive
  Future<void> openBox() async {
    if (sessionBox == null || !sessionBox!.isOpen) {
      sessionBox = await Hive.openBox<Session>('sessionBox');
    }
    notifyListeners();
  }

  // گرفتن تمرینات از یک جلسه
  List<Exercise> getExercisesFromSession(int sessionId) {
    if (sessionBox == null || !sessionBox!.isOpen) {
      print('Session box is not opened.');
      return [];
    }

    final session = sessionBox!.get(sessionId);

    if (session == null) {
      print('Session with ID $sessionId not found.');
      return [];
    }

    if (session.exercises.isEmpty) {
      print('No exercises found for session with ID $sessionId.');
      return [];
    }

    return session.exercises;
  }

  // گرفتن شناسه جلسه جاری
  int getCurrentSessionId() {
    if (sessionBox != null && sessionBox!.isNotEmpty) {
      return sessionBox!.values.last.id;
    } else {
      return 1; // مقدار پیش‌فرض برای اولین جلسه
    }
  }

// تابع برای ساخت یک جلسه جدید
//   Future<void> addSession(int id, String day, List<Exercise>? exercises, List<Test>? tests, User user) async {
//     print('addSession called!'); // لاگ ابتدایی
//
//     exercises = exercises ?? [];
//     tests = tests ?? [];
//
//     // ایجاد یک شیء Session جدید
//     Session newSession = Session(
//       id: id,
//       day: day,
//       exercises: exercises,
//       test: tests,
//       user: user,
//     );
//
//     // اضافه کردن جلسه به لیست جلسات کاربر
//     user.sessions.add(newSession);
//
//     // ذخیره در Hive
//     var box = await Hive.openBox<Session>('sessionBox');
//     await box.put(id, newSession);
//
//     print('Session created and saved with ID: $id');
//
//     notifyListeners();
//   }

  // گرفتن همه جلسات از Hive

  Future<void> addSession(int id, String day, List<Exercise>? exercises, List<Test>? tests, User user) async {
    try {
      print('Attempting to add session with ID: $id');

      exercises = exercises ?? [];
      tests = tests ?? [];

      Session newSession = Session(
        id: id,
        day: day,
        exercises: exercises,
        test: tests,
        user: user,
      );

      _sessions.add(newSession);
     // user.id.add(newSession.id);

      var userBox = await Hive.openBox<User>('userBox');
      await userBox.put(user.id, user);
      //print('User updated with new session ID: ${user.id}');

      var sessionBox = await Hive.openBox<Session>('sessionBox');
      await sessionBox.put(id, newSession);
      print('Session saved with ID: $id');

      notifyListeners();
    } catch (e) {
      print('Error in addSession: $e');
    }
  }

  Future<void> fetchSessions() async {
    var box = await Hive.openBox<Session>('sessionBox');
    _sessions = box.values.toList();

    print("Fetched sessions from Hive:");
    for (var session in _sessions) {
      print('Session ID: ${session.id}, Exercises: ${session.exercises.length}');
    }
    await printBoxContents();

    notifyListeners();
  }

  // حذف یک جلسه
  Future<void> deleteSession(int id) async {
    var box = await Hive.openBox<Session>('sessionBox');
    await box.delete(id);

    _sessions.removeWhere((session) => session.id == id);
    notifyListeners(); // برای بروزرسانی UI
  }

  Future<int> generateSessionId() async {
    var box = await Hive.openBox<Session>('sessionBox');

    // اگر جلسات قبلی وجود دارند، از بزرگترین شناسه استفاده کرده و 1 به آن اضافه کنید
    if (box.isNotEmpty) {
      int lastId = box.values.map((session) => session.id).reduce((a, b) => a > b ? a : b);
      return lastId + 1;
    }

    // اگر هیچ جلسه‌ای وجود ندارد، شناسه 1 را برگردانید
    return 1;
  }





  List<Session> getAllSessions() {
    if (sessionBox == null) return [];
    return sessionBox!.values.toList();
  }


  Future<void> createSessionIfNotExists(User user, String dayString) async {
    // بررسی اینکه آیا جلسه‌ای با این روز وجود دارد
    Session? existingSession;

    // بررسی اینکه جلسه‌ای برای این روز وجود دارد یا نه
    for (var session in user.sessions) {
      if (session.day == dayString) {
        existingSession = session;
        break;
      }
    }

    // اگر جلسه‌ای پیدا نشد، یک جلسه جدید ایجاد کنید
    if (existingSession == null) {
      print('No session found for day $dayString. Creating a new session.');

      // ایجاد جلسه جدید
      Session newSession = Session(
        id: await generateSessionId(),  // تولید شناسه جدید
        day: dayString,                 // تاریخ روز
        exercises: [],                  // لیست تمرینات (خالی)
        test: [],
        user: user,                     // کاربر مربوط به جلسه
      );

      // اضافه کردن جلسه جدید به لیست جلسات کاربر
      user.sessions.add(newSession);

      // ذخیره کاربر و جلسات در Hive
      var userBox = await Hive.openBox<User>('userBox');
      await userBox.put(user.id, user);

      print('Session for day $dayString created successfully with ID: ${newSession.id}');
    } else {
      print('Session for day $dayString already exists with ID: ${existingSession.id}');
    }
  }


  Future<void> openSessionBox() async {
    sessionBox = await Hive.openBox<Session>('sessionBox');
  }
  Future<void> printBoxContents() async {
    var sessionBox = await Hive.openBox<Session>('sessionBox');

    print("Keys in sessionBox: ${sessionBox.keys.toList()}");  // نمایش کلیدهای موجود
    print("Values in sessionBox:");

    for (var key in sessionBox.keys) {
      var session = sessionBox.get(key);
      print("Session ID: ${session?.id}, Day: ${session?.day}, Exercises Count: ${session?.exercises.length}");
    }
  }

}

