import 'package:flutter/material.dart';
import 'splashScreenPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '버킷리스트',
      home: SplashScreenPage(title: '버킷리스트'),
      debugShowCheckedModeBanner: false,
    );
  }
}
