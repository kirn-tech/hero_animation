import 'package:flutter/painting.dart';

class AppTextStyles {
  static const _undefinedStyle = TextStyle();

  final TextStyle h1;

  final TextStyle h2;

  const AppTextStyles._({
    this.h1 = _undefinedStyle,
    this.h2 = _undefinedStyle,
  });

  factory AppTextStyles.desktop() {
    return AppTextStyles._(
      h1: _createTextStyle(
        fontSize: 30.0,
        decoration: TextDecoration.underline,
      ),
      h2: _createTextStyle(
        fontSize: 40.0,
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
    );
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
    );
  }
}
