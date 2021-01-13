import 'package:flutter/material.dart';

double getStatusBarHeight(BuildContext context){
  return MediaQuery.of(context).padding.top;
}
