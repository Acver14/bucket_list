import 'package:bucket_list/provider/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'constantClass/enumValues.dart';
import 'package:intl/intl.dart';
//method list
import 'method/pageMoveMethod.dart';
//page list
import 'settingPage.dart';
import 'addBucketListPage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'widgetClass/loadingWidget.dart';

class BucketListPage extends StatefulWidget {
  BucketListPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  BucketListPageState createState() => BucketListPageState();
}

class BucketListPageState extends State<BucketListPage> {
  Sort _sorting = Sort.title;
  FirebaseProvider fp;

  var date_format = DateFormat('yyyy년 MM월 dd일');

  @override
  Widget build(BuildContext context) {
    Firestore firestore = Firestore.instance;
    fp = Provider.of<FirebaseProvider>(context);
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
                  child: DropdownButton(
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
            ),GridView.count(
                crossAxisCount: 1,
                padding: EdgeInsets.all(16.0),
                childAspectRatio: 5.0 / 10.0,
                children: <Widget>[
                  StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection(fp.getUser().uid)
                          .document('bucket_list')
                          .collection('buckets')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return widgetLoading();
                        } else {
                          if (snapshot.data.documents.length > 0) {
                            return new ListView(
                                children: getBucketList(snapshot));
                          } else {
                            return new Center(child: Text("예약건이 없습니다."));
                          }
                        }
                      }),
                ]),
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


  getBucketList(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents.map((doc) {
      var type;
      var state;
      var reservationID = doc['_id'].toString();
      if(doc["state"].toString() == 'incomplete'){
        type = "미완료";
      }else{
        type = "완료";
      }
      return new Card(
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(doc["title"]),
                // new IconButton(
                //     icon: new Icon(Icons.delete),
                //     onPressed:() async {
                //       await Firestore.instance.collection('reservationList')
                //           .document(fp.getUser().email).collection('reservationInfo')
                //           .document(reservationID).delete();
                //       print('예약 삭제 성공');
                //     }
                // )
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text('작성일 : ${date_format.format(doc["_startDate"].toDate())}'),
                new Text(
                    '중요 : ${doc["_importance"].toString()}'),
              ],
            ),
          ));
    }).toList();
  }

}

