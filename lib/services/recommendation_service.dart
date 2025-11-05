// lib/services/recommendation_service.dart
import 'package:collection/collection.dart';
import 'package:my_app/services/database.dart';
import 'package:my_app/models/purchase.dart';
import 'package:my_app/models/gifticon.dart';

class RecommendationService {
  List<Purchase> get allPurchases => DatabaseService.purchases.values.toList();
  List<Gifticon> get allGifticons => DatabaseService.gifticons.values.toList();

  Future<List<Gifticon>> getRecommendations(String userId) async {
    final userPurchasesMap = groupBy(allPurchases, (obj) => obj.userId);
    final currentUserPurchases = userPurchasesMap[userId] ?? [];
    final currentUserProductIds = currentUserPurchases.map((p) => p.productId).toSet();

    String? mostSimilarUser;
    double maxSimilarity = -1;

    userPurchasesMap.forEach((otherUserId, otherUserPurchases) {
      if (otherUserId == userId) return;

      final otherUserProductIds = otherUserPurchases.map((p) => p.productId).toSet();
      final intersectionSize = currentUserProductIds.intersection(otherUserProductIds).length;
      final unionSize = currentUserProductIds.length + otherUserProductIds.length - intersectionSize;
      final similarity = unionSize > 0 ? intersectionSize / unionSize : 0.0;

      if (similarity > maxSimilarity) {
        maxSimilarity = similarity;
        mostSimilarUser = otherUserId;
      }
    });

    if (mostSimilarUser != null && maxSimilarity > 0) {
      final recommendedProductIds = userPurchasesMap[mostSimilarUser]!
          .map((p) => p.productId)
          .toSet()
          .difference(currentUserProductIds);

      return recommendedProductIds
          .map((id) => allGifticons.firstWhere(
                (g) => g.id == id,
                orElse: () => Gifticon(
                  id: id,
                  name: 'Unknown',
                  brand: '',
                  price: 0,
                  // 🔴 수정: 누락된 필수 필드들을 임시값으로 추가했습니다.
                  ownerUserKey: -1,
                  imagePath: 'assets/images/placeholder.png',
                  purchaseDate: DateTime.now(),
                  expiryDate: DateTime.now(),
                  isUsed: false,
                  canConvert: false,
                  // convertiblePrice: null, // nullable 필드는 생략 가능
                ),
              ))
          .take(3)
          .toList();
    }

    return _getTopSellingProducts(currentUserProductIds);
  }

  List<Gifticon> _getTopSellingProducts(Set<String> userPurchasedItems) {
    Map<String, int> productCounts = {};
    for (var purchase in allPurchases) {
      String productId = purchase.productId;
      productCounts.update(productId, (value) => value + 1, ifAbsent: () => 1);
    }
    
    final sortedProductIds = productCounts.keys.toList()
      ..sort((a, b) => productCounts[b]!.compareTo(productCounts[a]!));
      
    final topProductIds = sortedProductIds.where((p) => !userPurchasedItems.contains(p)).take(3).toList();
    
    return topProductIds
        .map((id) => allGifticons.firstWhere(
              (g) => g.id == id,
              orElse: () => Gifticon(
                id: id,
                name: 'Unknown',
                brand: '',
                price: 0,
                // 🔴 수정: 누락된 필수 필드들을 임시값으로 추가했습니다.
                ownerUserKey: -1,
                imagePath: 'assets/images/placeholder.png',
                purchaseDate: DateTime.now(),
                expiryDate: DateTime.now(),
                isUsed: false,
                canConvert: false,
                // convertiblePrice: null,
              ),
            ))
        .toList();
  }
}