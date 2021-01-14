import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:bucket_list/method/printLog.dart';

class CategoryClass{
  List<String> _categoryList;
  int selected;

  @override
  CategoryClass(){
    _categoryList = [''];
    selected = 0;
  }

  Map<String,String> toMap(){
    return {
      "_categoryList": _categoryList.toString(),
      "selected": selected.toString()
    };
  }

  @override
  String toString(){
    return toMap().toString();
  }

  void sortCategory(){
    _categoryList.sort();
  }

  List<Widget> getCategoryTextList(){
    return _categoryList.map((e) {
      return new Text(e==''?'+':e);
    }).toList();
  }

  List<Widget> getCategoryDropDownMenuItemList(){
    return _categoryList.map((e) {
      return e==''?new DropdownMenuItem(
          child: Text('+'),
          value: _categoryList.indexOf('')
      ):new DropdownMenuItem(
          child: Text(e),
          value: _categoryList.indexOf(e)
      );
    }).toList();
  }

  int getIndex(String category){
    return _categoryList.indexOf(category);
  }

  String addCategory(String category){
    _categoryList.add(category);
    _categoryList.sort();
    _categoryList.add(_categoryList[0]);
    _categoryList.removeAt(0);
    return category;
  }
}