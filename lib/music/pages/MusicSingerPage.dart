import 'package:flutter/material.dart';
import '../service/serverMethod.dart';
import '../../theme/ThemeStyle.dart';
import '../../theme/ThemeSize.dart';
import '../../theme/ThemeColors.dart';
import '../model/SingerCategoryModel.dart';

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
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: ThemeStyle.paddingBox,
                child: Column(children: [
                  buildCategory(),
                ]),
              ),
            )));
  }

  Widget buildCategory() {
    return Container(
        decoration: ThemeStyle.boxDecoration,
        margin: ThemeStyle.margin,
        width:
            MediaQuery.of(context).size.width - ThemeSize.containerPadding * 2,
        padding: ThemeStyle.padding,
        child: GridView.count(
            mainAxisSpacing: ThemeSize.smallMargin,
            crossAxisSpacing: ThemeSize.smallMargin,
            //水平子 Widget 之间间距
            crossAxisCount: 4,
            //一行的 Widget 数量
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            childAspectRatio: 0.55,
            children: this.buildGridItems(context)));
  }

  List<Widget> buildGridItems(BuildContext context) {
    List<Widget> singerCategoryWidgetList = [];
    for (int i = 0; i < singerCategoryList.length; i++) {
      singerCategoryWidgetList.add(InkWell(
          onTap: () {
            setState(() {
              activeIndex = i;
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
            padding: EdgeInsets.only(
                top: ThemeSize.smallMargin, bottom: ThemeSize.smallMargin),
          )));
    }
    return singerCategoryWidgetList;
  }
}
