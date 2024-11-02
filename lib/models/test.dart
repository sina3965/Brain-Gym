import 'package:hive/hive.dart';

part 'test.g.dart';
@HiveType(typeId: 2)


class Test {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String type;// لغات، شمارش، استروپ

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
   String  score; // امتیاز تست

  Test({required this.id, required this.type, required this.date, required this.score});
}
