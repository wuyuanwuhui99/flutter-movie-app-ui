import 'package:flutter/material.dart';
import '../theme/ThemeStyle.dart';

class TitleComponent extends StatelessWidget {
  final String title;
  const TitleComponent({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: ThemeStyle.margin,
        padding: EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              width: 3, //宽度
              color: Colors.blue, //边框颜色
            ),
          ),
        ),
        child: Text(title));
  }
}