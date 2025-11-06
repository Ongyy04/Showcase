import 'package:hive/hive.dart';

part 'friend.g.dart';

@HiveType(typeId: 4) // 기존과 동일한 typeId 사용
class Friend extends HiveObject {
  @HiveField(0)
  int ownerUserKey;

  @HiveField(1)
  String name;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String birthday; // 'YYYY.MM.DD' 또는 '미가입자'

  @HiveField(4)
  int level; // 1~4 (친밀도)

  @HiveField(5)
  String type; // 'g'|'b'

  // ✅ 새 필드: 즐겨찾기(친밀도와 독립)
  @HiveField(6)
  bool isFavorite;

  Friend({
    required this.ownerUserKey,
    required this.name,
    required this.phone,
    required this.birthday,
    this.level = 1,
    required this.type,
    this.isFavorite = false, // 기본값
  });

  // 캐릭터 이미지: 성별+레벨
  String get imagePath => 'assets/images/chick_${type}${level}.png';
}
