import 'package:flutter/material.dart';
import 'constantClass/sizeConstant.dart';

class AddBucketListPage extends StatefulWidget {
  AddBucketListPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  AddBucketListPageState createState() => AddBucketListPageState();
}

class AddBucketListPageState extends State<AddBucketListPage> {

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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'addBucket',
        backgroundColor: Colors.black,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
