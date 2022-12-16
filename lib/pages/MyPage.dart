import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/serverMethod.dart';
import '../provider/UserInfoProvider.dart';
import '../provider/TokenProvider.dart';
import '../component/MovieListComponent.dart';
import '../component/AvaterComponent.dart';
import '../model/UserInfoModel.dart';
import '../model/UserMsgModel.dart';
import '../theme/ThemeStyle.dart';
import '../theme/ThemeSize.dart';
import '../theme/ThemeColors.dart';
import '../model/MovieDetailModel.dart';
import '../pages/WebViewPage.dart';

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
    UserInfoModel userInfoModel =
        Provider.of<UserInfoProvider>(context).userInfo;
    return Container(
      padding: ThemeStyle.paddingBox,
      child: ListView(
        children: <Widget>[
          Container(
            margin: ThemeStyle.margin,
            decoration: ThemeStyle.boxDecoration,
            padding: ThemeStyle.padding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AvaterComponent(size: ThemeSize.bigAvater),
                SizedBox(width: ThemeSize.containerPadding),
                Expanded(
                    flex: 1,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(userInfoModel.username,
                              style: TextStyle(
                                  color: ThemeColors.mainTitle,
                                  fontSize: ThemeSize.bigFontSize,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            userInfoModel.sign,
                            style: TextStyle(color: ThemeColors.subTitle),
                          )
                        ])),
                Image.asset("lib/assets/images/icon_edit.png",
                    width: ThemeSize.middleIcon, height: ThemeSize.middleIcon)
              ],
            ),
          ),
          UserMsgComponent(),
          Container(
            decoration: ThemeStyle.boxDecoration,
            margin: ThemeStyle.margin,
            padding: ThemeStyle.padding,
            child: Column(
              children: <Widget>[
                Row(children: <Widget>[
                  Image.asset("lib/assets/images/icon_play_record.png",
                      height: ThemeSize.middleIcon,
                      width: ThemeSize.middleIcon,
                      fit: BoxFit.cover),
                  SizedBox(width: ThemeSize.smallMargin),
                  Text("观看记录",
                      style: TextStyle(fontSize: ThemeSize.middleFontSize)),
                ]),
                SizedBox(
                  height: ThemeSize.smallMargin,
                ),
                HistoryComponent(),
              ],
            ),
          ),
          PannelComponent()
        ],
      ),
    );
  }
}

