import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/src/button.dart';

/// A sign in button that matches Kakao's design guidelines.
///
/// The button text can be overridden, however the default text is recommended
/// in order to be compliant with the design guidelines and to maximise
/// conversion.
class KakaoSignInButton extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final bool darkMode;
  final double borderRadius;
  final VoidCallback onPressed;
  final Color splashColor;

  /// Creates a new button. Set [darkMode] to `true` to use the dark
  /// blue background variant with white text, otherwise an all-white background
  /// with dark text is used.
  KakaoSignInButton(
      {this.onPressed,
        this.text = 'Kakao로 시작하기',
        this.textStyle,
        this.splashColor,
        this.darkMode = false,
        // Kakao doesn't specify a border radius, but this looks about right.
        this.borderRadius = defaultBorderRadius,
        Key key})
      : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child : RaisedButton(
          color: Color(0xFFFEE500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          splashColor: splashColor,
          onPressed: onPressed,
          child: Row(
            children: <Widget>[
              // The Kakao design guidelines aren't consistent. The dark mode
              // seems to have a perfect square of white around the logo, with a
              // thin 1dp (ish) border. However, since the height of the button
              // is 40dp and the logo is 18dp, it suggests the bottom and top
              // padding is (40 - 18) * 0.5 = 11. That's 10dp once we account for
              // the thin border.
              //
              // The design guidelines suggest 8dp padding to the left of the
              // logo, which doesn't allow us to center the image (given the 10dp
              // above). Something needs to give - either the 8dp is wrong or the
              // 40dp should be 36dp. I've opted to increase left padding to 10dp.
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  height: 38.0, // 40dp - 2*1dp border
                  width: 20.0, // matches above
                  decoration: BoxDecoration(
                    color: darkMode ? Colors.white : null,
                    borderRadius: BorderRadius.circular(this.borderRadius),
                  ),
                  child: Center(
                    child: Image(
                      image: AssetImage('assets/kakao_logo.png'
                      ),
                      height: 18.0,
                      width: 18.0,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 14.0 /* 24.0 - 10dp padding */),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
                child: Text(
                  text,
                  style: textStyle ?? TextStyle(
                    fontSize: 18.0,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7A6F0F),
                  ),
                ),
              ),
            ],
          ),
        )
    );

  }
}