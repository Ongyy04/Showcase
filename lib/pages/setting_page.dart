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

            // ✅ 아래쪽 전체 메뉴
            // 로그아웃 / Language / 닫기 버튼
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
                      ),
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

            // 좌우 2단 구조 (기프티콘 메뉴)
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
                        _leftMenuItem('기프티콘샵'),
                        _leftMenuItem('내 쿠폰'),
                        _leftMenuItem('주문/배송'),
                        _leftMenuItem('포인트/적립'),
                        _leftMenuItem('고객센터'),
                        _leftMenuItem('공지사항'),
                        _leftMenuItem('앱 설정'),
                      ],
                    ),
                  ),

                  // 오른쪽 내용
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _rightSectionTitle('최근 이용 메뉴'),
                        _rightMenuItem('기프티콘 구매'),
                        _rightMenuItem('내 쿠폰함'),
                        _rightMenuItem('포인트 충전'),
                        const SizedBox(height: 16),

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
                        const Text('자주 사용하는 메뉴를 등록해 보세요.', style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 16),

                        _rightSectionTitle('기프티콘샵'),
                        _rightMenuItem('기프티콘 구매하기'),
                        _rightMenuItem('브랜드별 기프티콘'),
                        _rightMenuItem('이벤트/할인전'),

                        _rightSectionTitle('내 쿠폰'),
                        _rightMenuItem('보유 쿠폰함'),
                        _rightMenuItem('사용 내역'),
                        _rightMenuItem('쿠폰 등록'),

                        _rightSectionTitle('포인트/적립'),
                        _rightMenuItem('포인트 내역'),
                        _rightMenuItem('적립 혜택 안내'),

                        _rightSectionTitle('고객센터'),
                        _rightMenuItem('자주 묻는 질문'),
                        _rightMenuItem('문의하기'),
                        _rightMenuItem('공지사항'),
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

  static Widget _leftMenuItem(String title, {bool isBold = false, bool isActive = false}) {
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

  static Widget _rightSectionTitle(String title) {
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

  static Widget _rightMenuItem(String title) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.star_border, size: 18, color: Colors.transparent),
      onTap: () {},
    );
  }
}
