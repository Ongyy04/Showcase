import 'package:hive/hive.dart';

part 'gifticon.g.dart'; // Hive 어댑터 생성 파일

@HiveType(typeId: 2) // typeId는 고유해야 합니다. 
class Gifticon extends HiveObject { // HiveObject를 상속하면 key와 같은 기능을 쉽게 사용할 수 있습니다.
  @HiveField(0)
  late String id;
  
  @HiveField(1)
  late String name;
  
  @HiveField(2)
  late String brand;
  
  @HiveField(3)
  late int ownerUserKey; // 이 기프티콘을 소유한 사용자의 키
  
  @HiveField(4)
  late String imagePath;
  
  @HiveField(5)
  late DateTime purchaseDate;
  
  @HiveField(6)
  late DateTime expiryDate;
  
  @HiveField(7)
  late bool isUsed;
  
  @HiveField(8)
  late bool canConvert;
  
  @HiveField(9)
  late int price; // 원래 쿠폰 금액

  @HiveField(10)
  late int usableAmount; // 잔여 사용 가능 금액
  
  @HiveField(11)
  late int pointAmount; // 잔여 포인트

  @HiveField(12) // HiveField 번호는 기존 번호와 겹치지 않게 주의하세요.
  final int? convertiblePrice;

  Gifticon({
    required this.id,
    required this.name,
    required this.brand,
    required this.ownerUserKey,
    required this.imagePath,
    required this.purchaseDate,
    required this.expiryDate,
    required this.price,
    this.isUsed = false,
    this.canConvert = false,
    this.usableAmount = 0,
    this.pointAmount = 0,
    this.convertiblePrice,
  });

  // copyWith 함수도 통합된 모델에 맞게 수정
  Gifticon copyWith({
    String? id,
    String? name,
    String? brand,
    int? ownerUserKey,
    String? imagePath,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    bool? isUsed,
    bool? canConvert,
    int? price,
    int? usableAmount,
    int? pointAmount,
  }) {
    return Gifticon(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      ownerUserKey: ownerUserKey ?? this.ownerUserKey,
      imagePath: imagePath ?? this.imagePath,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      isUsed: isUsed ?? this.isUsed,
      canConvert: canConvert ?? this.canConvert,
      price: price ?? this.price,
      usableAmount: usableAmount ?? this.usableAmount,
      pointAmount: pointAmount ?? this.pointAmount,
    );
  }
}