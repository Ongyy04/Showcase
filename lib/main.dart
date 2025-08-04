import 'package:flutter/material.dart';
<<<<<<< HEAD
//김지안수정'
//김현정 수정이요
void main() => runApp(const MyApp());
=======
import 'pages/home_page.dart';
import 'pages/search_page.dart';
import 'pages/order_page.dart';
import 'pages/my_coupons_page.dart';

void main() {
  runApp(const MyApp());
}
>>>>>>> 7d95d7c31832520b37b6efc93f4ed86a6bdb532b

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
      },
    );
  }
}
