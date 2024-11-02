import 'package:bg/models/Vocabulary.dart';
import 'package:bg/models/session.dart';
import 'package:bg/providers/session_provider.dart';
import 'package:bg/providers/user-provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:bg/models/test.dart';
import 'package:provider/provider.dart'; // مدل تست شما
import 'package:collection/collection.dart';


class TestProvider with ChangeNotifier {
  List<Test> _tests = [];

  List<Test> get tests => _tests;

  List<Map<String, bool>> _results = []; // لیست نتایج
  List<Vocabulary> _sessionWords = []; // لغات جلسه جاری

  // دریافت نتایج
  List<Map<String, bool>> get results => _results;
  SessionProvider? _sessionProvider; // ذخیره SessionProvider
  int? _sessionId;

  // تابع برای تنظیم SessionProvider و ذخیره داده‌ها
  void updateSessionProvider(SessionProvider sessionProvider) {
    _sessionProvider = sessionProvider;
    _sessionId = sessionProvider.getCurrentSessionId();
  }

  int? get sessionId => _sessionId; // برای دسترسی به sessionId در AnswerSheet


  void checkWord(String word) {
    if (_sessionId == null) {
      print('Error: Session ID is not set.');
      return;
    }
    print("Current Session ID: $_sessionId"); // چاپ sessionId

    // بارگذاری لغات برای session
    List<Vocabulary> correctWords = VocabularyData.getWordsForSession(_sessionId!);

    // چاپ لغات صحیح برای دیباگ
    print("Correct Words: ${correctWords.map((vocab) => vocab.word).toList()}");

    String normalizedWord = word.trim().toLowerCase();
    bool isCorrect = correctWords.any((vocab) => vocab.word.toLowerCase() == normalizedWord);

    // ذخیره نتیجه
    _results.add({word: isCorrect});

    // برای دیباگینگ
    print("Word: $word, Is Correct: $isCorrect");

    notifyListeners();
  }

  // مقداردهی لغات برای جلسه خاص
  void loadWordsForSession(int sessionId) {
    _sessionWords = VocabularyData.getWordsForSession(sessionId);
    notifyListeners();
  }

  // این تابع ورودی کاربر را با لغات صحیح بررسی می‌کند


  // تابع برای محاسبه تعداد لغات صحیح
  int calculateCorrectWords() {
    int correctCount = 0;
    for (var result in results) {
      if (result.values.first == true) {
        correctCount++;
      }
    }
    return correctCount;
  }


  // ریست کردن نتایج
  void resetResults() {
    _results.clear();
    notifyListeners();
  }

  // دریافت تست‌ها از Hive
  Future<void> fetchTests(int sessionId) async {
    var sessionBox = await Hive.openBox<Session>('sessionBox');
    Session? currentSession = sessionBox.get(sessionId);

    if (currentSession != null) {
      _tests = currentSession.test; // اطمینان از اینکه تست‌ها به درستی بارگذاری می‌شوند
      print("Fetched Tests: ${_tests.map((test) => test.id).toList()}"); // چاپ تست‌های بارگذاری شده
      notifyListeners();
    } else {
      print("No session found for ID: $sessionId");
    }
  }



  // به‌روزرسانی نتیجه تست
  void updateTestScore(String testId, String newScore, int currentSessionId) {
    int index = _tests.indexWhere((test) => test.id == testId);
    if (index != -1) {
      _tests[index] = Test(
        id: _tests[index].id,
        type: _tests[index].type,
        date: DateTime.now(),
        score: newScore,
      );
      notifyListeners();
      saveTestsToHive(currentSessionId); // ذخیره‌سازی تغییرات در Hive
    }
  }

  // ذخیره تست‌ها در Hive
  Future<void> saveTestsToHive(int currentSessionId) async {
    var sessionBox = await Hive.openBox<Session>('sessionBox');
    Session? currentSession = sessionBox.get(currentSessionId);

    if (currentSession != null) {
      currentSession.test = _tests; // به‌روزرسانی لیست تست‌ها
      await sessionBox.put(currentSession.id, currentSession);

      // چاپ تست‌های ذخیره شده
      print("Saved Tests: ${currentSession.test.map((test) => test.id).toList()}");
    } else {
      print("No session found for ID: $currentSessionId");
    }
  }

  Future<void> printAllTests() async {
    var sessionBox = await Hive.openBox<Session>('sessionBox');

    for (var session in sessionBox.values) {
      print("Session ID: ${session.id}");
      for (var test in session.test) {
        print("Test ID: ${test.id}, Type: ${test.type}, Date: ${test.date}, Score: ${test.score}");
      }
    }
  }

  // تابع ذخیره تعداد لغات صحیح
  Future<void> saveCorrectWords(BuildContext context, int correctWordCount) async
  {
    var sessionBox = await Hive.openBox<Session>('sessionBox');
    DateTime today = DateTime.now();
    String dayString = "${today.year}-${today.month}-${today.day}";

    // پیدا کردن یا ایجاد جلسه برای روز جاری
    Session? currentSession = sessionBox.values.firstWhereOrNull(
          (session) => session.day == dayString,
    );

    if (currentSession == null) {
      int newSessionId = await context.read<SessionProvider>().generateSessionId();

      // بررسی اینکه currentUser خالی نباشد
      var currentUser = context.read<UserProvider>().currentUser;
      if (currentUser == null) {
        print("Error: No current user found.");
        print('Correct word count saved: $correctWordCount'); // برای دیباگینگ

        return;
      }

      currentSession = Session(
        id: newSessionId,
        day: dayString,
        exercises: [],
        test: [],
        user: currentUser, // اکنون currentUser خالی نیست
      );

      await sessionBox.put(newSessionId, currentSession);
      print('New session created for day: $dayString');
    }

    // پیدا کردن یا ایجاد تست لغات
    Test? vocabularyTest = currentSession!.test.firstWhereOrNull(
          (test) => test.type == 'Vocabulary',
    );

    if (vocabularyTest == null) {
      vocabularyTest = Test(
        id: '2',
        type: 'Vocabulary',
        date: today,
        score: correctWordCount.toString(),
      );
      currentSession.test.add(vocabularyTest);
    } else {
      vocabularyTest.score = correctWordCount.toString();
    }

    await sessionBox.put(currentSession.id, currentSession);
    print('Correct word count saved: $correctWordCount');
  }

  Future<void> printStoredTests(int sessionId) async {
    var sessionBox = await Hive.openBox<Session>('sessionBox');
    Session? currentSession = sessionBox.get(sessionId);

    if (currentSession != null) {
      for (var test in currentSession.test) {
        print("Test ID: ${test.id}, Type: ${test.type}, Date: ${test.date}, Score: ${test.score}");
      }
    } else {
      print("No session found for ID: $sessionId");
    }
  }


}




