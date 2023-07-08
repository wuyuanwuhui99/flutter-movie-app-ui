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
import '../model/CircleLikeModel.dart';
import '../model/CommentModel.dart';

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

  String getLikeUserName(List<CircleLikeModel> circleLikeModelList) {
    return circleLikeModelList.map((item) => item.username).toList().join(",");
  }

  // 音乐圈列表项渲染
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
                          color: ThemeColors.blueColor,
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
                      borderRadius: BorderRadius.all(
                          Radius.circular(ThemeSize.minPlayIcon)),
                    ),
                    child: Row(
                      children: [
                        ClipOval(
                            child: Image.network(
                          //从全局的provider中获取用户信息
                          host + circleModel.musicCover,
                          height: ThemeSize.bigAvater,
                          width: ThemeSize.bigAvater,
                          fit: BoxFit.cover,
                        )),
                        SizedBox(width: ThemeSize.containerPadding),
                        Column(children: [
                          Text(circleModel.musicSongName),
                          SizedBox(height: ThemeSize.smallMargin),
                          Text(circleModel.musicAuthorName,
                              style: TextStyle(color: ThemeColors.disableColor))
                        ]),
                        Expanded(flex: 1, child: SizedBox()),
                        Image.asset("lib/assets/images/icon-music-play.png",
                            width: ThemeSize.smallIcon,
                            height: ThemeSize.smallIcon),
                        SizedBox(width: ThemeSize.minPlayIcon / 3)
                      ],
                    ),
                  ),
                  SizedBox(height: ThemeSize.containerPadding),
                  Row(children: [
                    Text(formatTime(circleModel.createTime),
                        style: TextStyle(color: ThemeColors.disableColor)),
                    Expanded(child: SizedBox(), flex: 1),
                    Image.asset("lib/assets/images/icon-music-menu.png",
                        width: ThemeSize.smallIcon, height: ThemeSize.smallIcon)
                  ]),
                  SizedBox(
                      height: circleModel.circleLikes.length > 0
                          ? ThemeSize.containerPadding
                          : 0),
                  buildCircleLikeAndCommentList(circleModel)
                ],
              )),
        ],
      ),
    );
  }

  // 获取每条音乐圈点赞人员
  Widget buildCircleLikeAndCommentList(CircleModel circleModel) {
    List<CircleLikeModel> circleLikes = circleModel.circleLikes;
    List<CommentModel> circleComments = circleModel.circleComments;
    if (circleLikes.length > 0 || circleComments.length > 0) {
      return Container(
          padding: ThemeStyle.padding,
          decoration: BoxDecoration(
              color: ThemeColors.colorBg,
              borderRadius:
                  BorderRadius.all(Radius.circular(ThemeSize.middleRadius))),
          child: Column(children: [
            buildCircleLikeList(circleLikes),
            buildCircleCommentList(circleComments, circleLikes)
          ]));
    } else {
      return SizedBox();
    }
  }

  Widget buildCircleLikeList(List<CircleLikeModel> circleLikes) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset("lib/assets/images/icon-music-like.png",
            width: ThemeSize.smallIcon, height: ThemeSize.smallIcon),
        SizedBox(width: ThemeSize.smallMargin),
        Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [SizedBox(height: ThemeSize.miniMargin),Text(
                circleLikes.map((item) => item.username).toList().join("、"),
                style: TextStyle(color: ThemeColors.blueColor),
                softWrap: false,
                maxLines: 5,
                overflow: TextOverflow.ellipsis)],)
    )
      ],
    );
  }

  List<CommentModel> findSubCommentsByTopId(
      List<CommentModel> circleComments, id) {
    return circleComments.where((element) => element.parentId == id).toList();
  }

  // 评论
  Widget buildCircleCommentList(
      List<CommentModel> circleComments, List<CircleLikeModel> circleLikes) {
    if (circleComments.length > 0) {
      List<CommentModel> topComments =
          circleComments.where((element) => element.topId == null).toList();
      return Column(
          children: buildCircleCommentItems(topComments,circleComments, circleLikes,true));
    } else {
      return SizedBox();
    }
  }

  List<Widget> buildCircleCommentItems(
      List<CommentModel> circleComments,
      List<CommentModel> allCircleComments,
      List<CircleLikeModel> circleLikes,bool isTopComment) {
    if(circleComments.length == 0)return [];
    List<Widget> circleCommentWidget = [
      SizedBox(height: (circleLikes.length > 0 || !isTopComment) ? ThemeSize.containerPadding : 0)
    ];
    circleComments.forEach((circleComment) => {
          circleCommentWidget.add(Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            ClipOval(
                child: Image.network(
              //从全局的provider中获取用户信息
              host + circleComment.avater,
              height: isTopComment ? ThemeSize.middleAvater : ThemeSize.middleAvater/2,
              width: isTopComment ? ThemeSize.middleAvater : ThemeSize.middleAvater/2,
              fit: BoxFit.cover,
            )),
            SizedBox(width: ThemeSize.smallMargin),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(circleComment.replyUserName != null ? '${circleComment.username}▶${circleComment.replyUserName}' : circleComment.username,
                      style: TextStyle(color: ThemeColors.subTitle)),
                  SizedBox(height: ThemeSize.smallMargin),
                  Text(circleComment.content),
                  SizedBox(height: ThemeSize.smallMargin),
                  Text(formatTime(circleComment.createTime),style: TextStyle(color: ThemeColors.subTitle)),
                  ... buildCircleCommentItems(findSubCommentsByTopId(allCircleComments, circleComment.id),[],[],false)
                ])
          ]))
        });
    return circleCommentWidget;
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
