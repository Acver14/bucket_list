import 'package:bucket_list/provider/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'methodForFirestore.dart';

void signInWithGoogle(GlobalKey<ScaffoldState> _scaffoldKey, FirebaseProvider fp) async {
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
