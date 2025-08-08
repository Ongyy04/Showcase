import 'package:hive/hive.dart';

part 'login_event.g.dart';

@HiveType(typeId: 1)
class LoginEvent extends HiveObject {
  @HiveField(0)
  int userKey;

  @HiveField(1)
  DateTime at;

  LoginEvent({required this.userKey, required this.at});
}
