import'package:flutter/material.dart';
import './Size.dart';

class ThemeStyle {
  static BoxDecoration boxDecoration =  BoxDecoration(
    color:  Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(Size.radius)),
  );
  static EdgeInsets margin = EdgeInsets.only(bottom: Size.containerPadding);
  static EdgeInsets padding = EdgeInsets.all(Size.containerPadding);
}