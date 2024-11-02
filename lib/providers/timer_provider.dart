import 'dart:async';
import 'package:bg/main.dart';
import 'package:bg/models/exercise.dart';
import 'package:bg/models/session.dart';
import 'package:bg/models/test.dart';
import 'package:bg/models/user.dart';
import 'package:bg/providers/exercise_provider.dart';
import 'package:bg/providers/session_provider.dart';
import 'package:bg/providers/test_provider.dart';
import 'package:bg/providers/user-provider.dart';
import 'package:bg/screens/answer_sheet_screen.dart';
import 'package:bg/screens/word_test_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:collection/collection.dart';  // اضافه کردن پکیج collection

enum TestType { Counting, Vocabulary, Stroop,Exercise, AnswerSheet  }


class TimerProvider with ChangeNotifier {
  // تعریف ValueNotifier برای نشان دادن نیاز به نمایش دیالوگ
  ValueNotifier<bool> showDialogNotifier = ValueNotifier<bool>(false);
  int seconds = 0;
  int minutes = 0;
  Timer? _timer;
  bool isRunning = false; // وضعیت تایمر: آیا در حال اجرا است؟
  late ExerciseProvider exerciseProvider;
  bool isTestMode = false; // وضعیت صفحه: تست یا تمرین
  late SessionProvider _sessionProvider;
  late ExerciseProvider _exerciseProvider;
// متغیر برای نگه داشتن نوع تست فعلی
  TestType? currentTestType;
// تنظیم نوع تست جاری
  void setCurrentTestType(TestType testType) {
    currentTestType = testType;
    notifyListeners();
  }

  // دریافت نوع تست جاری
  TestType? get getCurrentTestType => currentTestType;



  void updateProviders(SessionProvider sessionProvider, ExerciseProvider exerciseProvider) {
    _sessionProvider = sessionProvider;
    _exerciseProvider = exerciseProvider;
  }
  static final TimerProvider _instance = TimerProvider._internal();

  factory TimerProvider() {
    return _instance;
  }

  TimerProvider._internal();

// تابع برای تنظیم حالت تست
  void setTestMode(bool value) {
    isTestMode = value;
    notifyListeners();
  }

  // شروع تایمر
  void startTimer(BuildContext context, TestType testType) {
    // اگر تایمر از قبل فعال است، ابتدا آن را متوقف کنید
    if (_timer != null) {
      stopTimer(context, testType);  // تایمر قبلی را متوقف کنید
    }

    // تنظیم نوع تست جاری
    setCurrentTestType(testType);

    // شروع تایمر جدید
    print('Starting timer for test: $testType');
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds++;
      if (seconds == 60) {
        minutes++;
        seconds = 0;
      }

      // شرط برای Vocabulary: اگر زمان به دو دقیقه رسید
      if (testType == TestType.Vocabulary && seconds == 60) {
        print('Timer reached 2 minutes in Vocabulary test. Triggering Vocabulary action.');

        // انجام کار مخصوص برای تست Vocabulary
        triggerActionForWordTest(context);

        // متوقف کردن تایمر پس از رسیدن به دو دقیقه
        stopTimer(context, testType, shouldSave: false);

        // ریست کردن تایمر
        resetTimer(context);

        return;  // از تایمر خارج شوید
      }

      // شرط برای AnswerSheet: اگر زمان به هر مقدار خاصی رسید
       if (testType == TestType.AnswerSheet && minutes == 2) { // به عنوان مثال یک دقیقه برای AnswerSheet
        print('Timer reached 1 minute in AnswerSheet. Triggering AnswerSheet action.');

        // انجام کار مخصوص برای AnswerSheet
        triggerActionForAnswerSheet(context);

        // متوقف کردن تایمر
        stopTimer(context, testType, shouldSave: false);

        // ریست کردن تایمر
        resetTimer(context);

        return;
      }

      // نمایش زمان جاری تایمر
      print('Timer running: $minutes:$seconds');

      // به‌روزرسانی وضعیت برای رندر UI
      isRunning = true;
      notifyListeners();
    });
  }

  //bool showDialog = false; // متغیر وضعیت نمایش دیالوگ

  void triggerActionForWordTest(context) {
    // به جای استفاده از context یا ناوبری در اینجا، مقدار ValueNotifier را تغییر می‌دهیم
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnswerSheet(),
        ));

  }

  // بازنشانی ValueNotifier پس از نمایش دیالوگ
  void resetShowDialog() {
    showDialogNotifier.value = false;
  }
  @override
  void dispose() {
    showDialogNotifier.dispose();
    super.dispose();
  }

  void triggerActionForAnswerSheet(BuildContext context) {
    // گرفتن تعداد لغات صحیح از TestProvider
    int correctWordCount = Provider.of<TestProvider>(context, listen: false).calculateCorrectWords();

    // انجام عمل خاص برای AnswerSheet
    print('Correct word count: $correctWordCount');

    // ذخیره تعداد لغات صحیح
    Provider.of<TestProvider>(context, listen: false).saveCorrectWords(context, correctWordCount);

    // ناوبری به صفحه نتیجه یا هر عمل دیگری
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => ResultPage()), // صفحه نتیجه
    // );
  }









