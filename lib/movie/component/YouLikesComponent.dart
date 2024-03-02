import 'package:flutter/material.dart';
import '../service/serverMethod.dart';
import './MovieListComponent.dart';
import './TitleComponent.dart';
import '../model/MovieDetailModel.dart';
import '../../theme/ThemeStyle.dart';

/*-----------------------获取推荐的影片------------------------*/
class YouLikesComponent extends StatelessWidget {
  final String label;

  const YouLikesComponent({Key key, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getYourLikesService(label),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          } else {
            List<MovieDetailModel> movieList = [];
            snapshot.data.data.forEach((item) {
              movieList.add(MovieDetailModel.fromJson(item));
            });
            return Container(
                decoration: ThemeStyle.boxDecoration,
                margin: ThemeStyle.margin,
                child: Column(
                  children: <Widget>[
                    TitleComponent(title: "猜你想看"),
                    MovieListComponent(
                      movieList: movieList,
                      direction: "horizontal",
                    )
                  ],
                ));
          }
        });
  }
}
/*-----------------------获取推荐的影片------------------------*/
