import 'package:flutter/material.dart';

class MyCouponsPage extends StatefulWidget {
  const MyCouponsPage({super.key});

  @override
  State<MyCouponsPage> createState() => _MyCouponsPageState();
}

class _MyCouponsPageState extends State<MyCouponsPage> {
  String selectedTab = '내 기프티콘';
  String sortOption = '최신순';
  final List<String> sortOptions = ['최신순', '오래된순', '가나다순'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/images/arrow.png', width: 24, height: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '모바일 쿠폰마켓',
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/people'),
                  child: Image.asset('assets/images/people.png', width: 24, height: 24),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/home'),
                  child: Image.asset('assets/images/home.png', width: 24, height: 24),
                ),
                const SizedBox(width: 16),
                Image.asset('assets/images/more.png', width: 24, height: 24),
              ],
            ),
          )
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 잔액 영역
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('gifcon', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Row(
                  children: const [
                    Icon(Icons.monetization_on, color: Color(0xFF383C59)),
                    SizedBox(width: 6),
                    Text(
                      '2,300',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF383C59),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          // 하단 탭 메뉴
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['홈', '검색', '구매내역', '내 기프티콘'].map((tab) {
                    final bool isSelected = selectedTab == tab;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = tab;
                          if (tab == '홈') Navigator.pushNamed(context, '/home');
                          if (tab == '검색') Navigator.pushNamed(context, '/search');
                        });
                      },
                      child: Column(
                        children: [
                          Text(
                            tab,
                            style: TextStyle(
                              color: isSelected ? Colors.black : const Color(0xFF878C93),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '────────',
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // 정렬 옵션
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            color: Colors.white,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: sortOptions.map((option) {
                      return ListTile(
                        title: Text(option),
                        onTap: () {
                          setState(() {
                            sortOption = option;
                            Navigator.pop(context);
                          });
                        },
                      );
                    }).toList(),
                  ),
                );
              },
              child: Row(
                children: [
                  Text(sortOption, style: const TextStyle(color: Colors.black, fontSize: 14)),
                  const SizedBox(width: 6),
                  Image.asset('assets/images/down.arrow.png', width: 16, height: 16),
                ],
              ),
            ),
          ),

          // 쿠폰 목록
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.pushNamed(context, '/coupon_detail'),
                    child: const CouponCard(
                      imageAsset: 'assets/images/cafe.png',
                      brand: '스타벅스',
                      name: '카페라떼 (ICE)',
                      period: '2025.08.11~2026.08.11',
                      statusLabel: '포인트 전환 가능 금액: 250원',
                      statusColor: Color(0xFFFFE96A),
                      statusTextColor: Colors.black,
                    ),
                  ),
                  const CouponCard(
                    imageAsset: 'assets/images/ade.png',
                    brand: '이디야커피',
                    name: '베리베리에이드 (ICE)',
                    period: '2025.08.11~2026.08.11',
                    statusLabel: '미사용',
                    statusColor: Color(0xFFFEDC56),
                    statusTextColor: Colors.black,
                  ),
                  const CouponCard(
                    imageAsset: 'assets/images/americano.png',
                    brand: '메가커피',
                    name: '아이스아메리카노 (ICE)',
                    period: '2025.08.11~2026.08.11',
                    statusLabel: '사용완료',
                    statusColor: Color(0xFF2F2C46),
                    statusTextColor: Colors.white,
                  ),
                  const CouponCard(
                    imageAsset: 'assets/images/americano.png',
                    brand: '컴포즈커피',
                    name: '아이스아메리카노 (ICE)',
                    period: '2025.08.11~2026.08.11',
                    statusLabel: '기한 만료',
                    statusColor: Colors.black,
                    statusTextColor: Colors.white,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CouponCard extends StatelessWidget {
  final String imageAsset;
  final String brand;
  final String name;
  final String period;
  final String statusLabel;
  final Color statusColor;
  final Color statusTextColor;

  const CouponCard({
    super.key,
    required this.imageAsset,
    required this.brand,
    required this.name,
    required this.period,
    required this.statusLabel,
    required this.statusColor,
    required this.statusTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imageAsset, width: 50, height: 100, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(brand, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('사용기한: $period', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(statusLabel, style: TextStyle(color: statusTextColor, fontSize: 12)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}