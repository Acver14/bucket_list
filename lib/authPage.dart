import 'package:bucket_list/secondAuthPage.dart';
import 'package:flutter/material.dart';
import 'package:bucket_list/provider/firebase_provider.dart';
import 'package:bucket_list/bucketListPage.dart';
import 'package:bucket_list/signUpPage.dart';
import 'package:provider/provider.dart';

AuthPageState pageState;
bool _localAuth;
class AuthPage extends StatefulWidget {
  @override
  final bool localAuth;
  AuthPage({Key key, @required this.localAuth}) : super(key: key);
  AuthPageState createState() {
    pageState = AuthPageState();
    _localAuth = localAuth;
    return pageState;
  }
}

class AuthPageState extends State<AuthPage> {
  FirebaseProvider fp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    if (fp.getUser() != null && fp.getUser().isEmailVerified == true) {
      if(_localAuth){
        return SecondAuthPage();
      }else {
        return BucketListPage();
      }
    } else {
      return SignUpPage();
    }
  }
}