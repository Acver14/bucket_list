import 'package:bucket_list/bucketListPage.dart';
import 'package:bucket_list/splashScreenPage.dart';
import 'package:bucket_list/widgetClass/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'method/printLog.dart';
import 'pinputPage.dart';

class SecondAuthPage extends StatefulWidget {
  SecondAuthPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  SecondAuthPageState createState() => SecondAuthPageState();
}

class SecondAuthPageState extends State<SecondAuthPage> {
  static final _auth = LocalAuthentication();
  static var isAvailable;

  @override
  initState() {
    authenticate();

    super.initState();
  }

  static Future<bool> hasBiometrics() async{
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e){
      return false;
    }
  }

  static Future<bool> authenticate() async{
    isAvailable = await hasBiometrics();

    if(!isAvailable) return false;
    try{
      return await _auth.authenticateWithBiometrics(
          localizedReason: '지문 인식을 진행해주십시오.',
          useErrorDialogs: true,
          stickyAuth: true
      );
    } on PlatformException catch (e){
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: authenticate(),
          builder: (BuildContext context,
              AsyncSnapshot<bool> auth){
            if(!auth.hasData){
              return widgetLoading();
            }else{
              printLog((auth.data).toString());
              if(auth.data) return BucketListPage();
              else {
                return PinPutPage(isPinRegister: false,);
              }
            }
          }),
    );
  }
}

