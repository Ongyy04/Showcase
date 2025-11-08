import 'package:flutter/material.dart';
import 'package:my_app/services/database.dart';
import '../models/user.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_app/pages/product_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String selectedTab = '선물하기';
  String selectedSection = '추천상품'; // ✅ 추천 섹션 상태 추가
  final TextEditingController _searchController = TextEditingController();
  int? _currentUserKey;

  @override
  void initState() {
    super.initState();
    _currentUserKey = DatabaseService.currentUserKey();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  // ✅ 추천상품 / 친구추천 버튼 생성 함수
  Widget _buildSectionButton(String label) {
    final bool isSelected = selectedSection == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSection = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ?const Color(0xFF383C59) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 친구 목록 동기 호출
    final friends = DatabaseService.friendsOfCurrentUser();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 70,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
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

      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 프로필/포인트
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentUserKey == null)
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/hello.png',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '게스트님',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            Text(
                              '로그인하고 추천 상품을 확인하세요!',
                              style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 22, 22, 22)),
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    ValueListenableBuilder<Box<User>>(
                      valueListenable:
                          DatabaseService.users.listenable(keys: [_currentUserKey!]),
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
                                  style: const TextStyle(
                                      fontSize: 14, color: Color.fromARGB(255, 22, 22, 22)),
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
                  final bool isSelected = tab == '선물하기';
                  return GestureDetector(
                    onTap: () {
                      if (tab == '구매내역') {
                        Navigator.pushNamed(context, '/purchase_list');
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
  // ✅ 추천상품 / 친구추천 버튼
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSectionButton('나에게 맞춤 추천'),
                  const SizedBox(width: 12),
                  _buildSectionButton('친구에게 맞춤 추천'),
                ],
              ),
            ),
            // 검색
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '찾고있는 상품이 있으신가요?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      enabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      focusedBorder:
                          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),

          

            // ✅ 섹션 전환
            if (selectedSection == '나에게 맞춤 추천') ...[
              Container(
                color: Colors.white,
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
                      childAspectRatio: 0.63,
                      children: [
                        RecommendedItemCard(
                          imageAsset: 'assets/images/starcafe.png',
                          brand: '스타벅스',
                          name: '카페라떼 (ICE)',
                          price: '4,500원',
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/product_detail',
                              arguments: {
                                'brand': '스타벅스',
                                'name': '카페라떼 (ICE)',
                                'imageAsset': 'assets/images/starcafe.png',
                                'originalPrice': 4500,
                                'salePrice': 4050,
                                'discountPercent': 10,
                              },
                            );
                          },
                        ),
                        RecommendedItemCard(
                          imageAsset: 'assets/images/bery.png',
                          brand: '이디야커피',
                          name: '후르츠베리 에이드 (ICE)',
                          price: '4,800원',
                        ),
                        RecommendedItemCard(
                          imageAsset: 'assets/images/megamericano.png',
                          brand: '메가커피',
                          name: '아이스 아메리카노 (ICE)',
                          price: '2,000원',
                        ),
                        RecommendedItemCard(
                          imageAsset: 'assets/images/composeamericano.png',
                          brand: '컴포즈커피',
                          name: '아이스 아메리카노 (ICE)',
                          price: '1,500원',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '내 친구 맞춤 추천 상품',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: friends.map((f) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1)),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/chick_${f.type}${f.level}.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        f.name,
                                        style: const TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${f.name}님이 동의한 정보로 추천한 맞춤 상품이에요!',
                                        style: const TextStyle(fontSize: 13, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Icon(
                                    f.isFavorite
                                        ? Icons.star_rounded
                                        : Icons.star_border_rounded,
                                    color:
                                        f.isFavorite ? Colors.amber : Colors.grey,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: const [
                                  Expanded(
                                    child: RecommendedItemCard(
                                      imageAsset: 'assets/images/starcafe.png',
                                      brand: '스타벅스',
                                      name: '카페라떼 (ICE)',
                                      price: '4,500원',
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: RecommendedItemCard(
                                      imageAsset: 'assets/images/bery.png',
                                      brand: '이디야커피',
                                      name: '후르츠베리 에이드 (ICE)',
                                      price: '4,800원',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// 추천 상품 카드
class RecommendedItemCard extends StatelessWidget {
  final String imageAsset;
  final String brand;
  final String name;
  final String price;
  final VoidCallback? onTap;

  const RecommendedItemCard({
    super.key,
    required this.imageAsset,
    required this.brand,
    required this.name,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
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
              child: Container(
                height: 160,
                width: double.infinity,
                color: const Color(0xFFF7F7F7),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Image.asset(imageAsset, fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(brand, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(price, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
