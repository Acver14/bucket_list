import 'package:bucket_list/bucketListPage.dart';
import 'package:bucket_list/widgetClass/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class SecondAuthPage extends StatefulWidget {
  SecondAuthPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  SecondAuthPageState createState() => SecondAuthPageState();
}

class SecondAuthPageState extends State<SecondAuthPage> {
  bool _isLocalAuth;
  String _authorized;

  @override
  initState() {
    super.initState();
    checkBio();
  }

  checkBio() async {
    var isLocalAuth;
    isLocalAuth = await LocalAuthentication().canCheckBiometrics;
    setState(() {
      _isLocalAuth = isLocalAuth;
    });

    bool authenticated = false;
    authenticated = await LocalAuthentication()
        .authenticateWithBiometrics(
        localizedReason: '지문 인식을 진행해주십시오.');
    setState(() {
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
    });

    return authenticated;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: checkBio(),
          builder: (BuildContext context,
              AsyncSnapshot<bool> auth){
            if(!auth.hasData){
              return widgetLoading();
            }else{
              return BucketListPage();
            }
          }),
    );
  }
}