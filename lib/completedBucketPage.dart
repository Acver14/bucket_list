import 'package:bucket_list/method/popupMenu.dart';
import 'package:bucket_list/provider/firebase_provider.dart';
import 'package:bucket_list/widgetClass/imageCardList.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sortedmap/sortedmap.dart';
import 'constantClass/enumValues.dart';
import 'constantClass/sizeConstant.dart';
import 'dataClass/bucketDataClass.dart';
import 'dataClass/categoryDataClass.dart';
import 'method/printLog.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class CompletedBucketListPage extends StatefulWidget {
  BucketClass bucket_data;
  CompletedBucketListPage({Key key, this.title, @required this.bucket_data}) : super(key: key);
  final String title;

  @override
  CompletedBucketListPageState createState() => CompletedBucketListPageState();
}

class CompletedBucketListPageState extends State<CompletedBucketListPage> {
  FirebaseProvider fp;
  BucketClass bucketData = new BucketClass();
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  TextEditingController _titleCon;
  TextEditingController _contentCon;
  TextEditingController _addressCon = new TextEditingController();
  TextEditingController _reviewCon = new TextEditingController();
  double _importanceCon;
  var _achievementDate;
  String plusImageUrl;

  Map<String, String> _imageListMap = new SortedMap(Ordering.byKey());
  var _imageList = [];
  var _imageUrlList = [];
  int _cntForImageList = 0;


  var width_of_display;
  var date_format = DateFormat('yyyy년 MM월 dd일');
  var box_height = 40.0;
  var dday;

  @override
  void initState() {
    // TODO: implement initState
    dday = widget.bucket_data.getClosingDate();
    bucketData = widget.bucket_data;
    printLog(bucketData.toString());
    _titleCon = new TextEditingController(text: bucketData.getTitle());
    _contentCon = new TextEditingController(text: bucketData.getContent()??" ");
    _reviewCon = new TextEditingController(text : bucketData.getReview()??' ');
    setImageList();
    super.initState();
  }

  setImageList(){
    printLog(bucketData.imageListToMap().toString());
    _imageListMap.addAll(bucketData.imageListToMap());
    printLog('image list was made');
  }

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    width_of_display = getDisplayWidth(context);
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: new Text(
          '${bucketData.getTitle()}',
          style: TextStyle(color: Colors.black),
        ),
        leading: new IconButton(icon: new Icon(Icons.arrow_back_ios, color: Colors.black,), onPressed: ()=>Navigator.pop(context)),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Container(
              child:
              IconButton(onPressed: ()async {
                if(await popupTextAndButton(context, '버킷리스트를 완전히 삭제하시겠습니까?')){
                  removeBucket(bucketData);
                  Navigator.pop(context);
                }
              }, icon: Icon(Icons.delete, color: Colors.black,)),
            ),
          ),
        ],
      ),
      body: widgetForCompleted(),
    );
  }

  widgetForCompleted(){
    return Wrap(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
          child:Column(
            children: [
              ImageCardList(
                map: _imageListMap,
                titleColor: Colors.transparent,
                displayNameTag: true,
                reverse: true,
              ),
              SizedBox(
                height: 10,
              ),
              getWidgetForText(width_of_display, box_height*10, _contentCon, "내용"),
              SizedBox(
                height: 10,
              ),
              getWidgetForText(width_of_display, box_height*10, _reviewCon, "리뷰"),
            ],
          ),
        ),
      ],
    );
  }

  removeBucket(BucketClass bucketData) async{
    Firestore firestore = Firestore.instance;

    await firestore.collection(fp.getUser().uid).document('bucket_list').collection('buckets').document(bucketData.getId().toString())
        .delete();
    await firestore.collection(fp.getUser().uid).document('user_info')
        .setData({
      "numOfTrash" : fp.getUserInfo()['numOfTrash']-1,
    }, merge: true);
    await fp.setUserInfo();
  }
}

getWidgetForText(double width, double height, TextEditingController con, String labelText){

  return Container(
      width: width,
      height: height,
      child: TextField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: con,
        enabled: false,
        decoration: InputDecoration(
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black)
            ),
            labelStyle: TextStyle(
                color: Colors.black
            ),
            labelText: labelText
        ),
        cursorColor: Colors.black,
      )
  );
}

