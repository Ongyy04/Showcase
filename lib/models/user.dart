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

  // 🔥 구매 내역 추가
  @HiveField(4)
  List<Map<String, dynamic>> purchaseHistory;

  // 🔥 거래 내역 추가 (입금/출금 등)
  @HiveField(5)
  List<Map<String, dynamic>> transactionHistory;

  User({
    required this.username,
    required this.passwordHash,
    required this.phone,
    this.starPoint = 0,
    this.purchaseHistory = const [],
    this.transactionHistory = const [],
  });
}
