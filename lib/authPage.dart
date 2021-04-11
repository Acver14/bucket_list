import 'package:flutter/material.dart';
import 'package:bucket_list/provider/firebase_provider.dart';
import 'package:bucket_list/bucketListPage.dart';
import 'package:bucket_list/signUpPage.dart';
import 'package:provider/provider.dart';

AuthPageState pageState;

class AuthPage extends StatefulWidget {
  @override
  AuthPageState createState() {
    pageState = AuthPageState();
    return pageState;
  }
}

class AuthPageState extends State<AuthPage> {
  FirebaseProvider fp;

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);

    if (fp.getUser() != null && fp.getUser().isEmailVerified == true) {
      logger.d("user: ${fp.getUser().email}");
      return BucketListPage();
    } else {
      return SignUpPage();
    }
  }
}