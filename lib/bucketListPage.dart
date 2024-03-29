import 'dart:async';

import 'package:bucket_list/constantClass/sizeConstant.dart';
import 'package:bucket_list/dataClass/bucketDataClass.dart';
import 'package:bucket_list/method/popupMenu.dart';
import 'package:bucket_list/method/printLog.dart';
import 'package:bucket_list/provider/firebase_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sortedmap/sortedmap.dart';
import 'constantClass/enumValues.dart';
import 'package:intl/intl.dart';

//method list
import 'method/pageMoveMethod.dart';

//page list
import 'settingPage.dart';
import 'addBucketListPage.dart';
import 'modifyBucketListPage.dart';
import 'completedBucketPage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'widgetClass/loadingWidget.dart';

import 'constantClass/enumValues.dart';

class BucketListPage extends StatefulWidget {
  BucketListPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  BucketListPageState createState() => BucketListPageState();
}

FirebaseProvider fp;

class BucketListPageState extends State<BucketListPage> {
  Sort _sorting = Sort.title;

  var dateFormat = DateFormat('yyyy : MM : dd');

  AsyncSnapshot<QuerySnapshot> bucketListSnapshot;
  QuerySnapshot bucketInfos;
  List<DocumentSnapshot> bucketInfoList;

  List<InkWell> bucketList;

  List<InkWell> incompleteBucketList = [];
  List<InkWell> completeBucketList = [];
  List<InkWell> trashBucketList = [];

  bool _loaded = false;

  BucketState _stateOfView = BucketState.incomplete;

  final ScrollController _infiniteController =
      ScrollController(initialScrollOffset: 0.0);

  _scrollListener() {
    if (_infiniteController.offset >=
            _infiniteController.position.maxScrollExtent &&
        !_infiniteController.position.outOfRange) {
      setState(() {
        print(_infiniteController.position.maxScrollExtent);
      });
    }
    if (_infiniteController.offset <=
            _infiniteController.position.minScrollExtent &&
        !_infiniteController.position.outOfRange) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _infiniteController.addListener(_scrollListener);
    super.initState();
  }

  Future<QuerySnapshot> loadBucketList() async {
    if (!_loaded) {
      incompleteBucketList = [];
      completeBucketList = [];
      trashBucketList = [];
      bucketInfos = await Firestore.instance
          .collection(fp.getUser().uid)
          .document('bucket_list')
          .collection('buckets')
          .orderBy('_title', descending: false)
          .getDocuments()
          .then((value) {
        _loaded = true;
        return value;
      });
    }
    return bucketInfos;
  }
  Future<QuerySnapshot> refreshBucketList() async {
    printLog(_loaded.toString());
      incompleteBucketList = [];
      completeBucketList = [];
      trashBucketList = [];
      bucketInfos = await Firestore.instance
          .collection(fp.getUser().uid)
          .document('bucket_list')
          .collection('buckets')
          .orderBy('_title', descending: false)
          .getDocuments()
          .then((value) {
        _loaded = true;
        return value;
      });
    return bucketInfos;
  }

