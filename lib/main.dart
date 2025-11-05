import 'package:flutter/material.dart';
import 'package:my_app/pages/setting_page.dart';
import 'package:my_app/services/database.dart';
import 'package:my_app/pages/home_page.dart';
import 'package:my_app/pages/search_page.dart';
import 'package:my_app/pages/order_page.dart';
import 'package:my_app/pages/my_coupons_page.dart';
import 'package:my_app/pages/people.dart';
import 'package:my_app/pages/coupon_detail_page.dart';
import 'package:my_app/pages/purchase_list.dart';
import 'package:my_app/pages/login.dart';
import 'package:my_app/pages/myinfo.dart';
import 'package:my_app/pages/gifticon_catalog_page.dart';
import 'package:my_app/pages/signup.dart';
import 'package:my_app/pages/db_inspector_page.dart';
import 'package:my_app/pages/newpeople.dart';
import 'package:my_app/services/directory_service.dart';

Future<void> main() async {
  // Flutter 앱을 시작하기 전에 위젯 바인딩을 초기화합니다.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Hive 데이터베이스를 초기화합니다.
  await DatabaseService.init();

  // 디렉토리 서비스를 초기화합니다.
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
      // 앱의 시작 화면을 로그인 페이지로 설정합니다.
      initialRoute: '/login',
      // 앱 내의 모든 화면에 대한 라우트를 정의합니다.
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
      },
    );
  }
}
