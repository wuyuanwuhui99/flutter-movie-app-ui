import 'package:flutter/material.dart';
import 'package:movie/service/serverMethod.dart';
import './MovieListComponent.dart';
import '../model/MovieDetailModel.dart';
/*-----------------------获取推荐的影片------------------------*/
class YouLikesComponent extends StatelessWidget {
  final String label;
  const YouLikesComponent({Key key,this.label}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getYourLikesService(label),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          }else{
            List<MovieDetailModel> movieList = (snapshot.data["data"] as List).cast().map((item){
              return MovieDetailModel.fromJson(item);
            }).toList();
            return MovieListComponent(movieList: movieList,title: "猜你想看",direction: "horizontal",);
          }
        });
  }
}
/*-----------------------获取推荐的影片------------------------*/
