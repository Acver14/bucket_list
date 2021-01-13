import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get localFile async {
  final path = await localPath;
  return File('$path/bucketList.txt');
}

Future<File> writeString(String str) async {
  final file = await localFile;

  // 파일 쓰기
  return file.writeAsString(str);
}

Future<File> writeStringList(List<String> str) async {
  final file = await localFile;
  String str_for_write;
  str.forEach((element) {
    str_for_write += element+'\n';
  });

  // 파일 쓰기
  return file.writeAsString(str_for_write);
}