import 'package:flutter/material.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseProvider>(
            create: (context) => FirebaseProvider())
      ],
      child: MaterialApp(
        title: "Flutter Firebase",
        home: SplashScreenPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
