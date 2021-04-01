import 'package:flutter/material.dart';
import 'package:movie/service/server_method.dart';
import '../pages/detail_page.dart';
import '../config/service_url.dart';

/*-----------------------获取推荐的影片------------------------*/
class RecommendComponent extends StatelessWidget {

  const RecommendComponent({Key key}) : super(key: key);

  List<Widget> _items(List movieList,BuildContext context) {
    var tempList = movieList.map((item) {
      return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailPage(
                              movieItem: item)));
            },
            child: Container(
              alignment: Alignment.center,
              child: Container(
              child: Column(
                children: <Widget>[
                  ClipRRect(
                      borderRadius:
                      BorderRadius.circular(10),
                      child: Image(
                          width: 180,
                          image: NetworkImage(
                              item[
                              "localImg"] !=
                                  null
                                  ? serviceUrl +
                                  item
                                  ["localImg"]
                                  :item
                              ["img"]))),
                  SizedBox(height: 10),
                  Text(
                    item["movieName"],
                    softWrap: true,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                ],
              ),
            ),));
    });
    return tempList.toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getRecommend("电影"),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        }else{
          List movieList = snapshot.data["data"];
          return  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          width: 3, //宽度
                          color: Colors.blue, //边框颜色
                        ),
                      ),
                    ),
                    child: Text("推荐")),
                SizedBox(height: 15),
                 GridView.count(
                      crossAxisSpacing: 0, //水平子 Widget 之间间距
                      crossAxisCount: 2, //一行的 Widget 数量
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      childAspectRatio:0.7,
                      children: this._items(movieList,context))
              ]
          );
        }
      });
  }
}
/*-----------------------获取推荐的影片------------------------*/
