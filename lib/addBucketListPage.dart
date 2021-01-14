import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'constantClass/sizeConstant.dart';
import 'dataClass/bucketDataClass.dart';
import 'dataClass/categoryDataClass.dart';

import 'method/popupMenu.dart';
import 'method/printLog.dart';

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

  @override
  Widget build(BuildContext context) {
    printLog(categoryData.toString());
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: new Text(
          '버킷리스트 생성',
          style: TextStyle(color: Colors.black),
        ),
        leading: new IconButton(icon: new Icon(Icons.arrow_back_ios, color: Colors.black,), onPressed: ()=>Navigator.pop(context)),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child:Column(
          children: [
            Row(
              children: [
                Flexible(
                    child: TextField(
                    obscureText: false,
                    textInputAction: TextInputAction.continueAction,
                    cursorColor: Colors.black,
                    cursorWidth: 1.0,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.0),),
                      labelText: '제목',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  // margin: EdgeInsets.only(left: 20, top: 10),
                  height: 50,
                  width: 150,
                  alignment: Alignment.bottomRight,
                  child: DropdownButton(
                      value: categoryData.selected,
                      items: categoryData.getCategoryDropDownMenuItemList(),
                      onChanged: (value) async {
                        if(value == 0){
                          String new_category = await popupTextField(context);
                          value = categoryData.getIndex(categoryData.addCategory(new_category));
                        }
                        setState(() {
                          categoryData.selected = value;
                        });
                      }),
                )
              ],
            )
          ],
        ),
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
