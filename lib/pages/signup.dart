import 'dart:math';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../database.dart';
import '../utils/security.dart';
import '../services/directory_service.dart';
import 'package:flutter/services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  /// 0: ID, 1: PW, 2: Phone, 3: Code, 4: Birthday(+Gender)
  int _step = 0;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  String _verificationCode = '';

  // 새로 추가: 생일/성별
  String _birthdayString = ''; // 'YYYY.MM.DD'
  String _gender = 'g';        // 'g' or 'b'

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
              primary: Color(0xFFFFC107),
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
          label: '인증번호 입력',
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
        return _buildFinalStep(); // 생일+성별 + 가입완료
      default:
        return const SizedBox();
    }
  }

  Widget _buildFinalStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAppBar(),
        const SizedBox(height: 24),
        const Text('생년월일 입력', style: TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickBirthday,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white),
            ),
            child: Row(
              children: [
                Text(
                  _birthdayString.isEmpty ? '생년월일을 선택하세요' : _birthdayString,
                  style: TextStyle(color: _birthdayString.isEmpty ? Colors.grey : Colors.black),
                ),
                const Spacer(),
                const Icon(Icons.calendar_today, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        const Text('성별 선택', style: TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 8),
        Row(
          children: [
            _genderChip('여성(g)', 'g'),
            const SizedBox(width: 8),
            _genderChip('남성(b)', 'b'),
          ],
        ),
        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC107),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: _handleSignUp,
            child: const Text('회원가입 완료'),
          ),
        ),
      ],
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
          color: selected ? const Color(0xFFFFC107) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? const Color(0xFFFFC107) : Colors.grey.shade300),
        ),
        child: Text(label, style: TextStyle(color: selected ? Colors.black : Colors.black87)),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    // 검증
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

    // 1) User 저장
    final newUser = User(
      username: username,
      passwordHash: hashPassword(pw),
      phone: phone,
    );
    final key = await DatabaseService.addUser(newUser);
    await DatabaseService.setCurrentUserKey(key);

    // 2) DirectoryService에 '가입자 정보' 반영 (CSV 대신 override 박스에 저장됨)
    try {
      await DirectoryService.addOrUpdateRecord(
        phone: phone,
        birthday: _birthdayString,
        gender: _gender,
      );
    } catch (e) {
      // 실패해도 회원가입은 성공 처리
      // ignore: avoid_print
      print('DirectoryService.addOrUpdateRecord failed: $e');
    }

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
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
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
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          decoration: InputDecoration(
            counterText: maxLength != null ? '' : null,
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
