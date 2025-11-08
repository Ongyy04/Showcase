// lib/pages/login.dart
import 'package:flutter/material.dart';
import '../services/database.dart';
import '../models/user.dart';
import '../utils/security.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const primary = Color(0xFF383C59);
  static const accent  = Color(0xFFF9DB63);
  static const fieldBg = Colors.white;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final id = _idController.text.trim();
    final pwHash = hashPassword(_passwordController.text);
    if (id.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이디와 비밀번호를 입력하세요')),
      );
      return;
    }

    final box = DatabaseService.users;
    int? matchKey;
    for (final k in box.keys) {
      final u = box.get(k);
      if (u != null && u.username == id && u.passwordHash == pwHash) {
        matchKey = k as int;
        break;
      }
    }

    if (matchKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이디 또는 비밀번호가 올바르지 않습니다')),
      );
      return;
    }

    await DatabaseService.setCurrentUserKey(matchKey);
    await DatabaseService.logLogin(matchKey);
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/my_coupons');
    }
  }

  InputDecoration _inputDeco(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: fieldBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE7E8EC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE7E8EC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primary, width: 1.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    // 화면 세로에 따라 로고 크기를 살짝 조정
    final h = MediaQuery.of(context).size.height;
    final imgH1 = (h * 0.11).clamp(70.0, 90.0); // logo2.png
    final imgH2 = (h * 0.055).clamp(100.0, 170.0); // cashlooplogo.png

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                // ===== 로고 영역: 그림 로고 + 글자 로고 =====
                Column(
                  children: [
                    Image.asset(
                      'assets/images/logo2.png',
                      height: imgH1,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 0),
                    Image.asset(
                      'assets/images/cashlooplogo.png',
                      height: imgH2,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                TextField(
                  controller: _idController,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDeco('아이디'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: _inputDeco('비밀번호'),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '로그인',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: const Text(
                    '회원이 아니신가요?  회원가입하기',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 8),
                // 개발용 링크 유지
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/db'),
                  child: const Text('DB 확인 페이지 열기'),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
