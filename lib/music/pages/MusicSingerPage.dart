import 'package:flutter/material.dart';
import '../service/serverMethod.dart';
import '../../theme/ThemeStyle.dart';
import '../../theme/ThemeSize.dart';
import '../../theme/ThemeColors.dart';
import '../model/SingerCategoryModel.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import '../model/MusicAuthorModel.dart';
import '../../config/common.dart';

class MusicSingerPage extends StatefulWidget {
  MusicSingerPage({Key key}) : super(key: key);

  @override
  _MusicSingerPageState createState() => _MusicSingerPageState();
}

class _MusicSingerPageState extends State<MusicSingerPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  int activeIndex = 0; // 当前选中的分类
  int pageNum = 1; // 总页数
  int total = 0; // 总条数
  int pageSize = 20; // 每页条数
  List<MusicAuthorModel> musicAuthorList = [];
  List<SingerCategoryModel> singerCategoryList = []; // 播放记录列表

  @override
  void initState() {
    super.initState();
    getSingerCategoryService().then((res) {
      setState(() {
        (res["data"] as List).cast().forEach((item) {
          singerCategoryList.add(SingerCategoryModel.fromJson(item));
        });
      });
      useSingerList();
    });
  }

  ///@author: wuwenqiang
  ///@description: 根据分类获取列表
  ///@date: 2024-02-28 22:20
  useSingerList() {
    getSingerListService(
            singerCategoryList[activeIndex].category, pageNum, pageSize)
        .then((value) {
      setState(() {
        total = value["total"];
        (value["data"] as List).cast().forEach((item) {
          musicAuthorList.add(MusicAuthorModel.fromJson(item));
        });
      });
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
            child: EasyRefresh(
              footer: MaterialFooter(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: ThemeStyle.paddingBox,
                child: Column(
                    children: [buildCategory(), buildSingerListWidget()]),
              ),
              onLoad: () async {
                if (pageNum * pageSize < total) {
                  useSingerList();
                }
              },
            )));
  }

  ///@author: wuwenqiang
  ///@description: 歌手分类
  ///@date: 2024-02-28 22:20
  Widget buildCategory() {
    return Container(
        decoration: ThemeStyle.boxDecoration,
        margin: ThemeStyle.margin,
        width:
            MediaQuery.of(context).size.width - ThemeSize.containerPadding * 2,
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
    for (int i = 0; i < singerCategoryList.length; i++) {
      singerCategoryWidgetList.add(InkWell(
          onTap: () {
            setState(() {
              total = 0;
              pageNum = 1;
              activeIndex = i;
              musicAuthorList.clear();
              useSingerList();
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: singerCategoryList[activeIndex].category ==
                          singerCategoryList[i].category
                      ? Colors.orange
                      : ThemeColors.borderColor),
              borderRadius:
                  BorderRadius.all(Radius.circular(ThemeSize.middleRadius)),
            ),
            child: Center(
                child: Text(
              singerCategoryList[i].category,
              style: TextStyle(
                  color: singerCategoryList[activeIndex].category ==
                          singerCategoryList[i].category
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
  Widget buildSingerListWidget() {
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
          return Container(
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
                        : Image.asset("lib/assets/images/default-avater.png",
                            height: ThemeSize.middleAvater,
                            width: ThemeSize.middleAvater,
                            fit: BoxFit.cover),
                  ),
                  SizedBox(width: ThemeSize.containerPadding),
                  Column(
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
                  ),
                  Expanded(child: SizedBox(), flex: 1),
                  Image.asset("lib/assets/images/icon-music-play.png",
                      height: ThemeSize.smallIcon, width: ThemeSize.smallIcon),
                  SizedBox(width: ThemeSize.containerPadding),
                  Image.asset("lib/assets/images/icon-like.png",
                      height: ThemeSize.smallIcon, width: ThemeSize.smallIcon),
                  SizedBox(width: ThemeSize.containerPadding),
                  Image.asset("lib/assets/images/icon-music-menu.png",
                      height: ThemeSize.smallIcon, width: ThemeSize.smallIcon),
                ],
              ));
        }).toList()));
  }
}
