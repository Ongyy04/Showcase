import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/search_page.dart';
import 'pages/order_page.dart';
import 'pages/my_coupons_page.dart';
import 'pages/people.dart';
import 'pages/coupon_detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Pretendard'),
      initialRoute: '/my_coupons',
      routes: {
        '/home': (context) => const HomePage(),
        '/search': (context) => const SearchPage(),
        '/order': (context) => const OrderPage(),
        '/my_coupons': (context) => const MyCouponsPage(),
        '/people': (context) => const PeoplePage(),
        '/coupon_detail': (context) => const CouponDetailPage(), 
        '/purchase': (context) => const MyPurchasePage(),   
        
      },
    );
  }
}

