import 'package:flutter/material.dart';
import '../router/index.dart';
import '../theme/ThemeSize.dart';
import '../theme/ThemeStyle.dart';

/*-----------------------分类图标------------------------*/
class TopNavigators extends StatelessWidget {
  const TopNavigators({super.key});

  List<Widget> _items(BuildContext context) {
    List listData = [
      {"image": "lib/assets/images/icon_hot.png", "title": "热门"},
      {"image": "lib/assets/images/icon_play.png", "title": "预告"},
      {"image": "lib/assets/images/icon_top.png", "title": "最新"},
      {"image": "lib/assets/images/icon_classify.png", "title": "分类"}
    ];
    var tempList = listData.map((value) {
      return Expanded(
          flex: 1,
          child: InkWell(
              onTap: () {
                if (value["title"] == "最新") {
                  Routes.router.navigateTo(context, '/NewMoviePage');
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(value['image'],
                      height: ThemeSize.bigIcon,
                      width: ThemeSize.bigIcon,
                      fit: BoxFit.cover),
                  SizedBox(height: ThemeSize.containerPadding),
                  Text(
                    value['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  )
                ],
              )));
    });
    return tempList.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: ThemeStyle.boxDecoration,
        width: MediaQuery.of(context).size.width,
        margin: ThemeStyle.margin,
        padding: EdgeInsets.only(
            top: ThemeSize.containerPadding,
            bottom: ThemeSize.containerPadding),
        child: Row(
          children: this._items(context),
        ));
  }
}
/*-----------------------分类图标------------------------*/
