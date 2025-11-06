import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigator.pushNamed(context, '/product_detail', arguments: {...}) 로 전달 가능
    final args = (ModalRoute.of(context)?.settings.arguments as Map?) ?? {};
    final String brand = args['brand'] ?? '스타벅스';
    final String name = args['name'] ?? '카페라떼 (ICE)';
    final String imageAsset = args['imageAsset'] ?? 'assets/images/starcafe.png';
    final int originalPrice = args['originalPrice'] ?? 4500;
    final int salePrice = args['salePrice'] ?? 4050;
    final int discountPercent = args['discountPercent'] ?? 10;

    const primary = Color(0xFF383C59); // 앱 메인 색
    const divider = Color(0xFFE7E8EC);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '상품 상세 페이지',
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.person_outline, size: 22),
          ),
          Padding(
            padding: EdgeInsets.only(right: 14),
            child: Icon(Icons.shopping_bag_outlined, size: 22),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // 이미지 카드
          Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
                ],
                border: Border.all(color: divider),
              ),
              child: SizedBox(
                width: 280,
                height: 280,
                child: Image.asset(imageAsset, fit: BoxFit.contain),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 제목
          Center(
            child: Text(
              '[$brand] $name',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),

          // 가격 영역
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_money(originalPrice)}원',
                style: const TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$discountPercent% ',
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                '${_money(salePrice)}원',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: divider),
          const SizedBox(height: 16),

          // 상품 설명
          const Text('상품 설명', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const _BulletLine('부드러운 우유가 들어있는 커피로 전세계적으로 스타벅스에서 가장 인기있는 음료중 하나입니다.'),
          const _BulletLine('Only ICE'),

          const SizedBox(height: 20),
          // 이용 안내
          const Text('이용 안내', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const _BulletLine('상기 이미지는 연출된 컷으로 실제와 다를 수 있습니다.'),
          const _BulletLine('일부 매장 재고, 상황에 따라 동일 상품으로 교환이 불가능할 수 있습니다.'),
          const _BulletLine('동일 상품 교환이 불가할 경우 다른 상품으로 교환이 가능합니다.'),
          const SizedBox(height: 80), // 하단 버튼 영역과 겹치지 않게 여백
        ],
      ),

      // 하단 플로팅 액션 박스
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6)),
            ],
            border: Border.all(color: divider),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: 나에게 선물 로직
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('나에게 선물하기')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: divider),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('나에게 선물', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: 친구에게 선물 로직
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('친구에게 선물하기')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('친구에게 선물', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _money(int v) =>
      v.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
}

class _BulletLine extends StatelessWidget {
  final String text;
  const _BulletLine(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(height: 1.35)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, height: 1.35))),
        ],
      ),
    );
  }
}
