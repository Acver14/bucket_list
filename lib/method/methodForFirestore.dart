import 'package:bucket_list/provider/firebase_provider.dart';
import 'package:flutter/material.dart';

showLastFBMessage(GlobalKey<ScaffoldState> _scaffoldKey, FirebaseProvider fp) {
  _scaffoldKey.currentState
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      backgroundColor: Colors.red[400],
      duration: Duration(seconds: 10),
      content: Text(fp.getLastFBMessage()),
      action: SnackBarAction(
        label: "Done",
        textColor: Colors.white,
        onPressed: () {},
      ),
    ));
}