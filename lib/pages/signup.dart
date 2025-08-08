import 'dart:math';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../database.dart';
import '../utils/security.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  int _step = 0;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String _verificationCode = '';

  void _nextStep() {
    if (_step < 3) setState(() => _step++);
  }

  void _previousStep() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      Navigator.pop(context);
    }
  }

  void _sendVerificationCode() {
    final code = (Random().nextInt(900000) + 100000).toString();
    setState(() => _verificationCode = code);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('인증번호: $code')),
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: _previousStep,
          child: Image.asset('assets/images/arrow.png', width: 24),
        ),
        const SizedBox(width: 8),
        const Text('회원가입', style: TextStyle(color: Colors.white, fontSize: 20)),
      ],
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _buildInputStep(
          label: 'ID 설정',
          hint: '아이디',
          controller: _idController,
          buttonText: '중복확인',
          onPressed: () async {
            final inputId = _idController.text.trim();
            if (inputId.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('아이디를 입력해주세요')),
              );
              return;
            }
            if (DatabaseService.usernameExists(inputId)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('이미 사용 중인 아이디입니다')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('사용 가능한 아이디입니다')),
              );
              _nextStep();
            }
          },
        );
      case 1:
        return _buildInputStep(
          label: '비밀번호 설정',
          hint: '비밀번호',
          controller: _pwController,
          obscure: true,
          buttonText: '다음',
        );
      case 2:
        return _buildInputStep(
          label: '전화번호 입력',
          hint: '전화번호',
          controller: _phoneController,
          buttonText: '인증번호 받기',
          onPressed: () {
            final phone = _phoneController.text.trim();
            if (phone.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('전화번호를 입력해주세요')),
              );
              return;
            }
            if (DatabaseService.phoneExists(phone)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('이미 등록된 전화번호입니다')),
              );
              return;
            }
            _sendVerificationCode();
            _nextStep();
          },
        );
      case 3:
        return _buildInputStep(
          label: '인증번호 입력',
          hint: '인증번호 입력',
          controller: _codeController,
          buttonText: '회원가입 완료',
          onPressed: _handleSignUp,
        );
      default:
        return const SizedBox();
    }
  }

  Future<void> _handleSignUp() async {
    if (_codeController.text != _verificationCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('인증번호가 일치하지 않습니다')),
      );
      return;
    }

    final username = _idController.text.trim();
    final phone = _phoneController.text.trim();
    final pw = _pwController.text;

    // 마지막 방어 (중복체크 재확인)
    if (DatabaseService.usernameExists(username)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미 사용 중인 아이디입니다')),
      );
      return;
    }
    if (DatabaseService.phoneExists(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미 등록된 전화번호입니다')),
      );
      return;
    }

    final newUser = User(
      username: username,
      passwordHash: hashPassword(pw),
      phone: phone,
    );
    final key = await DatabaseService.addUser(newUser);
    await DatabaseService.setCurrentUserKey(key);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입이 완료되었습니다!')),
      );
      Navigator.pushReplacementNamed(context, '/my_coupons');
    }
  }

  Widget _buildInputStep({
    required String label,
    required String hint,
    required TextEditingController controller,
    String? buttonText,
    VoidCallback? onPressed,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAppBar(),
        const SizedBox(height: 24),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC107),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: onPressed ?? _nextStep,
            child: Text(buttonText ?? '다음'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF353A60),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: SingleChildScrollView(child: _buildStep()),
      ),
    );
  }
}
