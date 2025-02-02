import 'package:flutter/material.dart';
import '../theme/ThemeSize.dart';
import '../theme/ThemeColors.dart';
import '../theme/ThemeStyle.dart';

/*-----------------------头像组件------------------------*/
class NavigatorTitleComponent extends StatelessWidget {
  final String title;
  const NavigatorTitleComponent({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: ThemeStyle.padding,
        decoration: BoxDecoration(color: ThemeColors.colorWhite),
        child:
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image.asset("lib/assets/images/icon_back.png",
                width: ThemeSize.smallIcon, height: ThemeSize.smallIcon),
          ),
          Expanded(flex: 1, child: Center(child: Text(title))),
          SizedBox(
            width: ThemeSize.smallIcon,
            height: ThemeSize.smallIcon,
          ),
        ]));
  }
}
/*-----------------------头像组件------------------------*/