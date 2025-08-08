import 'package:hive/hive.dart';

part 'gifticon.g.dart'; // Hive 어댑터 생성 파일

@HiveType(typeId: 3)
class Gifticon extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String imageUrl;

  @HiveField(3)
  String brand;

  @HiveField(4)
  int price;

  Gifticon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.brand,
    required this.price,
  });
}
