// payment_page.dart
import 'package:flutter/material.dart';
import 'package:my_app/models/friend.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool usePoint = false;
  int availablePoint = 6200;

  String? _selectedPayMethod;

  final Map<String, double> logoScales = const {
    'kakaopay.png': 0.90,
    'naverpay.png': 0.80,
    'tosspay.png': 0.70,
    'kbcard.png': 1.00,
    'hanacard.png': 1.00,
    'nhcard.png': 1.00,
    'shinhan.png': 0.90,
    'lottcard.png': 0.90,
    'sinhyup.png': 1.00,
    'ibkcard.png': 0.90,
    'hyundai.png': 1.00,
    'wooricard.png': 0.95,
  };

  final Map<String, String> methodLabels = const {
    'kakaopay.png': '카카오페이',
    'naverpay.png': '네이버페이',
    'tosspay.png': '토스페이',
    'kbcard.png': 'KB국민카드',
    'hanacard.png': '하나카드',
    'nhcard.png': 'NH농협카드',
    'shinhan.png': '신한카드',
    'lottcard.png': '롯데카드',
    'sinhyup.png': '신협',
    'ibkcard.png': 'IBK 기업은행',
    'hyundai.png': '현대카드',
    'wooricard.png': '우리카드',
  };

  static const primary = Color(0xFF383C59);
  static const accent = Color(0xFFF9DB63);
  static const divider = Color(0xFFE7E8EC);

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments as Map?) ?? {};
    final String brand = args['brand'] ?? '';
    final String name = args['name'] ?? '';
    final String image = args['imageAsset'] ?? '';
    final int price = args['salePrice'] ?? 0;
    final int qty = args['qty'] ?? 1;
    final Friend? friend = args['friend'] as Friend?;

    // ▼ 셀프 선물 여부/표시값
    final bool isSelfGift = (friend == null) || (args['selfGift'] == true);
    final String avatarPath = isSelfGift ? 'assets/images/hello.png' : (friend!.imagePath);
    final String recipientLabel = isSelfGift ? '나에게 선물' : '${friend!.name}님에게 선물';

    final int itemTotal = price * qty;
    final int pointUse = usePoint ? availablePoint.clamp(0, itemTotal) : 0;
    final int payTotal = (itemTotal - pointUse).clamp(0, 1 << 31);

    final double imageBoxSize = MediaQuery.of(context).size.height / 5.5;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '결제 페이지',
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              children: [
                // 상품·수신자 요약
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Container(
                        width: imageBoxSize,
                        height: imageBoxSize,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: divider),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(image, fit: BoxFit.contain),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // ▼ 여기만 변경: 셀프 선물일 때는 네이비 원형 없이 hello.png만 크게
                                  if (isSelfGift)
                                    SizedBox(
                                      width: 70,  // 원하는 최종 크기
                                      height: 70,
                                      child: Image.asset(
                                        avatarPath,
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  else
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        color: primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          avatarPath,
                                          width: 37,
                                          height: 37,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      recipientLabel,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Text('[$brand] $name',
                                  style: const TextStyle(fontSize: 15, color: Colors.black87)),
                              const SizedBox(height: 2),
                              Text('수량: $qty',
                                  style: const TextStyle(fontSize: 14, color: Colors.black54)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ▶ 포인트 카드(스위치 + 요약을 한 카드로)
                _buildPointCard(pointUse: pointUse),

                const SizedBox(height: 16),

                // ▶ 일반 결제 선택 요약 카드
                _buildSelectedMethodTile(),

                const SizedBox(height: 24),
                const Divider(height: 1),
                const SizedBox(height: 16),

                // 최종 결제 금액
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: TextBaseline.alphabetic == null ? CrossAxisAlignment.center : CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const Text(
                      '최종 결제 금액',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    Baseline(
                      baseline: 22,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        '${_fmtWon(payTotal)}원',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 결제 버튼
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (payTotal == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('포인트로 결제 완료!')),
                    );
                  } else {
                    if (_selectedPayMethod == null) {
                      _showPaymentMethodSheet(context);
                    } else {
                      final label = methodLabels[_selectedPayMethod!] ?? '결제수단';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$label로 결제 완료!')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  '결제하기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ▼ 포인트 카드(스위치 + 요약 + 구분선)
  Widget _buildPointCard({required int pointUse}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: divider),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CASHLOOP 포인트 사용',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Switch(
                value: usePoint,
                onChanged: (v) => setState(() => usePoint = v),
                activeColor: Colors.white,
                activeTrackColor: primary,
                inactiveThumbColor: primary,
                inactiveTrackColor: const Color(0xFFF0F0F5),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('포인트 사용', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              Text('- ${_fmtPoint(pointUse)}P',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('포인트 사용 전', style: TextStyle(color: Colors.black54)),
              Text('${_fmtPoint(availablePoint)}P'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('포인트 사용 후', style: TextStyle(color: Colors.black54)),
              Text('${_fmtPoint(availablePoint - pointUse)}P'),
            ],
          ),
        ],
      ),
    );
  }

  // 하단 시트: 결제수단 선택
  void _showPaymentMethodSheet(BuildContext context) {
    final methods = [
      'kakaopay.png',
      'naverpay.png',
      'tosspay.png',
      'kbcard.png',
      'hanacard.png',
      'nhcard.png',
      'shinhan.png',
      'lottcard.png',
      'sinhyup.png',
      'ibkcard.png',
      'hyundai.png',
      'wooricard.png',
    ];

    String? tempSelected = _selectedPayMethod;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 0.95,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: methods
                    .map((img) => _buildPayMethodIcon(
                          'assets/images/$img',
                          isSelected: tempSelected == img,
                          onTap: () {
                            setModalState(() => tempSelected = img);
                            setState(() => _selectedPayMethod = img);
                            Navigator.pop(context);
                          },
                        ))
                    .toList(),
              ),
            );
          },
        );
      },
    );
  }

  // 카드 하나 (그리드용). 선택 시 검정 테두리
  Widget _buildPayMethodIcon(
    String imagePath, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    final fileName = imagePath.split('/').last;
    final double scale = (logoScales[fileName] ?? 0.72).clamp(0.5, 0.95);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.black : const Color(0xFFE7E8EC),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: const [
            BoxShadow(color: Color(0x11000000), blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double side = constraints.biggest.shortestSide;
            final double target = side * scale;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: target, maxHeight: target),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Image.asset(imagePath),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // 일반 결제 선택 요약 카드
  Widget _buildSelectedMethodTile() {
    return InkWell(
      onTap: () => _showPaymentMethodSheet(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: divider),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  '일반 결제 (카드 / 간편결제)',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text(
                  _selectedPayMethod == null
                      ? '선택'
                      : (methodLabels[_selectedPayMethod!] ?? ''),
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.keyboard_arrow_right, size: 18, color: Colors.black54),
              ],
            ),
            const SizedBox(height: 12),
            if (_selectedPayMethod != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 40,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Image.asset('assets/images/${_selectedPayMethod!}'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        methodLabels[_selectedPayMethod!] ?? '',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.centerLeft,
                child: const Text(
                  '결제수단을 선택하세요.',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '* 결제하기 클릭 시 각 서비스의 결제창으로 이동합니다.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _fmtPoint(int v) =>
      v.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');

  static String _fmtWon(int v) => _fmtPoint(v);
}
