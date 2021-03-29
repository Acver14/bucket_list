import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bucket_list/constantClass/enumValues.dart';
import 'package:bucket_list/widgetClass/loadingWidget.dart';

Future<QuerySnapshot> loadBucketList(Sort _sorting, Firestore, String uid) async {
  switch(_sorting){
    case Sort.importance:
      return await Firestore.instance
          .collection(uid)
          .document('bucket_list')
          .collection('buckets')
          .orderBy('_importance', descending: true).getDocuments();
      break;
    case Sort.creationDate:
      return await Firestore.instance
          .collection(uid)
          .document('bucket_list')
          .collection('buckets')
          .orderBy('_startDate', descending: true).getDocuments();
      break;
    case Sort.title:
      return await Firestore.instance
          .collection(uid)
          .document('bucket_list')
          .collection('buckets')
          .orderBy('_title', descending: true).getDocuments();
      break;
  }
}

Widget incompleteBucketCards(Sort _sorting, Firestore, String uid){

  return FutureBuilder(
      future: loadBucketList(_sorting, Firestore, uid),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return widgetLoading();
        } else {
          if (snapshot.data.documents.length > 0) {
            bucketListSnapshot = snapshot;
            bucketList = getBucketList();
            return Expanded(
                child: Column(
                  children: [
                    new ListView.builder(
                      //reverse: true,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      controller: _infiniteController,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return getBucketInfo(
                            index, snapshot.data.documents.length);
                      },
                    )
                  ],
                ));
          } else {
            return new Align(
              alignment: Alignment.center,
              child: Center(child: Text("항목이 없습니다.")),
            );
          }
        }
      })
}