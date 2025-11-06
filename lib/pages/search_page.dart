import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String selectedTab = '검색';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
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
                GestureDetector(onTap: () {}, child: Image.asset('assets/images/people.png', width: 24, height: 24)),
                const SizedBox(width: 16),
                GestureDetector(onTap: () => Navigator.pushNamed(context, '/home'), child: Image.asset('assets/images/home.png', width: 24, height: 24)),
                const SizedBox(width: 16),
                Image.asset('assets/images/more.png', width: 24, height: 24),
              ],
            ),
          )
        ],
      ),
      backgroundColor: Colors.white, // 전체 배경을 흰색으로 유지
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('CASHLOOP', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                          if (tab == '홈') {
                            Navigator.pushNamed(context, '/home');
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
            // 이 부분을 회색 경계가 있는 Container로 감싸서 배경을 구분합니다.
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '찾고있는 상품이 있으신가요?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: '  스타벅스 아메리카노T 10% 할인',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: false,
                      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                      suffixIcon: Icon(Icons.search, color: Colors.black),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 이 부분이 회색 배경을 가져야 하는 부분입니다.
            Container(
              color:  Colors.white, 
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '이 달의 추천상품',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.7,
                      children: const [
                        RecommendedItemCard(
                          imageAsset: 'assets/images/sblatte.jpg',
                          brand: '스타벅스',
                          name: '카페라떼 (ICE)',
                          price: '4,500원',
                        ),
                        RecommendedItemCard(
                          imageAsset: 'assets/images/bery.jpg',
                          brand: '이디야커피',
                          name: '후르츠베리 에이드 (ICE)',
                          price: '4,800원',
                        ),
                        RecommendedItemCard(
                          imageAsset: 'assets/images/megeamericaco.jpg',
                          brand: '메가커피',
                          name: '아이스 아메리카노 (ICE)',
                          price: '2,000원',
                        ),
                        RecommendedItemCard(
                          imageAsset: 'assets/images/composeame.jpg',
                          brand: '컴포즈커피',
                          name: '아이스 아메리카노 (ICE)',
                          price: '1,500원',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecommendedItemCard extends StatelessWidget {
  final String imageAsset;
  final String brand;
  final String name;
  final String price;

  const RecommendedItemCard({
    super.key,
    required this.imageAsset,
    required this.brand,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12, // 그림자 색상으로 경계 효과 주기
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              imageAsset,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brand,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}