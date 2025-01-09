import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:movie/theme/ThemeStyle.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../component/ScoreComponent.dart';
import '../../common/config.dart';
import '../service/serverMethod.dart';
import '../component/RecommendComponent.dart';
import '../component/YouLikesComponent.dart';
import '../model/MovieDetailModel.dart';
import '../model/MovieUrlModel.dart';
import '../model/CommentModel.dart';
import '../../theme/ThemeColors.dart';
import '../../theme/ThemeSize.dart';
import '../../utils/common.dart';
import '../../music/component/CommentComponent.dart';

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
  int commentTotal = 0;
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
    getCommentCountService(widget.movieItem.id, CommentEnum.MOVIE).then((res) {
      setState(() {
        commentTotal = res.data;
      });
    });
    savePlayRecordService(widget.movieItem);
  }

  void isFavorite() {
    isFavoriteService(widget.movieItem.movieId).then((res) {
      setState(() {
        isFavoriteFlag = res.data > 0;
      });
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
            ],
          )),
    );
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
            List<MovieUrlModel> playList = [];
            snapshot.data.data.forEach((item) {
              playList.add(MovieUrlModel.fromJson(item));
            });
            if (playList.length == 0) {
              return Container();
            }
            List<List<MovieUrlModel>> movieUrlGroup = [];
            for (int i = 0; i < playList.length; i++) {
              if (i == 0 && playList[0].url != null) {
                url = playList[0].url;
              }
              int index = movieUrlGroup.indexWhere((element) {
                return element[0].playGroup == playList[i].playGroup;
              });
              if (index != -1) {
                movieUrlGroup[index].add(playList[i]);
              } else {
                movieUrlGroup.add([playList[i]]);
              }
            }
            return Container(
                decoration: ThemeStyle.boxDecoration,
                padding: ThemeStyle.padding,
                margin: ThemeStyle.margin,
                width: MediaQuery.of(context).size.width -
                    ThemeSize.containerPadding * 2,
                child: Column(children: _getPlaySeries(movieUrlGroup)));
          }
        });
  }

  List<Widget> _getPlaySeries(List<List<MovieUrlModel>> movieUrlGroup) {
    List<Widget> playSeries = [];
    for (int i = 0; i < movieUrlGroup.length; i++) {
      List<Widget> urlWidgets = [];
      for (int j = 0; j < movieUrlGroup[i].length; j++) {
        urlWidgets.add(InkWell(
            onTap: () {
              setState(() {
                url = movieUrlGroup[i][j].url;
              });
            },
            child: Container(
              padding: ThemeStyle.padding,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: url == movieUrlGroup[i][j].url
                          ? Colors.orange
                          : ThemeColors.borderColor),
                  borderRadius: BorderRadius.all(
                      Radius.circular(ThemeSize.middleRadius))),
              child: Center(
                child: Text(movieUrlGroup[i][j].label,
                    style: TextStyle(
                        color: url == movieUrlGroup[i][j].url
                            ? Colors.orange
                            : Colors.black)),
              ),
            )));
      }
      playSeries.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(RegExp("^[0-9]+\$").hasMatch(movieUrlGroup[i][0].playGroup)
              ? movieUrlGroup[i][0].playGroup
              : '线路${movieUrlGroup[i][0].playGroup}'),
          SizedBox(height: ThemeSize.containerPadding),
          GridView.count(
              crossAxisSpacing: ThemeSize.smallMargin,
              mainAxisSpacing: ThemeSize.smallMargin,
              //水平子 Widget 之间间距
              crossAxisCount: ThemeSize.crossAxisCount,
              //一行的 Widget 数量
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              childAspectRatio: ThemeSize.childAspectRatio,
              children: urlWidgets)
        ],
      ));
      if (i != movieUrlGroup.length - 1) {
        playSeries.add(SizedBox(height: ThemeSize.containerPadding));
        playSeries.add(Divider(
          height: 1.0, // 横线的高度
          color: ThemeColors.borderColor, // 横线的颜色
          thickness: 1.0, // 横线的厚度
        ));
        playSeries.add(SizedBox(height: ThemeSize.containerPadding));
      }
    }
    return playSeries;
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
                    "lib/assets/images/icon_comment.png",
                    width: ThemeSize.middleIcon,
                    height: ThemeSize.middleIcon,
                  ),
                  SizedBox(width: ThemeSize.smallMargin),
                  Text(commentTotal.toString()),
                ],
              ),
              onTap: () {
                setState(() {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(ThemeSize.middleRadius),
                              topRight:
                                  Radius.circular(ThemeSize.middleRadius))),
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: CommentComponent(
                              type: CommentEnum.MOVIE,
                              relationId: widget.movieItem.id,
                            ));
                      });
                });
              }),
          Expanded(flex: 1, child: SizedBox()),
          InkWell(
            onTap: () {
              if (isFavoriteFlag) {
                //如果已经收藏过了，点击之后取消收藏
                deleteFavoriteService(widget.movieItem.movieId).then((res) {
                  if (res.data > 0) {
                    setState(() {
                      isFavoriteFlag = false;
                    });
                  }
                });
              } else {
                //如果没有收藏过，点击之后添加收藏
                saveFavoriteService(widget.movieItem.id).then((res) {
                  if (res.data > 0) {
                    setState(() {
                      isFavoriteFlag = true;
                    });
                  }
                });
              }
            },
            child: Image.asset(
                isFavoriteFlag
                    ? "lib/assets/images/icon_collection_active.png"
                    : "lib/assets/images/icon_collection.png",
                width: ThemeSize.middleIcon,
                height: ThemeSize.middleIcon),
          ),
          SizedBox(width: ThemeSize.smallMargin),
          Image.asset("lib/assets/images/icon_share.png",
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
