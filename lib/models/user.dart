import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1) // 기존 password 자리에 hash를 저장
  String passwordHash;

  @HiveField(2)
  String phone;

  User({
    required this.username,
    required this.passwordHash,
    required this.phone,
  });
}
