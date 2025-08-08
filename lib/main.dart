import 'package:flutter/material.dart';
import 'package:my_app/pages/setting_page.dart';
import 'database.dart';
import 'pages/home_page.dart';
import 'pages/search_page.dart';
import 'pages/order_page.dart';
import 'pages/my_coupons_page.dart';
import 'pages/people.dart';
import 'pages/coupon_detail_page.dart';
import 'pages/purchase_list.dart';
import 'pages/login.dart';
import 'pages/signup.dart';

import 'pages/db_inspector_page.dart';
import 'package:my_app/pages/purchase_list.dart';
import 'pages/newpeople.dart';
import '../services/directory_service.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.init();

  await DirectoryService.init(); // 내부에서 debugStatus 찍음

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Pretendard'),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/search': (context) => const SearchPage(),
        '/order': (context) => const OrderPage(),
        '/my_coupons': (context) => const MyCouponsPage(),
        '/people': (context) => const PeoplePage(),
        '/coupon_detail': (context) => const CouponDetailPage(),
        '/purchase_list': (context) => const PurchaseHistoryPage(),
        '/signup': (context) => const SignUpPage(),

        '/db': (context) => const DbInspectorPage(),

        '/coupon_detail': (context) => const CouponDetailPage(), 
        '/purchase': (context) => const PurchaseHistoryPage(),
        '/newpeople': (_) => const NewPeoplePage(),

        '/settings': (context) => const SettingsPage(),

      },
    );
  }
}