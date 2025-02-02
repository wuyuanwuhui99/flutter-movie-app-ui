import 'dart:convert';

import 'package:flutter/material.dart';
import '../router/index.dart';
import '../theme/ThemeColors.dart';
import '../service/serverMethod.dart';
import '../component/ScoreComponent.dart';
import '../component/YouLikesComponent.dart';
import '../component/RecommendComponent.dart';
import '../model/MovieDetailModel.dart';
import '../model/MovieStarModel.dart';
import '../theme/ThemeStyle.dart';
import '../theme/ThemeSize.dart';

class MovieDetailPage extends StatefulWidget {
  final MovieDetailModel movieItem;

  MovieDetailPage({super.key,required this.movieItem});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool isFavoriteFlag = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeColors.colorBg,
        body: SafeArea(
            top: true,
            child: Padding(
                padding: ThemeStyle.paddingBox,
                child: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    buildMovieInfoComponent(widget.movieItem, context),
                    buildPlotComponent("${widget.movieItem.plot}"),
                    buildStarComponent(widget.movieItem.id),
                    widget.movieItem.label != null
                        ? YouLikesComponent(label: widget.movieItem.label ?? "")
                        : SizedBox(),
                    RecommendComponent(
                      classify: widget.movieItem.classify ?? "",
                      direction: "horizontal",
                      title: "推荐",
                    )
                  ],
                )))));
  }

  Widget buildMovieInfoComponent(
      MovieDetailModel movieInfo, BuildContext context) {
    return Container(
      decoration: ThemeStyle.boxDecoration,
      margin: ThemeStyle.margin,
      child: Padding(
        padding: EdgeInsets.all(ThemeSize.containerPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
                onTap: () {
                  if (movieInfo.movieName != null) {
                    Routes.router.navigateTo(context, '/MoviePlayerPage?movieItem=${Uri.encodeComponent(json.encode(movieInfo.toMap()))}');
                  }
                },
                child: Container(
                    width: ThemeSize.movieWidth,
                    height: ThemeSize.movieHeight,
                    child: Center(
                        child: Image.asset(
                            "lib/assets/images/icon_detail_play.png",
                            height: ThemeSize.bigIcon,
                            width: ThemeSize.bigIcon,
                            fit: BoxFit.cover)),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ThemeSize.middleRadius),
                        image: DecorationImage(
                          image: NetworkImage(movieInfo.img),
                          fit: BoxFit.cover,
                        )))),
            Expanded(
              flex: 1,
              child: Padding(
                padding: ThemeStyle.padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      movieInfo.movieName,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                    SizedBox(height: 10),
                    movieInfo.description != null
                        ? Text(
                            movieInfo.description?.replaceAll('\n\s', '') ?? "",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(187, 187, 187, 1)),
                          )
                        : SizedBox(),
                    movieInfo.star != null
                        ? Text(
                            "${movieInfo.star}",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(187, 187, 187, 1)),
                          )
                        : SizedBox(),
                    SizedBox(height: 10),
                    ScoreComponent(score: movieInfo.score)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlotComponent(String plot) {
    if (plot != null) {
      return Container(
          decoration: ThemeStyle.boxDecoration,
          margin: ThemeStyle.margin,
          child: Padding(
            padding: ThemeStyle.padding,
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
          ));
    } else {
      return Container();
    }
  }

  Widget buildStarComponent(int id) {
    if (id == null) return Container();
    return FutureBuilder(
        future: getStarService(id),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<MovieStarModel> stars = [];
            snapshot.data?.data.forEach((item) {
              stars.add(MovieStarModel.fromJson(item));
            });
            if (stars.length > 0) {
              return Container(
                  decoration: ThemeStyle.boxDecoration,
                  margin: ThemeStyle.margin,
                  child: Padding(
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
                              width: MediaQuery.of(context).size.width -
                                  ThemeSize.containerPadding * 2,
                              height: ThemeSize.modualHeight,
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
                                                      stars[index].img),
                                                  fit: BoxFit.cover,
                                                ))),
                                        SizedBox(height: 5),
                                        Text(
                                          stars[index].starName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          stars[index].role ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  187, 187, 187, 1)),
                                        ),
                                      ]),
                                    );
                                  }))
                        ]),
                    padding: ThemeStyle.padding,
                  ));
            } else {
              return Container();
            }
          }
        });
  }
}
