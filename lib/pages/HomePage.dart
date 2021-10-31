import 'package:flutter/material.dart';
import '../service/serverMethod.dart';
import 'package:provider/provider.dart';
import '../provider/UserInfoProvider.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../config/global.dart';
import '../utils/LocalStroageUtils.dart';
import '../component/SearchCommponent.dart';
import '../component/AvaterComponent.dart';
import '../component/CategoryComponent.dart';
import '../component/SwiperComponent.dart';
import '../model/UserInfoModel.dart';
import './NewMoviePage.dart';
import '../config/ThemeColors.dart';
import '../config/Size.dart';
/*-----------------------分类图标------------------------*/
class TopNavigators extends StatelessWidget {
  const TopNavigators({Key key}) : super(key: key);
  List<Widget> _items(BuildContext context) {
    List listData = [
      {"image": "lib/assets/images/icon-hot.png", "title": "热门"},
      {"image": "lib/assets/images/icon-play.png", "title": "预告"},
      {"image": "lib/assets/images/icon-top.png", "title": "最新"},
      {"image": "lib/assets/images/icon-classify.png", "title": "分类"}
    ];
    var tempList = listData.map((value) {
      return InkWell(
          onTap: () {
            if(value["title"] == "最新"){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NewMoviePage()));
            }
          },
          child: Container(
              child: Column(
            children: <Widget>[
              Image.asset(value['image'],
                  height: 40, width: 40, fit: BoxFit.cover),
              SizedBox(height: 12),
              Text(
                value['title'],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              )
            ],
          )));
    });
    return tempList.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: GridView.count(
            crossAxisSpacing: 10.0, //水平子 Widget 之间间距
            mainAxisSpacing: 10.0, //垂直子 Widget 之间间距
            padding: EdgeInsets.all(20),
            crossAxisCount: 4, //一行的 Widget 数量
            children: this._items(context)));
  }
}
/*-----------------------分类图标------------------------*/

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
        decoration: new BoxDecoration(
            color: ThemeColors.colorBg
        ),
        width: MediaQuery.of(context).size.width - Size.containerPadding*2,
        child: Padding(padding: EdgeInsets.all(Size.containerPadding),
          child: Column(children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  alignment:Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width - Size.containerPadding*2,
                  decoration: new BoxDecoration(
                    color:  Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(Size.radius)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
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
            SizedBox(height: Size.containerPadding),
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
                          children: <Widget>[SwiperComponent(classify: "电影")],
                        ),
                        Column(
                          children: <Widget>[TopNavigators()],
                        ),
                        Column(
                          children: categoryList,
                        )
                      ],
                    )))
          ]))
        );
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
            Provider.of<UserInfoProvider>(context).setUserInfo(UserInfoModel.fromJson(userInfo));
            return init(context);
          });
    } else {
      //如果用户已经存在，初始化页面
      return init(context);
    }
  }
}
/*-----------------------首页------------------------*/
