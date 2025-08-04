import 'package:flutter/material.dart';

class Coupon {
  final String imageAsset;
  final String brand;
  final String name;
  final String period;
  final CouponStatus status;

  final String statusLabel;
  final int? pointAmount;

  Coupon({
    required this.imageAsset,
    required this.brand,
    required this.name,
    required this.period,
    required this.status,
    required this.statusLabel,
    this.pointAmount,
  });
}

enum CouponStatus { point, unused, used, expired }

class MyCouponsPage extends StatelessWidget {
  MyCouponsPage({super.key});

  final List<Coupon> coupons = [
    Coupon(
      imageAsset: 'assets/images/cafe.png',
      brand: '어쩌구저쩌구 카페',
      name: '카페라떼 (ICE)',
      period: '2025.08.11~2026.08.11',
      status: CouponStatus.point,
      statusLabel: '포인트 전환 가능 금액: 250원',
      pointAmount: 250,
    ),
    Coupon(
      imageAsset: 'assets/images/ade.png',
      brand: '어쩌구저쩌구 카페',
      name: '베리베리에이드 (ICE)',
      period: '2025.08.11~2026.08.11',
      status: CouponStatus.unused,
      statusLabel: '미사용',
    ),
    Coupon(
      imageAsset: 'assets/images/americano.png',
      brand: '어쩌구저쩌구 카페',
      name: '아이스아메리카노 (ICE)',
      period: '2025.08.11~2026.08.11',
      status: CouponStatus.used,
      statusLabel: '사용완료',
    ),
    Coupon(
      imageAsset: 'assets/images/americano.png',
      brand: '어쩌구저쩌구 카페',
      name: '아이스아메리카노 (ICE)',
      period: '2025.08.11~2026.08.11',
      status: CouponStatus.expired,
      statusLabel: '기한 만료',
    ),
  ];

  Color getStatusBgColor(CouponStatus status) {
    switch (status) {
      case CouponStatus.point:
        return const Color(0xFFFFE96A); // 노랑
      case CouponStatus.unused:
        return const Color(0xFFFEDC56); // 연노랑
      case CouponStatus.used:
        return const Color(0xFF2F2C46); // 남색
      case CouponStatus.expired:
        return Colors.black;
    }
  }

  Color getStatusTextColor(CouponStatus status) {
    switch (status) {
      case CouponStatus.point:
      case CouponStatus.unused:
        return Colors.black;
      case CouponStatus.used:
      case CouponStatus.expired:
        return Colors.white;
    }
  }

  void showExpiredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '사용기한 만료 안내',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 16),
              Image.asset(
                'assets/images/expired_chick.png', // 안내 캐릭터 이미지 필요
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 16),
              const Text(
                '기한이 만료되어 사용하실 수 없습니다.',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE96A),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('확인', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          '모바일 쿠폰마켓',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Color(0xFF383C59)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Color(0xFF383C59)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF383C59)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("gifcon", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Color(0xFF383C59), size: 18),
                    const SizedBox(width: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFECECEC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      child: const Text(
                        '2,300',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF383C59),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _TabItem(title: '홈', isSelected: false),
                  _TabItem(title: '검색', isSelected: false),
                  _TabItem(title: '구매내역', isSelected: false),
                  _TabItem(title: '내 기프티콘', isSelected: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              itemCount: coupons.length,
              itemBuilder: (context, i) {
                final coupon = coupons[i];
                final isExpired = coupon.status == CouponStatus.expired;
                return GestureDetector(
                  onTap: isExpired ? () => showExpiredDialog(context) : null,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              coupon.imageAsset,
                              width: 48,
                              height: 96,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  coupon.brand,
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  coupon.name,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '사용기한: ${coupon.period}',
                                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: getStatusBgColor(coupon.status),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    coupon.statusLabel,
                                    style: TextStyle(
                                      color: getStatusTextColor(coupon.status),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isSelected;

  const _TabItem({required this.title, required this.isSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 100,
      padding: const EdgeInsets.only(top: 18, bottom: 7),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.black : const Color(0xFF878C93),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 52,
            height: 5,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF383C59) : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
