import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../service/server_method.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import '../component/SearchCommponent.dart';
import '../component/AvaterComponent.dart';
import '../component/CategoryComponent.dart';
import '../component/SwiperComponent.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MoviePage extends StatefulWidget {
  MoviePage({Key key}) : super(key: key);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<Widget> categoryList = [];
  List<Map> allCategoryLists = [];

  int pageNum = 1;

  @override
  void initState() {
    super.initState();
    getAllCategoryByClassify("电影").then((res) {
      allCategoryLists = (res["data"] as List).cast(); //
      setState(() {
        allCategoryLists.sublist(0, 2).forEach((item) {
          categoryList.add(CategoryComponent(
            category: item["category"],
            classify: item["classify"],
          ));
        });
      });
    });

  }

  void _getCategoryItem() {
    if (pageNum < allCategoryLists.length) {
      setState(() {
        var item = allCategoryLists[pageNum];
        categoryList.add(CategoryComponent(
          category: item["category"],
          classify: item["classify"],
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                  child: Row(
                    children: <Widget>[
                      AvaterComponent(),
                      Expanded(
                          flex: 1,
                          child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: SearchCommponent(classify: "电影")))
                    ],
                  ),
                ),
              )
            ],
          ),
          Expanded(
            flex: 1,
            child: EasyRefresh(
                footer: MaterialFooter(),
                onLoad: () async {
                  pageNum++;
                  if (pageNum >= allCategoryLists.length) {
                    Fluttertoast.showToast(
                        msg: "已经到底了",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    _getCategoryItem();
                  }
                },
                child: ListView(
                  children: <Widget>[
                    Column(children: <Widget>[SwiperComponent(classify: "电影")]),
                    SizedBox(height: 10),
                    Column(
                      children: categoryList,
                    )
                  ],
                )),
          )
        ]));
  }
}
