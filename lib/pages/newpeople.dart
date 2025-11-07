// lib/pages/newpeople.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/services/database.dart';
import 'package:my_app/models/friend.dart';
import 'package:my_app/services/directory_service.dart';

class NewPeoplePage extends StatefulWidget {
  const NewPeoplePage({super.key});

  @override
  State<NewPeoplePage> createState() => _NewPeoplePageState();
}

class _NewPeoplePageState extends State<NewPeoplePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  String _birthdayPreview = '미가입자';
  String? _genderFromDir;
  String _typeManual = 'g';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _lookup() {
    FocusScope.of(context).unfocus();
    final rec = DirectoryService.recordForPhone(_phoneCtrl.text);
    setState(() {
      if (rec == null) {
        _birthdayPreview = '미가입자';
        _genderFromDir = null;
      } else {
        _birthdayPreview = rec.birthday;
        _genderFromDir = (rec.gender == 'b') ? 'b' : 'g';
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          rec == null ? '매칭 없음(미가입자)' : '매칭 성공: ${rec.birthday}, ${rec.gender}',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _submit() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('입력값을 확인하세요')),
      );
      return;
    }

    final owner = DatabaseService.currentUserKey();
    if (owner == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final digits = _phoneCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
      final rec = DirectoryService.recordForPhone(digits);

      final friend = Friend(
        ownerUserKey: owner,
        name: _nameCtrl.text.trim(),
        phone: digits,
        birthday: rec?.birthday ?? '미가입자',
        level: 1,
        type: rec?.gender ?? _typeManual,
      );

      final newKey = await DatabaseService.addFriend(friend);
      print('Friend saved with key=$newKey');

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('등록 완료', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),
                Text('${_nameCtrl.text.trim()} 친구가 추가됐어요.'),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFDD5D),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Text('확인'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('추가 실패: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final matched = _genderFromDir != null;
    final genderLabel = matched
        ? (_genderFromDir == 'b' ? '남성(b)' : '여성(g)')
        : (_typeManual == 'b' ? '남성(b)' : '여성(g)');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/images/arrow.png', width: 24, height: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '모바일 쿠폰마켓',
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
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
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            children: [
              // 친구 등록 카드
              _SectionCard(
                title: '친구 등록',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('이름'),
                    const SizedBox(height: 6),
                    _FilledField(
                      child: TextFormField(
                        controller: _nameCtrl,
                        textInputAction: TextInputAction.next,
                        decoration: _inputDecoration('이름을 입력하세요'),
                        validator: (v) => (v == null || v.trim().isEmpty) ? '이름을 입력하세요' : null,
                      ),
                    ),
                    const SizedBox(height: 14),

                    const _FieldLabel('전화번호'),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: _FilledField(
                            child: TextFormField(
                              controller: _phoneCtrl,
                              keyboardType: TextInputType.phone,
                              maxLength: 11,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: _inputDecoration('숫자만 입력해도 돼요').copyWith(counterText: ''),
                              validator: (v) {
                                final digits = (v ?? '').replaceAll(RegExp(r'[^0-9]'), '');
                                if (digits.isEmpty) return '전화번호를 입력하세요';
                                if (digits.length < 10 || digits.length > 11) {
                                  return '전화번호는 10~11자리 숫자여야 해요';
                                }
                                return null;
                              },
                              onChanged: (v) {
                                final d = v.replaceAll(RegExp(r'[^0-9]'), '');
                                if (d.length == 11) {
                                  _lookup();
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: _lookup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFDD5D),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            child: const Text('조회'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    const _FieldLabel('생일'),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(_birthdayPreview, style: const TextStyle(fontSize: 14)),
                    ),
                    const SizedBox(height: 14),

                    const _FieldLabel('성별'),
                    const SizedBox(height: 6),
                    if (matched)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF383C59),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lock, size: 16, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(genderLabel, style: const TextStyle(color: Colors.white, fontSize: 13)),
                            const Spacer(),
                            const Text('엑셀에서 매칭됨', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      )
                    else
                      Row(
                        children: [
                          _ToggleChip(
                            label: '여성(g)',
                            selected: _typeManual == 'g',
                            onTap: () => setState(() => _typeManual = 'g'),
                          ),
                          const SizedBox(width: 8),
                          _ToggleChip(
                            label: '남성(b)',
                            selected: _typeManual == 'b',
                            onTap: () => setState(() => _typeManual = 'b'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFDD5D),
                    disabledBackgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    _isSubmitting ? '추가 중...' : '추가하기',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      );
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        child,
      ]),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontWeight: FontWeight.w500));
}

class _FilledField extends StatelessWidget {
  final Widget child;
  const _FilledField({required this.child});
  @override
  Widget build(BuildContext context) =>
      Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)), child: child);
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ToggleChip({required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF383C59) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? const Color(0xFF383C59) : Colors.grey.shade300),
        ),
        child: Text(label, style: TextStyle(color: selected ? Colors.white : Colors.black, fontSize: 13)),
      ),
    );
  }
}
