import 'dart:io'; // ✅ Directory 사용을 위해 필요
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart'; // ✅ 경로 사용을 위해 필요

import 'package:my_app/pages/setting_page.dart';
import 'package:my_app/services/database.dart';
import 'package:my_app/pages/home_page.dart';
import 'package:my_app/pages/search_page.dart';
import 'package:my_app/pages/order_page.dart';
import 'package:my_app/pages/my_coupons_page.dart';
import 'package:my_app/pages/people.dart';
import 'package:my_app/pages/coupon_detail_page.dart';
import 'package:my_app/pages/product_detail_page.dart';
import 'package:my_app/pages/purchase_list.dart';
import 'package:my_app/pages/login.dart';
import 'package:my_app/pages/myinfo.dart';
import 'package:my_app/pages/gifticon_catalog_page.dart';
import 'package:my_app/pages/signup.dart';
import 'package:my_app/pages/db_inspector_page.dart';
import 'package:my_app/pages/newpeople.dart';
import 'package:my_app/services/directory_service.dart';
import 'package:my_app/pages/payment_page.dart';

import 'package:my_app/models/user.dart'; // ✅ UserAdapter 등록을 위해 필요

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();

  // ✅ Hive 데이터 초기화 (손상된 Box 제거)
  final hiveDir = Directory('${dir.path}/hive');
  if (hiveDir.existsSync()) {
    hiveDir.deleteSync(recursive: true);
  }

  await Hive.initFlutter('hive'); // ✅ Hive 경로 지정
  Hive.registerAdapter(UserAdapter()); // ✅ User 모델 등록

  await DatabaseService.init();
  await DirectoryService.init();

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
        '/myinfo': (context) => const MyInfo(),
        '/catalog': (context) => const GifticonCatalogPage(),
        '/signup': (context) => const SignUpPage(),
        '/db': (context) => const DbInspectorPage(),
        '/newpeople': (_) => const NewPeoplePage(),
        '/settings': (context) => const SettingsPage(),
        '/product_detail': (context) => const ProductDetailPage(),
        '/payment': (_) => const PaymentPage(),
      },
    );
  }
}
