import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

Widget widgetLoading() {
  return Center(
    child: LoadingBouncingGrid.square(
      size: 50,
      backgroundColor: Colors.black,
    ),
  );
}