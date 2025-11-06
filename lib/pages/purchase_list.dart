import 'package:flutter/material.dart';
import 'package:my_app/pages/setting_page.dart';

class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({super.key});

  @override
  State<PurchaseHistoryPage> createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  String selectedPurchaseButton = '전체';
  final List<String> purchaseOptions = ['전체', '구매내역', '선물내역'];

  final List<Map<String, String>> purchases = [
    {
      'brand': '컴포즈커피',
      'name': '카페 아메리카노 Tall',
      'store': 'gifcon',
      'date': '2025-02-03 14:34',
      'price': '₩4,500',
      'status': '결제완료',
      'type': '구매',
      'method': '포인트 결제',
    },
    {
      'brand': '메가커피',
      'name': '콜드브루 라떼',
      'store': 'gifcon',
      'date': '2025-01-27 12:10',
      'price': '₩4,800',
      'status': '결제완료',
      'type': '구매',
      'method': '카드 결제',
    },
    {
      'brand': '스타벅스',
      'name': '카페라떼 Tall',
      'store': 'gifcon',
      'date': '2025-01-11 09:45',
      'price': '₩5,000',
      'status': '결제완료',
      'type': '구매',
      'method': '포인트 + 카드 결제',
    },
    {
      'brand': '더벤티',
      'name': '망고패션티',
      'recipient': '홍길동',
      'date': '2025-02-02 10:15',
      'price': '₩5,300',
      'status': '선물보냄',
      'type': '선물',
      'message': '시험 잘 봐~!',
    },
    {
      'brand': '메가커피',
      'name': '디카페인 아메리카노 Tall',
      'recipient': '이수민',
      'date': '2025-01-29 18:40',
      'price': '₩4,100',
      'status': '선물보냄',
      'type': '선물',
      'message': '고생했어 ☕',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredPurchases = selectedPurchaseButton == '전체'
        ? purchases
        : selectedPurchaseButton == '구매내역'
            ? purchases.where((p) => p['type'] == '구매').toList()
            : purchases.where((p) => p['type'] == '선물').toList();

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
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  ),
                  child: Image.asset('assets/images/more.png', width: 24, height: 24),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 잔액
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('gifcon', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(Icons.monetization_on, color: Color(0xFF383C59)),
                    SizedBox(width: 6),
                    Text('2,300',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF383C59))),
                  ],
                ),
              ],
            ),
          ),

          // 하단 탭
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['홈', '검색', '구매내역', '내 기프티콘'].map((tab) {
                final bool isSelected = tab == '구매내역';
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
                      Text(
                        tab,
                        style: TextStyle(
                          color: isSelected ? Colors.black : const Color(0xFF878C93),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text('────────',
                          style: TextStyle(color: isSelected ? Colors.black : Colors.transparent)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // 구매 / 선물 탭
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            color: Colors.white,
            child: Row(
              children: purchaseOptions.map((option) {
                final bool isSelected = selectedPurchaseButton == option;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedPurchaseButton = option),
                    child: Container(
                      margin: EdgeInsets.only(right: option == '선물내역' ? 0 : 8),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFFDAF17) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected ? null : Border.all(color: const Color(0xFF878C93)),
                      ),
                      child: Text(
                        option,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF878C93),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // 총 개수
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              '총 ${filteredPurchases.length}건',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),

          // 리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filteredPurchases.length,
              itemBuilder: (context, index) {
                final item = filteredPurchases[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset('assets/images/cafe.png',
                            width: 70, height: 70, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['brand'] ?? '',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            Text(item['name'] ?? '',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(
                              item['type'] == '구매'
                                  ? '${item['store']} • ${item['date']} • ${item['method']}'
                                  : '${item['recipient']}님에게 선물함 • ${item['date']}',
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                            if (item['type'] == '선물') ...[
                              const SizedBox(height: 6),
                              Text('메시지: ${item['message'] ?? ''}',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black54)),
                            ],
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: item['type'] == '구매'
                                      ? const Color(0xFFFEDC56)
                                      : const Color(0xFFFFE96A),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${item['price']} (${item['status']})',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
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
