import 'package:flutter/material.dart';
import 'package:movie/service/server_method.dart';
import "../pages/detail_page.dart";
import '../config/service_url.dart';


/*-----------------------分类电影------------------------*/
class CategoryComponent extends StatelessWidget {
  final String category, classify;
  const CategoryComponent({Key key, this.category, this.classify})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCategoryList(this.category, this.classify),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          }
          // var result = json.decode(snapshot.data.toString());
          var result = snapshot.data;
          List<Map> categoryList = [];
          if (result != null && result['data'] != null) {
            categoryList = (result['data'] as List).cast();
          }
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
                                itemCount: categoryList.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailPage(
                                                        movieItem: categoryList[
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
                                                        categoryList[index][
                                                        "localImg"] !=
                                                            null
                                                            ? serviceUrl +
                                                            categoryList[
                                                            index]
                                                            ["localImg"]
                                                            : categoryList[
                                                        index]
                                                        ["img"]))),
                                            SizedBox(height: 10),
                                            Text(
                                              categoryList[index]["name"],
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
        });
  }
}
/*-----------------------分类电影------------------------*/