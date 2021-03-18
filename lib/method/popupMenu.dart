import 'package:flutter/material.dart';
import 'package:popup_box/popup_box.dart';
import 'package:bucket_list/constantClass/sizeConstant.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

Future<String> popupTextField(BuildContext context) async {
  TextEditingController _input = new TextEditingController();
  await PopupBox.showPopupBox(
      context: context,
      button: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.blue,
        child: Text(
          'Ok',
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      willDisplayWidget: Column(
        children: <Widget>[
          Text(
            '카테고리를 추가해주세요',
            style: TextStyle(fontSize: 40, color: Colors.black),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
              controller: _input,
              obscureText: false,
              textInputAction: TextInputAction.done,
              cursorColor: Colors.black,
              cursorWidth: 1.0,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.0),),
                labelText: '제목',
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
        ],
      ));
  return _input.text;
}

