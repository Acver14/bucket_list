import 'package:bucket_list/method/printLog.dart';
import 'package:bucket_list/pinputPage.dart';
import 'package:bucket_list/secondAuthPage.dart';
import 'package:flutter/material.dart';
import 'package:bucket_list/provider/firebase_provider.dart';
import 'package:bucket_list/bucketListPage.dart';
import 'package:bucket_list/signUpPage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screen_lock/configurations/input_button_config.dart';
import 'package:flutter_screen_lock/configurations/screen_lock_config.dart';
import 'package:flutter_screen_lock/configurations/secret_config.dart';
import 'package:flutter_screen_lock/configurations/secrets_config.dart';
import 'package:flutter_screen_lock/functions.dart';
import 'package:flutter_screen_lock/input_controller.dart';
import 'package:flutter_screen_lock/screen_lock.dart';
import 'package:local_auth/local_auth.dart';

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

  Future<bool> localAuth(BuildContext context) async {
    final localAuth = LocalAuthentication();
    final didAuthenticate = await localAuth.authenticateWithBiometrics(
      localizedReason: 'Please authenticate',
    );
    if (didAuthenticate) {
      return true;
      // Route route = MaterialPageRoute(
      //     builder: (context) => BucketListPage());
      // Navigator.pop(context);
      // Navigator.push(context, route);
    }else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    if (fp.getUser() != null) {
      if(_localAuth){
        return PinPutPage(isPinRegister: false);
      }
        return BucketListPage();
    } else {
      return SignUpPage();
    }
  }
}