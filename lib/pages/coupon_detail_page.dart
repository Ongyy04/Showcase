import 'package:flutter/material.dart';
import '../services/database.dart';
import '../models/user.dart';

class CouponDetailPage extends StatefulWidget {
  const CouponDetailPage({super.key});

  @override
  State<CouponDetailPage> createState() => _CouponDetailPageState();
}

class _CouponDetailPageState extends State<CouponDetailPage> {
  // 상태 변수
  String imageAsset = 'assets/images/백억.png';
  String brand = '백억커피';
  String name = '바닐라 라떼 (ICE)';
  String barcode = '784531358451234123';
  int usableAmount = 250;
  String expireDate = '2026년 07월 31일';
  int pointAmount = 250;

  // 전환 아이콘 상태
  String switchIcon = 'assets/images/switch_yellow.png';

  // 포인트 전환 약관 안내 팝업
  void _showPointInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('포인트 전환 약관 안내',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const SizedBox(height: 26),
                const Text(
                  '「상품권 표준약관」 제7조 및 「소비자분쟁해결기준(공정거래위원회 고시)」에 의거하여, '
                  '1만 원 이하의 상품권은 80% 이상, 1만 원을 초과하는 상품권은 60% 이상 사용한 경우 '
                  '잔액에 대해 포인트 반환이 가능합니다.',
                  style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                  textAlign: TextAlign.start,
                  softWrap: true,
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9DB63),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('확인',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 포인트 전환 팝업
  void _showPointConvertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('스타포인트로 전환하기',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text('${pointAmount}P를 포인트로 전환하시겠습니까?',
                    style: const TextStyle(fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('취소',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
  child: TextButton(
    style: TextButton.styleFrom(
      backgroundColor: const Color(0xFFF9DB63),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(vertical: 12),
    ),
    onPressed: () async {
      final userBox = DatabaseService.users;
      final currentUserKey = DatabaseService.currentUserKey();
      if (currentUserKey != null) {
        final user = userBox.get(currentUserKey);
        if (user != null) {
          print("🔍 before: ${user.starPoint}");
user.starPoint += pointAmount;
await DatabaseService.users.put(user.key, user);
print("🔍 after: ${DatabaseService.users.get(user.key)!.starPoint}");

        }
      }

      setState(() {
        usableAmount = 0;
        pointAmount = 0;
        switchIcon = 'assets/images/switch.png';
      });

      Navigator.pop(context, true);
    },
    child: const Text(
      '예',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      textAlign: TextAlign.center,

    ),
  ),
),

                  ],
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
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          titleSpacing: 0,
          title: const Text('모바일 쿠폰마켓',
              style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600)),
          actions: [
            Image.asset('assets/images/people.png', width: 24, height: 24),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/home'),
              child: Image.asset('assets/images/home.png', width: 24, height: 24),
            ),
            const SizedBox(width: 16),
            Image.asset('assets/images/more.png', width: 24, height: 24),
            const SizedBox(width: 12),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 프로필 + 선물 문구
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFF383C59),
                      child: const CircleAvatar(
                        radius: 16,
                        backgroundImage: AssetImage('assets/images/chick_g3.png'),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('김지안님의 선물', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // 상품 이미지
              Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Center(
                    child: Image.asset(imageAsset, width: 200, height: 200, fit: BoxFit.contain),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 상품명
              Center(
                child: Text('[$brand] $name', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 12),

              // 바코드
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/images/barcode.png', width: 280, height: 70, fit: BoxFit.contain),
                    const SizedBox(height: 6),
                    Text(barcode,
                        style: const TextStyle(fontSize: 14, letterSpacing: 2, color: Colors.black)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 사용가능금액
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9DB63),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('사용가능금액', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    Text('$usableAmount원',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),

              // 유효기간 + 포인트 전환 가능 금액
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF383C59),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    // 유효기간
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('유효기간', style: TextStyle(color: Colors.white, fontSize: 14)),
                        Text(expireDate, style: const TextStyle(color: Colors.white, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // 포인트 전환 가능 금액 + 아이콘
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('포인트 전환 가능 금액',
                                style: TextStyle(color: Colors.white, fontSize: 14)),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => _showPointInfoDialog(context),
                              child: Image.asset('assets/images/info.png', width: 12, height: 12),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('$pointAmount원',
                                style: const TextStyle(color: Colors.white, fontSize: 14)),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => _showPointConvertDialog(context),
                              child: Image.asset(switchIcon, width: 30, height: 30),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
