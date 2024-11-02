import 'package:bg/models/question.dart';
import 'package:bg/providers/timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:bg/models/questions.dart';
import 'package:provider/provider.dart';




class QuestionProvider with ChangeNotifier {
  List<Question> sessionQuestions = [];
  int currentQuestionIndex = 0; // شاخص سوال فعلی
  String feedbackMessage = ''; // پیام بازخورد
  String userAnswer = ''; // پاسخ کاربر از کیبورد مجازی


  // پاک کردن ورودی کاربر
  void clearUserAnswer() {
    userAnswer = ''; // پاک‌سازی ورودی
    notifyListeners();
  }

  // دریافت سوال فعلی
  Question getCurrentQuestion() {
    return sessionQuestions[currentQuestionIndex];
  }

  // بارگذاری سوالات برای session خاص
  void loadQuestions(int sessionId) {
    sessionQuestions = QuestionsData.getQuestionsForSession(sessionId);
    currentQuestionIndex = 0;
    feedbackMessage = '';
    userAnswer = ''; // پاسخ کاربر را پاک کنید
    notifyListeners();
  }

  // متد برای ذخیره ورودی‌های کیبورد مجازی
  void updateUserAnswer(String input,BuildContext context) {
    if (userAnswer.length < 2) { // محدودیت به دو کاراکتر
      userAnswer += input; // افزودن ورودی به پاسخ کاربر
      notifyListeners();

      // اگر پاسخ یک‌رقمی باشد یا اگر دو‌رقمی شد، بررسی انجام شود
      if (userAnswer.length == 1 || userAnswer.length == 2) {
        checkAnswer(context); // بررسی پاسخ
      }
    }
  }



  String convertPersianNumberToEnglish(String input) {
    final persianDigits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    final englishDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    for (int i = 0; i < persianDigits.length; i++) {
      input = input.replaceAll(persianDigits[i], englishDigits[i]);
    }
    return input;
  }


  // بررسی پاسخ کاربر
  void checkAnswer(BuildContext context) {
    // تبدیل ورودی فارسی به انگلیسی
    String englishAnswer = convertPersianNumberToEnglish(userAnswer);

    int userAnswerInt = int.tryParse(englishAnswer) ?? -1;

    // بررسی زمانی که یک یا دو کاراکتر وارد شده است
    if (userAnswer.length == 1) {
      // اگر پاسخ یک کاراکتری صحیح بود
      if (userAnswerInt == sessionQuestions[currentQuestionIndex].correctAnswer) {
        feedbackMessage = 'Correct!';
        goToNextQuestion(context); // حرکت به سوال بعدی
      } else {
        // اگر نادرست بود، منتظر ورودی دوم می‌مانیم
        feedbackMessage = 'Wrong answer, waiting for second character...';
        notifyListeners();
      }
    } else if (userAnswer.length == 2) {
      // وقتی ورودی دوم وارد شد، بررسی پاسخ
      if (userAnswerInt == sessionQuestions[currentQuestionIndex].correctAnswer) {
        feedbackMessage = 'Correct!';
        goToNextQuestion(context); // حرکت به سوال بعدی
      } else {
        feedbackMessage = 'Wrong answer. Try again.'; // اگر دو کاراکتر نادرست بودند
        clearUserAnswer(); // پاک کردن ورودی برای سوال بعدی
      }
      notifyListeners();
    }
  }



  // حرکت به سوال بعدی
  Future<void> goToNextQuestion(BuildContext context) async {
    if (currentQuestionIndex < sessionQuestions.length - 1) {
      currentQuestionIndex++; // حرکت به سوال بعدی
      clearUserAnswer(); // پاک کردن ورودی برای سوال بعدی
      feedbackMessage = ''; // پاک کردن پیام بازخورد
      notifyListeners();
    } else {
      feedbackMessage = 'You have completed all questions!';
      Provider.of<TimerProvider>(context, listen: false).toggleTimer(context, TestType.Exercise);
      notifyListeners();
    }
  }

  // بررسی پایان سوالات
  bool hasMoreQuestions() {
    return currentQuestionIndex < sessionQuestions.length;
  }
}

