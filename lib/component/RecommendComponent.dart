import 'package:flutter/material.dart';
import '../pages/detail_page.dart';
import '../config/service_url.dart';

/*-----------------------获取推荐的影片------------------------*/
class RecommendComponent extends StatelessWidget {
  final List<Map> movieList;//电影列表
  final String category;//标题
  final bool horizontal;//表示横向或者纵向
  const RecommendComponent({Key key,this.movieList,this.category,this.horizontal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(movieList.length == 0)return null;
    return Container(
      child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(children: <Widget>[
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
                      child: Text(this.category))
                ]),
                SizedBox(height: 15),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 240,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: movieList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailPage(
                                                  movieItem: movieList[
                                                  index])));
                                },
                                child: Container(
                                  width: 150,
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    children: <Widget>[
                                      ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          child: Image(
                                              image: NetworkImage(
                                                  movieList[index][
                                                  "localImg"] !=
                                                      null
                                                      ? serviceUrl +
                                                      movieList[
                                                      index]
                                                      ["localImg"]
                                                      : movieList[
                                                  index]
                                                  ["img"]))),
                                      SizedBox(height: 10),
                                      Text(
                                        movieList[index]["movieName"],
                                        softWrap: true,
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      )
                                    ],
                                  ),
                                ));
                          }),
                    )
                  ],
                )
              ])),
    );
  }
}
/*-----------------------获取推荐的影片------------------------*/
