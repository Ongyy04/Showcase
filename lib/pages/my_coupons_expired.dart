import 'package:flutter/material.dart';

class MyCouponsExpiredPage extends StatelessWidget {
  const MyCouponsExpiredPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold를 사용하여 전체 화면을 구성합니다.
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5), // 배경을 반투명하게 만듭니다.
      body: Center(
        child: Container(
          width: 300, // 팝업의 가로 크기
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 콘텐츠 크기에 맞춰 높이 조절
            children: [
              const Text(
                '사용기한 만료 안내',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // 이미지를 Asset으로 추가했다고 가정합니다.
              Image.asset(
                'assets/images/sad.png', // 이미지 경로를 실제 파일명으로 수정하세요.
                width: 80,
                height: 80,
              ),
              const SizedBox(height: 16),
              const Text(
                '기한이 만료되어 사용하실 수 없습니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // '확인' 버튼을 누르면 이전 화면으로 돌아갑니다.
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEDC56), // 이미지의 노란색 배경과 동일한 색상
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
      ),
    );
  }
}