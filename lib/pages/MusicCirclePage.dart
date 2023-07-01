import 'package:flutter/material.dart';
import '../service/serverMethod.dart';
import '../model/CircleModel.dart';
import '../theme/ThemeStyle.dart';
import '../theme/ThemeSize.dart';
import '../theme/ThemeColors.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../config/serviceUrl.dart';
import '../utils/common.dart';

class MusicCirclePage extends StatefulWidget {
  MusicCirclePage({Key key}) : super(key: key);

  @override
  _MusicCirclePageState createState() => _MusicCirclePageState();
}

class _MusicCirclePageState extends State<MusicCirclePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  int pageNum = 1;
  int total = 0;
  final int pageSize = 10;
  final List<Widget> circleWidgeList = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
    getCircleListByTypeService();
  }

  void getCircleListByTypeService() {
    getCircleListByType('music', pageNum, pageSize).then((res) {
      setState(() {
        total = res["total"];
        (res["data"] as List).cast().forEach((item) {
          CircleModel circleModel = CircleModel.fromJson(item);
          circleWidgeList.add(buildCircleItem(circleModel, index));
          index++;
        });
      });
    });
  }

  Widget buildCircleItem(CircleModel circleModel, int index) {
    return Container(
      decoration: ThemeStyle.boxDecoration,
      margin: ThemeStyle.margin,
      width: MediaQuery.of(context).size.width - ThemeSize.containerPadding * 2,
      padding: ThemeStyle.padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
              child: Image.network(
            //从全局的provider中获取用户信息
            host + circleModel.useravater,
            height: ThemeSize.middleAvater,
            width: ThemeSize.middleAvater,
            fit: BoxFit.cover,
          )),
          SizedBox(width: ThemeSize.containerPadding),
          Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(circleModel.username,
                      style: TextStyle(
                          color: ThemeColors.activeColor,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: ThemeSize.smallMargin),
                  Text(circleModel.content,
                      softWrap: false,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: ThemeSize.containerPadding),
                  Container(
                    decoration: BoxDecoration(
                      color: ThemeColors.colorBg,
                      borderRadius: BorderRadius.all(Radius.circular(ThemeSize.minPlayIcon)),
                    ),
                    child: Row(children: [
                      ClipOval(
                          child: Image.network(
                            //从全局的provider中获取用户信息
                            host + circleModel.musicCover,
                            height: ThemeSize.minPlayIcon,
                            width: ThemeSize.minPlayIcon,
                            fit: BoxFit.cover,
                          )),
                      SizedBox(width: ThemeSize.containerPadding),
                      Column(children: [
                        Text(circleModel.musicSongName),
                        SizedBox(height: ThemeSize.smallMargin),
                        Text(circleModel.musicAuthorName,style: TextStyle(color: ThemeColors.disableColor))
                      ]),
                      Expanded(flex: 1,child: SizedBox()),
                      Image.asset("lib/assets/images/icon-music-play.png",width: ThemeSize.smallIcon,height: ThemeSize.smallIcon),
                      SizedBox(width: ThemeSize.minPlayIcon/3)
                    ],),
                  ),
                  SizedBox(height: ThemeSize.containerPadding),
                  Row(children: [
                    Text(formatTime(circleModel.createTime),style: TextStyle(color: ThemeColors.disableColor)),
                    Expanded(child: SizedBox(),flex: 1),
                    Image.asset("lib/assets/images/icon-music-menu.png",width: ThemeSize.smallIcon,
                        height: ThemeSize.smallIcon)
                  ])
                ],
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: EasyRefresh(
        footer: MaterialFooter(),
        onLoad: () async {
          pageNum++;
          if (total <= circleWidgeList.length) {
            Fluttertoast.showToast(
                msg: "已经到底了",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIos: 1,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                fontSize: ThemeSize.middleFontSize);
          } else {
            getCircleListByTypeService();
          }
        },
        child: Column(
          children: circleWidgeList,
        ),
      ),
    );
  }
}
