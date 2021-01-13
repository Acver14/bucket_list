import 'package:flutter/material.dart';
import 'constantClass/enumValues.dart';
//method list
import 'method/pageMoveMethod.dart';
//page list
import 'settingPage.dart';
import 'addBucketListPage.dart';

class BucketListPage extends StatefulWidget {
  BucketListPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  BucketListPageState createState() => BucketListPageState();
}

class BucketListPageState extends State<BucketListPage> {
  Sort _sorting = Sort.title;

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: statusBarHeight,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, top: 10),
                  height: 50,
                  child:
                  DropdownButton(
                      value: _sorting,
                      items: [
                        DropdownMenuItem(
                          child: Text("제목순"),
                          value: Sort.title,
                        ),
                        DropdownMenuItem(
                          child: Text("생성일순"),
                          value: Sort.creationDate,
                        ),
                        DropdownMenuItem(
                            child: Text("중요도순"),
                            value: Sort.importance
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _sorting = value;
                        });
                      }),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, top: 10),
                  height: 50,
                  child: new IconButton(
                      icon: new Icon(Icons.settings, size: 30),
                      onPressed: () => moveToPageBySlide(context, SettingPage())
                  ),
                ),
              ],
            ),
            new ListView(
              padding: const EdgeInsets.all(8),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                new Card(
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Text(
                          'title',
                          style : TextStyle(fontSize: 20),
                        ),
                        new Text(
                            'category',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                    subtitle: Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Text('d-day'),
                          new Text('importance')
                        ],
                      ),
                    )
                  ),
                )
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => moveToPageBySlide(context, AddBucketListPage()),
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