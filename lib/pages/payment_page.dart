// lib/pages/payment_page.dart
import 'package:flutter/material.dart';
import 'package:my_app/models/friend.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool? usePoint; // 초기에는 선택 안 됨 상태
  int availablePoint = 6200;

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments as Map?) ?? {};
    final String brand = args['brand'] ?? '';
    final String name  = args['name'] ?? '';
    final String image = args['imageAsset'] ?? '';
    final int price    = args['salePrice'] ?? 0;
    final int qty      = args['qty'] ?? 1;
    final Friend? friend = args['friend'] as Friend?;

    final int itemTotal = price * qty;
    final int pointUse  = (usePoint == true) ? itemTotal.clamp(0, availablePoint) : 0;
    final int payTotal  = (itemTotal - pointUse).clamp(0, 1 << 31);

    const primary = Color(0xFF383C59);
    const accent  = Color(0xFFF9DB63);
    const cardBg  = Color(0xFFF6F6F6);
    const divider = Color(0xFFE7E8EC);

    double imageBoxSize = MediaQuery.of(context).size.height / 5.5;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('결제 페이지', style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600)),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: imageBoxSize,
                        height: imageBoxSize,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: divider),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(color: primary, shape: BoxShape.circle),
                                    child: Center(
                                      child: Image.asset(
                                        friend?.imagePath ?? 'assets/images/chick_g1.png',
                                        width: 37,
                                        height: 37,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      '${friend?.name ?? ''}님에게 선물',
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Text('[$brand] $name', style: const TextStyle(fontSize: 15, color: Colors.black87)),
                              const SizedBox(height: 2),
                              Text('수량: $qty', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                _PaymentOptionCard(
                  selected: usePoint == true,
                  onTap: () => setState(() => usePoint = true),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('CASHLOOP  POINT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      SizedBox(height: 6),
                      Text('사용 가능 포인트: 6,200P', style: TextStyle(fontSize: 13, color: Colors.black54)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                _PaymentOptionCard(
                  selected: usePoint == false,
                  onTap: () => setState(() => usePoint = false),
                  child: const Text('일반 결제  카드 / 간편결제', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),

                const SizedBox(height: 24),
                const Divider(height: 1),
                const SizedBox(height: 16),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('포인트 사용', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '- ${_fmtPoint(pointUse)}P',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 12),
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

                const SizedBox(height: 24),
                const Divider(height: 1),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const Text(
                      '최종 결제 금액',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    Baseline(
                      baseline: 22, // 원하는 만큼 내려주세요 (22~26 사이 추천)
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: usePoint == null
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('결제 진행')));
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('결제하기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _fmtPoint(int v) =>
      v.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');

  static String _fmtWon(int v) => _fmtPoint(v);
}

class _PaymentOptionCard extends StatelessWidget {
  final Widget child;
  final bool selected;
  final VoidCallback onTap;
  const _PaymentOptionCard({required this.child, required this.selected, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    const divider = Color(0xFFE7E8EC);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? Colors.black87 : divider, width: selected ? 1.2 : 1),
        ),
        child: Row(
          children: [
            Expanded(child: child),
            Icon(selected ? Icons.check_circle : Icons.radio_button_off,
                color: selected ? Colors.black : Colors.black26),
          ],
        ),
      ),
    );
  }
}
