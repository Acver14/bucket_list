import 'dart:io';

import 'package:bucket_list/method/printLog.dart';
import 'package:bucket_list/provider/firebase_provider.dart';
import 'package:bucket_list/widgetClass/loadingWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constantClass/sizeConstant.dart';
import 'method/popupMenu.dart';
import 'splashScreenPage.dart';
import 'method/launchUrl.dart';
import 'method/localAuthMethod.dart';
import 'pinputPage.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  FirebaseProvider fp;
  var userInfo = null;
  var _loaded = false;
  var picker = ImagePicker();
  bool localAuth;
  SharedPreferences prefsLocalAuth;
  var profilePath = '';

  Future<DocumentSnapshot> loadUserInfo() async {
    if (!_loaded) {
      userInfo = await Firestore.instance
          .collection(fp.getUser().uid)
          .document('user_info').get().then((value) {
            printLog(value.data.toString());
        _loaded = true;
        profilePath = value['profilePath'];
        return value;
      });
    }
    printLog(userInfo);

    return userInfo;
  }

  initState(){
    loadLocalAuth().then((ret){
      localAuth = ret;
    });
    super.initState();
  }

  Future<DocumentSnapshot> forceLoadUserInfo() async {
    userInfo = await Firestore.instance
          .collection(fp.getUser().uid)
          .document('user_info').get();
    return userInfo;
  }

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          new Container(height: getStatusBarHeight(context),),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Align(
                alignment: Alignment.centerLeft,
                child: new IconButton(icon: new Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context)),
              ),
              Padding(
                  padding: EdgeInsets.all(5.0),
              child: new IconButton(icon: new Icon(Icons.logout),
                onPressed: () async {
                  if(await popupTextAndButton(context, '로그아웃 하시겠습니까?')){
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScreenPage()));
                    await fp.signOut();
                  }
                },
              )
              )
            ],
          ),
          FutureBuilder(
            future: loadUserInfo(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
              if(userInfo==null){
                return Container(
                  child: widgetLoading(),
                );
              }
              else{
                  try{
                    return new Column(
                      children: [
                        new Card(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: new Row(
                                children: [
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: InkWell(
                                      child: profilePath==''?
                                      ClipOval(
                                        child: Icon(Icons.person_outline),
                                      ):ClipOval(
                                        child: profilePath.contains('http')?CachedNetworkImage(
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.fill,
                                          imageUrl:
                                          profilePath,
                                          placeholder: (context, url) => CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        ):Image.file(File(profilePath),fit: BoxFit.cover,),
                                      ),
                                      onTap: () async {
                                        await uploadProfile();
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('별명 : ' + userInfo['nickName']),
                                      SizedBox(height:5),
                                      Text('달성률 : ${((userInfo['numOfComplete'] / (userInfo['numOfComplete'] + userInfo['numOfIncomplete'])) * 100).toStringAsFixed(2)}%')
                                    ],
                                  )
                                ],
                              ),
                            )
                        ),
                        new Card(
                          child : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('간편 로그인'),
                              IconButton(
                                icon: Icon(localAuth?Icons.check_box:Icons.check_box_outline_blank_outlined),
                                onPressed: () async {
                                  setState(() {
                                    localAuth = !localAuth;
                                  });
                                  if(localAuth){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => new PinPutPage(isPinRegister: true,))).then((value) async {
                                        var pinTemp = await loadPinPut();
                                        if(pinTemp == '----') {
                                          setState(() {
                                            localAuth = false;
                                          });
                                        }
                                    });
                                      await saveLocalAuth(localAuth);
                                  }
                                },),
                            ],
                          ),
                        ),
                        new Card(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Icon(Icons.access_alarm),
                                      Text('미완료'),
                                      Text(userInfo['numOfIncomplete'].toString())
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(Icons.check_box),
                                      Text('완료'),
                                      Text(userInfo['numOfComplete'].toString())
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(Icons.delete),
                                      Text('휴지통'),
                                      Text(userInfo['numOfTrash'].toString())
                                    ],
                                  )
                                ],
                              ),
                            )
                        ),
                        Container(
                          width: double.infinity,
                          child: new Card(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Contact', style: TextStyle(fontSize: 20),),
                                    SizedBox(height: 5),
                                    InkWell(
                                      child: Text('P.H. : 010-2975-6120'),
                                      onTap: () async => await launchBrowser('tel:01029756120'),
                                    ),
                                    SizedBox(height: 5),
                                    InkWell(
                                      child: Text('Email : devacver@gmail.com'),
                                      onTap: () async => await launchBrowser('mailto:devacver@gmail.com'),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 50, 15, 0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                child: new Card(
                                  child: Container(
                                      width: 90,
                                      height : 30,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('회원탈퇴'),
                                          Icon(Icons.delete)
                                        ],
                                      )
                                  ),
                                ),
                                onTap: ()=>printLog('회탈s'),
                              )
                          ),
                        ),
                      ],
                    );
                  }on Exception catch (e){
                    logger.e(e);
                    return Container();
                  }
              }
          })
        ],
      )
    );
  }


  uploadProfile() async {
    Firestore firestore = Firestore.instance;

    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('${fp.getUser().uid}/profile');
    setState(() {
      profilePath = pickedFile.path;
    });
    StorageUploadTask uploadTask = storageReference.putFile(File(pickedFile.path));
    await uploadTask.onComplete;
    printLog('File Uploaded: profile');
    var path = await storageReference.getDownloadURL();
    await firestore.collection(fp.getUser().uid).document('user_info')
          .setData({
        'profilePath': path
      }, merge: true);

  }


  downloadImage(String key) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('${fp.getUser().uid}/profile');
    return await storageReference.getDownloadURL();
  }
}