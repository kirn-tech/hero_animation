import 'package:flutter/painting.dart';

class AppTextStyles {
  static const _undefinedStyle = TextStyle();

  final TextStyle h1;

  final TextStyle h2;

  final TextStyle h3;

  const AppTextStyles._({
    this.h1 = _undefinedStyle,
    this.h2 = _undefinedStyle,
    this.h3 = _undefinedStyle,
  });

  factory AppTextStyles.desktop() {
    return AppTextStyles._(
      h1: _createTextStyle(
        fontSize: 30.0,
        decoration: TextDecoration.underline,
      ),
      h2: _createTextStyle(fontSize: 40.0, fontWeight: FontWeight.w600),
      h3: _createTextStyle(
        fontSize: 32.0,
      ),
    );
  }

  factory AppTextStyles.mobile() {
    return AppTextStyles._(
        h1: _createTextStyle(
          fontSize: 16.0,
          decoration: TextDecoration.underline,
        ),
        h2: _createTextStyle(
          fontSize: 20.0,
        ),
        h3: _createTextStyle(
          fontSize: 18.0,
        ));
  }

  static TextStyle _createTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    TextDecoration? decoration,
  }) {
    return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.normal,
        decoration: decoration,
        letterSpacing: 1.1);
  }
}
