import 'dart:io';
import 'package:bucket_list/constantClass/enumValues.dart';
import 'package:bucket_list/method/imageConveter.dart';

class BucketClass{
  int _id;
  String _title;
  String _category;
  List<File> _image;
  String _content;
  String _address;
  DateTime _startDate;
  DateTime _closingDate;
  DateTime _achievementDate;
  Importance _importance;
  static int count = 0;

  @override
  BucketClass(){
    this._id = count++;
    this._title = '';
    this._category = '';
    this._image = [];
    this._content = '';
    this._address = '';
    this._startDate = DateTime.now();
    this._closingDate = DateTime.now();
    this._achievementDate = DateTime.now();
    this._importance = Importance.middle;
  }

  bool addImage(File new_image){
    if(new_image != null){
      _image.add(new_image);
      return true;
    }
    else return false;
  }

  bool existImage(){
    print(_image.isNotEmpty);
    return _image.isNotEmpty;
  }

  getLastImage(){
    print(_image[0]);
    if(_image.isNotEmpty) return _image[_image.length-1];
    else return -1;
  }

  imageListToMap() async {
    Map<String, String> m = new Map();
    File plusImage = await getImageFileFromAssets('plusImage.png');
    _image.forEach((element) {
      m[_image.indexOf(element).toString()] = element.toString();
    });
    m['100'] = plusImage.toString();
    return m;
  }

  Map<String, String> toMap(){
    return  {
      "_id" : _id.toString(),
      "_title": _title,
      "_category": _category,
      "_image": _image.toString(),
      "_content": _content,
      "_address": _address,
      "_startDate": _startDate.toString(),
      "_closingDate": _closingDate.toString(),
      "_achievementDate" : _achievementDate.toString(),
      "_importance": _importance.toString()
    };
  }

  @override
  String toString(){
    return toMap().toString();
  }
}