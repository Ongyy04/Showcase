import 'package:flutter/material.dart';

class CouponDetailPage extends StatelessWidget {
  const CouponDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('쿠폰 상세 페이지')),
      body: const Center(child: Text('여기가 상세페이지입니다.')),
    );
  }
}
