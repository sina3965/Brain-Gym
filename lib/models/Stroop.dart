
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// مدل Stroop
class Stroop {
  final int id;
  final String word;
  final Color color;

  Stroop({required this.id, required this.word, required this.color});
}

class StroopData {
  static List<Stroop> generateWordsForSession(int sessionId) {
    List<String> words = ['قرمز', 'سبز', 'زرد', 'آبی'];
    // محدود کردن رنگ‌ها به زرد، قرمز، آبی و سبز
    List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.blue,
    ];

    if (sessionId % 5 != 0) {
      return []; // اگر جلسه تست نیست، لیست خالی برگردانید
    }

    List<Stroop> stroopWords = [];
    Random random = Random(); // ایجاد یک نمونه از Random

    for (int i = 0; i < 50; i++) {
      int randomWordIndex = random.nextInt(words.length);
      int randomColorIndex = random.nextInt(colors.length); // انتخاب رنگ تصادفی
      stroopWords.add(Stroop(
        id: i + 1,
        word: words[randomWordIndex],
        color: colors[randomColorIndex], // رنگ تصادفی
      ));
    }

    print("Generated ${stroopWords.length} Stroop words for session $sessionId"); // چاپ تعداد کلمات
    return stroopWords;
  }
}