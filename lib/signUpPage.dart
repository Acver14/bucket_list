import 'package:bucket_list/authButton/email.dart';
import 'package:flutter/material.dart';
import 'package:bucket_list/provider/firebase_provider.dart';
import 'package:provider/provider.dart';
import 'authButton/google.dart';
import 'authButton/naver.dart';
import 'authButton/kakao.dart';
import 'authButton/apple.dart';
import 'method/loginMethod.dart';

SignUpPageState pageState;

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() {
    pageState = SignUpPageState();
    return pageState;
  }
}

class SignUpPageState extends State<SignUpPage> {
  TextEditingController _mailCon = TextEditingController();
  TextEditingController _pwCon = TextEditingController();
  bool doRemember = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseProvider fp;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _mailCon.dispose();
    _pwCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      //appBar: AppBar(title: Text("Sign-In Page")),
      body: ListView(
        children: <Widget>[
          NaverSignInButton(onPressed: (){},),
          GoogleSignInButton(onPressed: () async => await signInWithGoogle(_scaffoldKey, fp),),
          KakaoSignInButton(onPressed: (){},),
          AppleSignInButton(onPressed: (){},),
          EmailSignInButton(onPressed: (){},)
        ],
      ),
    );
  }
}