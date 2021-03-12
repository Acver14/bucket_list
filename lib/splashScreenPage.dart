import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bucket_list/authPage.dart';
import 'method/pageMoveMethod.dart';
import 'provider/firebase_provider.dart';
import 'package:provider/provider.dart';

class SplashScreenPage extends StatefulWidget {
  SplashScreenPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  SplashScreenPageState createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage> {

  FirebaseProvider fp;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1500), () {
        moveToPageBySlide(context, AuthPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
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
