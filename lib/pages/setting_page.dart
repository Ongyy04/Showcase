import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 로그아웃 / Language / 닫기 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {},
                    child: const Text('로그아웃', style: TextStyle(fontSize: 14)),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.language, size: 20, color: Colors.grey),
                      const SizedBox(width: 4),
                      const Text('Language', style: TextStyle(fontSize: 14)),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ],
              ),
            ),

            // 최근 접속 시간
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '최근접속 2025.08.08 14:32',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 4),

            // 검색창
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '메뉴를 검색해보세요.',
                  hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                  prefixIcon: const Icon(Icons.search),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // 서비스 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _serviceButton(Icons.headset_mic, '고객센터'),
                  _serviceButton(Icons.lock, '인증/보안'),
                  _serviceButton(Icons.settings, '환경설정'),
                ],
              ),
            ),

            const Divider(height: 1, color: Colors.grey),

            // 좌우 2단 구조
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 왼쪽 메뉴
                  Container(
                    width: 120,
                    color: Colors.grey[100],
                    child: ListView(
                      children: [
                        _leftMenuItem('최근/My메뉴', isBold: true, isActive: true),
                        _leftMenuItem('조회'),
                        _leftMenuItem('이체'),
                        _leftMenuItem('상품가입'),
                        _leftMenuItem('가입상품관리'),
                        _leftMenuItem('자산관리'),
                        _leftMenuItem('공과금'),
                        _leftMenuItem('외환'),
                        _leftMenuItem('금융편의'),
                        _leftMenuItem('혜택'),
                        _leftMenuItem('멤버십'),
                        _leftMenuItem('생활/제휴'),
                        _leftMenuItem('테마별서비스'),
                      ],
                    ),
                  ),

                  // 오른쪽 내용
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // 최근 이용 메뉴
                        _rightSectionTitle('최근 이용 메뉴'),
                        _rightMenuItem('환전신청'),
                        _rightMenuItem('인증/보안'),
                        _rightMenuItem('한번에홈'),
                        const SizedBox(height: 16),

                        // My메뉴
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _rightSectionTitle('My메뉴'),
                            TextButton(
                              onPressed: () {},
                              child: const Text('설정', style: TextStyle(color: Colors.grey)),
                            ),
                          ],
                        ),
                        const Text('My메뉴를 설정해 보세요.', style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 16),

                        // 조회
                        _rightSectionTitle('조회'),
                        _rightMenuItem('전체계좌조회'),
                        _rightMenuItem('통합거래내역조회'),
                        _rightMenuItem('해지계좌조회'),
                        _rightMenuItem('휴면예금·보험금 찾기'),
                        _rightMenuItem('수수료 납부내역조회'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _serviceButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.grey[800]),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _leftMenuItem(String title, {bool isBold = false, bool isActive = false}) {
    return Container(
      color: isActive ? Colors.white : Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
          color: isActive ? Colors.black : Colors.grey[800],
        ),
      ),
    );
  }

  Widget _rightSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(width: 4, height: 14, color: Colors.orange),
          const SizedBox(width: 6),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _rightMenuItem(String title) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.star_border, size: 18, color: Color.fromRGBO(255, 255, 255, 0.2442)),
      onTap: () {},
    );
  }
}
