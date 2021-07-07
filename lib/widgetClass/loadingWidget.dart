import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

Widget widgetLoading() {
  return Center(
    child: Stack(
      children: [
        Positioned(
          right: 10.0,
          top: 5.0,
          child: Container(
            child: Image.asset('assets/logos/logo_rectangle.png'),
            margin: EdgeInsets.all(20.0),
            height: 50,
          ),
        ),
        // LoadingBouncingGrid.square(
        //   size: 70,
        //   backgroundColor: Colors.black,
        // ),
        Positioned(
            child: SizedBox(
              child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),),
              width: 100,
              height: 100,
            ),
        )
      ],
    )
  );
}