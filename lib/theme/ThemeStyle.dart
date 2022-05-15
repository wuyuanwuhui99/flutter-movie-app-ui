import 'package:flutter/material.dart';
import './Size.dart';
import './ThemeColors.dart';

class ThemeStyle {
  static BoxDecoration boxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(Size.radius)),
  );

  static EdgeInsets margin = EdgeInsets.only(bottom: Size.containerPadding);

  static EdgeInsets padding = EdgeInsets.all(Size.containerPadding);

  static EdgeInsets paddingBox = EdgeInsets.only(left: Size.containerPadding,right: Size.containerPadding,top: Size.containerPadding);

  static TextStyle mainTitleStyle = TextStyle(
      color: ThemeColors.mainTitle,
      fontSize: Size.bigFontSize,
      fontWeight: FontWeight.bold);

  static TextStyle subTitleStyle =
      TextStyle(color: ThemeColors.subTitle, fontSize: Size.smallFontSize);

  static BoxDecoration bottomDecoration = BoxDecoration(
      border: Border(
          bottom: BorderSide(
            // 设置单侧边框的样式
              color: ThemeColors.border,
              width: 1,
              style: BorderStyle.solid)));
}
