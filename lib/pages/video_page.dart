import 'package:flutter/material.dart';
import '../component/common.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../service/server_method.dart';
import 'dart:convert';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VideoPage extends StatefulWidget {
  VideoPage({Key key}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Widget> categoryList = [];

  List<Map> allCategoryLists = [];

  int pageNum = 1;

  @override
  void initState() {
    getAllCategoryByClassify("电视剧").then((res) {
      Map result = json.decode(res.toString());
      allCategoryLists = (result["data"] as List).cast(); // 顶部轮播组件数
      setState(() {
        allCategoryLists.sublist(0, 2).forEach((item) {
          categoryList.add(CategoryComponent(
            category: item["category"],
            classify: item["classify"],
          ));
        });
      });
    });
    super.initState();
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
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      AvaterComponent(),
                      Expanded(
                          flex: 1,
                          child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: SearchCommponent(classify: "电视剧")))
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
                    Column(
                      children: <Widget>[SwiperComponent(classify: "电视剧")],
                    ),
                    Column(children: categoryList)
                  ],
                )),
          )
        ]));
  }
}