// متوقف کردن تایمر

  // متوقف کردن تایمر
  Future<void> stopTimer(BuildContext context, TestType testType, {bool shouldSave = true}) async {
    if (_timer != null) {
      // متوقف کردن تایمر
      _timer!.cancel();
      _timer = null;
      isRunning = false;
      notifyListeners();

      if (!shouldSave) {
        print('Timer stopped without saving.');
        return;
      }

      final currentUser = context.read<UserProvider>().currentUser;
      if (currentUser == null) {
        print('Error: Current user is null.');
        return;
      }

      // بازیابی جلسات از Hive
      await _sessionProvider.fetchSessions();

      DateTime today = DateTime.now();
      String dayString = "${today.year}-${today.month}-${today.day}";

      // پیدا کردن یا ایجاد جلسه امروز
      Session? currentSession = _sessionProvider.sessions.firstWhereOrNull(
            (session) => session.day == dayString,
      );

      if (currentSession == null) {
        debugPrint('No session found for today. Creating a new session.');
        currentSession = Session(
          id: await _sessionProvider.generateSessionId(),
          day: dayString,
          exercises: [],
          test: [],
          user: currentUser,
        );

        await _sessionProvider.addSession(
          currentSession.id,
          dayString,
          [],
          [],
          currentUser,
        );

        await _sessionProvider.fetchSessions();
        debugPrint('Session added successfully for day: $dayString');
      }

      // اگر نوع تست باشد، بررسی ثبت تست را انجام دهید
      if (testType == TestType.Exercise) {
        Exercise newExercise = Exercise(
          id: currentSession.exercises.length + 1,
          type: 'addition', // یا هر نوع تمرین دیگر
          difficulty: 1,
          record: getElapsedTime(),
        );

        currentSession.exercises.add(newExercise);
        print('Exercise added to session: ${newExercise.record}');

      } else if (testType == TestType.Vocabulary || testType == TestType.Counting || testType == TestType.Stroop) {
        // بررسی مضرب پنجم بودن جلسه برای ثبت تست
        bool shouldAddTest = (_sessionProvider.sessions.length % 5 == 0);
        if (shouldAddTest) {
          print("This is the 5th session. Adding test results.");

          Test newTest = Test(
            id: '${testType.index + 1}',
            type: testType.toString().split('.').last,
            date: today,
            score: getElapsedTime(),
          );

          currentSession.test.add(newTest);
          print('Test added to session: ${newTest.score}');
        } else {
          print("Not a 5th session. No tests added.");
        }
      }

      // ذخیره جلسه به‌روزرسانی شده در Hive
      var sessionBox = await Hive.openBox<Session>('sessionBox');
      await sessionBox.put(currentSession.id, currentSession);
      print('Session with updated exercises or tests saved in Hive.');

      // بررسی تعداد تمرینات و تست‌ها پس از ذخیره در Hive
      Session? savedSession = sessionBox.get(currentSession.id);
      if (savedSession != null) {
        print('Verified session from Hive: Session ID ${savedSession.id}, Exercises count: ${savedSession.exercises.length}, Tests count: ${savedSession.test.length}');
      } else {
        print('Error: Unable to retrieve session with ID ${currentSession.id} from Hive.');
      }
    }
  }


  void resetTimer(BuildContext context) {
    if (currentTestType != null) {
      stopTimer(context, currentTestType!);  // تایمر را متوقف کنید و از نوع تست جاری استفاده کنید
      seconds = 0;
      minutes = 0;
      notifyListeners();  // به‌روزرسانی UI برای نمایش حالت صفر تایمر
      debugPrint("Timer reset to 00:00.");
    } else {
      print('Error: No test type set.');
    }
  }


  void toggleTimer(BuildContext context, TestType testType) {
    if (isRunning) {
      // اضافه کردن لاگ برای فهمیدن وضعیت تایمر
      print('Toggling timer: stopping');
      stopTimer(context, testType);
    } else {
      // اضافه کردن لاگ برای شروع تایمر
      print('Toggling timer: starting');
      startTimer(context, testType);
    }
  }




  // گرفتن زمان سپری شده به صورت رشته
  String getElapsedTime() {
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }


  void startAnswerSheetTimer(BuildContext context) {
    if (_timer != null) {
      stopTimer(context, TestType.AnswerSheet);  // تایمر قبلی را متوقف کنید
    }

    // شروع تایمر جدید برای AnswerSheet
    print('Starting AnswerSheet timer');
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds++;
      if (seconds == 60) {
        minutes++;
        seconds = 0;
      }

      // وقتی زمان به 1 دقیقه رسید
      if (minutes == 1) {
        print('AnswerSheet Timer reached 1 minute. Triggering action.');

        // فراخوانی تابع برای محاسبه و ثبت تعداد لغات صحیح
        triggerActionForAnswerSheet(context);

        // متوقف کردن تایمر
        stopTimer(context, TestType.AnswerSheet, shouldSave: false);

        // ریست کردن تایمر
        resetTimer(context);

        return;  // از تایمر خارج شوید
      }

      // نمایش زمان جاری تایمر
      print('AnswerSheet Timer running: $minutes:$seconds');

      // به‌روزرسانی وضعیت برای رندر UI
      isRunning = true;
      notifyListeners();
    });
  }


