import 'package:flutter/material.dart';
import 'constantClass/sizeConstant.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          new Container(height: getStatusBarHeight(context),),
          new Align(
            alignment: Alignment.centerLeft,
            child: new IconButton(icon: new Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context)),
          )
        ],
      )
    );
  }
}
