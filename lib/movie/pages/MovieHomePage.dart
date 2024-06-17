import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../service/serverMethod.dart';
import '../component/SearchCommponent.dart';
import '../component/AvaterComponent.dart';
import '../component/CategoryComponent.dart';
import '../component/SwiperComponent.dart';
import '../component/TopNavigators.dart';
import '../../theme/ThemeSize.dart';
import '../../theme/ThemeStyle.dart';
import '../model/CategoryModel.dart';

/*-----------------------首页------------------------*/
class MovieHomePage extends StatefulWidget {
  MovieHomePage({Key key}) : super(key: key);

  @override
  _MovieHomePageState createState() => _MovieHomePageState();
}

class _MovieHomePageState extends State<MovieHomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Widget> categoryList = [];

  List<CategoryModel> allCategoryLists = [];

  int pageNum = 1;

  void _getCategoryItem() {
    if (pageNum < allCategoryLists.length) {
      setState(() {
        CategoryModel item = allCategoryLists[pageNum];
        categoryList.add(CategoryComponent(
          key: GlobalKey(),
          category: item.category,
          classify: item.classify,
        ));
      });
    }
  }

  @override
  void initState() {
    getAllCategoryListByPageNameService("首页").then((res) {
      res.data.forEach((element) {
        allCategoryLists.add(CategoryModel.fromJson(element));
      }); // 顶部轮播组件数
      setState(() {
        allCategoryLists.sublist(0, 2).forEach((CategoryModel item) {
          categoryList.add(CategoryComponent(
            category: item.category,
            classify: item.classify
          ));
        });
      });
    });
    super.initState();
  }

  Widget init(BuildContext context) {

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width:
        MediaQuery.of(context).size.width - ThemeSize.containerPadding * 2,
        padding: ThemeStyle.paddingBox,
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width -
                    ThemeSize.containerPadding * 2,
                margin: ThemeStyle.margin,
                decoration: ThemeStyle.boxDecoration,
                child: Padding(
                  padding: ThemeStyle.padding,
                  child: Row(
                    children: <Widget>[
                      AvaterComponent(size: ThemeSize.middleAvater),
                      Expanded(
                          flex: 1,
                          child: Padding(
                              padding:
                              EdgeInsets.only(left: ThemeSize.smallMargin),
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
                          fontSize: ThemeSize.middleFontSize);
                    } else {
                      _getCategoryItem();
                    }
                  },
                  child: ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          SwiperComponent(classify: "电影"),
                          TopNavigators(),
                        ],
                      ),
                      Column(
                        children: categoryList,
                      )
                    ],
                  )))
        ]));
  }
}
/*-----------------------首页------------------------*/
