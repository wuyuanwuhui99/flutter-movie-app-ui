import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movie/service/server_method.dart';
import 'package:provider/provider.dart';
import '../config/service_url.dart';
import '../provider/UserInfoProvider.dart';
import "../pages/detail_page.dart";
import '../pages/search_page.dart';
import '../pages/user_page.dart';

/*-----------------------搜索------------------------*/
class SearchCommponent extends StatelessWidget {
  final String classify;
  const SearchCommponent({Key key, this.classify}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getKeyWord(classify),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          }
          // var result = json.decode(snapshot.data.toString());
          var result = snapshot.data;
          String keyword = "";
          if (result != null && result['data'] != null) {
            keyword = result["data"]["name"];
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

/*-----------------------头像组件------------------------*/
class AvaterComponent extends StatelessWidget {
  const AvaterComponent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UserPage()));
      },
      child: Container(
          width: 40,
          height: 40,
          child: ClipOval(
            child: Image.network(
              //从全局的provider中获取用户信息
              serviceUrl +
                  Provider.of<UserInfoProvider>(context).userInfo["avater"],
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
          )),
    );
  }
}
/*-----------------------头像组件------------------------*/

/*-----------------------轮播组件------------------------*/
class SwiperComponent extends StatelessWidget {
  final String classify;
  const SwiperComponent({Key key, this.classify}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCategoryList("轮播", classify),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          }
          // var result = json.decode(snapshot.data.toString());
          var result = snapshot.data;
          List<Map> swiperDataList = [];
          if (result != null && result['data'] != null) {
            swiperDataList = (result['data'] as List).cast(); // 顶部轮播组件数
          }
          return Container(
              height: 200.0,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.network(
                    swiperDataList[index]['localImg'] != null
                        ? serviceUrl + swiperDataList[index]['localImg']
                        : swiperDataList[index]['img'],
                    height: 200,
                    fit: BoxFit.fitHeight,
                  );
                },
                itemCount: swiperDataList.length,
                // viewportFraction: 0.9,
                // scale: 0.9,
                pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                  color: Colors.black54,
                  activeColor: Colors.white,
                )),
                control: SwiperControl(),
                scrollDirection: Axis.horizontal,
                // viewportFraction: 0.8,
                // scale: 0.9,
                autoplay: true,
                loop: true,
                onTap: (index) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(movieItem: swiperDataList[index])));
                },
              ));
        });
  }
}
/*-----------------------轮播组件------------------------*/

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

/*-----------------------分类影片------------------------*/
class CategoryComponents extends StatefulWidget {
  final List<Map> categoryList;

  CategoryComponents({Key key, this.categoryList}) : super(key: key);

  @override
  _CategoryComponentsState createState() => _CategoryComponentsState();
}

class _CategoryComponentsState extends State<CategoryComponents> {
  List<Map> get categoryList => categoryList;

  List<Widget> getAllCategoryList(List<Map> categoryList) {
    List<Widget> list = [];
    for (int i = 0; i < categoryList.length; i++) {
      list.add(CategoryComponent(
        category: categoryList[i]["category"],
        classify: categoryList[i]["classify"],
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: getAllCategoryList(this.categoryList)),
    );
  }
}
/*-----------------------分类影片------------------------*/
