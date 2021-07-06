import 'package:bucket_list/method/localAuthMethod.dart';
import 'package:bucket_list/method/printLog.dart';
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
    var _localAuth;
    loadLocalAuth().then((ret){
      _localAuth = ret;
    });
    Timer(Duration(milliseconds: 1500), () {
        Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => AuthPage(localAuth: _localAuth,)));
    });
  }

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset('assets/logos/cube.png'),
        ),
      ),
    );
  }

}
