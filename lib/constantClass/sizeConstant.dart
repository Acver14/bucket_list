import 'package:flutter/material.dart';

double getStatusBarHeight(BuildContext context){
  return MediaQuery.of(context).padding.top;
}

double getDisplayWidth(BuildContext context){
  return MediaQuery.of(context).size.width;
}

double getDisplayHeight(BuildContext context){
  return MediaQuery.of(context).size.height;
}