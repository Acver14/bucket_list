import 'package:image_picker/image_picker.dart';
import 'dart:io';

Future getImage() async {
  final picker = ImagePicker();
  File _image;
  final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      _image = null;
    }

    return _image;
}
