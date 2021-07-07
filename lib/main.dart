import 'package:bucket_list/authPage.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'splashScreenPage.dart';

import 'package:provider/provider.dart';
import 'package:bucket_list/provider/firebase_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    KakaoContext.clientId = "7da825303df3079be26a6a3f36e1a55e";
    KakaoContext.javascriptClientId = "7da825303df3079be26a6a3f36e1a55e";
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseProvider>(
            create: (context) => FirebaseProvider())
      ],
      child: MaterialApp(
        title: "inYourBucket",
        home: SplashScreenPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
