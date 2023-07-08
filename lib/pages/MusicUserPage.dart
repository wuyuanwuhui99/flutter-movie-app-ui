import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/serverMethod.dart';
import '../provider/UserInfoProvider.dart';
import '../model/UserInfoModel.dart';
import '../theme/ThemeStyle.dart';
import '../theme/ThemeSize.dart';
import '../theme/ThemeColors.dart';
import '../config/serviceUrl.dart';
import '../model/MuiscPlayMenuModel.dart';

class MusicUserPage extends StatefulWidget {
  MusicUserPage({Key key}) : super(key: key);

  @override
  _MusicUserPageState createState() => _MusicUserPageState();
}

class _MusicUserPageState extends State<MusicUserPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Column(children: [buildUserInfoWidget(), buildMenuWidget(),buildMyPlaylMenuWidget()]);
  }

  // 用户模块
  Widget buildUserInfoWidget() {
    UserInfoModel userInfo = Provider.of<UserInfoProvider>(context).userInfo;
    return Container(
      decoration: ThemeStyle.boxDecoration,
      margin: ThemeStyle.margin,
      width: MediaQuery.of(context).size.width - ThemeSize.containerPadding * 2,
      padding: ThemeStyle.padding,
      child: Row(
        children: [
          ClipOval(
              child: Image.network(
            //从全局的provider中获取用户信息
            host + userInfo.avater,
            height: ThemeSize.bigAvater,
            width: ThemeSize.bigAvater,
            fit: BoxFit.cover,
          )),
          SizedBox(width: ThemeSize.containerPadding),
          Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userInfo.username,
                      style: TextStyle(fontSize: ThemeSize.bigFontSize)),
                  SizedBox(height: ThemeSize.smallMargin),
                  Text(userInfo.sign,
                      style: TextStyle(color: ThemeColors.subTitle))
                ],
              )),
          Image.asset("lib/assets/images/icon_edit.png",
              width: ThemeSize.middleIcon, height: ThemeSize.middleIcon)
        ],
      ),
    );
  }

  Widget buildMenuWidget() {
    return Container(
        decoration: ThemeStyle.boxDecoration,
        margin: ThemeStyle.margin,
        width:
            MediaQuery.of(context).size.width - ThemeSize.containerPadding * 2,
        padding: ThemeStyle.padding,
        child: Row(
          children: [
            Expanded(
                child: Column(
                  children: [
                    Image.asset("lib/assets/images/icon-menu-board.png",
                        width: ThemeSize.middleIcon,
                        height: ThemeSize.middleIcon),
                    SizedBox(height: ThemeSize.smallMargin),
                    Text("歌单")
                  ],
                ),
                flex: 1),
            Expanded(
                child: Column(
                  children: [
                    Image.asset("lib/assets/images/icon-menu-like.png",
                        width: ThemeSize.middleIcon,
                        height: ThemeSize.middleIcon),
                    SizedBox(height: ThemeSize.smallMargin),
                    Text("喜欢")
                  ],
                ),
                flex: 1),
            Expanded(
                child: Column(
                  children: [
                    Image.asset("lib/assets/images/icon-menu-collect.png",
                        width: ThemeSize.middleIcon,
                        height: ThemeSize.middleIcon),
                    SizedBox(height: ThemeSize.smallMargin),
                    Text("收藏")
                  ],
                ),
                flex: 1),
            Expanded(
                child: Column(
                  children: [
                    Image.asset("lib/assets/images/icon-menu-history.png",
                        width: ThemeSize.middleIcon,
                        height: ThemeSize.middleIcon),
                    SizedBox(height: ThemeSize.smallMargin),
                    Text("收藏")
                  ],
                ),
                flex: 1),
          ],
        ));
  }

  Widget buildMyPlaylMenuWidget() {
    return Container(
        decoration: ThemeStyle.boxDecoration,
        margin: ThemeStyle.margin,
        width:
        MediaQuery.of(context).size.width - ThemeSize.containerPadding * 2,
    padding: ThemeStyle.padding,
    child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("lib/assets/images/icon-down.png",
                width: ThemeSize.smallIcon, height: ThemeSize.smallIcon),
            SizedBox(width: ThemeSize.smallMargin),
            Text("我的歌单"),
            Expanded(child: SizedBox(), flex: 1),
            Image.asset("lib/assets/images/icon-menu-add.png",
                width: ThemeSize.smallIcon, height: ThemeSize.smallIcon),
          ],
        ),
        FutureBuilder(
            future: getMusicPlayMenu(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container();
              } else {
                List<Widget> playMenuList = [];
                (snapshot.data["data"] as List).cast().forEach((item) {
                  MuiscPlayMenuModel muiscPlayMenuModel = MuiscPlayMenuModel.fromJson(item);
                  playMenuList.add(buildPlayMenuItem(muiscPlayMenuModel));
                });
                if (playMenuList.length == 0) {
                  return Container();
                }else{
                  return Column(children: playMenuList);
                }
              }
            })
      ],
    ));
  }

  // 创建我的歌单item
  Widget buildPlayMenuItem(MuiscPlayMenuModel muiscPlayMenuModel){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        SizedBox(height: ThemeSize.containerPadding),
        Row(children: [
          ClipOval(child: Image.network(host+muiscPlayMenuModel.cover,
            width: ThemeSize.bigAvater,
            height: ThemeSize.bigAvater,
            )),
          SizedBox(width: ThemeSize.containerPadding),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(muiscPlayMenuModel.name),
              SizedBox(height: ThemeSize.smallMargin),
              Text(muiscPlayMenuModel.total.toString()+"首",style: TextStyle(color: ThemeColors.subTitle))
            ],),flex: 1,),
          Image.asset(
            "lib/assets/images/icon-music-play.png",
            width: ThemeSize.smallIcon,
            height: ThemeSize.smallIcon,
          ),
          SizedBox(width: ThemeSize.containerPadding*2),
          Image.asset(
            "lib/assets/images/icon-delete.png",
            width: ThemeSize.smallIcon,
            height: ThemeSize.smallIcon,
          ),
          SizedBox(width: ThemeSize.containerPadding*2),
          Image.asset(
            "lib/assets/images/icon-music-menu.png",
            width: ThemeSize.smallIcon,
            height: ThemeSize.smallIcon,
          )
        ],)
    ]);
  }
}
