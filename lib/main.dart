import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

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

import 'package:my_app/models/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ⚠️ path_provider는 웹에서 사용 불가 → 분기 필요
  if (kIsWeb) {
    // 웹에서는 파일 경로 없음 → 기본 init만
    await Hive.initFlutter();
  } else {
    final dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter('${dir.path}/hive');
  }

  Hive.registerAdapter(UserAdapter());

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
      // ✅ 스플래시에서 자동 라우팅
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const _SplashGate(),
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

/// 현재 세션을 보고 자동으로 라우팅
class _SplashGate extends StatefulWidget {
  const _SplashGate({super.key});
  @override
  State<_SplashGate> createState() => _SplashGateState();
}


class _SplashGateState extends State<_SplashGate> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    // 🔥 DatabaseService.init()이 실제로 완료될 때까지 기다림
    await Future.delayed(const Duration(milliseconds: 100));
    await DatabaseService.session.clear();//이게 앱 다시 시작 할 때마다 캐시 삭제해주는 거임 그래서 다시 회원가입 해야됨
    final key = DatabaseService.currentUserKey();
    if (!mounted) return;

    if (key != null) {
      Navigator.pushReplacementNamed(context, '/my_coupons');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

