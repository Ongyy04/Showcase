import 'package:flutter/material.dart';

class MyCouponsPage extends StatefulWidget {
  const MyCouponsPage({super.key});

  @override
  State<MyCouponsPage> createState() => _MyCouponsPageState();
}

class _MyCouponsPageState extends State<MyCouponsPage> {
  String selectedMainTab = '내 기프티콘'; 
  String sortOption = '최신순';
  final List<String> sortOptions = ['최신순', '오래된순', '가나다순'];
  String selectedPurchaseButton = '전체';
  final List<String> purchaseOptions = ['전체', '구매하기', '선물하기'];

  void _showExpiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '사용기한 만료 안내',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Image.asset(
                  'assets/images/sad.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 15),
                const Text(
                  '기한이 만료되어 사용하실 수 없습니다.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEDC56),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '확인',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
        title: const Text('모바일 쿠폰마켓', style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/people');
                  },
                  child: Image.asset('assets/images/people.png', width: 24, height: 24),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: Image.asset('assets/images/home.png', width: 24, height: 24),
                ),
                const SizedBox(width: 16),
                Image.asset('assets/images/more.png', width: 24, height: 24),
              ],
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    Text('2,300', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF383C59))),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['홈', '검색', '구매내역', '내 기프티콘'].map((tab) {
                final bool isSelected = selectedMainTab == tab;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMainTab = tab;
                    });
                  },
                  child: Column(
                    children: [
                      Text(tab, style: TextStyle(color: isSelected ? Colors.black : const Color(0xFF878C93), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      const SizedBox(height: 2),
                      Text('────────', style: TextStyle(color: isSelected ? Colors.black : Colors.transparent))
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          
          if (selectedMainTab == '내 기프티콘') ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              color: Colors.white,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: sortOptions.map((option) => ListTile(
                        title: Text(option),
                        onTap: () {
                          setState(() {
                            sortOption = option;
                            Navigator.pop(context);
                          });
                        },
                      )).toList(),
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/coupon_detail');
                      },
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
                    GestureDetector(
                      onTap: () {
                        _showExpiredDialog();
                      },
                      child: const CouponCard(
                        imageAsset: 'assets/images/americano.png',
                        brand: '컴포즈커피',
                        name: '아이스아메리카노 (ICE)',
                        period: '2025.08.11~2026.08.11',
                        statusLabel: '기한 만료',
                        statusColor: Colors.black,
                        statusTextColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ] else if (selectedMainTab == '구매내역') ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: Colors.white,
              child: Row(
                children: purchaseOptions.map((option) {
                  final bool isSelected = selectedPurchaseButton == option;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedPurchaseButton = option;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: option == '선물하기' ? 0 : 8),
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFDAF17) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: isSelected ? null : Border.all(color: const Color(0xFF878C93)),
                        ),
                        child: Text(
                          option,
                          style: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF878C93),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // '총 0건' 텍스트
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                '총 0건',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              // 선택된 버튼에 따라 텍스트 변경
                              selectedPurchaseButton == '선물하기'
                                  ? '선물한 내역이 없습니다.'
                                  : '구매한 내역이 없습니다.',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                '이용약관',
                                style: TextStyle(fontSize: 12, color: Colors.black54),
                              ),
                              const SizedBox(width: 8),
                              Container(width: 1, height: 12, color: Colors.black12),
                              const SizedBox(width: 8),
                              const Text(
                                '개인정보처리방침',
                                style: TextStyle(fontSize: 12, color: Colors.black54),
                              ),
                            ],
                          ),
                          Row(
                            children: const [
                              Text(
                                '사업자정보',
                                style: TextStyle(fontSize: 12, color: Colors.black54),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.keyboard_arrow_up, size: 16, color: Colors.black54),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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