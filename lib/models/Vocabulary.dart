class Vocabulary {
  final int id;
  final String word;

  Vocabulary({required this.id, required this.word});
}

class VocabularyData {
  // لیست لغات برای جلسات 5، 10، 15 و ...
  static List<Vocabulary> getWordsForSession(int sessionId) {
    // بررسی اینکه آیا sessionId مضربی از 5 است
    if (sessionId % 5 != 0) {
      return []; // اگر جلسه تست نیست، لیست خالی برگردانید
    }

    switch (sessionId) {
      case 5:
        return [
          Vocabulary(id: 1, word: 'apple'),   // لغات باید دقیقاً همین‌طور باشد
          Vocabulary(id: 2, word: 'banana'),
          Vocabulary(id: 3, word: 'orange'),
        ];
      case 10:
        return [
          Vocabulary(id: 1, word: 'car'),
          Vocabulary(id: 2, word: 'house'),
          Vocabulary(id: 3, word: 'tree'),
        ];
      case 15:
        return [
          Vocabulary(id: 1, word: 'water'),
          Vocabulary(id: 2, word: 'sky'),
          Vocabulary(id: 3, word: 'mountain'),
        ];
    // سایر جلسات تست
      default:
        return [];
    }
  }
}
