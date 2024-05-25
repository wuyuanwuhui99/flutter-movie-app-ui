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
import '../../movie/service/serverMethod.dart';
import '../../movie/provider/UserInfoProvider.dart';
import 'package:provider/provider.dart';

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
  final List<CircleModel> circleList = [];
  OverlayEntry circleOverlayEntry; // 点赞和评论选项的弹窗
  OverlayEntry inputOverlayEntry; // 评论输入框的弹窗
  CircleModel circleModel; // 当前操作的那条点赞和评论框
  TextEditingController inputController =
      new TextEditingController(); // 评论框的控制条
  CommentModel firstCommentModel;// 一级评论
  CommentModel replyCommentModel;// 回复的评论
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getCircleWidgetListByType();
  }

  @override
  void dispose() {
    if (circleOverlayEntry != null) {
      circleOverlayEntry.remove();
      circleOverlayEntry = null;
    }
    if (inputOverlayEntry != null) {
      inputOverlayEntry.remove();
      inputOverlayEntry = null;
    }
  }

  ///@author: wuwenqiang
  ///@description: 获取朋友圈动态
  /// @date: 2024-03-27 00:35
  void getCircleWidgetListByType() {
    getCircleListByTypeService('music', pageNum, pageSize).then((res) {
      setState(() {
        total = res.total;
        res.data.forEach((item) {
          circleList.add(CircleModel.fromJson(item));
        });
      });
    });
  }

  ///@author: wuwenqiang
  ///@description: 获取点赞用户
  /// @date: 2024-03-27 00:35
  String getLikeUserName(List<CircleLikeModel> circleLikeModelList) {
    return circleLikeModelList.map((item) => item.username).toList().join(",");
  }

  ///@author: wuwenqiang
  ///@description: 点击点赞和评论的弹出图标
  /// @date: 2024-03-27 00:35
  onTapMenu(CircleModel mCircleModel) {
    circleModel = mCircleModel;
    if (circleOverlayEntry != null) {
      circleOverlayEntry.remove();
    }
    circleOverlayEntry = new OverlayEntry(builder: (context) {
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
                    left:
                        offset.dx - ThemeSize.menuWidth - ThemeSize.smallMargin,
                    child: buildMenu())
              ],
            ),
          ));
    });

    //插入到 Overlay中显示 OverlayEntry
    Overlay.of(context).insert(circleOverlayEntry);
  }

  ///@author: wuwenqiang
  ///@description: 创建评论框的弹窗
  /// @date: 2024-03-30 10:03
  void buildCommentInputDailog() {
    if (circleOverlayEntry != null) {
      circleOverlayEntry.remove();
      circleOverlayEntry = null;
    }
    if (inputOverlayEntry != null) return; // 如果评论框弹窗已经存在，点击其他想回复的评论，不在创建评论框弹窗
    inputOverlayEntry = new OverlayEntry(builder: (BuildContext context) {
      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
            decoration: BoxDecoration(color: ThemeColors.colorWhite),
            padding: ThemeStyle.padding,
            child: Row(children: [
              Expanded(
                  flex: 1,
                  child: Material(
                      child: Container(
                          height: ThemeSize.middleAvater,
                          child: TextField(
                              controller: inputController,
                              cursorColor: Colors.grey, //设置光标
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: ThemeColors.colorBg,
                                hintText:
                                replyCommentModel != null ? "回复${replyCommentModel.username}"
                                    : (firstCommentModel != null ? "回复${firstCommentModel.username}" : "评论"),
                                hintStyle: TextStyle(
                                    fontSize: ThemeSize.smallFontSize,
                                    color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(
                                      ThemeSize.middleAvater), // 圆角的大小
                                ),
                                contentPadding: EdgeInsets.only(
                                    left: ThemeSize.smallMargin),
                              ))))),
              SizedBox(width: ThemeSize.containerPadding),
              Container(
                height: ThemeSize.middleAvater,
                child: RaisedButton(
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    if(loading)return;
                    loading = true;
                    CommentModel mCommentModel = CommentModel(
                        type:"music_circle",
                        relationId:circleModel.id,
                        content: inputController.text,
                        topId:firstCommentModel != null ? firstCommentModel.id : null,
                        parentId:replyCommentModel != null ? replyCommentModel.id : null
                    );
                    insertCommentService(mCommentModel.toMap()).then((value){
                      loading = false;
                      setState(() {
                        if(firstCommentModel != null){
                            firstCommentModel.replyList.add(CommentModel.fromJson(value.data));
;                        }else{
                            circleModel.circleComments.add(CommentModel.fromJson(value.data));
                        }
                      });
                      firstCommentModel = replyCommentModel = null;
                      inputOverlayEntry.remove();
                      inputOverlayEntry = null;
                      inputController.text = "";
                    });
                  },
                  child: Text(
                    '发送',
                    style: TextStyle(
                        fontSize: ThemeSize.middleFontSize,
                        color: Colors.white),
                  ),

                  ///圆角
                  shape: RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: BorderRadius.all(
                          Radius.circular(ThemeSize.bigRadius))),
                ),
              )
            ])),
      );
    });

    //插入到 Overlay中显示 OverlayEntry
    Overlay.of(context).insert(inputOverlayEntry);
  }

  ///@author: wuwenqiang
  ///@description: 创建弹出点赞和评论选项框
  /// @date: 2024-03-27 00:35
  Widget buildMenu() {
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
          buildLikeMenu(), // 创建点赞选项
          buildCommentMenu() // 创建评论选项
        ],
      ),
    );
  }

  ///@author: wuwenqiang
  ///@description: 创建弹出点赞选项
  /// @date: 2024-03-30 10:29
  Widget buildLikeMenu() {
    int circleIndex =
        circleModel.circleLikes.indexWhere((CircleLikeModel element) {
      return element.userId ==
          Provider.of<UserInfoProvider>(context).userInfo.userId;
    });
    bool loading = false;
    return Expanded(
        flex: 1,
        child: GestureDetector(
            onTap: () {
              if (loading) return;
              if (circleIndex == -1) {
                // 如果已经赞过，点击之后取消点赞
                CircleLikeModel likeMode = CircleLikeModel(
                    type: 'music_circle', relationId: circleModel.id);
                saveLikeService(likeMode).then((res) {
                  setState(() {
                    circleModel.circleLikes
                        .add(CircleLikeModel.fromJson(res.data));
                  });
                  // 移除点赞和评论的弹窗
                  circleOverlayEntry.remove();
                  circleOverlayEntry = null;
                  loading = false;
                }).onError((error, stackTrace) {
                  // 移除点赞和评论的弹窗
                  circleOverlayEntry.remove();
                  circleOverlayEntry = null;
                  loading = false;
                });
              } else {
                // 如果已经赞过，点击之后取消点赞
                deleteLikeService(circleModel.id, "music_circle").then((res) {
                  setState(() {
                    circleModel.circleLikes.removeAt(circleIndex);
                  });
                  // 移除点赞和评论的弹窗
                  circleOverlayEntry.remove();
                  circleOverlayEntry = null;
                  loading = false;
                }).onError((error, stackTrace) {
                  loading = false;
                });
              }
            },
            child: Padding(
                padding: EdgeInsets.only(
                    top: ThemeSize.smallMargin, bottom: ThemeSize.smallMargin),
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
                      circleIndex != -1 ? '取消赞' : '赞',
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: ThemeSize.smallFontSize,
                          color: ThemeColors.colorWhite,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                ))));
  }

  ///@author: wuwenqiang
  ///@description: 创建弹出评论选项
  /// @date: 2024-03-30 10:29
  Widget buildCommentMenu() {
    return Expanded(
        flex: 1,
        child: GestureDetector(
            onTap: buildCommentInputDailog, // 显示评论框的弹窗
            child: Padding(
                padding: EdgeInsets.only(
                    top: ThemeSize.smallMargin, bottom: ThemeSize.smallMargin),
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
                ))));
  }

  // 音乐圈列表项渲染
  List<Widget> buildCircleList() {
    return circleList.map((CircleModel circleModel) {
      return Container(
        decoration: ThemeStyle.boxDecoration,
        margin: ThemeStyle.margin,
        width:
            MediaQuery.of(context).size.width - ThemeSize.containerPadding * 2,
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
    }).toList();
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
    if (circleComments.length > 0 || circleLikes.length > 0) {
      List<CommentModel> topComments =
          circleComments.where((element) => element.topId == null).toList();
      return Column(
          children: buildCircleCommentItems(
              topComments, circleLikes));
    } else {
      return SizedBox();
    }
  }

  List<Widget> buildCircleCommentItems(
      List<CommentModel> circleComments,
      List<CircleLikeModel> circleLikes) {
    if (circleComments.length == 0) return [];
    List<Widget> circleCommentWidget = [
      SizedBox(
          height: (circleLikes.length > 0 || replyCommentModel != null)
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
              height: replyCommentModel == null
                  ? ThemeSize.middleAvater
                  : ThemeSize.middleAvater / 2,
              width: replyCommentModel == null
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
                  GestureDetector(
                    child: Text(circleComment.content),
                    onTap: () {
                      setState(() {
                        if(circleComment.topId == null){// 如果不是二级评论
                          replyCommentModel = firstCommentModel = circleComment;
                        }else{// 如果是二级评论
                          replyCommentModel = circleComment;
                          firstCommentModel = circleModel.circleComments.firstWhere((element) => element.id == replyCommentModel.topId);
                        }
                        buildCommentInputDailog();
                      });
                    },
                  ),
                  SizedBox(height: ThemeSize.smallMargin),
                  Text(formatTime(circleComment.createTime),
                      style: TextStyle(color: ThemeColors.subTitle)),
                  SizedBox(height: ThemeSize.smallMargin),
                  ...buildCircleCommentItems(
                      circleComment.replyList,
                      [])
                ])
          ]))
        });
    return circleCommentWidget;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (circleOverlayEntry != null) {
            circleOverlayEntry.remove();
            circleOverlayEntry = null;
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: EasyRefresh(
            footer: MaterialFooter(),
            onLoad: () async {
              pageNum++;
              if (circleOverlayEntry != null) circleOverlayEntry.remove();
              if (total <= circleList.length) {
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
              children: buildCircleList(),
            ),
          ),
        ));
  }
}
