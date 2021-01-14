import 'package:logger/logger.dart';

void printLog(String log){
  new Logger().d(log);
}

void printError(String err){
  new Logger().e(err);
}