import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../component/ScoreComponent.dart';
import '../service/server_method.dart';
import '../component/RecommendComponent.dart';
import '../component/YouLikesComponent.dart';

class PlayerPage extends StatefulWidget {
  final Map movieItem;
  PlayerPage({Key key, this.movieItem}) : super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  String url = "";
  int currentIndex = 0;
  List<Widget> playGroupWidget = [];
  bool isFavoriteFlag = false;
  @override
  void initState() {
    super.initState();
    _isFavorite(); //查询电影是否已经收藏过
    savePlayRecord(widget.movieItem);
  }

  void _isFavorite() {
    isFavorite(widget.movieItem["movieId"]).then((res) {
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
      body: ListView(children: <Widget>[
        webViewWidget(),
        handleWidget(),
        titleWidget(),
        SizedBox(height: 20),
        playUrlWidget(),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: <Widget>[
              widget.movieItem["label"] != null
                  ? YouLikesComponent(label: widget.movieItem["label"])
                  : SizedBox(),
              RecommendComponent(
                  classify: widget.movieItem["classify"],
                  direction: "horizontal")
            ],
          ),
        )
      ]),
    );
  }

  Widget playUrlWidget() {
    return FutureBuilder(
        future: getMovieUrl(widget.movieItem["id"].toString()),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          } else {
            List<Map> playList = (snapshot.data["data"] as List).cast();
            if (playList.length == 0) {
              return Container();
            }
            List<List<Map>> playGroupList = [];
            for (int i = 0; i < playList.length; i++) {
              if (i == 0) {
                url = playList[0]["url"];
              }
              var playGroup = playList[i]["playGroup"];
              if (playGroupList.length < playGroup) {
                playGroupList.add(<Map>[]);
              }
              playGroupList[playGroup - 1].add(playList[i]);
            }
            Widget tabs = _renderTab(playGroupList.length);
            Widget series = _getPlaySeries(playGroupList);
            return Column(children: [tabs, SizedBox(height: 10), series]);
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
                    url = playGroupList[currentIndex][index]["url"];
                  });
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color:
                              url == playGroupList[currentIndex][index]["url"]
                                  ? Colors.orange
                                  : Color.fromRGBO(187, 187, 187, 1)),
                      borderRadius: BorderRadius.all(Radius.circular(80))),
                  child: Center(
                      child: Text(
                    playGroupList[currentIndex][index]["label"],
                    style: TextStyle(
                        color: url == playGroupList[currentIndex][index]["url"]
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
              Image.asset(
                "lib/assets/images/icon-comment.png",
                width: 30,
                height: 30,
              ),
              SizedBox(width: 10),
              // Text("111"),
              Expanded(flex: 1, child: SizedBox()),
              InkWell(
                onTap: () {
                  if (isFavoriteFlag) {
                    //如果已经收藏过了，点击之后取消收藏
                    deleteFavorite(widget.movieItem["movieId"]).then((res) {
                      if (res["data"] > 0) {
                        setState(() {
                          isFavoriteFlag = false;
                        });
                      }
                    });
                  } else {
                    //如果没有收藏过，点击之后添加收藏
                    saveFavorite(widget.movieItem).then((res) {
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
                    widget.movieItem["movieName"],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.movieItem['star'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10),
                  ScoreComponent(score: widget.movieItem["score"]),
                ])));
  }
}
