import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:movie/theme/ThemeStyle.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../component/ScoreComponent.dart';
import '../../config/common.dart';
import '../service/serverMethod.dart';
import '../component/RecommendComponent.dart';
import '../component/YouLikesComponent.dart';
import '../model/MovieDetailModel.dart';
import '../model/MovieUrlModel.dart';
import '../model/CommentModel.dart';
import '../../theme/ThemeColors.dart';
import '../../theme/ThemeSize.dart';
import '../../utils/common.dart';

class MoviePlayerPage extends StatefulWidget {
  final MovieDetailModel movieItem;

  MoviePlayerPage({Key key, this.movieItem}) : super(key: key);

  @override
  _MoviePlayerPageState createState() => _MoviePlayerPageState();
}

class _MoviePlayerPageState extends State<MoviePlayerPage> {
  String url = "";
  int currentIndex = 0;
  List<Widget> playGroupWidget = [];
  bool isFavoriteFlag = false;
  int commentCount = 0;
  bool showComment = false;
  List<CommentModel> commentList = [];
  int pageNum = 1;
  CommentModel replyTopCommentItem;
  CommentModel replyCommentItem;
  bool disabledSend = true;
  TextEditingController keywordController = TextEditingController();
  String hintText = '';

  @override
  void initState() {
    super.initState();
    isFavorite(); //查询电影是否已经收藏过
    keywordController.addListener(() {
      setState(() {
        disabledSend = keywordController.text == "";
      });
    });
    getCommentCountService(widget.movieItem.id, "movie").then((res) {
      setState(() {
        commentCount = res["data"];
      });
    });
    savePlayRecordService(widget.movieItem);
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
      body: SafeArea(
          top: true,
          child: Stack(
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
          )),
    );
  }

  //获取一级评论
  Widget getTopCommentWidget() {
    return Positioned(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color.fromRGBO(0, 0, 0, 0.5),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.width / 16 * 9,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                      color: ThemeColors.colorBg,
                      child: Column(children: <Widget>[
                        SizedBox(height: ThemeSize.smallMargin),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(commentCount.toString() + "条评论")
                          ],
                        ),
                        Expanded(
                            flex: 1,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: ThemeSize.containerPadding,
                                    right: ThemeSize.containerPadding,
                                    top: 0),
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: commentList.length,
                                    itemBuilder: (content, index) {
                                      return Padding(
                                          padding: EdgeInsets.only(
                                              bottom: ThemeSize.smallMargin),
                                          child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                ClipOval(
                                                    child: Image.network(
                                                        HOST +
                                                            commentList[index]
                                                                .avater,
                                                        height:
                                                            ThemeSize.bigIcon,
                                                        width:
                                                            ThemeSize.bigIcon,
                                                        fit: BoxFit.cover)),
                                                SizedBox(
                                                    width:
                                                        ThemeSize.smallMargin),
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
                                                                          color:
                                                                              ThemeColors.subTitle)),
                                                                  SizedBox(
                                                                      height: ThemeSize
                                                                          .miniMargin),
                                                                  Text(commentList[
                                                                          index]
                                                                      .content),
                                                                  SizedBox(
                                                                      height: ThemeSize
                                                                          .miniMargin),
                                                                  Text(
                                                                    formatTime(commentList[index]
                                                                            .createTime) +
                                                                        '  回复',
                                                                    style: TextStyle(
                                                                        color: ThemeColors
                                                                            .subTitle),
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
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                5),
                                                                    child: Text(
                                                                        '--展开${commentList[index].replyCount - 10 * commentList[index].replyPageNum}条回复 >',
                                                                        style: TextStyle(
                                                                            color:
                                                                                ThemeColors.subTitle))),
                                                                onTap: () {
                                                                  getReplyCommentListService(
                                                                          commentList[index]
                                                                              .id,
                                                                          10,
                                                                          commentList[index].replyPageNum +
                                                                              1)
                                                                      .then(
                                                                          (value) {
                                                                    setState(
                                                                        () {
                                                                      (value["data"]
                                                                              as List)
                                                                          .cast()
                                                                          .forEach(
                                                                              (element) {
                                                                        commentList[index]
                                                                            .replyList
                                                                            .add(CommentModel.fromJson(element));
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
                            padding: ThemeStyle.padding,
                            child: Row(children: <Widget>[
                              Expanded(
                                child: Container(
                                    height: 45,
                                    //修饰黑色背景与圆角
                                    decoration: new BoxDecoration(
                                      //灰色的一层边框
                                      color: ThemeColors.borderColor,
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(
                                              ThemeSize.bigRadius)),
                                    ),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                        left: ThemeSize.smallMargin, top: 0),
                                    child: TextField(
                                        controller: keywordController,
                                        cursorColor: Colors.grey, //设置光标
                                        decoration: InputDecoration(
                                          hintText: replyCommentItem != null
                                              ? '回复${replyCommentItem.username}'
                                              : '有爱评论，说点好听的~',
                                          hintStyle: TextStyle(
                                              fontSize: ThemeSize.smallFontSize,
                                              color: Colors.grey),
                                          contentPadding: EdgeInsets.only(
                                              left: ThemeSize.smallMargin,
                                              top: 0),
                                          border: InputBorder.none,
                                        ))),
                              ),
                              SizedBox(width: ThemeSize.smallMargin),
                              Container(
                                height: 45,
                                child: RaisedButton(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    color: disabledSend
                                        ? ThemeColors.disableColor
                                        : Theme.of(context).accentColor,
                                    child: Text("发送",
                                        style: TextStyle(
                                            color: disabledSend
                                                ? ThemeColors.subTitle
                                                : Colors.white)),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                ThemeSize.superRadius))),
                                    onPressed: () async {
                                      if (disabledSend) {
                                        Fluttertoast.showToast(
                                            msg: "已经到底了",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIos: 1,
                                            backgroundColor:
                                                ThemeColors.disableColor,
                                            textColor: Colors.white,
                                            fontSize: ThemeSize.middleFontSize);
                                      } else {
                                        onInserComment();
                                      }
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
          padding: EdgeInsets.only(top: ThemeSize.smallMargin),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipOval(
                  child: Image.network(HOST + element.avater,
                      height: ThemeSize.middleIcon,
                      width: ThemeSize.middleIcon,
                      fit: BoxFit.cover)),
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
                                  '${element.username}▶${element.replyUserName}',
                                  style:
                                      TextStyle(color: ThemeColors.subTitle)),
                              SizedBox(height: ThemeSize.miniMargin),
                              Text(element.content),
                              Text(formatTime(element.createTime) + '  回复',
                                  style: TextStyle(color: ThemeColors.subTitle))
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
        // 测试数据
        future: getMovieUrlService(72667 /*widget.movieItem.id*/),
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
            List<List<MovieUrlModel>> movieUrlGroup = [];
            for (int i = 0; i < playList.length; i++) {
              if (i == 0) {
                url = playList[0].url;
              }
              int index = movieUrlGroup.indexWhere((element){
                return element[0].playGroup == playList[i].playGroup;
              });
              if (index != -1) {
                movieUrlGroup[index].add(playList[i]);
              }else{
                movieUrlGroup.add([playList[i]]);
              }
            }
            return Container(
                decoration: ThemeStyle.boxDecoration,
                padding: ThemeStyle.padding,
                margin: ThemeStyle.margin,
                width: MediaQuery.of(context).size.width -
                    ThemeSize.containerPadding * 2,
                child: Column(children: [
                  _renderTab(movieUrlGroup),
                  SizedBox(
                      height: movieUrlGroup.length > 1
                          ? ThemeSize.containerPadding
                          : 0),
                  _getPlaySeries(movieUrlGroup)
                ]));
          }
        });
  }

  Widget _renderTab(List<List<MovieUrlModel>> movieUrlGroup) {
    print(movieUrlGroup);
    return Container(
      width: MediaQuery.of(context).size.width - ThemeSize.containerPadding * 2,
      height: 40,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movieUrlGroup.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () {
                  setState(() {
                    currentIndex = index;
                  });
                },
                child: Container(
                    padding: EdgeInsets.all(ThemeSize.smallMargin),
                    decoration: BoxDecoration(
                        border: Border(
                      left: BorderSide(
                          width:
                              currentIndex == index ? ThemeSize.borderWidth : 0,
                          color: currentIndex == index ? ThemeColors.borderColor:ThemeColors.colorWhite),
                      right: BorderSide(
                          width: currentIndex == index ? ThemeSize.borderWidth : 0,
                          color: currentIndex == index ? ThemeColors.borderColor:ThemeColors.colorWhite),
                      top: BorderSide(
                          width: currentIndex == index ? ThemeSize.borderWidth : 0,
                          color: currentIndex == index ? ThemeColors.borderColor:ThemeColors.colorWhite),
                      bottom: BorderSide(
                          width:  currentIndex == index ? 0 : ThemeSize.borderWidth ,
                          color: currentIndex == index ? ThemeColors.colorWhite:ThemeColors.borderColor)
                    )),
                    child: Text(
                        RegExp("^[0-9]+\$")
                                .hasMatch(movieUrlGroup[index][0].playGroup)
                            ? movieUrlGroup[index][0].playGroup
                            : '线路${movieUrlGroup[index][0].playGroup}',
                        style: TextStyle(
                            color: currentIndex == index
                                ? Colors.orange
                                : Colors.black))));
          }),
    );
  }

  Widget _getPlaySeries(List<List<MovieUrlModel>> movieUrlGroup) {
    List<Widget> playSeries = [];
    for (int i = 0; i < movieUrlGroup[currentIndex].length; i++) {
      playSeries.add(Container(
        padding: ThemeStyle.padding,
        decoration: BoxDecoration(
            border: Border.all(
                color: url == movieUrlGroup[currentIndex][i].url
                    ? Colors.orange
                    : ThemeColors.borderColor),
            borderRadius:
                BorderRadius.all(Radius.circular(ThemeSize.middleRadius))),
        child: Center(
          child: Text(movieUrlGroup[0][i].label,
              style: TextStyle(
                  color: url == movieUrlGroup[currentIndex][i].url
                      ? Colors.orange
                      : Colors.black)),
        ),
      ));
    }
    return GridView.count(
        crossAxisSpacing: ThemeSize.smallMargin,
        mainAxisSpacing: ThemeSize.smallMargin,
        //水平子 Widget 之间间距
        crossAxisCount: ThemeSize.crossAxisCount,
        //一行的 Widget 数量
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        childAspectRatio: ThemeSize.childAspectRatio,
        children: playSeries);
  }

  Widget webViewWidget() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 16 * 9,
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
                    width: ThemeSize.middleIcon,
                    height: ThemeSize.middleIcon,
                  ),
                  SizedBox(width: ThemeSize.smallMargin),
                  Text(commentCount.toString()),
                ],
              ),
              onTap: () {
                setState(() {
                  showComment = true;
                  getTopCommentListService(widget.movieItem.movieId, "movie",
                          ThemeSize.pageSize, pageNum)
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
                width: ThemeSize.middleIcon,
                height: ThemeSize.middleIcon),
          ),
          SizedBox(width: ThemeSize.smallMargin),
          Image.asset("lib/assets/images/icon-share.png",
              width: ThemeSize.middleIcon, height: ThemeSize.middleIcon)
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
              SizedBox(height: ThemeSize.smallMargin),
              Text(
                widget.movieItem.star,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: ThemeSize.smallMargin),
              ScoreComponent(score: widget.movieItem.score),
            ]));
  }
}
