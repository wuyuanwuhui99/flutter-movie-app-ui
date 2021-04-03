import 'package:flutter/material.dart';
import 'package:movie/service/server_method.dart';
import './MovieListComponent.dart';

/*-----------------------获取推荐的影片------------------------*/
class YouLikesComponent extends StatelessWidget {
  final String label;
  const YouLikesComponent({Key key,this.label}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getYourLikes(label),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          }else{
            List movieList = snapshot.data["data"];
            return MovieListComponent(movieList: movieList,title: "猜你想看",direction: "horizontal",);
          }
        });
  }
}
/*-----------------------获取推荐的影片------------------------*/