/*-------------------用户数据，使用天数，观看记录等-----------------*/
class UserMsgComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserMsgService(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          } else {
            UserMsgModel userMsg = UserMsgModel.fromJson(snapshot.data["data"]);
            print(userMsg);
            return Container(
                decoration: ThemeStyle.boxDecoration,
                padding: ThemeStyle.padding,
                margin: ThemeStyle.margin,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Column(children: <Widget>[
                          Text(userMsg.userAge.toString(),
                              style: ThemeStyle.mainTitleStyle),
                          SizedBox(height: ThemeSize.smallMargin),
                          Text("使用天数", style: ThemeStyle.subTitleStyle)
                        ])),
                    Expanded(
                        flex: 1,
                        child: Column(children: <Widget>[
                          Text(userMsg.favoriteCount.toString(),
                              style: ThemeStyle.mainTitleStyle),
                          SizedBox(height: ThemeSize.smallMargin),
                          Text("收藏", style: ThemeStyle.subTitleStyle)
                        ])),
                    Expanded(
                        flex: 1,
                        child: Column(children: <Widget>[
                          Text(userMsg.playRecordCount.toString(),
                              style: ThemeStyle.mainTitleStyle),
                          SizedBox(height: ThemeSize.smallMargin),
                          Text("观看记录", style: ThemeStyle.subTitleStyle)
                        ])),
                    Expanded(
                        flex: 1,
                        child: Column(children: <Widget>[
                          Text(userMsg.viewRecordCount.toString(),
                              style: ThemeStyle.mainTitleStyle),
                          SizedBox(height: ThemeSize.smallMargin),
                          Text("浏览记录", style: ThemeStyle.subTitleStyle)
                        ])),
                  ],
                ));
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
        future: getPlayRecordService(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          } else {
            List<MovieDetailModel> movieList =
                (snapshot.data["data"] as List).cast().map((item) {
              return MovieDetailModel.fromJson(item);
            }).toList();
            if (movieList.length == 0) {
              return Container(
                  alignment: Alignment.center,
                  height: ThemeSize.movieHeight,
                  child: Text("暂无观看记录"));
            } else {
              return MovieListComponent(
                  movieList: movieList, direction: "horizontal");
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
          decoration: ThemeStyle.boxDecoration,
          padding: ThemeStyle.padding,
          margin: ThemeStyle.margin,
          child: Column(children: <Widget>[
            Container(
                decoration: ThemeStyle.bottomDecoration,
                padding: EdgeInsets.only(bottom: ThemeSize.containerPadding),
                child: Row(
                  children: <Widget>[
                    Image.asset("lib/assets/images/icon-collection.png",
                        height: ThemeSize.middleIcon,
                        width: ThemeSize.middleIcon,
                        fit: BoxFit.cover),
                    SizedBox(width: ThemeSize.smallMargin),
                    Text("我的收藏",
                        style: TextStyle(fontSize: ThemeSize.middleFontSize)),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Image.asset("lib/assets/images/icon-arrow.png",
                        height: ThemeSize.smallIcon,
                        width: ThemeSize.smallIcon,
                        fit: BoxFit.cover),
                  ],
                )),
            Container(
                decoration: ThemeStyle.bottomDecoration,
                padding: EdgeInsets.only(
                    top: ThemeSize.containerPadding,
                    bottom: ThemeSize.containerPadding),
                child: Row(
                  children: <Widget>[
                    Image.asset("lib/assets/images/icon-record.png",
                        height: ThemeSize.middleIcon,
                        width: ThemeSize.middleIcon,
                        fit: BoxFit.cover),
                    SizedBox(width: 10),
                    Text("我浏览过的电影",
                        style: TextStyle(fontSize: ThemeSize.middleFontSize)),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Image.asset("lib/assets/images/icon-arrow.png",
                        height: ThemeSize.smallIcon,
                        width: ThemeSize.smallIcon,
                        fit: BoxFit.cover),
                  ],
                )),
            Container(
                padding: EdgeInsets.only(top: ThemeSize.containerPadding),
                child: InkWell(
                    onTap: () {
                      String token = Provider.of<TokenProvider>(context).token;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebViewPage(
                                  url: "http://192.168.0.103:3003/#/?token=" +
                                      token,
                                  title: "电影圈")));
                    },
                    child: Row(
                      children: <Widget>[
                        Image.asset("lib/assets/images/icon-talk.png",
                            height: ThemeSize.middleIcon,
                            width: ThemeSize.middleIcon,
                            fit: BoxFit.cover),
                        SizedBox(width: ThemeSize.smallMargin),
                        Text(
                          "电影圈",
                          style: TextStyle(fontSize: ThemeSize.middleFontSize),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Image.asset("lib/assets/images/icon-arrow.png",
                            height: ThemeSize.smallIcon,
                            width: ThemeSize.smallIcon,
                            fit: BoxFit.cover),
                      ],
                    )))
          ])),
      Container(
          decoration: ThemeStyle.boxDecoration,
          padding: ThemeStyle.padding,
          margin: ThemeStyle.margin,
          child: Column(children: <Widget>[
            Container(
                decoration: ThemeStyle.bottomDecoration,
                padding: EdgeInsets.only(bottom: ThemeSize.containerPadding),
                child: Row(
                  children: <Widget>[
                    Image.asset("lib/assets/images/icon-music.png",
                        height: ThemeSize.middleIcon,
                        width: ThemeSize.middleIcon,
                        fit: BoxFit.cover),
                    SizedBox(width: 10),
                    Text("音乐",
                        style: TextStyle(fontSize: ThemeSize.middleFontSize)),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Image.asset("lib/assets/images/icon-arrow.png",
                        height: ThemeSize.smallIcon,
                        width: ThemeSize.smallIcon,
                        fit: BoxFit.cover),
                  ],
                )),
            Container(
                margin: EdgeInsets.only(top: ThemeSize.containerPadding),
                child: Row(
                  children: <Widget>[
                    Image.asset("lib/assets/images/icon-app.png",
                        height: ThemeSize.middleIcon,
                        width: ThemeSize.middleIcon,
                        fit: BoxFit.cover),
                    SizedBox(width: 10),
                    Text("小程序",
                        style: TextStyle(fontSize: ThemeSize.middleFontSize)),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Image.asset("lib/assets/images/icon-arrow.png",
                        height: ThemeSize.smallIcon,
                        width: ThemeSize.smallIcon,
                        fit: BoxFit.cover),
                  ],
                )),
          ]))
    ]);
  }
}
