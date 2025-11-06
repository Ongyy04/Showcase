// lib/pages/payment_page.dart
import 'package:flutter/material.dart';
import 'package:my_app/models/friend.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool usePoint = true; // 포인트 결제 선택
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
    final int pointUse  = usePoint ? (itemTotal.clamp(0, availablePoint)) : 0;
    final int payTotal  = (itemTotal - pointUse).clamp(0, 1 << 31);

    const primary = Color(0xFF383C59);
    const accent  = Color(0xFFF9DB63);
    const cardBg  = Color(0xFFF6F6F6);
    const divider = Color(0xFFE7E8EC);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('결제 페이지', style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 상단 주문 요약
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 84, height: 84,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: divider),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(image, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 받는 친구
                    Row(
                      children: [
                        // 네이비 원 + 알 이미지
                        Container(
                          width: 28, height: 28,
                          decoration: const BoxDecoration(color: primary, shape: BoxShape.circle),
                          child: Center(child: Image.asset(friend?.imagePath ?? 'assets/images/chick_g1.png', width: 32, height: 32)),
                        ),
                        const SizedBox(width: 8),
                        Text('${friend?.name ?? ''}님에게 선물', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('[$brand] $name', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text('수량: $qty', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 결제 수단 카드: 포인트
          _PaymentOptionCard(
            selected: usePoint,
            onTap: () => setState(() => usePoint = true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // 로고/뱃지는 이미지 자산 준비되면 Image.asset(...) 로 교체
                Text('CASHLOOP  POINT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                SizedBox(height: 6),
                Text('사용 가능 포인트: 6,200P', style: TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 결제 수단 카드: 일반결제
          _PaymentOptionCard(
            selected: !usePoint,
            onTap: () => setState(() => usePoint = false),
            child: const Text('일반 결제  카드 / 간편결제', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),

          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // 포인트 사용 내역
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('포인트 사용', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              // 우측에는 실제 차감 표시
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('포인트 사용액', style: TextStyle(color: Colors.black54)),
              Text('- ${_fmtPoint(pointUse)}P', style: const TextStyle(fontWeight: FontWeight.w700)),
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

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // 최종 결제 금액
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('최종 결제 금액', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              Text('${_fmtWon(payTotal)}원', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 16),

          // 결제하기 버튼
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                // TODO: 결제 로직
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
          const SizedBox(height: 12),
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
