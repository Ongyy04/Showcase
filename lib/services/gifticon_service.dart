// lib/services/gifticon_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'database.dart';
import '../models/gifticon.dart';

class GifticonService {
  // 서버에서 카탈로그 받아오는 예시 (URL은 나중에 실제로 교체)
  static Future<int> syncFromServer(String url) async {
    final resp = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
    });
    if (resp.statusCode == 200) {
      final map = jsonDecode(resp.body) as Map<String, dynamic>;
      final items = (map['items'] as List).cast<Map<String, dynamic>>();
      int upserts = 0;
      final box = DatabaseService.gifticons;

      for (final m in items) {
        final id = m['id'] as String;
        final existingKey = box.keys.cast<dynamic?>().firstWhere(
          (k) => box.get(k)!.id == id,
          orElse: () => null,
        );

        // 🔴 수정: 'imageUrl' 대신 'imagePath' 필드에 값을 할당합니다.
        final g = Gifticon(
          id: id,
          name: m['name'] as String,
          brand: m['brand'] as String,
          price: (m['price'] as num).toInt(),
          imagePath: m['image'] as String, // 서버에서 받아온 URL을 imagePath에 저장
          ownerUserKey: -1, 
          purchaseDate: DateTime.now(),
          expiryDate: DateTime.now().add(const Duration(days: 365)),
          isUsed: false,
          canConvert: false,
        );
        if (existingKey == null) {
          await box.add(g);
        } else {
          await box.put(existingKey, g);
        }
        upserts++;
      }
      return upserts;
    } else if (resp.statusCode == 304) {
      return 0;
    } else {
      throw Exception('Failed to fetch catalog: ${resp.statusCode}');
    }
  }

  // 서버 없을 때 샘플 넣기
  static Future<void> seedSamples() async {
    final box = DatabaseService.gifticons;
    if (box.isNotEmpty) return;

    final samples = <Gifticon>[
      Gifticon(
        id: 'sku_001',
        name: '아메리카노 Tall',
        imagePath: 'https://picsum.photos/seed/sku_001/400/400', // 🔴 수정
        brand: '스타벅스',
        price: 4500,
        ownerUserKey: -1,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 365)),
        isUsed: false,
        canConvert: false,
      ),
      Gifticon(
        id: 'sku_002',
        name: '카페라떼 ICE',
        imagePath: 'https://picsum.photos/seed/sku_002/400/400', // 🔴 수정
        brand: '이디야',
        price: 4200,
        ownerUserKey: -1,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 365)),
        isUsed: false,
        canConvert: false,
      ),
      Gifticon(
        id: 'sku_003',
        name: '초코 프라페',
        imagePath: 'https://picsum.photos/seed/sku_003/400/400', // 🔴 수정
        brand: '메가커피',
        price: 3800,
        ownerUserKey: -1,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 365)),
        isUsed: false,
        canConvert: false,
      ),
    ];

    for (final g in samples) {
      await box.add(g);
    }
  }
}