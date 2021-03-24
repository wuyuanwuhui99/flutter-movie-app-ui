import 'package:flutter/material.dart';
import './player_page.dart';
import '../service/server_method.dart';
import '../component/ScoreComponent.dart';
import '../config/global.dart';

class DetailPage extends StatefulWidget {
  final Map movieItem;
  DetailPage({Key key, this.movieItem}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    saveViewRecord(widget.movieItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        BannerComponent(
          movieItem: widget.movieItem,
        ),
        MovieInfoComponent(movieInfo: widget.movieItem),
        PlotComponent(plot: widget.movieItem["plot"]),
        StarComponent(movieId: widget.movieItem["movieId"]),
      ],
    )));
  }
}

class BannerComponent extends StatelessWidget {
  final Map movieItem;
  const BannerComponent({Key key, this.movieItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PlayerPage(movieItem: movieItem)));
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: NetworkImage(movieItem["img"]),
            fit: BoxFit.cover,
          )),
          child: Center(
              child: Image.asset("lib/assets/images/icon-detail-play.png",
                  height: 40, width: 40, fit: BoxFit.cover)),
        ));
  }
}

class MovieInfoComponent extends StatelessWidget {
  final Map movieInfo;
  const MovieInfoComponent({Key key, this.movieInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 180,
          height: 150,
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                left: 25,
                top: -50,
                width: 150,
                height: 200,
                child: Container(
                    width: 150,
                    height: 200,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromRGBO(238, 238, 238, 1), width: 3),
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(movieInfo["img"]),
                          fit: BoxFit.cover,
                        ))),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      movieInfo["name"],
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                    SizedBox(height: 10),
                    Text(
                      movieInfo["star"] != null ? movieInfo["star"] : "",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(187, 187, 187, 1)),
                    ),
                  ],
                )),
                SizedBox(height: 10),
                ScoreComponent(score: movieInfo["score"])
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PlotComponent extends StatelessWidget {
  final String plot;
  const PlotComponent({Key key, this.plot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (plot != null) {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
                Container(
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          width: 3, //宽度
                          color: Colors.blue, //边框颜色
                        ),
                      ),
                    ),
                    child: Text("剧情"))
              ]),
              SizedBox(height: 15),
              Text(
                "        " + plot,
                style: TextStyle(
                    color: Color.fromRGBO(187, 187, 187, 1), height: 1.5),
              )
            ]),
      );
    } else {
      return Container();
    }
  }
}

class StarComponent extends StatelessWidget {
  final String movieId;
  const StarComponent({Key key, this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.movieId == null) return Container();
    return FutureBuilder(
        future: getStar(this.movieId),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<Map> stars = (snapshot.data["data"] as List).cast();
            if (stars.length > 0) {
              return Padding(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  width: 3, //宽度
                                  color: Colors.blue, //边框颜色
                                ),
                              ),
                            ),
                            child: Text("演员"))
                      ]),
                      SizedBox(height: 15),
                      Container(
                          width: MediaQuery.of(context).size.width - 40,
                          height: 260,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: stars.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Column(children: <Widget>[
                                    Container(
                                        width: 150,
                                        height: 200,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  stars[index]["img"]),
                                              fit: BoxFit.cover,
                                            ))),
                                    SizedBox(height: 5),
                                    Text(
                                      stars[index]["starName"],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      stars[index]["role"],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(187, 187, 187, 1)),
                                    ),
                                  ]),
                                );
                              }))
                    ]),
                padding: EdgeInsets.all(20),
              );
            } else {
              return Container();
            }
          }
        });
  }
}
