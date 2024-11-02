import 'package:bg/models/exercise.dart';
import 'package:bg/models/test.dart';
import 'package:bg/models/user.dart';
import 'package:hive/hive.dart';

part 'session.g.dart';
@HiveType(typeId: 3)
class Session extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String day;

  @HiveField(2)
  List<Exercise> exercises;

  @HiveField(3)
  List<Test> test;

  @HiveField(4)
  final User user;

  Session({
    required this.id,
    required this.day,
    required this.exercises,
    required this.test,
    required this.user,
  });
}
