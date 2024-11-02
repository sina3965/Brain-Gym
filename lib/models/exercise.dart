import 'package:hive/hive.dart';
part 'exercise.g.dart';

@HiveType(typeId: 5)
class Exercise extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final int difficulty;

  @HiveField(3)
  final String record;

  Exercise({
    required this.id,
    required this.type,
    required this.difficulty,
    required this.record,
  });
}
