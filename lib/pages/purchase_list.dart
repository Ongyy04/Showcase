import 'package:flutter/material.dart';
import 'package:my_app/pages/setting_page.dart'; // SettingsPage import

class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({super.key});

  @override
  State<PurchaseHistoryPage> createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  String selectedPurchaseButton = '전체';
  final List<String> purchaseOptions = ['전체', '구매하기', '선물하기'];

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
                GestureDetector(
                  onTap: () {
                    // 'more.png' 아이콘을 탭하면 SettingsPage로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsPage()),
                    );
                  },
                  child: Image.asset('assets/images/more.png', width: 24, height: 24),
                ),
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
                final bool isSelected = tab == '구매내역'; // 이 페이지에서는 구매내역 탭이 항상 선택된 상태
                return GestureDetector(
                  onTap: () {
                    if (tab == '홈') {
                      Navigator.pushNamed(context, '/home');
                    } else if (tab == '검색') {
                      Navigator.pushNamed(context, '/search');
                    } else if (tab == '내 기프티콘') {
                      Navigator.pushNamed(context, '/my_coupons');
                    }
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
      ),
    );
  }
}