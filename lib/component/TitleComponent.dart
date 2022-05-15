import 'package:flutter/material.dart';
import '../theme/ThemeStyle.dart';

class TitleComponent extends StatelessWidget {
  final String title;
  const TitleComponent({Key key,this.title}) : super(key: key);

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