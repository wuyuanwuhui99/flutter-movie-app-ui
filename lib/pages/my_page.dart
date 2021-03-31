import 'package:flutter/material.dart';
import '../config/service_url.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../service/server_method.dart';
import '../provider/UserInfoProvider.dart';

class MyPage extends StatefulWidget {
  MyPage({Key key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    Map userInfo = Provider.of<UserInfoProvider>(context).userInfo;
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(238, 238, 238, 1),
      ),
      child: Column(children: <Widget>[
        Expanded(
            flex: 1,
            child: ListView(
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: <Widget>[
                        AvaterComponent(userInfo: userInfo),
                        SizedBox(height: 20),
                        UserMsgComponent(userId: userInfo["userId"]),
                        SizedBox(height: 20)
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Row(children: <Widget>[
                          Image.asset("lib/assets/images/icon-history.png",
                              height: 25, width: 25, fit: BoxFit.cover),
                          SizedBox(width: 10),
                          Text("观看记录", style: TextStyle(fontSize: 16)),
                        ]),
                        SizedBox(height: 10),
                        Column(
                          children: <Widget>[
                            HistoryComponent(userId: userInfo["userId"])
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                PannelComponent()
              ],
            )),
      ]),
    );
  }
}

/*-------------------用户头像-----------------*/
class AvaterComponent extends StatelessWidget {
  final Map userInfo;

  const AvaterComponent({Key key, this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, //垂直方向居中对齐
      children: <Widget>[
        SizedBox(height: 20),
        Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(238, 238, 238, 1), width: 5),
                borderRadius: BorderRadius.circular(120)),
            width: 120,
            height: 120,
            child: ClipOval(
              child: Image.network(
                //从全局的provider中获取用户信息
                serviceUrl + userInfo["avater"],
                fit: BoxFit.cover,
              ),
            )),
        SizedBox(height: 10),
        Text(
          userInfo["username"],
          style: TextStyle(fontSize: 25.0),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
/*-------------------用户头像-----------------*/

/*-------------------用户数据，使用天数，观看记录等-----------------*/
class UserMsgComponent extends StatefulWidget {
  final String userId;
  UserMsgComponent({Key key, this.userId}) : super(key: key);

  @override
  _UserMsgComponentState createState() => _UserMsgComponentState();
}

class _UserMsgComponentState extends State<UserMsgComponent> {
  Map userMsg = {
    "userAge": "0",
    "recordCount": "0",
    "playCount": "0",
    "favoriteCount": "0"
  };

  @override
  void initState() {
    getUserMsg(widget.userId).then((res) {
      Map result = json.decode(res.toString());
      setState(() {
        userMsg = result["data"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(
                            // 设置单侧边框的样式
                            color: Color.fromRGBO(221, 221, 221, 1),
                            width: 1,
                            style: BorderStyle.solid))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, //垂直方向居中对齐
                  children: <Widget>[
                    Text(
                      userMsg["userAge"],
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(height: 10),
                    Text("使用天数",
                        style: TextStyle(
                            color: Color.fromRGBO(221, 221, 221, 1),
                            fontSize: 16))
                  ],
                ),
              )),
          Expanded(
            flex: 1,
            child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(
                            // 设置单侧边框的样式
                            color: Color.fromRGBO(221, 221, 221, 1),
                            width: 1,
                            style: BorderStyle.solid))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, //垂直方向居中对齐
                  children: <Widget>[
                    Text(userMsg["favoriteCount"],
                        style: TextStyle(fontSize: 25)),
                    SizedBox(height: 10),
                    Text("关注",
                        style: TextStyle(
                            color: Color.fromRGBO(221, 221, 221, 1),
                            fontSize: 16))
                  ],
                )),
          ),
          Expanded(
              flex: 1,
              child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              // 设置单侧边框的样式
                              color: Color.fromRGBO(221, 221, 221, 1),
                              width: 1,
                              style: BorderStyle.solid))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, //垂直方向居中对齐
                    children: <Widget>[
                      Text(userMsg["playCount"],
                          style: TextStyle(fontSize: 25)),
                      SizedBox(height: 10),
                      Text("观看记录",
                          style: TextStyle(
                              color: Color.fromRGBO(221, 221, 221, 1),
                              fontSize: 16))
                    ],
                  ))),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, //垂直方向居中对齐
              children: <Widget>[
                Text(userMsg["recordCount"], style: TextStyle(fontSize: 25)),
                SizedBox(height: 10),
                Text("浏览记录",
                    style: TextStyle(
                        color: Color.fromRGBO(221, 221, 221, 1), fontSize: 16))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
/*-------------------用户数据，使用天数，观看记录等-----------------*/

/*-------------------历史记录数据-----------------*/
class HistoryComponent extends StatefulWidget {
  final String userId;
  HistoryComponent({Key key, this.userId}) : super(key: key);

  @override
  _HistoryComponentState createState() => _HistoryComponentState();
}

class _HistoryComponentState extends State<HistoryComponent> {
  List<Map> categoryList = [];

  @override
  void initState() {
    getHistory(widget.userId).then((res) {
      Map result = json.decode(res.toString());
      setState(() {
        categoryList = (result["data"] as List).cast();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 240,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryList.length,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    print(categoryList[index]);
                  },
                  child: Container(
                    width: 150,
                    margin: EdgeInsets.only(right: 10),
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image(
                                image: NetworkImage(
                                    categoryList[index]["localImg"] != null
                                        ? serviceUrl +
                                            categoryList[index]["localImg"]
                                        : categoryList[index]["img"]))),
                        SizedBox(height: 10),
                        Text(
                          categoryList[index]["movieName"],
                          softWrap: true,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ));
            }),
      ),
    );
  }
}
/*-------------------历史记录数据-----------------*/

