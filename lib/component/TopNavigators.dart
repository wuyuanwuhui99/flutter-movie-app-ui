import 'package:flutter/material.dart';
import '../pages/NewMoviePage.dart';
import '../theme/Size.dart';
import '../theme/ThemeStyle.dart';
/*-----------------------分类图标------------------------*/
class TopNavigators extends StatelessWidget {
  const TopNavigators({Key key}) : super(key: key);
  List<Widget> _items(BuildContext context) {
    List listData = [
      {"image": "lib/assets/images/icon-hot.png", "title": "热门"},
      {"image": "lib/assets/images/icon-play.png", "title": "预告"},
      {"image": "lib/assets/images/icon-top.png", "title": "最新"},
      {"image": "lib/assets/images/icon-classify.png", "title": "分类"}
    ];
    var tempList = listData.map((value) {
      return InkWell(
          onTap: () {
            if(value["title"] == "最新"){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NewMoviePage()));
            }
          },
          child: Container(
              child: Column(
                children: <Widget>[
                  Image.asset(value['image'],
                      height: Size.bigIcon, width: Size.bigIcon, fit: BoxFit.cover),
                  SizedBox(height: Size.containerPadding),
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
        height: 110,
        margin: ThemeStyle.margin,
        child: GridView.count(
            crossAxisSpacing: 10.0, //水平子 Widget 之间间距
            mainAxisSpacing: 10.0, //垂直子 Widget 之间间距
            padding: EdgeInsets.all(20),
            crossAxisCount: 4, //一行的 Widget 数量
            children: this._items(context)));
  }
}
/*-----------------------分类图标------------------------*/
