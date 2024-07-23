import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie/music/model/MusicClassifyModel.dart';
import 'package:movie/music/service/serverMethod.dart';
import 'dart:ui';
import '../../theme/ThemeStyle.dart';
import '../../theme/ThemeColors.dart';
import '../../theme/ThemeSize.dart';
import '../model/MusicModel.dart';
import '../../utils/common.dart';
import '../../common/constant.dart';

class MusicClassifyListPage extends StatefulWidget {
  final MusicClassifyModel musicClassifyModel;

  MusicClassifyListPage({Key key, this.musicClassifyModel}) : super(key: key);

  @override
  _MusicClassifyListPageState createState() => _MusicClassifyListPageState();
}

class _MusicClassifyListPageState extends State<MusicClassifyListPage>
    with TickerProviderStateMixin, RouteAware {
  EasyRefreshController easyRefreshController = EasyRefreshController();
  bool loading = false;
  int total = 0;
  int pageNum = 1;
  List<MusicModel> musicList = [];

  @override
  void initState() {
    useMusicList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeColors.colorBg,
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                buildTitleWidget(),
                Expanded(
                  flex: 1,
                  child: EasyRefresh(
                    controller: easyRefreshController,
                    footer:
                        total > pageNum * PAGE_SIZE ? MaterialFooter() : null,
                    onLoad: () async {
                      if (total > pageNum * PAGE_SIZE) {
                        pageNum++;
                        useMusicList();
                      } else {
                        // easyRefreshController
                        Fluttertoast.showToast(
                            msg: "已经到底了",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: ThemeSize.middleFontSize);
                      }
                    },
                    child: buildMusicListWidget(),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  ///@author: wuwenqiang
  ///@description: 创建头部按钮
  /// @date: 2024-07-13 17:33
  Widget buildTitleWidget() {
    return Container(
        padding: ThemeStyle.padding,
        decoration: BoxDecoration(color: ThemeColors.colorWhite),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          InkWell(
            child: Image.asset('lib/assets/images/icon_back.png',
                width: ThemeSize.smallIcon, height: ThemeSize.smallIcon),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Text(widget.musicClassifyModel.classifyName),
          SizedBox(width: ThemeSize.smallIcon)
        ]));
  }

  ///@author: wuwenqiang
  ///@description: 创建音乐模块
  /// @date: 2024-07-23 00:25
  Widget buildMusicListWidget() {
    List<Widget> musicListWidget = [];
    int index = -1;
    musicList.forEach((ele) {
      index++;
      musicListWidget.add(Row(children: [
        ele.cover != null
            ? ClipOval(
                child: Image.network(
                  //从全局的provider中获取用户信息
                  getMusicCover(ele.cover),
                  height: ThemeSize.middleAvater,
                  width: ThemeSize.middleAvater,
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                //从全局的provider中获取用户信息
                height: ThemeSize.middleAvater,
                width: ThemeSize.middleAvater,
                child: Center(
                    child: Image.asset(
                  'lib/assets/images/icon_music.png',
                  height: ThemeSize.smallIcon,
                  width: ThemeSize.smallIcon,
                  fit: BoxFit.cover,
                )),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(ThemeSize.middleAvater))),
              ),
        SizedBox(width: ThemeSize.containerPadding),
        Expanded(
          child: Text('${ele.authorName} - ${ele.songName}'),
          flex: 1,
        ),
        SizedBox(width: ThemeSize.containerPadding),
        Image.asset('lib/assets/images/icon_music_play.png',
            width: ThemeSize.smallIcon, height: ThemeSize.smallIcon),
        SizedBox(width: ThemeSize.containerPadding),
        Image.asset('lib/assets/images/icon_like.png',
            width: ThemeSize.smallIcon, height: ThemeSize.smallIcon),
        SizedBox(width: ThemeSize.containerPadding),
        Image.asset('lib/assets/images/icon_music_menu.png',
            width: ThemeSize.smallIcon, height: ThemeSize.smallIcon),
      ]));
      if (index != musicList.length - 1) {
        musicListWidget.add(Container(
          height: 1,
          decoration: BoxDecoration(color: ThemeColors.borderColor),
          margin: EdgeInsets.only(
              top: ThemeSize.containerPadding,
              bottom: ThemeSize.containerPadding),
        ));
      }
    });
    return Padding(
      padding: ThemeStyle.padding,
      child: Container(
          padding: ThemeStyle.padding,
          decoration: ThemeStyle.boxDecoration,
          child: Column(children: musicListWidget)),
    );
  }

  ///@author: wuwenqiang
  ///@description: 加载音乐列表
  /// @date: 2024-07-13 18:16
  void useMusicList() {
    getMusicListByClassifyIdService(
            widget.musicClassifyModel.id, pageNum, PAGE_SIZE, 1)
        .then((value) {
      setState(() {
        musicList
            .addAll(value.data.map((e) => MusicModel.fromJson(e)).toList());
        total = value.total;
      });
    });
  }
}
