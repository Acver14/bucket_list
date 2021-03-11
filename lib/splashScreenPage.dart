import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bucket_list/signUpPage.dart';
import 'method/pageMoveMethod.dart';

class SplashScreenPage extends StatefulWidget {
  SplashScreenPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  SplashScreenPageState createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1500), () {
        moveToPageBySlide(context, SignUpPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff28385e),
        child: Center(
          child: Image.asset('assets/logos/blacklotus.jpg'),
        ),
      ),
    );
  }

}
