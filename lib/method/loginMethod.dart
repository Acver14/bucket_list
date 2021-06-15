import 'package:bucket_list/provider/firebase_provider.dart';
import 'package:flutter/material.dart';
import '../authPage.dart';
import 'localAuthMethod.dart';
import 'methodForFirestore.dart';

Future<void> signInWithGoogle(GlobalKey<ScaffoldState> _scaffoldKey, FirebaseProvider fp) async {
  _scaffoldKey.currentState
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      duration: Duration(seconds: 10),
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(),
          Text("   Signing-In...")
        ],
      ),
    ));
  bool result = await fp.signInWithGoogleAccount();
  _scaffoldKey.currentState.hideCurrentSnackBar();
  if (result == false) showLastFBMessage(_scaffoldKey, fp);
}

Future<void> signInWithKakao(GlobalKey<ScaffoldState> _scaffoldKey, FirebaseProvider fp) async {
  _scaffoldKey.currentState
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      duration: Duration(seconds: 10),
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(),
          Text("   Signing-In...")
        ],
      ),
    ));
  bool result = await fp.signInWithKakaoAccount();
  _scaffoldKey.currentState.hideCurrentSnackBar();
  if (result == false) showLastFBMessage(_scaffoldKey, fp);
}

Future<void> signInWithNaver(GlobalKey<ScaffoldState> _scaffoldKey, FirebaseProvider fp) async {
  _scaffoldKey.currentState
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      duration: Duration(seconds: 10),
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(),
          Text("   Signing-In...")
        ],
      ),
    ));
  bool result = await fp.signInWithNaverAccount();
  _scaffoldKey.currentState.hideCurrentSnackBar();
  if (result == false) showLastFBMessage(_scaffoldKey, fp);
}

Future<void> signInWithApple(GlobalKey<ScaffoldState> _scaffoldKey, FirebaseProvider fp) async {
  var _localAuth;
  loadLocalAuth().then((ret){
    _localAuth = ret;
  });
  _scaffoldKey.currentState
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      duration: Duration(seconds: 10),
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(),
          Text("   Signing-In...")
        ],
      ),
    ));
  bool result = await fp.signInWithAppleAccount();
  _scaffoldKey.currentState.hideCurrentSnackBar();
  if (result == false) showLastFBMessage(_scaffoldKey, fp);
}

Future<void> signInWithEmail(BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey, FirebaseProvider fp, String email, String password) async {
  var _localAuth;
  loadLocalAuth().then((ret){
    _localAuth = ret;
  });
  _scaffoldKey.currentState
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      duration: Duration(seconds: 10),
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(),
          Text("   Signing-In...")
        ],
      ),
    ));
  bool result = await fp.signInWithEmail(email, password);
  _scaffoldKey.currentState.hideCurrentSnackBar();
  if(result){
    Navigator.pop(context);
    Route route = MaterialPageRoute(
        builder: (context) => AuthPage(localAuth: _localAuth,));
    Navigator.push(context, route);
  }
  if (result == false) showLastFBMessage(_scaffoldKey, fp);
}

Future<void> signUpWithEmail(GlobalKey<ScaffoldState> _scaffoldKey, FirebaseProvider fp, String email, String password) async {
  var _localAuth;
  loadLocalAuth().then((ret){
    _localAuth = ret;
  });
  _scaffoldKey.currentState
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      duration: Duration(seconds: 10),
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(),
          Text("   Signing-In...")
        ],
      ),
    ));
  bool result = await fp.signUpWithEmail(email, password);
  _scaffoldKey.currentState.hideCurrentSnackBar();
  if (result == false) showLastFBMessage(_scaffoldKey, fp);
}
