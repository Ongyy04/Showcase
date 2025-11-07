import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/database.dart';
import '../models/user.dart';
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

  int? _currentUserKey;

  @override
  void initState() {
    super.initState();
    _currentUserKey = DatabaseService.currentUserKey();
  }

  Widget _buildStarPoint() {
    if (_currentUserKey == null) {
      return const Text(
        '-',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color(0xFF383C59),
        ),
      );
    }
    return ValueListenableBuilder<Box<User>>(
      valueListenable: DatabaseService.users.listenable(keys: [_currentUserKey!]),
      builder: (_, box, __) {
        final user = box.get(_currentUserKey!);
        final point = user?.starPoint ?? 0;
        return Text(
          '$point',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF383C59),
          ),
        );
      },
    );
  }

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
  leadingWidth: 70,     // 로고가 차지할 영역
  titleSpacing: 0,      // 텍스트와 로고 간격 최소화
  leading: Padding(
    padding: const EdgeInsets.only(left: 12.0), // 왼쪽 벽에서 12px 떨어지게
    child: IconButton(
      icon: Image.asset('assets/images/logo.png', width: 40, height: 40),
      onPressed: () => Navigator.pop(context),
    ),
  ),
  title: const Text(
    'CASHLOOP',
    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  ),
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/people'),
            child: Image.asset('assets/images/people.png', width: 24, height: 24),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/search'),
            child: Image.asset('assets/images/home.png', width: 24, height: 24),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/settings'),
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
          // 상단 포인트 + 프로필 영역
Container(
  padding: const EdgeInsets.all(20),
  color: Colors.white,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ValueListenableBuilder<Box<User>>(
        valueListenable: DatabaseService.users.listenable(keys: [_currentUserKey!]),
        builder: (context, box, _) {
          final user = box.get(_currentUserKey!);
          final userName = user?.username ?? '사용자';
          final profileImage = 'assets/images/hello.png';

          return Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  profileImage,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$userName님',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    '반가워요 $userName님, 추천 상품을 확인하세요!',
                    style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 22, 22, 22)),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      Row(
        children: [
          Image.asset(
            'assets/images/point.png',
            width: 20,
            height: 20,
            color: const Color(0xFF383C59),
          ),
          const SizedBox(width: 6),
          _buildStarPoint(),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: DropdownButtonHideUnderline(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF383C59),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 0),
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
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            item['image'] ?? 'assets/images/cafe.png',
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            Text(
                              (item['name'] ?? '').replaceAll('CASHLOOP', ''),
                              style: const TextStyle(fontSize: 15, color: Colors.black87),
                            ),
                            const SizedBox(height: 10),
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
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE266),
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
