import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie/theme/ThemeStyle.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../component/ScoreComponent.dart';
import '../service/serverMethod.dart';
import '../component/RecommendComponent.dart';
import '../component/YouLikesComponent.dart';
import '../model/MovieDetailModel.dart';
import '../model/MovieUrlModel.dart';
import '../model/CommentModel.dart';
import '../config/serviceUrl.dart';
import '../theme/ThemeColors.dart';
import '../theme/Size.dart';
import '../theme/ThemeColors.dart';

class PlayerPage extends StatefulWidget {
  final MovieDetailModel movieItem;

  PlayerPage({Key key, this.movieItem}) : super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  String url = "";
  int currentIndex = 0;
  List<Widget> playGroupWidget = [];
  bool isFavoriteFlag = false;
  int commentCount = 0;
  bool showComment = false;
  List<CommentModel> commentList = [];
  int pageNum = 1;
  int pageSize = 20;
  CommentModel replyTopCommentItem;
  CommentModel replyCommentItem;
  bool disabledSend = true;
  TextEditingController keywordController = TextEditingController();
  String hintText = '';

  @override
  void initState() {
    super.initState();
    isFavorite(); //查询电影是否已经收藏过
    savePlayRecordService(widget.movieItem);
    keywordController.addListener(() {
      setState(() {
        disabledSend = keywordController.text == "";
      });
    });
    getCommentCountService(widget.movieItem.movieId).then((res) {
      setState(() {
        commentCount = res["data"];
      });
    });
  }

