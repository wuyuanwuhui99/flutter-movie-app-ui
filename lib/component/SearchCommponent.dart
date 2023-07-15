import 'package:flutter/material.dart';
import '../pages/MovieSearchPage.dart';
import 'package:movie/service/serverMethod.dart';
import '../theme/ThemeColors.dart';
import '../theme/ThemeSize.dart';

/*-----------------------搜索------------------------*/
class SearchCommponent extends StatelessWidget {
  final String classify;
  const SearchCommponent({Key key, this.classify}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getKeyWordService(classify),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          }
          // var result = json.decode(snapshot.data.toString());
          var result = snapshot.data;
          String keyword = "";
          if (result != null && result['data'] != null) {
            keyword = result["data"]["movieName"];
          }
          return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MovieSearchPage(keyword: keyword)));
              },
              child: Container(
                  height: ThemeSize.buttonHeight,
                  //修饰黑色背景与圆角
                  decoration: new BoxDecoration(
                    color: ThemeColors.colorBg,
                    borderRadius:
                    new BorderRadius.all(new Radius.circular(ThemeSize.bigRadius)),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: ThemeSize.containerPadding),
                  child: Text(
                    keyword,
                    style: TextStyle(color: Colors.grey),
                  )));
        });
  }
}

/*-----------------------搜索------------------------*/