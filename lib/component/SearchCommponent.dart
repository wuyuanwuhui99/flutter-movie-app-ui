import 'package:flutter/material.dart';
import '../pages/SearchPage.dart';
import 'package:movie/service/serverMethod.dart';

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
                        builder: (context) => SearchPage(keyword: keyword)));
              },
              child: Container(
                  height: 40,
                  //修饰黑色背景与圆角
                  decoration: new BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(255, 241, 242, 246),
                        width: 1.0), //灰色的一层边框
                    color: Color.fromARGB(255, 230, 230, 230),
                    borderRadius:
                    new BorderRadius.all(new Radius.circular(20.0)),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                  child: Text(
                    keyword,
                    style: TextStyle(color: Colors.grey),
                  )));
        });
  }
}

/*-----------------------搜索------------------------*/