  void isFavorite() {
    isFavoriteService(widget.movieItem.movieId).then((res) {
      if (res["data"] > 0) {
        setState(() {
          isFavoriteFlag = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.colorBg,
      body: Stack(
        children: <Widget>[
          ListView(children: <Widget>[
            webViewWidget(),
            Container(
                padding: ThemeStyle.padding,
                child: Column(children: <Widget>[
                  handleWidget(),
                  titleWidget(),
                  playUrlWidget(),
                  Column(
                    children: <Widget>[
                      widget.movieItem.label != null
                          ? YouLikesComponent(label: widget.movieItem.label)
                          : SizedBox(),
                      RecommendComponent(
                        classify: widget.movieItem.classify,
                        direction: "horizontal",
                        title: "推荐",
                      )
                    ],
                  )
                ])),
          ]),
          showComment ? getTopCommentWidget() : SizedBox()
        ],
      ),
    );
  }

  //获取一级评论
  Widget getTopCommentWidget() {
    return Positioned(
        child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Color.fromRGBO(0, 0, 0, 0.5),
            child: Column(
              children: <Widget>[
                Container(height: 300),
                Expanded(
                  flex: 1,
                  child: Container(
                      color: Color.fromRGBO(249, 249, 249, 1),
                      child: Column(children: <Widget>[
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(commentCount.toString() + "条评论",
                                style: TextStyle(
                                    color: Color.fromRGBO(136, 136, 136, 1)))
                          ],
                        ),
                        Expanded(
                            flex: 1,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 0),
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: commentList.length,
                                    itemBuilder: (content, index) {
                                      return Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                ClipOval(
                                                    child: Image.network(
                                                        serviceUrl +
                                                            commentList[index]
                                                                .avater,
                                                        height: 40,
                                                        width: 40,
                                                        fit: BoxFit.cover)),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: <Widget>[
                                                        InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                replyCommentItem =
                                                                    replyTopCommentItem =
                                                                commentList[
                                                                index];
                                                              });
                                                            },
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                      commentList[
                                                                      index]
                                                                          .username,
                                                                      style: TextStyle(
                                                                          color: Color
                                                                              .fromRGBO(
                                                                              136,
                                                                              136,
                                                                              136,
                                                                              1))),
                                                                  Text(
                                                                      commentList[
                                                                      index]
                                                                          .content),
                                                                  Text(
                                                                    commentList[index]
                                                                        .createTime +
                                                                        '  回复',
                                                                    style: TextStyle(
                                                                        color: Color
                                                                            .fromRGBO(
                                                                            136,
                                                                            136,
                                                                            136,
                                                                            1)),
                                                                  ),
                                                                ])),
                                                        commentList[index]
                                                            .replyList
                                                            .length >
                                                            0
                                                            ? getReplyList(
                                                            commentList[
                                                            index]
                                                                .replyList,
                                                            commentList[
                                                            index])
                                                            : SizedBox(),
                                                        commentList[index]
                                                            .replyCount >
                                                            0 &&
                                                            commentList[index]
                                                                .replyCount -
                                                                10 *
                                                                    commentList[index]
                                                                        .replyPageNum >
                                                                0
                                                            ? InkWell(
                                                            child: Padding(
                                                                padding:
                                                                EdgeInsets.only(
                                                                    top:
                                                                    5),
                                                                child: Text(
                                                                    '--展开${commentList[index]
                                                                        .replyCount -
                                                                        10 *
                                                                            commentList[index]
                                                                                .replyPageNum}条回复 >',
                                                                    style: TextStyle(
                                                                        color: Color
                                                                            .fromRGBO(
                                                                            136,
                                                                            136,
                                                                            136,
                                                                            1)))),
                                                            onTap: () {
                                                              getReplyCommentListService(
                                                                  commentList[index]
                                                                      .id,
                                                                  10,
                                                                  commentList[index]
                                                                      .replyPageNum +
                                                                      1)
                                                                  .then(
                                                                      (value) {
                                                                    setState(
                                                                            () {
                                                                          (value["data"]
                                                                          as List)
                                                                              .cast()
                                                                              .forEach(
                                                                                  (
                                                                                  element) {
                                                                                commentList[index]
                                                                                    .replyList
                                                                                    .add(
                                                                                    CommentModel
                                                                                        .fromJson(
                                                                                        element));
                                                                              });
                                                                          commentList[
                                                                          index]
                                                                              .replyPageNum++;
                                                                        });
                                                                  });
                                                            })
                                                            : SizedBox()
                                                      ]),
                                                )
                                              ]));
                                    }))),
                        Padding(
                            padding: EdgeInsets.all(20),
                            child: Row(children: <Widget>[
                              Expanded(
                                child: Container(
                                    height: 45,
                                    //修饰黑色背景与圆角
                                    decoration: new BoxDecoration(
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              255, 241, 242, 246),
                                          width: 1.0), //灰色的一层边框
                                      color: Color.fromARGB(255, 230, 230, 230),
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(30.0)),
                                    ),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(left: 10, top: 0),
                                    child: TextField(
                                        controller: keywordController,
                                        cursorColor: Colors.grey, //设置光标
                                        decoration: InputDecoration(
                                          hintText: replyCommentItem != null
                                              ? '回复${replyCommentItem.username}'
                                              : '有爱评论，说点好听的~',
                                          hintStyle: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                          contentPadding:
                                          EdgeInsets.only(left: 10, top: 0),
                                          border: InputBorder.none,
                                        ))),
                              ),
                              SizedBox(width: 10),
                              Container(
                                height: 45,
                                child: RaisedButton(
                                    color: disabledSend
                                        ? Color.fromARGB(255, 230, 230, 230)
                                        : Theme
                                        .of(context)
                                        .accentColor,
                                    child: Text("发送",
                                        style: TextStyle(color: Colors.white)),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    onPressed: () async {
                                      onInserComment();
                                    }),
                              )
                            ]))
                      ])),
                )
              ],
            )));
  }

  void onInserComment() {
    Map commentMap = {};
    commentMap["content"] = keywordController.text;
    commentMap["parentId"] =
    replyCommentItem == null ? null : replyCommentItem.id;
    commentMap["topId"] =
    replyCommentItem == null ? null : replyTopCommentItem.topId;
    commentMap["movieId"] = widget.movieItem.movieId;
    commentMap["replyUserId"] =
    replyCommentItem == null ? null : replyCommentItem.userId;
    insertCommentService(commentMap).then((res) {
      setState(() {
        commentCount++;
        if (replyTopCommentItem == null) {
          commentList.add(CommentModel.fromJson(res["data"]));
        } else {
          replyTopCommentItem.replyList.add(CommentModel.fromJson(res["data"]));
          replyCommentItem = replyTopCommentItem = null;
        }
        keywordController.text = '';
      });
    });
  }

  //获取回复
  Widget getReplyList(List<CommentModel> replyList, topCommentItem) {
    List<Widget> replyListWidget = [];
    replyList.forEach((element) {
      replyListWidget.add(Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipOval(
                  child: Image.network(serviceUrl + element.avater,
                      height: 30, width: 30, fit: BoxFit.cover)),
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          setState(() {
                            replyTopCommentItem = topCommentItem;
                            replyCommentItem = element;
                          });
                        },
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  '${element.username}▶${element
                                      .replyUserName}',
                                  style: TextStyle(
                                      color: Color.fromRGBO(136, 136, 136, 1))),
                              Text(element.content),
                              Text(element.createTime + '  回复',
                                  style: TextStyle(
                                      color: Color.fromRGBO(136, 136, 136, 1)))
                            ]))
                  ],
                ),
              )
            ],
          )));
    });
    return Column(children: replyListWidget);
  }

  //获取播放地址
  Widget playUrlWidget() {
    return FutureBuilder(
        future: getMovieUrlService(widget.movieItem.movieId),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          } else {
            List<MovieUrlModel> playList =
            (snapshot.data["data"] as List).cast().map((item) {
              return MovieUrlModel.fromJson(item);
            }).toList();
            if (playList.length == 0) {
              return Container();
            }
            List<List<MovieUrlModel>> playGroupList = [];
            for (int i = 0; i < playList.length; i++) {
              if (i == 0) {
                url = playList[0].url;
              }
              int playGroup = playList[i].playGroup;
              if (playGroupList.length < playGroup) {
                playGroupList.add(<MovieUrlModel>[]);
              }
              playGroupList[playGroup - 1].add(playList[i]);
            }
            Widget tabs = _renderTab();
            Widget series = _getPlaySeries(playGroupList);
            return Container(
                decoration: ThemeStyle.boxDecoration,
                padding: ThemeStyle.padding,
                margin: ThemeStyle.margin,
                child: Column(children: [tabs, SizedBox(height: 10), series]));
          }
        });
  }

  Widget _renderTab() {
    int length = 4;
    List<Widget> tabs = <Widget>[];
    if (length > 1) {
      for (int i = 0; i < length; i++) {
        if(i !=0)tabs.add(Container(width: 1,decoration: BoxDecoration(color: Colors.red,)));
        tabs.add(InkWell(
            onTap: () {
              setState(() {
                currentIndex = i;
              });
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(i == 0 ? Size.bigRadius : 0),
                        bottomLeft: Radius.circular(
                            i == 0 ? Size.bigRadius : 0),
                        topRight: Radius.circular(
                            i == length - 1 ? Size.bigRadius : 0),
                        bottomRight: Radius.circular(
                            i == length - 1 ? Size.bigRadius : 0)
                    ),
                    color: currentIndex == i
                        ? ThemeColors.activeColor
                        : ThemeColors.colorBg,
            ),
                    height: Size.buttomHeight,
                    padding: EdgeInsets.only(
                        left: Size.smallMargin, right: Size.smallMargin),
                    child: Center(child: Text("播放地址${(i + 1).toString()}",
                        style: TextStyle(
                            color: currentIndex == i
                                ? ThemeColors.colorWhite
                                : Colors.black))))));
        }
        }
          return Row(
          children: tabs,
          mainAxisAlignment: MainAxisAlignment.center,
        );
      }

  Widget _getPlaySeries(List playGroupList) {
    return Container(
      height: 80,
      width: MediaQuery
          .of(context)
          .size
          .width - 40,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: playGroupList[currentIndex].length,
          itemBuilder: (content, index) {
            return InkWell(
                onTap: () {
                  setState(() {
                    url = playGroupList[currentIndex][index].url;
                  });
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: url == playGroupList[currentIndex][index].url
                              ? Colors.orange
                              : Color.fromRGBO(187, 187, 187, 1)),
                      borderRadius: BorderRadius.all(Radius.circular(80))),
                  child: Center(
                      child: Text(
                        playGroupList[currentIndex][index].label,
                        style: TextStyle(
                            color: url == playGroupList[currentIndex][index].url
                                ? Colors.orange
                                : Colors.black),
                      )),
                ));
          }),
    );
  }

  Widget webViewWidget() {
    return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .width / 16 * 9,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child:
        /*url != ""
          ? WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
            )
          : SizedBox(),*/
        SizedBox());
  }

  Widget handleWidget() {
    return Container(
      decoration: ThemeStyle.boxDecoration,
      padding: ThemeStyle.padding,
      margin: ThemeStyle.margin,
      child: Row(
        children: <Widget>[
          InkWell(
              child: Row(
                children: <Widget>[
                  Image.asset(
                    "lib/assets/images/icon-comment.png",
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(width: 10),
                  Text(commentCount.toString()),
                ],
              ),
              onTap: () {
                setState(() {
                  showComment = true;
                  getTopCommentListService(
                      widget.movieItem.movieId, pageSize, pageNum)
                      .then((value) {
                    (value["data"] as List).forEach((element) {
                      setState(() {
                        commentList.add(CommentModel.fromJson(element));
                      });
                    });
                  });
                });
              }),
          Expanded(flex: 1, child: SizedBox()),
          InkWell(
            onTap: () {
              if (isFavoriteFlag) {
                //如果已经收藏过了，点击之后取消收藏
                deleteFavoriteService(widget.movieItem.movieId).then((res) {
                  if (res["data"] > 0) {
                    setState(() {
                      isFavoriteFlag = false;
                    });
                  }
                });
              } else {
                //如果没有收藏过，点击之后添加收藏
                saveFavoriteService(widget.movieItem).then((res) {
                  if (res["data"] > 0) {
                    setState(() {
                      isFavoriteFlag = true;
                    });
                  }
                });
              }
            },
            child: Image.asset(
                isFavoriteFlag
                    ? "lib/assets/images/icon-collection-active.png"
                    : "lib/assets/images/icon-collection.png",
                width: 30,
                height: 30),
          ),
          SizedBox(width: 10),
          Image.asset("lib/assets/images/icon-share.png", width: 30, height: 30)
        ],
      ),
    );
  }

  Widget titleWidget() {
    return Container(
        decoration: ThemeStyle.boxDecoration,
        padding: ThemeStyle.padding,
        margin: ThemeStyle.margin,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.movieItem.movieName,
                style: ThemeStyle.mainTitleStyle,
              ),
              SizedBox(height: Size.smallMargin),
              Text(
                widget.movieItem.star,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: Size.smallMargin),
              ScoreComponent(score: widget.movieItem.score),
            ]));
  }
}
