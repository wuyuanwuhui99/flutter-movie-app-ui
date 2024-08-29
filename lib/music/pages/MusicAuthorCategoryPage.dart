import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:movie/router/index.dart';
import '../service/serverMethod.dart';
import '../../theme/ThemeStyle.dart';
import '../../theme/ThemeSize.dart';
import '../../theme/ThemeColors.dart';
import '../model/MusicAuthorCategoryModel.dart';
import '../model/MusicAuthorModel.dart';
import '../../common/constant.dart';
import '../component/NavigatorTiitleComponent.dart';

class MusicAuthorCategoryPage extends StatefulWidget {
  MusicAuthorCategoryPage({Key key}) : super(key: key);

  @override
  _MusicAuthorCategoryPageState createState() => _MusicAuthorCategoryPageState();
}

class _MusicAuthorCategoryPageState extends State<MusicAuthorCategoryPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  int activeIndex = 0; // 当前选中的分类
  int pageNum = 1; // 总页数
  int total = 0; // 总条数
  List<MusicAuthorModel> musicAuthorList = [];
  List<MusicAuthorCategoryModel> authorCategoryList = []; // 播放记录列表
  EasyRefreshController easyRefreshController = EasyRefreshController();

  @override
  void initState() {
    super.initState();
    getMusicAuthorCategoryService().then((res) {
      setState(() {
        res.data.forEach((item) {
          authorCategoryList.add(MusicAuthorCategoryModel.fromJson(item));
        });
      });
      useMusicAuthorList();
    });
  }

  ///@author: wuwenqiang
  ///@description: 根据分类获取列表
  ///@date: 2024-02-28 22:20
  useMusicAuthorList() {
    getMusicAuthorListService(
            authorCategoryList[activeIndex].id, pageNum, PAGE_SIZE)
        .then((value) {
      setState(() {
        total = value.total;
        value.data.forEach((item) {
          musicAuthorList.add(MusicAuthorModel.fromJson(item));
        });
      });
      easyRefreshController.finishLoad(success: true,noMore: musicAuthorList.length == total);
    });
  }

  @override
  void dispose() {
    super.dispose();
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
                  NavigatorTiitleComponent(title: '歌手分类'),
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
                            if (pageNum * PAGE_SIZE < total) {
                              useMusicAuthorList();
                            }
                        },
                        child: Padding(
                          padding: ThemeStyle.padding,
                          child: Column(
                            children: [
                              buildCategory(),
                              buildAuthorListWidget()
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
        ));
  }

  ///@author: wuwenqiang
  ///@description: 歌手分类
  ///@date: 2024-02-28 22:20
  Widget buildCategory() {
    return Container(
        decoration: ThemeStyle.boxDecoration,
        margin: ThemeStyle.margin,
        width: double.infinity,
        padding: ThemeStyle.padding,
        child: GridView.count(
            mainAxisSpacing: ThemeSize.smallMargin,
            //水平子 Widget 之间间距
            crossAxisSpacing: ThemeSize.smallMargin,
            //一行的 Widget 数量
            crossAxisCount: 4,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            childAspectRatio: 3,
            // 宽高比列
            children: this.buildGridItems(context)));
  }

  List<Widget> buildGridItems(BuildContext context) {
    List<Widget> singerCategoryWidgetList = [];
    for (int i = 0; i < authorCategoryList.length; i++) {
      singerCategoryWidgetList.add(InkWell(
          onTap: () {
            setState(() {
              total = 0;
              pageNum = 1;
              activeIndex = i;
              musicAuthorList.clear();
              useMusicAuthorList();
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: authorCategoryList[activeIndex].id ==
                          authorCategoryList[i].id
                      ? Colors.orange
                      : ThemeColors.borderColor),
              borderRadius:
                  BorderRadius.all(Radius.circular(ThemeSize.middleRadius)),
            ),
            child: Center(
                child: Text(
              authorCategoryList[i].categoryName,
              style: TextStyle(
                  color: authorCategoryList[activeIndex].categoryName ==
                          authorCategoryList[i].categoryName
                      ? Colors.orange
                      : Colors.black),
            )),
          )));
    }
    return singerCategoryWidgetList;
  }

  ///@author: wuwenqiang
  ///@description: 歌手列表
  ///@date: 2024-02-28 22:20
  Widget buildAuthorListWidget() {
    int index = 0;
    return Container(
        decoration: ThemeStyle.boxDecoration,
        margin: ThemeStyle.margin,
        width:
            MediaQuery.of(context).size.width - ThemeSize.containerPadding * 2,
        padding: EdgeInsets.only(
            left: ThemeSize.containerPadding,
            right: ThemeSize.containerPadding,
            bottom: ThemeSize.containerPadding),
        child: Column(
            children: musicAuthorList.map((item) {
          index++;
          return
            InkWell(onTap: (){
              Routes.router.navigateTo(context, '/MusicAuthorListPage?authorModel=${Uri.encodeComponent(json.encode(item.toMap()))}');
            },child: Container(
                padding: EdgeInsets.only(
                    top: ThemeSize.containerPadding,
                    bottom: index == musicAuthorList.length
                        ? 0
                        : ThemeSize.containerPadding),
                decoration: index == musicAuthorList.length
                    ? null
                    : BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                          width: 1, //宽度
                          color: ThemeColors.colorBg, //边框颜色
                        ))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: item.avatar != null && item.avatar != ""
                          ? Image.network(
                        //从全局的provider中获取用户信息
                        item.avatar.indexOf("http") != -1
                            ? item.avatar.replaceAll("{size}", "480")
                            : HOST + item.avatar,
                        height: ThemeSize.middleAvater,
                        width: ThemeSize.middleAvater,
                        fit: BoxFit.cover,
                      )
                          : Image.asset("lib/assets/images/default_avater.png",
                          height: ThemeSize.middleAvater,
                          width: ThemeSize.middleAvater,
                          fit: BoxFit.cover),
                    ),
                    SizedBox(width: ThemeSize.containerPadding),
                    Expanded(flex: 1,child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.authorName),
                        SizedBox(height: ThemeSize.miniMargin),
                        Text(
                          "${item.total.toString()}首",
                          style: TextStyle(
                              color: ThemeColors.disableColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                    Image.asset("lib/assets/images/icon_music_play.png",
                        height: ThemeSize.smallIcon, width: ThemeSize.smallIcon),
                    SizedBox(width: ThemeSize.containerPadding),
                    Image.asset("lib/assets/images/icon_like.png",
                        height: ThemeSize.smallIcon, width: ThemeSize.smallIcon),
                    SizedBox(width: ThemeSize.containerPadding),
                    Image.asset("lib/assets/images/icon_music_menu.png",
                        height: ThemeSize.smallIcon, width: ThemeSize.smallIcon),
                  ],
                )),);
        }).toList()));
  }
}
