import 'package:bg/models/session.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';
@HiveType(typeId: 1)
class User {
  @HiveField(0)
  final int id;

  @HiveField(1)
  String userName;

  @HiveField(2)
  late final DateTime startDate;

  @HiveField(3)
  final List<Session> sessions ;

  @HiveField(4)
  final  String phoneNumber;

  User( {required this.id,required this.sessions,required this.userName, required this.phoneNumber, required this.startDate});
}
