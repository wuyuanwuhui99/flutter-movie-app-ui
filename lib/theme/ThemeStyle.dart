import 'package:flutter/material.dart';
import './ThemeSize.dart';
import './ThemeColors.dart';

class ThemeStyle {
  static BoxDecoration boxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(ThemeSize.middleRadius)),
  );

  static EdgeInsets margin = EdgeInsets.only(bottom: ThemeSize.containerPadding);

  static EdgeInsets padding = EdgeInsets.all(ThemeSize.containerPadding);

  static EdgeInsets paddingBox = EdgeInsets.only(left: ThemeSize.containerPadding,right: ThemeSize.containerPadding);

  static TextStyle mainTitleStyle = TextStyle(
      color: ThemeColors.mainTitle,
      fontSize: ThemeSize.bigFontSize,
      fontWeight: FontWeight.bold);

  static TextStyle subTitleStyle =
      TextStyle(color: ThemeColors.subTitle, fontSize: ThemeSize.smallFontSize);

  static BoxDecoration bottomDecoration = BoxDecoration(
      border: Border(
          bottom: BorderSide(
            // 设置单侧边框的样式
              color: ThemeColors.borderColor,
              width: 1,
              style: BorderStyle.solid)));

  //列边距
  static EdgeInsets columnPadding = EdgeInsets.only(top: ThemeSize.columnPadding,bottom: ThemeSize.columnPadding);
}
