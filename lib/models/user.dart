import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String passwordHash;

  @HiveField(2)
  String phone;

  @HiveField(3)
  int starPoint;

  User({
    required this.username,
    required this.passwordHash,
    required this.phone,
    this.starPoint = 0,
  });
}
