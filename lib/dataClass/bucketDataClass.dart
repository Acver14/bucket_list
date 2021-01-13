class BucketClass{
  String _title;
  String _category;
  List<String> _image;
  String _content;
  String _address;
  DateTime _startDate;
  DateTime _closingDate;
  DateTime _achievementDate;
  int _importance;

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