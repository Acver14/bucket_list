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
  double _importance;
  State _state = State.incomplete;

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
    this._closingDate = null;
    this._achievementDate = DateTime.now();
    this._importance = 3;
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

  getStartDate(){
    return _startDate;
  }

  getClosingDate(){
    return _closingDate;
  }

  setClosingDate(DateTime dt){
    _closingDate = dt;
  }

  setData(int id, DateTime d_day, String title, String content, double importance){
    _id = id;
    _closingDate = d_day;
    _title = title;
    _content = content;
    _importance = importance;
  }

  getId() {
    return _id;
  }

  Map<String, Object> toMap(){
    return  {
      "_id" : _id,
      "_title": _title,
      "_category": _category,
      "_image": _image,
      "_content": _content,
      "_address": _address,
      "_startDate": _startDate,
      "_closingDate": _closingDate,
      "_achievementDate" : _achievementDate,
      "_importance": _importance,
      "_state": _state
    };
  }

  @override
  String toString(){
    return toMap().toString();
  }
}