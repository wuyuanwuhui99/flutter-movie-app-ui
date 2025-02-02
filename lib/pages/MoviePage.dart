import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../theme/ThemeColors.dart';
import '../service/serverMethod.dart';
import '../component/SearchCommponent.dart';
import '../component/AvaterComponent.dart';
import '../component/CategoryComponent.dart';
import '../component/SwiperComponent.dart';
import '../theme/ThemeSize.dart';
import '../theme/ThemeStyle.dart';
import '../model/CategoryModel.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<CategoryModel> categoryList = [];
  List<CategoryModel> allCategoryLists = [];
  EasyRefreshController easyRefreshController = EasyRefreshController();

  @override
  void initState() {
    super.initState();
    getAllCategoryByClassifyService("电影").then((res) {
      allCategoryLists = res.data.map((element){
        return CategoryModel.fromJson(element);
      }).toList();
      setState(() {
        categoryList.addAll(allCategoryLists.sublist(0, 2));
      });
    });
  }

  void _getCategoryItem() {
    if (categoryList.length < allCategoryLists.length) {
      setState(() {
        categoryList.add(allCategoryLists[categoryList.length]);
      });
      easyRefreshController.finishLoad(success: true,noMore: categoryList.length == allCategoryLists.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: ThemeStyle.paddingBox,
      child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width -
                    ThemeSize.containerPadding * 2,
                margin: ThemeStyle.margin,
                decoration: ThemeStyle.boxDecoration,
                padding: ThemeStyle.padding,
                child: Row(
                  children: <Widget>[
                    AvaterComponent(
                      size: ThemeSize.middleAvater,
                    ),
                    Expanded(
                        flex: 1,
                        child: Padding(
                            padding:
                                EdgeInsets.only(left: ThemeSize.smallMargin),
                            child: SearchCommponent(classify: "电影")))
                  ],
                ))
          ],
        ),
        Expanded(
          flex: 1,
          child: EasyRefresh(
              controller: easyRefreshController,
              footer: ClassicalFooter(
                loadText: '上拉加载',
                loadReadyText: '准备加载',
                loadingText: '加载中...',
                loadedText: '加载完成',
                noMoreText: '没有更多',
                bgColor: Colors.transparent,
                textColor: ThemeColors.disableColor,
              ),
              onLoad: () async {
                if (categoryList.length == allCategoryLists.length) {
                  Fluttertoast.showToast(
                      msg: "已经到底了",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: ThemeSize.middleFontSize);
                } else {
                  _getCategoryItem();
                }
              },
              child: ListView(
                children: <Widget>[
                  Column(children: <Widget>[SwiperComponent(classify: "电影")]),
                  Column(
                    children: categoryList.map((item) => CategoryComponent(
                      category: item.category,
                      classify: item.classify,
                    )).toList(),
                  )
                ],
              )),
        )
      ]),
    );
  }
}
