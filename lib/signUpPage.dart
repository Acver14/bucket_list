import 'package:bucket_list/authButton/email.dart';
import 'package:flutter/material.dart';
import 'package:bucket_list/provider/firebase_provider.dart';
import 'package:provider/provider.dart';
import 'authButton/google.dart';
import 'authButton/naver.dart';
import 'authButton/kakao.dart';
import 'authButton/apple.dart';
import 'method/loginMethod.dart';
import 'loginWithEmailPage.dart';
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
          SizedBox(height: 50,),
          Container(
            child: Image.asset('assets/logos/logo_rectangle.png'),
            margin: EdgeInsets.all(20.0),
            height: 200,
          ),
          SizedBox(height: 20,),
          NaverSignInButton(onPressed: ()async => await signInWithNaver(_scaffoldKey, fp),),
          GoogleSignInButton(onPressed: () async => await signInWithGoogle(_scaffoldKey, fp),),
          KakaoSignInButton(onPressed: () async => await signInWithKakao(_scaffoldKey, fp),),
          AppleSignInButton(onPressed: () async => await signInWithApple(_scaffoldKey, fp),),
          EmailSignInButton(onPressed: (){
            Route route = MaterialPageRoute(
                builder: (context) => LoginWithEmailPage());
            Navigator.push(context, route);})
        ],
      ),
    );
  }
}