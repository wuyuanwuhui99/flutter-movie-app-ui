import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../component/ScoreComponent.dart';
import '../service/server_method.dart';

class PlayerPage extends StatefulWidget {
  final Map movieItem;
  PlayerPage({Key key, this.movieItem}) : super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  String currentIndex = "1-1";
  String url = "";
  List<Widget> playGroupWidget = [];

  @override
  void initState() {
    super.initState();
    _getPlayUrl();
    saveViewRecord(widget.movieItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: <Widget>[
        webView(),
        handle(),
        title(),
        Column(children: playGroupWidget)
      ]),
    );
  }

  void _getPlayUrl() {
    getMovieUrl(widget.movieItem["id"]).then((res) {
      setState(() {
        List<Map> playList = (res["data"] as List).cast();
        if (playList.length == 0) {
          return;
        }
        List<List<Map>> playGroupList = [];
        for (int i = 0; i < playList.length; i++) {
          if(i == 0){
            url = playList[0]["url"];
          }
          var playGroup = playList[i]["playGroup"];
          if (playGroupList.length < playGroup) {
            playGroupList.add(<Map>[]);
          }
          playGroupList[playGroup - 1].add(playList[i]);
        }
        for (int j = 0; j < playGroupList.length; j++) {
          playGroupWidget.add(_renderPlayList(playGroupList[j], j + 1));
        }
      });
    });
  }

  Widget webView() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 16 * 9,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: url != ""
          ? WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
            )
          : SizedBox(),
    );
  }

  Widget handle() {
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
              Image.asset("lib/assets/images/icon-collection.png",
                  width: 30, height: 30),
              SizedBox(width: 10),
              Image.asset("lib/assets/images/icon-share.png",
                  width: 30, height: 30)
            ],
          )),
    );
  }

  Widget title() {
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
                    widget.movieItem["name"],
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

  Widget _renderPlayList(List<Map> urlList, int playGroup) {
    return Container(
        width: MediaQuery.of(context).size.width,
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
              Row(
                children: <Widget>[
                  Text(
                    "播放地址${playGroup}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                height: 80,
                width: MediaQuery.of(context).size.width - 40,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: urlList.length,
                    itemBuilder: (content, index) {
                      return InkWell(
                          onTap: () {
                            setState(() {
                              currentIndex = "${playGroup}-${index + 1}";
                              url = urlList[index]["url"];
                            });
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: currentIndex ==
                                            "${playGroup}-${index + 1}"
                                        ? Colors.orange
                                        : Color.fromRGBO(187, 187, 187, 1)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(80))),
                            child: Center(
                                child: Text(
                              urlList[index]["label"],
                              style: TextStyle(
                                  color: currentIndex ==
                                          "${playGroup}-${index + 1}"
                                      ? Colors.orange
                                      : Colors.black),
                            )),
                          ));
                    }),
              ),
            ],
          ),
        ));
  }
}