class PannelComponent extends StatelessWidget {
  const PannelComponent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
          decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1)),
          child: Column(children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            // 设置单侧边框的样式
                            color: Color.fromRGBO(221, 221, 221, 1),
                            width: 1,
                            style: BorderStyle.solid))),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Image.asset("lib/assets/images/icon-collection.png",
                          height: 25, width: 25, fit: BoxFit.cover),
                      SizedBox(width: 10),
                      Text("我的收藏", style: TextStyle(fontSize: 16)),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Image.asset("lib/assets/images/icon-arrow.png",
                          height: 25, width: 25, fit: BoxFit.cover),
                    ],
                  ),
                )),
            Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            // 设置单侧边框的样式
                            color: Color.fromRGBO(221, 221, 221, 1),
                            width: 1,
                            style: BorderStyle.solid))),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Image.asset("lib/assets/images/icon-record.png",
                          height: 25, width: 25, fit: BoxFit.cover),
                      SizedBox(width: 10),
                      Text("我浏览过的电影", style: TextStyle(fontSize: 16)),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Image.asset("lib/assets/images/icon-arrow.png",
                          height: 25, width: 25, fit: BoxFit.cover),
                    ],
                  ),
                )),
            Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            // 设置单侧边框的样式
                            color: Color.fromRGBO(221, 221, 221, 1),
                            width: 1,
                            style: BorderStyle.solid))),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Image.asset("lib/assets/images/icon-talk.png",
                          height: 25, width: 25, fit: BoxFit.cover),
                      SizedBox(width: 10),
                      Text(
                        "电影圈",
                        style: TextStyle(fontSize: 16),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Image.asset("lib/assets/images/icon-arrow.png",
                          height: 25, width: 25, fit: BoxFit.cover),
                    ],
                  ),
                ))
          ])),
      SizedBox(height: 20),
      Container(
          decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1)),
          child: Column(children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            // 设置单侧边框的样式
                            color: Color.fromRGBO(221, 221, 221, 1),
                            width: 1,
                            style: BorderStyle.solid))),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Image.asset("lib/assets/images/icon-music.png",
                          height: 25, width: 25, fit: BoxFit.cover),
                      SizedBox(width: 10),
                      Text("音乐", style: TextStyle(fontSize: 16)),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Image.asset("lib/assets/images/icon-arrow.png",
                          height: 25, width: 25, fit: BoxFit.cover),
                    ],
                  ),
                )),
            Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            // 设置单侧边框的样式
                            color: Color.fromRGBO(221, 221, 221, 1),
                            width: 1,
                            style: BorderStyle.solid))),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Image.asset("lib/assets/images/icon-app.png",
                          height: 25, width: 25, fit: BoxFit.cover),
                      SizedBox(width: 10),
                      Text("小程序", style: TextStyle(fontSize: 16)),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Image.asset("lib/assets/images/icon-arrow.png",
                          height: 25, width: 25, fit: BoxFit.cover),
                    ],
                  ),
                )),
          ]))
    ]);
  }
}
