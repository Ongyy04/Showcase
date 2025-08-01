import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/search.dart';
import 'pages/mygif.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Pretendard'),
      initialRoute: '/mygif',
      routes: {
        '/home': (context) => const HomePage(),
        '/search': (context) => const SearchPage(),
        '/mygif': (context) => const MyGifPage(),
      },
    );
  }
}
