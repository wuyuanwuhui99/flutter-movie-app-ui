import 'package:flutter/material.dart';
import 'package:movie/service/serverMethod.dart';
import './MovieListComponent.dart';
import '../model/MovieDetailModel.dart';
import '../theme/ThemeStyle.dart';
import './TitleComponent.dart';
/*-----------------------分类电影------------------------*/
class CategoryComponent extends StatelessWidget {
  final String category, classify;
  const CategoryComponent({Key key, this.category, this.classify})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCategoryListService(this.category, this.classify),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          }
          var result = snapshot.data;
          List<MovieDetailModel> categoryList = [];
          if (result != null && result['data'] != null) {
            categoryList = (result['data'] as List).cast().map((item){
              return MovieDetailModel.fromJson(item);
            }).toList();
          }
          return Container(decoration: ThemeStyle.boxDecoration,
            margin: ThemeStyle.margin,
            padding: ThemeStyle.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleComponent(title: category),
                MovieListComponent(movieList: categoryList,direction: "horizontal",)
              ],
            ),
          );
//          return MovieListComponent(movieList: categoryList,title: category,direction: "horizontal",);
        });
  }
}
/*-----------------------分类电影------------------------*/