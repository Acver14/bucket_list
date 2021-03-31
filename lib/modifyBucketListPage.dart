import 'package:bucket_list/provider/firebase_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'constantClass/sizeConstant.dart';
import 'dataClass/bucketDataClass.dart';
import 'dataClass/categoryDataClass.dart';
import 'method/printLog.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ModifyBucketListPage extends StatefulWidget {
  BucketClass bucket_data;
  ModifyBucketListPage({Key key, this.title, @required this.bucket_data}) : super(key: key);
  final String title;

  @override
  ModifyBucketListPageState createState() => ModifyBucketListPageState();
}

class ModifyBucketListPageState extends State<ModifyBucketListPage> {
  FirebaseProvider fp;
  BucketClass bucketData = new BucketClass();

  TextEditingController _titleCon;
  TextEditingController _contentCon;
  TextEditingController _addressCon = new TextEditingController();
  TextEditingController _reviewCon = new TextEditingController();
  double _importanceCon = 3;

  var imageMap;
  var width_of_display;
  var date_format = DateFormat('yyyy년 MM월 dd일');
  var box_height = 40.0;
  var dday;

  bool _mode = false;
  @override
  void initState() {
    // TODO: implement initState
    dday = widget.bucket_data.getClosingDate();
    bucketData = widget.bucket_data;
    _titleCon = new TextEditingController(text: bucketData.getTitle());
    _contentCon = new TextEditingController(text: bucketData.getContent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    width_of_display = getDisplayWidth(context);
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: new Text(
          _mode==false?'버킷리스트 수정':'버킷리스트 완료',
          style: TextStyle(color: Colors.black),
        ),
        leading: new IconButton(icon: new Icon(Icons.arrow_back_ios, color: Colors.black,), onPressed: ()=>Navigator.pop(context)),
        actions: [
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Container(
              child: FlutterSwitch(
                width: 90.0,
                height: 35.0,
                valueFontSize: 15.0,
                toggleSize: 45.0,
                value: _mode,
                borderRadius: 30.0,
                padding: 8.0,
                showOnOff: true,
                activeColor: Colors.black,
                activeText: '완료',
                inactiveText: '수정',
                onToggle: (val) {
                  setState(() {
                    _mode = val;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      body: _mode==false?widgetForModify():widgetForComplete(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await modifyBucket();
          Navigator.pop(context);
        },
        tooltip: 'addBucket',
        backgroundColor: Colors.black,
        child: Icon(
          _mode==false?Icons.add:Icons.check,
          color: Colors.white,
        ),
      ),
    );
  }

  widgetForModify(){
    return Wrap(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
          child:Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Container(
                    width: width_of_display,
                    height: box_height,
                    child: TextField(
                      controller: null,
                      enabled: false,
                      decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                          ),
                          labelStyle: TextStyle(
                              color: Colors.black
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                          ),
                          labelText: '수정일 : ${date_format.format(DateTime.now())}'
                      ),
                      cursorColor: Colors.black,
                    )
                ),
              ),
              Container(
                  width: width_of_display,
                  height: box_height,
                  child: FlatButton(
                    onPressed: () async {
                      await DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime.now().add(Duration(days:1)),
                          maxTime: DateTime.now().add(Duration(days: 3650)),
                          onConfirm: (date) {
                            dday = date;
                          },
                          currentTime: dday==null?DateTime.now():dday, locale: LocaleType.ko);
                      setState(() {});
                    },
                    padding: EdgeInsets.all(0.0),
                    child: TextField(
                      controller: null,
                      enabled: false,
                      decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                          ),
                          labelStyle: TextStyle(
                              color: Colors.black
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                          ),
                          labelText: '디데이 : ${dday==null?'--':date_format.format(dday)}'
                      ),
                      cursorColor: Colors.black,
                    ),
                  )
              ),
              SizedBox(height: 10,),
              Container(
                  width: width_of_display,
                  height: box_height,
                  child: TextField(
                    controller: _titleCon,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                        ),
                        labelStyle: TextStyle(
                            color: Colors.black
                        ),
                        labelText: '제목'
                    ),
                    cursorColor: Colors.black,
                  )
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: width_of_display,
                  height: box_height,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      updateOnDrag: true,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        _importanceCon = rating;
                        printLog(_importanceCon.toString());
                      },
                    ),
                  )
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: width_of_display,
                  height: box_height*10,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _contentCon,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                        ),
                        labelStyle: TextStyle(
                            color: Colors.black
                        ),
                        labelText: '내용'
                    ),
                    cursorColor: Colors.black,
                  )
              ),
            ],
          ),
        ),
      ],
    );
  }

  widgetForComplete(){
    return Wrap(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
          child:Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Container(
                    width: width_of_display,
                    height: box_height,
                    child: TextField(
                      controller: null,
                      enabled: false,
                      decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                          ),
                          labelStyle: TextStyle(
                              color: Colors.black
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                          ),
                          labelText: '완료일 : ${date_format.format(DateTime.now())}'
                      ),
                      cursorColor: Colors.black,
                    )
                ),
              ),
              Container(
                  width: width_of_display,
                  height: box_height,
                  child: TextField(
                    controller: _addressCon,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                        ),
                        labelStyle: TextStyle(
                            color: Colors.black
                        ),
                        labelText: '완료한 위치 (선택)'
                    ),
                    cursorColor: Colors.black,
                  )
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: width_of_display,
                  height: box_height*10,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _reviewCon,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)
                        ),
                        labelStyle: TextStyle(
                            color: Colors.black
                        ),
                        labelText: '후기'
                    ),
                    cursorColor: Colors.black,
                  )
              ),
            ],
          ),
        ),
      ],
    );
  }

  modifyBucket() async {
    Firestore firestore = Firestore.instance;

    // await firestore.collection(fp.getUser().uid).document('bucket_list').collection('buckets').document(bucketData.getId().toString()).
    //     delete();

    bucketData.setData(DateTime.now().millisecondsSinceEpoch, dday, _titleCon.text, _contentCon.text, _importanceCon);

    printLog(bucketData.toString());
    printLog(fp.getUser().uid);
    await firestore.collection(fp.getUser().uid).document('bucket_list').collection('buckets').document(bucketData.getId().toString())
        .setData(bucketData.toMap(), merge: true);
  }
}
