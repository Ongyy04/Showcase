import 'package:flutter/material.dart';
import 'package:my_app/pages/setting_page.dart';

class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({super.key});

  @override
  State<PurchaseHistoryPage> createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  String selectedPurchaseButton = '전체';
  final List<String> purchaseOptions = ['전체', '나에게 선물한 내역', '친구에게 선물한 내역'];

  final List<Map<String, String>> purchases = [
    {
      'brand': '컴포즈커피',
      'name': '카페 아메리카노 Tall',
      'store': '구로 스타벅스점',
      'date': '2025-02-03 14:34',
      'price': '₩4,500',
      'status': '결제완료',
      'type': '구매',
      'method': '포인트 결제',
      'image': 'assets/images/composeamericano.png',
    },
    {
      'brand': '메가커피',
      'name': '콜드브루 라떼',
      'store': '강남 메가커피점',
      'date': '2025-01-27 12:10',
      'price': '₩4,800',
      'status': '결제완료',
      'type': '구매',
      'method': '네이버페이 결제',
      'image': 'assets/images/megalatte.jpg',
    },
    {
      'brand': '스타벅스',
      'name': '카페라떼 Tall',
      'store': '수원역점',
      'date': '2025-01-11 09:45',
      'price': '₩5,000',
      'status': '결제완료',
      'type': '구매',
      'method': '포인트 + 카카오페이 결제',
      'image': 'assets/images/starcafe.png',
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
      'method': '포인트 결제',
      'image': 'assets/images/ventimango.jpg',
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
      'method': '포인트 결제',
      'image': 'assets/images/megamericano.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredPurchases = selectedPurchaseButton == '전체'
        ? purchases
        : selectedPurchaseButton == '나에게 선물한 내역'
            ? purchases.where((p) => p['type'] == '구매').toList()
            : purchases.where((p) => p['type'] == '선물').toList();

    return Scaffold(
      backgroundColor: Colors.white,
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
                Text('CASHLOOP', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
    children: ['선물하기', '구매내역', '내 기프티콘'].map((tab) {
      final bool isSelected = tab == '구매내역';
      return GestureDetector(
        onTap: () {
          if (tab == '선물하기') {
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
            Text(
              '────────',
              style: TextStyle(color: isSelected ? Colors.black : Colors.transparent),
            ),
          ],
        ),
      );
    }).toList(),
  ),
),

          // 드롭다운
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: Colors.white,
            child: DropdownButtonHideUnderline(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF383C59),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<String>(
                  value: selectedPurchaseButton,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    setState(() {
                      selectedPurchaseButton = value!;
                    });
                  },
                  items: purchaseOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option,
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                    );
                  }).toList(),
                  selectedItemBuilder: (BuildContext context) {
                    return purchaseOptions.map((String option) {
                      return Center(
                        child: Text(
                          option,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
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
                final isGift = item['type'] == '선물';
                final isPurchase = item['type'] == '구매';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [ // ✅ 이 줄이 꼭 있어야 함
                          Padding(
                            padding: const EdgeInsets.all(12), // ✅ 사진 여백 추가
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                item['image'] ?? 'assets/images/cafe.png',
                                height: 130, // ✅ 기존보다 작게
                                width: double.infinity,
                                fit: BoxFit.contain, // ✅ 비율 유지하며 여백 생김
                              ),
                            ),
                          ),
                        

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 브랜드 + 가격
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item['brand'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold)),
                                Text(item['price'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // 상세 설명 (CASHLOOP 제거)
                            Text(
                              (item['name'] ?? '').replaceAll('CASHLOOP', ''),
                              style: const TextStyle(fontSize: 15, color: Colors.black87),
                            ),
                            const SizedBox(height: 10),

                            // 시간 / 지점 구분
                            if (item['date'] != null || item['store'] != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item['date'] ?? '',
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 13)),
                                  if (item['store'] != null)
                                    Text(item['store'] ?? '',
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 13)),
                                ],
                              ),
                            const SizedBox(height: 10),

                            // 노란 결제창
                            if (isPurchase)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE266),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    item['method'] ?? '네이버페이 결제',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                        fontSize: 14),
                                  ),
                                ),
                              ),

                            // 선물 내역일 때 문구
                            if (isGift) ...[
                              const SizedBox(height: 8),
                              Text(
                                '${item['recipient'] ?? ''}님에게 선물함',
                                style: const TextStyle(color: Colors.black54, fontSize: 13),
                              ),
                              if (item['message'] != null)
                                Text(
                                  '메시지: ${item['message']}',
                                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                                ),

                              // ✅ 여기가 새로 추가된 “노란 결제창” 부분
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE266), // 노란 배경색
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    item['method'] ?? '네이버페이 결제',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ]

                          ],
                        ),
                      ),
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
