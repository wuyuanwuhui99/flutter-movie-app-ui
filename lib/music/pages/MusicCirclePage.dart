import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../model/CircleModel.dart';
import '../../theme/ThemeStyle.dart';
import '../../theme/ThemeSize.dart';
import '../../theme/ThemeColors.dart';
import '../../config/common.dart';
import '../../utils/common.dart';
import '../model/CircleLikeModel.dart';
import '../../movie/model/CommentModel.dart';
import '../service/serverMethod.dart';

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
  OverlayEntry overlayEntry;

  @override
  void initState() {
    super.initState();
    getCircleWidgetListByType();
  }

  void getCircleWidgetListByType() {
    getCircleListByTypeService('music', pageNum, pageSize).then((res) {
      setState(() {
        total = res.total;
        res.data.forEach((item) {
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

  ///@author: wuwenqiang
  ///@description: 点击点赞和评论的弹出图标
  /// @date: 2024-03-27 00:35
  onTapMenu(CircleModel circleModel) {
    if (overlayEntry != null) {
      overlayEntry.remove();
    }
    overlayEntry = new OverlayEntry(builder: (context) {
      RenderBox renderBox = circleModel.key.currentContext?.findRenderObject();
      //获取当前屏幕位置
      Offset offset = renderBox.localToGlobal(Offset.zero);
      return Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {},
            child: Stack(
              children: [
                Positioned(
                    top: offset.dy - ThemeSize.smallIcon / 2,
                    left: offset.dx -
                        ThemeSize.menuWidth -
                        ThemeSize.smallMargin,
                    child: buildLikeMenu())
              ],
            ),
          ));
    });

    //插入到 Overlay中显示 OverlayEntry
    Overlay.of(context).insert(overlayEntry);
  }

  ///@author: wuwenqiang
  ///@description: 创建弹出点赞和评论选项框
  /// @date: 2024-03-27 00:35
  Widget buildLikeMenu() {
    return Container(
      width: ThemeSize.menuWidth,
      height: ThemeSize.menuHeight,
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(ThemeSize.middleRadius)),
          color: ThemeColors.subTitle),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 1,
              child: Padding(
                  padding: EdgeInsets.only(
                      top: ThemeSize.smallMargin,
                      bottom: ThemeSize.smallMargin),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/assets/images/icon_like_white.png',
                        width: ThemeSize.smallIcon,
                        height: ThemeSize.smallIcon,
                      ),
                      SizedBox(width: ThemeSize.smallMargin),
                      Text(
                        '赞',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: ThemeSize.smallFontSize,
                            color: ThemeColors.colorWhite,
                            fontWeight: FontWeight.normal),
                      )
                    ],
                  ))),
          Expanded(
              flex: 1,
              child: Padding(
                  padding: EdgeInsets.only(
                      top: ThemeSize.smallMargin,
                      bottom: ThemeSize.smallMargin),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/assets/images/icon_comment_white.png',
                        width: ThemeSize.smallIcon,
                        height: ThemeSize.smallIcon,
                      ),
                      SizedBox(width: ThemeSize.smallMargin),
                      Text(
                        '评论',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: ThemeSize.smallFontSize,
                            color: ThemeColors.colorWhite,
                            fontWeight: FontWeight.normal),
                      )
                    ],
                  )))
        ],
      ),
    );
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
            HOST + circleModel.useravater,
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
                          HOST + circleModel.musicCover,
                          height: ThemeSize.middleAvater,
                          width: ThemeSize.middleAvater,
                          fit: BoxFit.cover,
                        )),
                        SizedBox(width: ThemeSize.containerPadding),
                        Text(
                            '${circleModel.musicSongName} - ${circleModel.musicAuthorName}'),
                        Expanded(flex: 1, child: SizedBox()),
                        Image.asset("lib/assets/images/icon-music-play.png",
                            width: ThemeSize.smallIcon,
                            height: ThemeSize.smallIcon),
                        SizedBox(width: ThemeSize.containerPadding),
                      ],
                    ),
                  ),
                  SizedBox(height: ThemeSize.containerPadding),
                  Row(children: [
                    Text(formatTime(circleModel.createTime),
                        style: TextStyle(color: ThemeColors.disableColor)),
                    Expanded(child: SizedBox(), flex: 1),
                    InkWell(
                      key: circleModel.key,
                      child: Image.asset(
                          "lib/assets/images/icon-music-menu.png",
                          width: ThemeSize.smallIcon,
                          height: ThemeSize.smallIcon),
                      onTap: () {
                        onTapMenu(circleModel);
                      },
                    )
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
              children: [
                SizedBox(height: ThemeSize.miniMargin),
                Text(
                    circleLikes.map((item) => item.username).toList().join("、"),
                    style: TextStyle(color: ThemeColors.blueColor),
                    softWrap: false,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis)
              ],
            ))
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
          children: buildCircleCommentItems(
              topComments, circleComments, circleLikes, true));
    } else {
      return SizedBox();
    }
  }

  List<Widget> buildCircleCommentItems(
      List<CommentModel> circleComments,
      List<CommentModel> allCircleComments,
      List<CircleLikeModel> circleLikes,
      bool isTopComment) {
    if (circleComments.length == 0) return [];
    List<Widget> circleCommentWidget = [
      SizedBox(
          height: (circleLikes.length > 0 || !isTopComment)
              ? ThemeSize.containerPadding
              : 0)
    ];
    circleComments.forEach((circleComment) => {
          circleCommentWidget
              .add(Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipOval(
                child: Image.network(
              //从全局的provider中获取用户信息
              HOST + circleComment.avater,
              height: isTopComment
                  ? ThemeSize.middleAvater
                  : ThemeSize.middleAvater / 2,
              width: isTopComment
                  ? ThemeSize.middleAvater
                  : ThemeSize.middleAvater / 2,
              fit: BoxFit.cover,
            )),
            SizedBox(width: ThemeSize.smallMargin),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      circleComment.replyUserName != null
                          ? '${circleComment.username}▶${circleComment.replyUserName}'
                          : circleComment.username,
                      style: TextStyle(color: ThemeColors.subTitle)),
                  SizedBox(height: ThemeSize.smallMargin),
                  Text(circleComment.content),
                  SizedBox(height: ThemeSize.smallMargin),
                  Text(formatTime(circleComment.createTime),
                      style: TextStyle(color: ThemeColors.subTitle)),
                  ...buildCircleCommentItems(
                      findSubCommentsByTopId(
                          allCircleComments, circleComment.id),
                      [],
                      [],
                      false)
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
            getCircleWidgetListByType();
          }
        },
        child: Column(
          children: circleWidgeList,
        ),
      ),
    );
  }
}
