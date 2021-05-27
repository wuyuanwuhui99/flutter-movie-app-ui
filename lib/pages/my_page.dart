import 'package:flutter/material.dart';
import '../config/service_url.dart';
import 'package:provider/provider.dart';
import '../service/server_method.dart';
import '../provider/UserInfoProvider.dart';
import '../component/MovieListComponent.dart';
import '../model/UserInfoModel.dart';
import '../model/UserMsgModel.dart';
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
    UserInfoModel userInfo = Provider.of<UserInfoProvider>(context).userInfo;
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
                        AvaterComponent(),
                        SizedBox(height: 20),
                        UserMsgComponent(),
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
                            HistoryComponent()
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

  const AvaterComponent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserInfoModel userInfo = Provider.of<UserInfoProvider>(context).userInfo;
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
                serviceUrl + userInfo.avater,
                fit: BoxFit.cover,
              ),
            )),
        SizedBox(height: 10),
        Text(
          userInfo.username,
          style: TextStyle(fontSize: 25.0),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
/*-------------------用户头像-----------------*/

/*-------------------用户数据，使用天数，观看记录等-----------------*/
class UserMsgComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserMsg(),
        builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        }else {
          UserMsgModel userMsg = UserMsgModel.fromJson(snapshot.data["data"]);
          return  Container(
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
                            userMsg.userAge,
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
                          Text(userMsg.favoriteCount,
                              style: TextStyle(fontSize: 25)),
                          SizedBox(height: 10),
                          Text("收藏",
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
                            Text(userMsg.playRecordCount,
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
                      Text(userMsg.viewRecordCount, style: TextStyle(fontSize: 25)),
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

        });
  }
}
/*-------------------用户数据，使用天数，观看记录等-----------------*/

/*-------------------历史记录数据-----------------*/
class HistoryComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPlayRecord(),
        builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        }else {
          List movieList = snapshot.data["data"];
          if(movieList.length == 0){
            return Container(
                alignment: Alignment.center,
                height: 240,
                child: Text("暂无观看记录"));
          }else{
            return MovieListComponent(movieList: movieList,direction: "horizontal");
          }

        }
      });
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
