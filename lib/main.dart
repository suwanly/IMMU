import 'package:flutter/material.dart';
import 'MyHomePage.dart';
import 'landingpaged.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black, // AppBar 색상 변경
          // AppBar의 textTheme 설정
          titleTextStyle: TextStyle(
            fontFamily: 'YourFontFamily', // AppBar 내의 폰트 변경
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/main': (context) => Mainhomp(),
      },
    );
  }
}