  sortBucketList(){
    bucketInfoList.sort((a, b){
      switch(_sorting){
        case Sort.importance:
          if(b['_importance'] < a['_importance']) return -1;
          else if(b['_importance'] > a['_importance']) return -1;
          else return 0;
          break;
        case Sort.creationDate:
          return (b['_startDate'].toDate().compareTo(a['_startDate'].toDate()));
        case Sort.title:
          //if(b['_state'] == 0 && a['_state'] == 0) printLog("${b['_title']} & ${a['_title']}" + b['_title'].toString().compareTo(a['_title'].toString()).toString());
          return (b['_title'].toString().compareTo(a['_title'].toString()));
        default:
          return (b['_title'].toString().compareTo(a['_title'].toString()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Firestore firestore = Firestore.instance;
    fp = Provider.of<FirebaseProvider>(context);
    final a = ['horse', 'pig', 'dog', 'cat']; print(a); a.sort((a, b) => a.compareTo(b)); print(a);
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: statusBarHeight,
                ),
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
                                value: Sort.importance),
                          ],
                          onChanged: (value) async {
                            setState(() {
                              _sorting = value;
                              //_loaded = false;
                              printLog(_sorting.toString());
                              sortBucketList();
                              getBucketList();
                            });
                            setState(() {});
                          }),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      height: 50,
                      child: new IconButton(
                          icon: new Icon(Icons.settings, size: 30),
                          onPressed: () =>
                              moveToPageBySlide(context, SettingPage())),
                    ),
                  ],
                ),
                FutureBuilder(
                    future: loadBucketList(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          height: getDisplayHeight(context)/2,
                          child: widgetLoading(),
                        );
                      } else {
                        if (snapshot.data.documents.length > 0) {
                          bucketInfoList = snapshot.data.documents;
                          sortBucketList();
                          getBucketList();
                          //switch 이용해서 분류
                          switch (_stateOfView) {
                            case BucketState.incomplete:
                              return Expanded(
                                  child:
                                  new ListView.builder(
                                    //reverse: true,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    controller: _infiniteController,
                                    itemCount: incompleteBucketList.length,
                                    itemBuilder: (context, index) {
                                      return getIncompleteBucketInfo(
                                          index, incompleteBucketList.length);
                                    },
                                  ));
                              break;
                            case BucketState.complete:
                              return Expanded(
                                  child:
                                  new ListView.builder(
                                    //reverse: true,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    controller: _infiniteController,
                                    itemCount: completeBucketList.length,
                                    itemBuilder: (context, index) {
                                      return getCompleteBucketInfo(
                                          index, completeBucketList.length);
                                    },
                                  )
                              );
                              break;
                            case BucketState.trash:
                              return Expanded(
                                  child: new ListView.builder(
                                    //reverse: true,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    controller: _infiniteController,
                                    itemCount: trashBucketList.length,
                                    itemBuilder: (context, index) {
                                      return getTrashBucketInfo(
                                          index, trashBucketList.length);
                                    },
                                  ));
                              break;
                            default:
                              return Expanded(
                                  child: new ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    controller: _infiniteController,
                                    itemCount: incompleteBucketList.length,
                                    itemBuilder: (context, index) {
                                      return getIncompleteBucketInfo(
                                          index, incompleteBucketList.length);
                                    },
                                  ));
                          }
                        } else {
                          return new Align(
                            alignment: Alignment.center,
                            child: Center(child: Text("항목이 없습니다.")),
                          );
                        }
                      }
                    }),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Route route =
              MaterialPageRoute(builder: (context) => AddBucketListPage());
          Navigator.push(context, route).then(refreshBucketListPage);
        },
        tooltip: 'addBucket',
        backgroundColor: Colors.black,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                rippleColor: Colors.grey[300],
                hoverColor: Colors.grey[100],
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100],
                tabs: [
                  GButton(
                    icon: Icons.access_alarm,
                    text: '미완료',
                  ),
                  GButton(
                    icon: Icons.check_box,
                    text: '완료',
                  ),
                  GButton(
                    icon: Icons.delete,
                    text: '휴지통',
                  ),
                ],
                onTabChange: (index) {
                  setState(() {
                    switch (index) {
                      case 0:
                        _stateOfView = BucketState.incomplete;
                        break;
                      case 1:
                        _stateOfView = BucketState.complete;
                        break;
                      case 2:
                        _stateOfView = BucketState.trash;
                        break;
                    }
                  });
                }),
          ),
        ),
      ),
    );
  }

  FutureOr refreshBucketListPage(dynamic value) async {
    await refreshBucketList();
    setState(() {});
  }

  getBucketList() {
    incompleteBucketList = [];
    completeBucketList = [];
    trashBucketList = [];

    bucketInfoList.map((doc) {
      var _state;
      switch (_stateOfView) {
        case BucketState.incomplete:
          if (doc["_state"] == 0) {
            _state = "미완료";
            BucketClass bucket_data = new BucketClass.forModify(
                doc['_id'],
                doc['_title'],
                doc['_content'],
                doc['_startDate'].toDate(),
                doc['_closingDate'] == null
                    ? null
                    : doc['_closingDate'].toDate(),
                doc['_importance']);
            incompleteBucketList.add(new InkWell(
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => ModifyBucketListPage(
                            bucket_data: bucket_data,
                          ));
                  Navigator.push(context, route).then(refreshBucketListPage);
                },
                onLongPress: () async {
                  if(await popupTextAndButton(context, '버킷리스트를 휴지통으로 옮기시겠습니까?')){
                    goToTrashPressedBucket(bucket_data);
                    await refreshBucketList();
                    setState(() {});
                  }
                },
                child: Card(
                  color: doc["_closingDate"]==null?Colors.white:(DateTime.now().difference(doc["_closingDate"].toDate())).inDays>-2?Colors.red:
                  (DateTime.now().difference(doc["_closingDate"].toDate())).inDays>-5?Colors.orange:
                    (DateTime.now().difference(doc["_closingDate"].toDate())).inDays>-10?Colors.yellow:Colors.white,
                    child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(doc["_title"]),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                          '작성일 : ${dateFormat.format(doc["_startDate"].toDate())}'),
                      new Text(
                          '종료일 : ${doc["_closingDate"] == null ? '---- : -- : --' : dateFormat.format(doc["_closingDate"].toDate())}'),
                      new Text('중요 : ${doc["_importance"].toString()}'),
                    ],
                  ),
                ))));
          }
          break;
        case BucketState.complete:
          if (doc["_state"] == 1) {
            printLog(doc['_startDate'].toDate().toString());
            BucketClass bucket_data = new BucketClass.forComplete(
                doc['_id'],
                doc['_title'],
                doc['_content'],
                doc['_startDate'].toDate(),
                doc['_closingDate'] == null
                    ? null
                    : doc['_closingDate'].toDate(),
                doc['_importance'],
                doc['_image'],
                doc['_review'],
                doc['_address']);
            completeBucketList.add(new InkWell(
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => CompletedBucketListPage(
                            bucket_data: bucket_data,
                          ));
                  Navigator.push(context, route).then(refreshBucketListPage);
                },
                child: Card(
                    child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(doc["_title"]),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                          '작성일 : ${dateFormat.format(doc["_startDate"].toDate())}'),
                      new Text(
                          '종료일 : ${doc["_closingDate"] == null ? '---- : -- : --' : dateFormat.format(doc["_closingDate"].toDate())}'),
                      new Text('중요 : ${doc["_importance"].toString()}'),
                    ],
                  ),
                ))));
          }
          break;
        case BucketState.trash:
          if (doc["_state"] == -1) {
            printLog(doc['_startDate'].toDate().toString());
            BucketClass bucket_data = new BucketClass.forModify(
                doc['_id'],
                doc['_title'],
                doc['_content'],
                doc['_startDate'].toDate(),
                doc['_closingDate'] == null
                    ? null
                    : doc['_closingDate'].toDate(),
                doc['_importance']);
            trashBucketList.add(
                new InkWell(
                onTap: () async {
                  if(await popupTextAndButton(context, '버킷리스트를 복원하시겠습니까?')){
                    goToIncompletedPressedBucket(bucket_data);
                    await refreshBucketList();
                    setState(() {});
                  }
                },
                    onLongPress:()async {
                      if(await popupTextAndButton(context, '버킷리스트를 완전히 삭제하시겠습니까?')){
                        removeBucket(bucket_data);
                        await refreshBucketList();
                        setState(() {});
                      }
                    },
                child: Card(
                    child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(doc["_title"]),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                          '작성일 : ${dateFormat.format(doc["_startDate"].toDate())}'),
                      new Text(
                          '종료일 : ${doc["_closingDate"] == null ? '---- : -- : --' : dateFormat.format(doc["_closingDate"].toDate())}'),
                      new Text('중요 : ${doc["_importance"].toString()}'),
                    ],
                  ),
                ))));
          }
          break;
      }
    }).toList();
  }

  getIncompleteBucketInfo(int index, int length) {
    try {
      return incompleteBucketList[length - index - 1];
    } catch (Exception, e) {
      print(e);
      _infiniteController.jumpTo(0);
    }
  }

  getCompleteBucketInfo(int index, int length) {
    try {
      return completeBucketList[length - index - 1];
    } catch (Exception, e) {
      print(e);
      _infiniteController.jumpTo(0);
    }
  }

  getTrashBucketInfo(int index, int length) {
    try {
      return trashBucketList[length - index - 1];
    } catch (Exception, e) {
      print(e);
      _infiniteController.jumpTo(0);
    }
  }
}

goToTrashPressedBucket(BucketClass bucketData) async {
  Firestore firestore = Firestore.instance;

  await firestore.collection(fp.getUser().uid).document('bucket_list').collection('buckets').document(bucketData.getId().toString())
      .setData({
    "_state" : -1
  }, merge: true);
  await firestore.collection(fp.getUser().uid).document('user_info')
      .setData({
    "numOfTrash" : fp.getUserInfo()['numOfTrash']+1,
    "numOfIncomplete" : fp.getUserInfo()['numOfIncomplete']-1
  }, merge: true);
  await fp.setUserInfo();
}


goToIncompletedPressedBucket(BucketClass bucketData) async {
  Firestore firestore = Firestore.instance;

  await firestore.collection(fp.getUser().uid).document('bucket_list').collection('buckets').document(bucketData.getId().toString())
      .setData({
    "_state" : 0
  }, merge: true);

  await firestore.collection(fp.getUser().uid).document('user_info')
      .setData({
    "numOfTrash" : fp.getUserInfo()['numOfTrash']-1,
    "numOfIncomplete" : fp.getUserInfo()['numOfIncomplete']+1
  });
  await fp.setUserInfo();
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