//
// // مدیریت جلسه و ثبت تمرین
// Future<void> _handleSessionAndExercise(BuildContext context, User user, String elapsedTime) async {
//
//   // گرفتن SessionProvider از طریق context
//   final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
//
//   // گرفتن تاریخ جاری به فرمت مورد نیاز
//   String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//
//   // چک کردن آیا جلسه‌ای برای امروز وجود دارد
//   Session? existingSession;
//   try {
//     existingSession = user.sessions.firstWhere((session) => session.day == today);
//   } catch (e) {
//     existingSession = null;
//   }
//
//
//   if (existingSession == null) {
//     // اگر جلسه‌ای وجود ندارد، یک جلسه جدید ایجاد کنید
//     await sessionProvider.addSession(user.id, today, [], []);
//     existingSession = user.sessions.firstWhere((session) => session.day == today);
//   }
//   var box = await Hive.openBox<User>('userBox');
//   int newId = box.isEmpty ? 1 : box.values.last.id + 1;
//   // اضافه کردن تمرین به جلسه
//   Exercise newExercise = Exercise(
//     id:newId.toString() ,// شناسه‌ی یکتا برای تمرین
//     difficulty: 1,
//     type: 'one',
//     record: elapsedTime, // ثبت زمان تمرین
//   );
//
//   await Provider.of<ExerciseProvider>(context, listen: false)
//       .addExerciseToSession(user, existingSession.id, newExercise);
 }

