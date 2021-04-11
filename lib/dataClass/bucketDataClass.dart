import 'dart:io';
import 'package:bucket_list/constantClass/enumValues.dart';
import 'package:bucket_list/method/imageConveter.dart';

class BucketClass{
  int _id;
  String _title;
  String _category;
  List<dynamic> _image;
  String _content;
  String _review;
  String _address;
  DateTime _startDate;
  DateTime _closingDate;
  DateTime _achievementDate;
  double _importance;
  BucketState _state = BucketState.incomplete;

  @override
  BucketClass(){
    this._title = '';
    this._category = '';
    this._image = [];
    this._content = '';
    this._review = '';
    this._address = '';
    this._startDate = DateTime.now();
    this._closingDate = null;
    this._achievementDate = null;
    this._importance = 3;
  }

  @override
  BucketClass.forModify(int id, String title, String content, DateTime startDate, DateTime closingDate, double  importance){
    this._id = id;
    this._title = title;
    this._content = content;
    this._startDate = startDate;
    this._closingDate = closingDate;
    this._importance = importance;
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

  getId() {
    return _id;
  }

  getContent(){
    return _content;
  }

  getTitle(){
    return _title;
  }

  setData(int id, DateTime d_day, String title, String content, double importance, BucketState state,
      {List<dynamic> image, String review, String address, DateTime achievementDate})
  {
    switch(state){
      case BucketState.incomplete:
        _id = id;
        _closingDate = d_day;
        _title = title;
        _content = content;
        _importance = importance;
        _state = state;
        break;
      case BucketState.complete:
        _id = id;
        _closingDate = d_day;
        _title = title;
        _content = content;
        _importance = importance;
        _state = state;
        _image = image;
        _review = review;
        _address = address;
        _achievementDate = achievementDate;
    }
  }

  Map<String, Object> toMap(){
    switch(_state){
      case BucketState.incomplete:
        return  {
          "_id" : _id,
          "_title": _title,
          "_category": _category,
          "_image": _image,
          "_content": _content,
          "_review": _review,
          "_address": _address,
          "_startDate": _startDate,
          "_closingDate": _closingDate,
          "_achievementDate" : _achievementDate,
          "_importance": _importance,
          "_state": 0
        };
        break;
      case BucketState.complete:
          return {
            "_id" : _id,
            "_title": _title,
            "_category": _category,
            "_image": _image,
            "_content": _content,
            "_review": _review,
            "_address": _address,
            "_startDate": _startDate,
            "_closingDate": _closingDate,
            "_achievementDate" : _achievementDate,
            "_importance": _importance,
            "_state": 1
          };
          break;
      case BucketState.trash:
        return  {
          "_id" : _id,
          "_title": _title,
          "_category": _category,
          "_image": _image,
          "_content": _content,
          "_review": _review,
          "_address": _address,
          "_startDate": _startDate,
          "_closingDate": _closingDate,
          "_achievementDate" : _achievementDate,
          "_importance": _importance,
          "_state": -1
        };
    }
  }

  @override
  String toString(){
    return toMap().toString();
  }
}