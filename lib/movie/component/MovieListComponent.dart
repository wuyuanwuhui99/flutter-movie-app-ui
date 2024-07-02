import 'package:flutter/material.dart';
import '../pages/MovieDetailPage.dart';
import '../../config/common.dart';
import '../model/MovieDetailModel.dart';
import '../../theme/ThemeSize.dart';

/*-----------------------获取推荐的影片------------------------*/
class MovieListComponent extends StatelessWidget {
  final List<MovieDetailModel> movieList;
  final String direction;

  const MovieListComponent(
      {Key key, this.movieList, this.direction})
      : super(key: key);

  List<Widget> _items(BuildContext context) {
    int index = -1;
    var tempList = movieList.map((item) {
      index++;
      return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MovieDetailPage(movieItem: item)));
          },
          child: direction == "verital"
              ? Container(
                  alignment: Alignment.center,
                  child: movieItemWidget(item, index))
              : movieItemWidget(item, index));
    });
    return tempList.toList();
  }

  Widget movieItemWidget(MovieDetailModel item, int index) {
    return Container(
      width: ThemeSize.movieWidth,
      height: ThemeSize.movieHeight,
      margin: EdgeInsets.only(
          left: direction == "horizontal" && index > 0 ? 10 : 0),
      child: Column(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(ThemeSize.middleRadius),
              child: Image(
                  width: ThemeSize.movieWidth,
                  height: ThemeSize.movieHeight,
                  fit: BoxFit.fill,
                  image: NetworkImage(item.localImg != null
                      ? HOST + item.localImg
                      : item.img))),
          SizedBox(height: 10),
          Text(
            item.movieName,
            softWrap: true,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          direction == "vertical"
              ? GridView.count(
                  crossAxisSpacing: 10,
                  //水平子 Widget 之间间距
                  crossAxisCount: 3,
                  //一行的 Widget 数量
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  childAspectRatio: 0.55,
                  children: this._items(context))
              : Container(
                  height: 230,
                  width: MediaQuery.of(context).size.width -
                      ThemeSize.containerPadding * 2,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: this._items(context),
                  ))
        ]);
  }
}
/*-----------------------获取推荐的影片------------------------*/
