import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'constantClass/sizeConstant.dart';
import 'dataClass/bucketDataClass.dart';
import 'dataClass/categoryDataClass.dart';
import 'method/printLog.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddBucketListPage extends StatefulWidget {
  AddBucketListPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  AddBucketListPageState createState() => AddBucketListPageState();
}

class AddBucketListPageState extends State<AddBucketListPage> {
  BucketClass bucketData = new BucketClass();
  CategoryClass categoryData = new CategoryClass();

  TextEditingController _titleCon = new TextEditingController();
  TextEditingController _categoryCon = new TextEditingController();
  TextEditingController _contentCon = new TextEditingController();
  TextEditingController _importanceCon = new TextEditingController();

  var imageMap;
  var width_of_display;
  var date_format = DateFormat('yyyy년 MM월 dd일');
  var box_height = 40.0;
  var dday = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width_of_display = getDisplayWidth(context);
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: new Text(
          '버킷리스트 생성',
          style: TextStyle(color: Colors.black),
        ),
        leading: new IconButton(icon: new Icon(Icons.arrow_back_ios, color: Colors.black,), onPressed: ()=>Navigator.pop(context)),
      ),
      body: Wrap(
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
                            labelText: '작성일 : ${date_format.format(bucketData.getStartDate())}'
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
                    height: box_height * 10,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>addBucket(),
        tooltip: 'addBucket',
        backgroundColor: Colors.black,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  addBucket(){
    printLog(bucketData.toString());
  }
}
