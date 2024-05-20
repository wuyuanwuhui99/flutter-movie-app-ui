import 'dart:math';
import 'package:flutter/material.dart';
import 'package:movie/router/index.dart';
import 'package:provider/provider.dart';
import '../service/serverMethod.dart';
import '../provider/UserInfoProvider.dart';
import '../component/MovieListComponent.dart';
import '../component/AvaterComponent.dart';
import '../model/UserInfoModel.dart';
import '../model/UserMsgModel.dart';
import '../../theme/ThemeStyle.dart';
import '../../theme/ThemeSize.dart';
import '../../theme/ThemeColors.dart';
import '../model/MovieDetailModel.dart';
import 'WebViewPage.dart';

class MovieMyPage extends StatefulWidget {
  MovieMyPage({Key key}) : super(key: key);

  @override
  _MovieMyPageState createState() => _MovieMyPageState();
}

class _MovieMyPageState extends State<MovieMyPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  bool isExpandPlayRecord = true; // 是否展开播放记录，默认展开
  bool isExpandMyFavorite = false; // 是否展开我的收藏
  bool isExpandMyView = false;// 是否展开我的电影

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
          buildUserMsgWidget(),
          buildPlayRecordWidget(),
          buildMyFavoriteWidget(),
          buildMyViewWidget(),
          buildPannelWidget()
        ],
      ),
    );
  }

  ///@author: wuwenqiang
  ///@description: 用户数据，使用天数，观看记录等
  /// @date: 2024-05-20 22:49
  Widget buildUserMsgWidget(){
    return FutureBuilder(
        future: getUserMsgService(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          } else {
            UserMsgModel userMsg = UserMsgModel.fromJson(snapshot.data.data);
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

  ///@author: wuwenqiang
  ///@description: 播放记录
  /// @date: 2024-05-20 22:49
  Widget buildPlayRecordWidget(){
    return Container(
        decoration: ThemeStyle.boxDecoration,
        margin: ThemeStyle.margin,
        child: Column(children: <Widget>[
          Container(child: Row(
            children: <Widget>[
              Image.asset("lib/assets/images/icon_play_record.png",
                  height: ThemeSize.middleIcon,
                  width: ThemeSize.middleIcon,
                  fit: BoxFit.cover),
              SizedBox(width: ThemeSize.smallMargin),
              Text("观看记录",
                  style: TextStyle(fontSize: ThemeSize.middleFontSize)),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              InkWell(
                child: Transform.rotate(
                    angle: (isExpandPlayRecord ? 90 : 0) * pi / 180,
                    child: Image.asset("lib/assets/images/icon-arrow.png",
                        height: ThemeSize.smallIcon,
                        width: ThemeSize.smallIcon,
                        fit: BoxFit.cover)),
                onTap: () {
                  setState(() {
                    isExpandPlayRecord = !isExpandPlayRecord;
                  });
                },
              ),
            ],
          ),padding: ThemeStyle.padding),
          isExpandPlayRecord ? Column(children: [
            Divider(height: 1,color:ThemeColors.borderColor),
            FutureBuilder(
                future: getPlayRecordService(1,20),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return SizedBox();
                  } else {
                    List<MovieDetailModel> movieList = [];
                    snapshot.data.data.forEach((item) {
                      movieList.add(MovieDetailModel.fromJson(item));
                    });
                    if (movieList.length == 0) {
                      return Container(
                          alignment: Alignment.center,
                          height: ThemeSize.movieHeight / 3,
                          child: Text("暂无收藏"));
                    } else {
                      return Container(
                        padding: EdgeInsets.only(top: ThemeSize.containerPadding),
                        child: MovieListComponent(
                            movieList: movieList, direction: "horizontal"),
                      );
                    }
                  }
                })
          ],) : SizedBox()
        ]));
  }

  ///@author: wuwenqiang
  ///@description: 我的收藏
  /// @date: 2024-05-20 22:49
  Widget buildMyFavoriteWidget() {
    return Container(
        decoration: ThemeStyle.boxDecoration,
        margin: ThemeStyle.margin,
        child: Column(children: <Widget>[
          Container(child: Row(
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
              InkWell(
                child: Transform.rotate(
                    angle: (isExpandMyFavorite ? 90 : 0) * pi / 180,
                    child: Image.asset("lib/assets/images/icon-arrow.png",
                        height: ThemeSize.smallIcon,
                        width: ThemeSize.smallIcon,
                        fit: BoxFit.cover)),
                onTap: () {
                  setState(() {
                    isExpandMyFavorite = !isExpandMyFavorite;
                  });
                },
              ),
            ],
          ),padding: ThemeStyle.padding),
          isExpandMyFavorite ? Column(children: [
            Divider(height: 1,color:ThemeColors.borderColor),
            FutureBuilder(
                future: getFavoriteService(1,20),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return SizedBox();
                  } else {
                    List<MovieDetailModel> movieList = [];
                    snapshot.data.data.forEach((item) {
                      movieList.add(MovieDetailModel.fromJson(item));
                    });
                    if (movieList.length == 0) {
                      return Container(
                          alignment: Alignment.center,
                          height: ThemeSize.movieHeight / 3,
                          child: Text("暂无收藏"));
                    } else {
                      return Container(
                        padding: EdgeInsets.only(top: ThemeSize.containerPadding),
                        child: MovieListComponent(
                            movieList: movieList, direction: "horizontal"),
                      );
                    }
                  }
                })
          ],) : SizedBox()
        ]));
  }

  ///@author: wuwenqiang
  ///@description: 我的收藏
  /// @date: 2024-05-20 22:49
  Widget buildMyViewWidget() {
    return Container(
        decoration: ThemeStyle.boxDecoration,
        margin: ThemeStyle.margin,
        child: Column(children: <Widget>[
          Container(child:
          Row(
            children: <Widget>[
              Image.asset("lib/assets/images/icon-collection.png",
                  height: ThemeSize.middleIcon,
                  width: ThemeSize.middleIcon,
                  fit: BoxFit.cover),
              SizedBox(width: ThemeSize.smallMargin),
              Text("我浏览的电影",
                  style: TextStyle(fontSize: ThemeSize.middleFontSize)),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              InkWell(
                child: Transform.rotate(
                    angle: (isExpandMyView ? 90 : 0) * pi / 180,
                    child: Image.asset("lib/assets/images/icon-arrow.png",
                        height: ThemeSize.smallIcon,
                        width: ThemeSize.smallIcon,
                        fit: BoxFit.cover)),
                onTap: () {
                  setState(() {
                    isExpandMyView = !isExpandMyView;
                  });
                },
              ),
            ],
          ),padding: ThemeStyle.padding),
          isExpandMyView ? Column(children: [
            Divider(height: 1,color:ThemeColors.borderColor),
            FutureBuilder(
                future: getViewRecordService(1,20),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return SizedBox();
                  } else {
                    List<MovieDetailModel> movieList = [];
                    snapshot.data.data.forEach((item) {
                      movieList.add(MovieDetailModel.fromJson(item));
                    });
                    if (movieList.length == 0) {
                      return Container(
                          alignment: Alignment.center,
                          height: ThemeSize.movieHeight / 3,
                          child: Text("暂无浏览记录"));
                    } else {
                      return Container(
                        padding: EdgeInsets.only(top: ThemeSize.containerPadding),
                        child: MovieListComponent(
                            movieList: movieList, direction: "horizontal"),
                      );
                    }
                  }
                })
          ],) : SizedBox()
        ]));
  }

  ///@author: wuwenqiang
  ///@description: 我的收藏
  /// @date: 2024-05-20 22:49
  Widget buildPannelWidget() {
    return Container(
        decoration: ThemeStyle.boxDecoration,
        padding: ThemeStyle.padding,
        margin: ThemeStyle.margin,
        child: Column(children: <Widget>[
          Container(
              decoration: ThemeStyle.bottomDecoration,
              padding: EdgeInsets.only(bottom: ThemeSize.containerPadding),
              child: InkWell(
                  onTap: () {
                    Routes.router.navigateTo(context, '/MusicIndexPage');
                  },
                  child: Row(
                    children: <Widget>[
                      Image.asset("lib/assets/images/icon-music.png",
                          height: ThemeSize.middleIcon,
                          width: ThemeSize.middleIcon,
                          fit: BoxFit.cover),
                      SizedBox(width: 10),
                      Text("音乐",
                          style:
                          TextStyle(fontSize: ThemeSize.middleFontSize)),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Image.asset("lib/assets/images/icon-arrow.png",
                          height: ThemeSize.smallIcon,
                          width: ThemeSize.smallIcon,
                          fit: BoxFit.cover),
                    ],
                  ))),
          Container(
              decoration: ThemeStyle.bottomDecoration,
              padding: EdgeInsets.only(bottom: ThemeSize.containerPadding,top: ThemeSize.containerPadding),
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewPage(
                                url: "http://192.168.0.103:3003/#/?_t=" +
                                    DateTime.now()
                                        .microsecondsSinceEpoch
                                        .toString(),
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
                  ))),
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
              ))
        ]));
  }
}
