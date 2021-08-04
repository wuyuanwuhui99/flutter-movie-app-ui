import 'package:flutter/material.dart';
import '../pages/detail_page.dart';
import '../config/service_url.dart';
import '../model/MovieDetailModel.dart';

/*-----------------------获取推荐的影片------------------------*/
class MovieListComponent extends StatelessWidget {
  final String title;
  final List<MovieDetailModel> movieList;
  final String direction;
  const MovieListComponent({Key key,this.movieList,this.title="",this.direction}) : super(key: key);

  List<Widget> _items(BuildContext context) {
    int index = -1;
    var tempList = movieList.map((item) {
      index++;
      return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetailPage(
                            movieItem: item)));
          },
          child: direction == "verital" ?
            Container(
              alignment: Alignment.center,
              child: movieItemWidget(item,index))
              : movieItemWidget(item,index)

      );
    });
    return tempList.toList();
  }

  Widget movieItemWidget(MovieDetailModel item,int index){
    return Container(
      width: 150,
      height: 200,
      margin: EdgeInsets.only(left: direction == "horizontal" && index > 0 ? 10 : 0),
      child: Column(
        children: <Widget>[
          ClipRRect(
              borderRadius:
              BorderRadius.circular(10),
              child: Image(
                  width: 150,
                  height: 200,
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      item.localImg !=null ? serviceUrl +item.localImg: item.img))),
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
        return  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 15),
              title != "" ? Container(
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        width: 3, //宽度
                        color: Colors.blue, //边框颜色
                      ),
                    ),
                  ),
                  child: Text(title))
              : SizedBox(),
              SizedBox(height: title != "" ? 10 : 0),
              direction == "vertical" ?
               GridView.count(
                    crossAxisSpacing: 10, //水平子 Widget 之间间距
                    crossAxisCount: 3, //一行的 Widget 数量
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio:0.55,
                    children: this._items(context))
                :
                  Container(
                      height: 240,
                      width: MediaQuery.of(context).size.width - 40,
                      child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: this._items(context),
                  ))

            ]
        );

  }
}
/*-----------------------获取推荐的影片------------------------*/
