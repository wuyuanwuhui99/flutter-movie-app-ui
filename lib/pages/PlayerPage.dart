import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../component/ScoreComponent.dart';
import '../service/serverMethod.dart';
import '../component/RecommendComponent.dart';
import '../component/YouLikesComponent.dart';
import '../model/MovieDetailModel.dart';
import '../model/MovieUrlModel.dart';
import '../model/CommentModel.dart';
import '../config/serviceUrl.dart';

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
  List<CommentModel>commentList=[];
  int pageNum = 1;
  int pageSize = 20;

  @override
  void initState() {
    super.initState();
    isFavorite(); //查询电影是否已经收藏过
    savePlayRecordService(widget.movieItem);
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
      body:
      Stack(children: <Widget>[
        ListView(children: <Widget>[
          webViewWidget(),
          handleWidget(),
          titleWidget(),
          SizedBox(height: 20),
          playUrlWidget(),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
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
            ),
          )
        ]),
        showComment?
        getTopCommentWidget()
        :SizedBox()
      ],),

    );
  }

  //获取一级评论
  Widget getTopCommentWidget(){
    return Positioned(child: Container(
    width: double.infinity,
    height:double.infinity,
    color: Color.fromRGBO(0, 0, 0, 0.5),
    child:
      Column(
        children: <Widget>[
          Container(height: 300),
          Expanded(flex:1,child:
            Container(color: Colors.white,child:
              Column(children: <Widget>[
                SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[Text(commentCount.toString()+"条评论",style:TextStyle(color: Color.fromRGBO(136, 136,136, 1)))],),
                Expanded(flex: 1,child:
                   Padding(padding: EdgeInsets.only(left: 20,right: 20,top: 0),child:
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: commentList.length,
                        itemBuilder: (content, index) {
                          return
                            Padding(padding: EdgeInsets.only(bottom: 10),child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[
                              ClipOval(
                                  child: Image.network(serviceUrl + commentList[index].avater,
                                      height: 40, width: 40, fit: BoxFit.cover)
                              ),
                              SizedBox(width: 10),
                              Expanded(flex: 1,child:
                              Column(crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[
                                Text(commentList[index].username,style: TextStyle(color: Color.fromRGBO(136, 136,136, 1))),
                                Text(commentList[index].content),
                                Text(commentList[index].createTime + '  回复',style: TextStyle(color: Color.fromRGBO(136, 136,136, 1)),),
                                commentList[index].replyList.length > 0 ? getReplyList(commentList[index].replyList)  : SizedBox(),
                                commentList[index].replyCount > 0 && commentList[index].replyCount - 10*commentList[index].replyPageNum > 0 ?
                                  InkWell(child:
                                    Padding(
                                        padding: EdgeInsets.only(top:5),
                                        child: Text('--展开${commentList[index].replyCount - 10*commentList[index].replyPageNum }条回复 >',style:  TextStyle(color: Color.fromRGBO(136, 136,136, 1)))),
                                        onTap: (){
                                          getReplyCommentListService(commentList[index].id,10,commentList[index].replyPageNum+1).then((value){
                                            setState(() {
                                              (value["data"] as List).cast().forEach((element) {
                                                commentList[index].replyList.add(CommentModel.fromJson(element));
                                              });
                                              commentList[index].replyPageNum++;
                                            });
                                          });
                                        }
                                  ):
                                  SizedBox()
                              ]),

                              )
                            ]));
                        })
                   )
                )

              ])
            ),
          )
    ],)));
  }

  //获取回复
  Widget getReplyList(List<CommentModel>replyList){
    List<Widget>replyListWidget = [];
    replyList.forEach((element) {
      replyListWidget.add(
          Padding(padding: EdgeInsets.only(top: 10),child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipOval(
                  child: Image.network(serviceUrl + element.avater,
                      height: 30, width: 30, fit: BoxFit.cover)
              ),
              SizedBox(width: 10),
              Expanded(flex: 1,child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[
                Text('${element.username}▶${element.replyUserName}',style: TextStyle(color: Color.fromRGBO(136, 136,136, 1))),
                Text(element.content),
                Text(element.createTime + '  回复',style: TextStyle(color: Color.fromRGBO(136, 136,136, 1)))
              ],),)
            ],
          )));
    });
    return Column(children:replyListWidget);
  }

  //获取播放地址
  Widget playUrlWidget() {
    return FutureBuilder(
        future: getMovieUrlService(widget.movieItem.movieId),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          } else {
            List<MovieUrlModel> playList = (snapshot.data["data"] as List).cast().map((item){
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
            Widget tabs = _renderTab(playGroupList.length);
            Widget series = _getPlaySeries(playGroupList);
            return Column(children: [tabs, SizedBox(height: 10),series]);
          }
        });
  }

  Widget _renderTab(int length) {
    List<Widget> tabs = <Widget>[];
    for (int i = 0; i < length; i++) {
      tabs.add(InkWell(
          onTap: () {
            setState(() {
              currentIndex = i;
            });
          },
          child: Container(
              decoration: BoxDecoration(
                  border: currentIndex == i
                      ? Border(
                          left: BorderSide(
                            width: 1, //宽度
                            color: Color.fromRGBO(221, 221, 221, 1), //边框颜色
                          ),
                          right: BorderSide(
                            width: 1, //宽度
                            color: Color.fromRGBO(221, 221, 221, 1), //边框颜色
                          ),
                          top: BorderSide(
                            width: 1, //宽度
                            color: Color.fromRGBO(221, 221, 221, 1), //边框颜色
                          ),
                          bottom: BorderSide(
                            width: 1, //宽度
                            color: Colors.white, //边框颜色
                          ))
                      : Border(
                          bottom: BorderSide(
                          width: 1, //宽度
                          color: Color.fromRGBO(221, 221, 221, 1), //边框颜色
                        ))),
              height: 40,
              padding: EdgeInsets.all(10),
              child: Text("播放地址${(i + 1).toString()}"))));
    }
    tabs.add(Expanded(
        flex: 1,
        child: Container(
            height: 40,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1, color: Color.fromRGBO(221, 221, 221, 1)))))));
    return Padding(
        padding: EdgeInsets.only(left: 10, top: 0), child: Row(children: tabs));
  }

  Widget _getPlaySeries(List playGroupList) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width - 40,
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
                          color:
                              url == playGroupList[currentIndex][index].url
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
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          width: 0.5, //宽度
          color: Color.fromRGBO(187, 187, 187, 1), //边框颜色
        ),
      )),
      child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: <Widget>[
              InkWell(
                child:
                  Row(children: <Widget>[
                    Image.asset(
                      "lib/assets/images/icon-comment.png",
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(width: 10),
                    Text(commentCount.toString()),
                ],),
                onTap: () {
                  setState(() {
                    showComment = true;
                    getTopCommentListService(widget.movieItem.movieId,pageSize,pageNum).then((value){
                      (value["data"] as List).forEach((element) {
                        setState(() {
                          commentList.add(CommentModel.fromJson(element));
                        });
                      });
                    });
                  });
                }
              ),
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
                    isFavoriteFlag ? "lib/assets/images/icon-collection-active.png" :"lib/assets/images/icon-collection.png",
                    width: 30,
                    height: 30),
              ),
              SizedBox(width: 10),
              Image.asset("lib/assets/images/icon-share.png",
                  width: 30, height: 30)
            ],
          )),
    );
  }

  Widget titleWidget() {
    return Container(
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
            width: 0.5, //宽度
            color: Color.fromRGBO(187, 187, 187, 1), //边框颜色
          ),
        )),
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.movieItem.movieName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.movieItem.star,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10),
                  ScoreComponent(score: widget.movieItem.score),
                ])));
  }
}
