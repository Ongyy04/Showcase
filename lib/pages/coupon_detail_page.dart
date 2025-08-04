import 'package:flutter/material.dart';

class CouponDetailPage extends StatelessWidget {
  const CouponDetailPage({super.key});

  // 여기서 직접 값 지정
  final String imageAsset = 'assets/images/cafe.png';
  final String brand = '스타벅스';
  final String name = '카페라떼 (ICE)';
  final String barcode = '784531358451234123';
  final int usableAmount = 250;
  final String expireDate = '2026년 07월 31일';
  final int pointAmount = 250;

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
          title: const Text(
            '모바일 쿠폰마켓',
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
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
                      backgroundColor: const Color(0xFF383C59), // 바깥 원 파란색
                      child: CircleAvatar(
                        radius: 16, // 안쪽 병아리 크기
                        backgroundImage: const AssetImage('assets/images/chick_g3.png'),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '김지안님의 선물',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // 상품 이미지 (흰 박스는 키우고, 사진은 고정 크기)
              Center(
                child: Container(
                  width: 300, // 흰색 박스 크기
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
                    child: Image.asset(
                      imageAsset,
                      width: 200, // 이미지 가로 크기 고정
                      height: 200, // 이미지 세로 크기 고정
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 상품명
              Center(
                child: Text(
                  '[$brand] $name',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 바코드
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/barcode.png',
                      width: 280,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      barcode,
                      style: const TextStyle(
                        fontSize: 14,
                        letterSpacing: 2,
                        color: Colors.black,
                      ),
                    ),
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
                    const Text(
                      '사용가능금액',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '$usableAmount원',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              // 유효기간 + 포인트 전환 가능 금액
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF383C59),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '유효기간',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        Text(
                          expireDate,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '포인트 전환 가능 금액',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        Text(
                          '$pointAmount원',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
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

