import 'package:bucket_list/constantClass/enumValues.dart';

class BucketClass{
  String _title;
  String _category;
  List<String> _image;
  String _content;
  String _address;
  DateTime _startDate;
  DateTime _closingDate;
  DateTime _achievementDate;
  Importance _importance;

  @override
  BucketClass(){
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

  Map<String, String> toMap(){
    return  {
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