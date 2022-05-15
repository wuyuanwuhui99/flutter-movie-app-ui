import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/serverMethod.dart';
import '../provider/UserInfoProvider.dart';
import '../component/MovieListComponent.dart';
import '../component/AvaterComponent.dart';
import '../model/UserInfoModel.dart';
import '../model/UserMsgModel.dart';
import '../theme/ThemeStyle.dart';
import '../theme/Size.dart';
import '../theme/ThemeColors.dart';
import '../model/MovieDetailModel.dart';

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
                AvaterComponent(size: Size.bigAvater),
                SizedBox(width: Size.containerPadding),
                Expanded(
                    flex: 1,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(userInfoModel.username,
                              style: TextStyle(
                                  color: ThemeColors.mainTitle,
                                  fontSize: Size.bigFontSize,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            userInfoModel.sign,
                            style: TextStyle(color: ThemeColors.subTitle),
                          )
                        ])),
                Image.asset("lib/assets/images/icon_edit.png",
                    width: Size.middleIcon, height: Size.middleIcon)
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
                      height: Size.middleIcon, width: Size.middleIcon, fit: BoxFit.cover),
                  SizedBox(width: Size.smallMargin),
                  Text("观看记录", style: TextStyle(fontSize: Size.middleFontSize)),
                ]),
                SizedBox(height: Size.smallMargin,),
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
                          Text("使用天数", style: ThemeStyle.subTitleStyle)
                        ])),
                    Expanded(
                        flex: 1,
                        child: Column(children: <Widget>[
                          Text(userMsg.favoriteCount.toString(),
                              style: ThemeStyle.mainTitleStyle),
                          Text("收藏", style: ThemeStyle.subTitleStyle)
                        ])),
                    Expanded(
                        flex: 1,
                        child: Column(children: <Widget>[
                          Text(userMsg.playRecordCount.toString(), style: ThemeStyle.mainTitleStyle),
                          Text("观看记录", style: ThemeStyle.subTitleStyle)
                        ])),
                    Expanded(
                        flex: 1,
                        child: Column(children: <Widget>[
                          Text(userMsg.viewRecordCount.toString(), style: ThemeStyle.mainTitleStyle),
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
            List<MovieDetailModel> movieList = (snapshot.data["data"] as List).cast().map((item){
              return MovieDetailModel.fromJson(item);
            }).toList();
            if (movieList.length == 0) {
              return Container(
                  alignment: Alignment.center,
                  height: Size.movieHeight,
                  child: Text("暂无观看记录"));
            } else {
              return MovieListComponent(movieList: movieList, direction: "horizontal");
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
                padding: EdgeInsets.only(bottom:Size.containerPadding),
                child:  Row(
                  children: <Widget>[
                    Image.asset("lib/assets/images/icon-collection.png",
                        height: Size.middleIcon, width: Size.middleIcon, fit: BoxFit.cover),
                    SizedBox(width: Size.smallMargin),
                    Text("我的收藏", style: TextStyle(fontSize: Size.middleFontSize)),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Image.asset("lib/assets/images/icon-arrow.png",
                        height: Size.smallIcon, width: Size.smallIcon, fit: BoxFit.cover),
                  ],
                )),
            Container(
                decoration: ThemeStyle.bottomDecoration,
                padding: EdgeInsets.only(top: Size.containerPadding,bottom: Size.containerPadding),
                child: Row(
                  children: <Widget>[
                    Image.asset("lib/assets/images/icon-record.png",
                        height: Size.middleIcon, width: Size.middleIcon, fit: BoxFit.cover),
                    SizedBox(width: 10),
                    Text("我浏览过的电影", style: TextStyle(fontSize: Size.middleFontSize)),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Image.asset("lib/assets/images/icon-arrow.png",
                        height: Size.smallIcon, width: Size.smallIcon, fit: BoxFit.cover),
                  ],
                )),
            Container(
                padding: EdgeInsets.only(top: Size.containerPadding),
                child: Row(
                  children: <Widget>[
                    Image.asset("lib/assets/images/icon-talk.png",
                        height: Size.middleIcon, width: Size.middleIcon, fit: BoxFit.cover),
                    SizedBox(width: Size.smallMargin),
                    Text(
                      "电影圈",
                      style: TextStyle(fontSize: Size.middleFontSize),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Image.asset("lib/assets/images/icon-arrow.png",
                        height: Size.smallIcon, width: Size.smallIcon, fit: BoxFit.cover),
                  ],
                ))
          ])),


      Container(
          decoration: ThemeStyle.boxDecoration,
          padding: ThemeStyle.padding,
          margin: ThemeStyle.margin,
          child: Column(children: <Widget>[
            Container(
                decoration: ThemeStyle.bottomDecoration,
                padding: EdgeInsets.only(bottom: Size.containerPadding),
                child: Row(
                  children: <Widget>[
                    Image.asset("lib/assets/images/icon-music.png",
                        height: Size.middleIcon, width: Size.middleIcon, fit: BoxFit.cover),
                    SizedBox(width: 10),
                    Text("音乐", style: TextStyle(fontSize: Size.middleFontSize)),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Image.asset("lib/assets/images/icon-arrow.png",
                        height: Size.smallIcon, width: Size.smallIcon, fit: BoxFit.cover),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(top: Size.containerPadding),
                child: Row(
                  children: <Widget>[
                    Image.asset("lib/assets/images/icon-app.png",
                        height: Size.middleIcon, width: Size.middleIcon, fit: BoxFit.cover),
                    SizedBox(width: 10),
                    Text("小程序", style: TextStyle(fontSize: Size.middleFontSize)),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Image.asset("lib/assets/images/icon-arrow.png",
                        height: Size.smallIcon, width: Size.smallIcon, fit: BoxFit.cover),
                  ],
                )),
          ]))
    ]);
  }
}
