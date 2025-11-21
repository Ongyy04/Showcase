// lib/pages/myinfo.dart

import 'package:flutter/material.dart';
import 'package:my_app/services/recommendation_service.dart';
import 'package:my_app/models/gifticon.dart';
import 'package:my_app/services/database.dart';
import 'package:my_app/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
// GifticonDetailPage는 별도의 파일에 있거나 여기에 포함되어야 합니다.

class MyInfo extends StatefulWidget {
  const MyInfo({super.key});

  @override
  State<MyInfo> createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {
  final RecommendationService recommendationService = RecommendationService();
  List<Gifticon> recommendedGifticons = [];
  bool isLoading = true;
  String selectedPrivacy = '비공개';

  User? get currentUser => DatabaseService.currentUser();

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  // 1. 플레이스홀더 기프티콘 더미 데이터 정의
  final List<Map<String, String>> placeholderGifts = [
    {
      'name': '메가커피 아메리카노',
      'store': '메가MGC커피 용인서천파크원점',
      'distance': '580m',
      'price': '1,900원',
      'image': 'assets/images/megamericano.png', 
    },
    {
      'name': '스타벅스 라떼 Tall',
      'store': '스타벅스 경희대국제캠퍼스점',
      'distance': '830m',
      'price': '5,000원',
      'image': 'assets/images/starcafe.png', 
    },
    {
      'name': '더벤티 애플망고 에이드',
      'store': '더벤티 수원영통중앙점',
      'distance': '1.4km',
      'price': '3,800원',
      'image': 'assets/images/ventimango.jpg', 
    },
  ];

  Future<void> _fetchRecommendations() async {
    const String userId = 'arin73';
    final recommendations =
        await recommendationService.getRecommendations(userId);

    setState(() {
      recommendedGifticons = recommendations;
      isLoading = false;
    });
  }

  void _showPlaceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child:
                    Text('장소 등록하기', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: '도로명/000/00로 찾기..',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: '장소명',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.home, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFDD5D),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:
                      const Text('확인', style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPrivacyInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('정보 공개 범위 안내',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
                const SizedBox(height: 20),
                const Text(
                    '기프티콘 추천 기능은 집 주소 및 결제 내역을 기반으로 개인 맞춤형 선물을 추천해드립니다.',
                    style: TextStyle(fontSize: 14, color: Colors.black)),
                const SizedBox(height: 16),
                const Text('정보 공개 범위를 아래 중에서 선택하실 수 있어요:',
                    style: TextStyle(fontSize: 14, color: Colors.black)),
                const SizedBox(height: 12),
                const Text('비공개: 나만 추천받을 수 있어요. 친구들에게는 노출되지 않아요.',
                    style: TextStyle(fontSize: 14, color: Colors.black)),
                const SizedBox(height: 8),
                const Text('친한 친구 공개: 지정한 친한 친구만 당신의 추천 기프티콘을 확인할 수 있어요.',
                    style: TextStyle(fontSize: 14, color: Colors.black)),
                const SizedBox(height: 8),
                const Text('모든 친구 공개: 내 친구라면 누구나 추천받은 기프티콘을 볼 수 있어요.',
                    style: TextStyle(fontSize: 14, color: Colors.black)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('프라이버시는 안전하게 보호됩니다.',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                    SizedBox(width: 8),
                    Icon(Icons.lock_outline, size: 18, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Spacer(),
                    Image.asset('assets/images/hello.png', width: 80),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFDD5D),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child:
                        const Text('확인', style: TextStyle(color: Colors.black)),
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
    final userName = currentUser?.username ?? "사용자";

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/images/arrow.png', width: 24, height: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('모바일 쿠폰마켓',
            style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                Image.asset('assets/images/people.png', width: 24, height: 24),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/search'),
                  child: Image.asset('assets/images/home.png',
                      width: 24, height: 24),
                ),
              ],
            ),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/people'),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child:
                                Text('친구', style: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text('내 정보',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Text('내 정보 공개 범위 설정',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => _showPrivacyInfo(context),
                          child: Image.asset('assets/images/info.png',
                              width: 12),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF383C59),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isDense: true,
                              value: selectedPrivacy,
                              dropdownColor: const Color(0xFF383C59),
                              icon: Image.asset(
                                  'assets/images/down.arrow.png',
                                  width: 12,
                                  height: 12),
                              items: ['비공개', '친한 친구 공개', '전체공개']
                                  .map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12)),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedPrivacy = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child:
                        Text('나의 장소', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF383C59),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.school, color: Colors.white),
                          SizedBox(width: 10),
                          Text('경희대학교 국제캠퍼스',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () => _showPlaceDialog(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: const Center(
                          child: Text('+ 장소 등록하기',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                        'CASHLOOP가 추천해주는 $userName님 맞춤 기프티콘',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('$userName님 근처에서 요즘 인기 있는 기프티콘을 모아봤어요!',
                        style: const TextStyle(
                            color: Color.fromARGB(128, 31, 30, 30),
                            fontSize: 15)),
                  ),
                  const SizedBox(height: 10),
                  _buildRecommendedGifticonList(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildRecommendedGifticonList() {
    if (recommendedGifticons.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/images/mapping.png',
                width: 350,
                height: 350,
              ),
              const SizedBox(height: 7),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: placeholderGifts.length,
                itemBuilder: (context, index) {
                  final gift = placeholderGifts[index];
                  return _VerticalGiftCard(
                    name: gift['name']!,
                    store: gift['store']!,
                    distance: gift['distance']!,
                    price: gift['price']!,
                    imagePath: gift['image']!,
                  );
                },
              ),
              const SizedBox(height: 15),
              const Text(
                '지금 있는 곳 근처의 추천 기프티콘 사용 가능 매장이에요.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: recommendedGifticons.length,
        itemBuilder: (context, index) {
          final gifticon = recommendedGifticons[index];
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          GifticonDetailPage(gifticon: gifticon),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12)),
                      child: CachedNetworkImage(
                        imageUrl: gifticon.imagePath,
                        width: 150,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            gifticon.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${gifticon.price}원',
                            style: TextStyle(color: Colors.green[700]),
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
    );
  }
}

// 기프티콘 상세 페이지 위젯
class GifticonDetailPage extends StatelessWidget {
  final Gifticon gifticon;
  const GifticonDetailPage({super.key, required this.gifticon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gifticon.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: gifticon.imagePath,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '브랜드: ${gifticon.brand}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '가격: ${gifticon.price}원',
                style: const TextStyle(fontSize: 18, color: Colors.green),
              ),
              const SizedBox(height: 16),
              const Text(
                '상품 설명: 이 기프티콘은 전국 모든 매장에서 사용 가능합니다.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 새로운 세로 기프티콘 카드 위젯
class _VerticalGiftCard extends StatelessWidget {
  final String name;
  final String store;
  final String distance;
  final String price;
  final String imagePath;

  const _VerticalGiftCard({
    required this.name,
    required this.store,
    required this.distance,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '$store · $distance 이내',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      // "사용 가능" 텍스트 제거됨
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
