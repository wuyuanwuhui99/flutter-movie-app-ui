import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../service/serverMethod.dart';
import '../provider/UserInfoProvider.dart';
import '../provider/TokenProvider.dart';
import '../config/global.dart';
import '../utils/LocalStroageUtils.dart';
import '../component/SearchCommponent.dart';
import '../component/AvaterComponent.dart';
import '../component/CategoryComponent.dart';
import '../component/SwiperComponent.dart';
import '../model/UserInfoModel.dart';
import '../component/TopNavigators.dart';
import '../theme/ThemeSize.dart';
import '../theme/ThemeStyle.dart';

/*-----------------------首页------------------------*/
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Widget> categoryList = [];

  List<Map> allCategoryLists = [];

  int pageNum = 1;

  void _getCategoryItem() {
    if (pageNum < allCategoryLists.length) {
      setState(() {
        var item = allCategoryLists[pageNum];
        categoryList.add(CategoryComponent(
          key: GlobalKey(),
          category: item["category"],
          classify: item["classify"],
        ));
      });
    }
  }

  @override
  void initState() {
    getAllCategoryListByPageNameService("首页").then((res) {
      allCategoryLists = (res["data"] as List).cast(); // 顶部轮播组件数
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

  Widget init(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - ThemeSize.containerPadding * 2,
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
                              padding: EdgeInsets.only(left: ThemeSize.smallMargin),
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

  @override
  Widget build(BuildContext context) {
    UserInfoModel userInfo = Provider.of<UserInfoProvider>(context).userInfo;
    if (userInfo.userId == null) {
      //如果用户不存在，先去获取用户信息
      return FutureBuilder(
          future: getUserDataService(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            var userInfo = snapshot.data["data"];
            var token = snapshot.data["token"];
            Global.token = token;
            LocalStroageUtils.setToken(token);
            Provider.of<UserInfoProvider>(context)
                .setUserInfo(UserInfoModel.fromJson(userInfo));
            Provider.of<TokenProvider>(context)
                .setToken(token);
            return init(context);
          });
    } else {
      //如果用户已经存在，初始化页面
      return init(context);
    }
  }
}
/*-----------------------首页------------------------*/
