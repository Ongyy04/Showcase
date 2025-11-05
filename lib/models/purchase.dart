import 'package:hive/hive.dart';

part 'purchase.g.dart';

@HiveType(typeId: 1) // User 모델의 typeId와 겹치지 않게 1로 설정
class Purchase extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String productId;

  @HiveField(2)
  final DateTime purchaseDate;

  @HiveField(3)
  final int quantity;

  Purchase({
    required this.userId,
    required this.productId,
    required this.purchaseDate,
    required this.quantity,
  });
}