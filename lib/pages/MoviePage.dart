import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import '../service/serverMethod.dart';
import '../component/SearchCommponent.dart';
import '../component/AvaterComponent.dart';
import '../component/CategoryComponent.dart';
import '../component/SwiperComponent.dart';
import '../theme/Size.dart';
import '../theme/ThemeStyle.dart';

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
    getAllCategoryByClassifyService("电影").then((res) {
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
      padding: ThemeStyle.padding,
      child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width -
                    Size.containerPadding * 2,
                margin: ThemeStyle.margin,
                decoration: ThemeStyle.boxDecoration,
                padding: ThemeStyle.padding,
                child:Row(
                  children: <Widget>[
                    AvaterComponent(size: Size.middleAvater,),
                    Expanded(
                        flex: 1,
                        child: Padding(
                            padding:
                            EdgeInsets.only(left: Size.smallMargin),
                            child: SearchCommponent(classify: "电影")))
                  ],
                )
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
                      fontSize: Size.middleFontSize);
                } else {
                  _getCategoryItem();
                }
              },
              child: ListView(
                children: <Widget>[
                  Column(children: <Widget>[SwiperComponent(classify: "电影")]),
                  Column(
                    children: categoryList,
                  )
                ],
              )),
        )
      ]),
    );
  }
}
