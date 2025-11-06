// lib/pages/home.dart

import 'package:flutter/material.dart';
import 'package:my_app/pages/setting_page.dart'; // settings_page.dart import

String _money(int v) =>
    v.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');

class Product {
  final String brand;
  final String title;
  final int price;
  final int? listPrice;
  final String imagePath; // 이미지 경로

  const Product({
    required this.brand,
    required this.title,
    required this.price,
    this.listPrice,
    required this.imagePath,
  });

  int get discount {
    if (listPrice == null || listPrice! <= price) return 0;
    return ((1 - price / listPrice!) * 100).round();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedTab = '홈';

  final List<Product> items = const [
    Product(
      brand: '이디야커피',
      title: '[이디야커피] 베리베리에이드 (ICE)',
      price: 3800,
      listPrice: 4000,
      imagePath: 'assets/images/ade.png',
    ),
    Product(
      brand: '컴포즈커피',
      title: '[컴포즈커피] 아이스 아메리카노',
      price: 2250,
      listPrice: 2500,
      imagePath: 'assets/images/americano.png',
    ),
    Product(
      brand: '바나프레소',
      title: '[바나프레소] 시그니처 아이스 아메리카노',
      price: 2700,
      imagePath: 'assets/images/americano.png',
    ),
    Product(
      brand: '백억커피',
      title: '[백억커피] 카라멜 팝콘 + 아메리카노',
      price: 9900,
      imagePath: 'assets/images/popcorn.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white, // 🔥 전체 배경 흰색으로 변경
    appBar: AppBar(
      backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/images/arrow.png', width: 24, height: 24),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          '모바일 쿠폰마켓',
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
        ),
        actions: [
          // 테스트 이동 아이콘 추가
          
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    );
                  },
                  child: Image.asset('assets/images/more.png', width: 24, height: 24),
                ),
              ],
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 브랜드/잔액
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

          // 탭 행
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['홈', '선물하기', '구매내역', '내 기프티콘'].map((tab) {
                      final bool isSelected = selectedTab == tab;
                      return GestureDetector(
                        onTap: () {
                          if (tab == '선물하기') {
                            Navigator.pushNamed(context, '/search');
                          } else if (tab == '구매내역') {
                            Navigator.pushNamed(context, '/purchase_list');
                          } else if (tab == '내 기프티콘') {
                            Navigator.pushNamed(context, '/my_coupons');
                          }
                          setState(() {
                            selectedTab = tab;
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
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              height: 2,
                              width: 30,
                              color: isSelected ? Colors.black : Colors.transparent,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

       

          // 그리드
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (_, i) => _ProductCard(p: items[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product p;
  const _ProductCard({required this.p});

  @override
  Widget build(BuildContext context) {
    const gapXS = SizedBox(height: 6);
    const gapSM = SizedBox(height: 8);

    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/coupon_detail'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset(p.imagePath),
                  ),
                ),
              ),
              gapSM,
              Text(
                p.brand,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
              gapXS,
              Text(
                p.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
              gapSM,
              if (p.listPrice != null && p.listPrice! > p.price)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    '${_money(p.listPrice!)}원',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black38,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
              Row(
                children: [
                  if (p.discount > 0)
                    Text(
                      '${p.discount}%',
                      style: const TextStyle(
                        color: Color(0xFFFF7A00),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  if (p.discount > 0) const SizedBox(width: 6),
                  Text(
                    '${_money(p.price)}원',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

