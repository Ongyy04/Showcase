// my_coupons_page.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/database.dart';
import '../models/user.dart';

class MyCouponsPage extends StatefulWidget {
  const MyCouponsPage({super.key});

  @override
  State<MyCouponsPage> createState() => _MyCouponsPageState();
}

class _MyCouponsPageState extends State<MyCouponsPage> {
  String selectedTab = '내 기프티콘';
  String selectedSortOption = '최신순';
  final List<String> sortOptions = ['최신순', '오래된순', '가나다순'];

  int? _currentUserKey;

  // 백억커피 쿠폰이 포인트로 전환됐는지 여부
  bool _isBaeokConverted = false;

  @override
  void initState() {
    super.initState();
    _currentUserKey = DatabaseService.currentUserKey();
  }

  Future<void> _showExpiredDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '사용기한 만료 안내',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Image.asset('assets/images/sad.png', width: 150, height: 150),
                const SizedBox(height: 15),
                const Text(
                  '기한이 만료되어 사용하실 수 없습니다.',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
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
      valueListenable: DatabaseService.users.listenable(),
      builder: (context, box, _) {
        final user = box.get(_currentUserKey);
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
    return Scaffold(
      backgroundColor: Colors.white,
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
                if (_currentUserKey != null)
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                '반가워요 $userName님, 내 기프티콘을 확인하세요!',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 22, 22, 22),
                                ),
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
                final bool isSelected = selectedTab == tab;
                return GestureDetector(
                  onTap: () {
                    if (tab == '선물하기') {
                      Navigator.pushNamed(context, '/search');
                    } else if (tab == '구매내역') {
                      Navigator.pushNamed(context, '/purchase_list');
                    } else if (tab == '내 기프티콘') {
                      setState(() {
                        selectedTab = tab;
                      });
                    }
                  },
                  child: Column(
                    children: [
                      Text(
                        tab,
                        style: TextStyle(
                          color: isSelected ? Colors.black : const Color(0xFF878C93),
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
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
          ),

          // 정렬 드롭다운
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: DropdownButtonHideUnderline(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF383C59),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButton<String>(
                  value: selectedSortOption,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  dropdownColor: const Color(0xFF383C59),
                  borderRadius: BorderRadius.circular(12),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSortOption = newValue!;
                    });
                  },
                  items: sortOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child:
                          Text(option, style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  selectedItemBuilder: (BuildContext context) {
                    return sortOptions.map((String option) {
                      return Center(
                        child: Text(
                          option,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),

          // 쿠폰 리스트
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const CouponCard(
                    imageAsset: 'assets/images/starcafe.png',
                    brand: '스타벅스',
                    name: '카페라떼 (ICE)',
                    period: '2025.08.11~2026.08.11',
                    statusLabel: '미사용',
                    statusColor: Color(0xFFFFE96A),
                    statusTextColor: Colors.black,
                  ),

                  // 포인트 전환 가능한 백억커피 쿠폰
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _isBaeokConverted
                        ? null
                        : () async {
                            final result = await Navigator.pushNamed(
                              context,
                              '/coupon_detail',
                            );

                            // 상세 페이지에서 true를 보내주면 사용완료로 전환
                            if (result == true && mounted) {
                              setState(() {
                                _isBaeokConverted = true;
                              });
                            }
                          },
                    child: CouponCard(
                      imageAsset: 'assets/images/백억.png',
                      brand: '백억커피',
                      name: '바닐라 라떼 (ICE)',
                      period: '2025.08.11~2026.08.11',
                      statusLabel: _isBaeokConverted
                          ? '사용완료'
                          : '포인트 전환 가능 금액: 250원',
                      statusColor: _isBaeokConverted
                          ? const Color(0xFF2F2C46)
                          : const Color(0xFFFFE96A),
                      statusTextColor:
                          _isBaeokConverted ? Colors.white : Colors.black,
                    ),
                  ),

                  const CouponCard(
                    imageAsset: 'assets/images/megamericano.png',
                    brand: '메가커피',
                    name: '아이스아메리카노 (ICE)',
                    period: '2025.08.11~2026.08.11',
                    statusLabel: '사용완료',
                    statusColor: Color(0xFF2F2C46),
                    statusTextColor: Colors.white,
                  ),
                  GestureDetector(
                    onTap: _showExpiredDialog,
                    child: const CouponCard(
                      imageAsset: 'assets/images/cp.png',
                      brand: '컴포즈커피',
                      name: '아이스아메리카노 (ICE)',
                      period: '2025.08.11~2026.08.11',
                      statusLabel: '기한 만료',
                      statusColor: Color(0xFF2F2C46),
                      statusTextColor: Colors.white,
                    ),
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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imageAsset,
              width: 50,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(brand,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('사용기한: $period',
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(color: statusTextColor, fontSize: 12),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
