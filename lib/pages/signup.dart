// lib/pages/signup.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/database.dart';
import '../utils/security.dart';
import '../services/directory_service.dart';
import 'package:flutter/services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // 0: ID, 1: PW, 2: Phone, 3: Code, 4: Birthday(+Gender)
  int _step = 0;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  String _verificationCode = '';
  String _birthdayString = ''; // 'YYYY.MM.DD'
  String _gender = 'g';        // 'g' or 'b'

  static const primary = Color(0xFF383C59);
  static const accent  = Color(0xFFF9DB63);

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_step < 4) setState(() => _step++);
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

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20, 1, 1),
      firstDate: DateTime(1900, 1, 1),
      lastDate: now,
      helpText: '생년월일 선택',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: accent,
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final y = picked.year.toString().padLeft(4, '0');
      final m = picked.month.toString().padLeft(2, '0');
      final d = picked.day.toString().padLeft(2, '0');
      setState(() => _birthdayString = '$y.$m.$d');
    }
  }

  // ---------- UI 공통 ----------
  PreferredSizeWidget _whiteAppBar() => AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text('회원가입', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: _previousStep,
        ),
      );

  InputDecoration _inputDeco(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
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

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w600)),
      );

  // ---------- 스텝별 화면 ----------
  Widget _buildStepBody() {
    switch (_step) {
      case 0:
        return _buildInputStep(
          label: '아이디',
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
          label: '비밀번호',
          hint: '비밀번호',
          controller: _pwController,
          obscure: true,
          buttonText: '다음',
        );

      case 2:
        return _buildInputStep(
          label: '전화번호',
          hint: '숫자만 10~11자리',
          controller: _phoneController,
          buttonText: '인증번호 받기',
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 11,
          onPressed: () {
            final phone = _phoneController.text.trim();
            if (phone.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('전화번호를 입력해주세요')),
              );
              return;
            }
            if (phone.length < 10 || phone.length > 11) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('전화번호는 10~11자리 숫자여야 해요')),
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
          label: '인증번호',
          hint: '인증번호 6자리',
          controller: _codeController,
          buttonText: '다음',
          onPressed: () {
            if (_codeController.text != _verificationCode) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('인증번호가 일치하지 않습니다')),
              );
              return;
            }
            _nextStep();
          },
        );

      case 4:
        return _buildFinalStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildInputStep({
    required String label,
    required String hint,
    required TextEditingController controller,
    String? buttonText,
    VoidCallback? onPressed,
    bool obscure = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(label),
          TextField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            maxLength: maxLength,
            decoration: _inputDeco(hint).copyWith(counterText: maxLength != null ? '' : null),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onPressed ?? _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(buttonText ?? '다음',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('생년월일'),
          GestureDetector(
            onTap: _pickBirthday,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE7E8EC)),
              ),
              child: Row(
                children: [
                  Text(
                    _birthdayString.isEmpty ? '생년월일을 선택하세요' : _birthdayString,
                    style: TextStyle(color: _birthdayString.isEmpty ? Colors.black45 : Colors.black),
                  ),
                  const Spacer(),
                  const Icon(Icons.calendar_today, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          _sectionLabel('성별'),
          Row(
            children: [
              _genderChip('여성(g)', 'g'),
              const SizedBox(width: 10),
              _genderChip('남성(b)', 'b'),
            ],
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _handleSignUp,
              child: const Text('회원가입 완료',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _genderChip(String label, String value) {
    final selected = _gender == value;
    return GestureDetector(
      onTap: () => setState(() => _gender = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? accent : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? accent : const Color(0xFFE7E8EC)),
        ),
        child: Text(label, style: TextStyle(color: selected ? Colors.black : Colors.black87)),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    if (_codeController.text != _verificationCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('인증번호가 일치하지 않습니다')),
      );
      return;
    }
    if (_birthdayString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('생년월일을 선택해주세요')),
      );
      return;
    }

    final username = _idController.text.trim();
    final phone = _phoneController.text.trim();
    final pw = _pwController.text;

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

    try {
      await DirectoryService.addOrUpdateRecord(
        phone: phone,
        birthday: _birthdayString,
        gender: _gender,
      );
    } catch (_) {}

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입이 완료되었습니다!')),
      );
      Navigator.pushReplacementNamed(context, '/my_coupons');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _whiteAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 8, bottom: 24),
          child: _buildStepBody(),
        ),
      ),
    );
  }
}
