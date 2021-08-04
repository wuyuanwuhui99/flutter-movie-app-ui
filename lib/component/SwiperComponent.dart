import 'package:flutter/material.dart';
import 'package:movie/service/server_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../config/service_url.dart';
import "../pages/detail_page.dart";
import '../model/MovieDetailModel.dart';

/*-----------------------轮播组件------------------------*/
class SwiperComponent extends StatelessWidget {
  final String classify;
  const SwiperComponent({Key key, this.classify}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCategoryListService("轮播", classify),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          }
          var result = snapshot.data;
          List<MovieDetailModel> swiperDataList = [];
          if (result != null && result['data'] != null) {
            swiperDataList = (result['data'] as List).cast().map((item){
              return MovieDetailModel.fromJson(item);
            }).toList(); // 顶部轮播组件数
          }
          print(swiperDataList);
          return Container(
              height: 200.0,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.network(
                    swiperDataList[index].localImg != null
                        ? serviceUrl + swiperDataList[index].localImg
                        : swiperDataList[index].img,
                    height: 200,
                    fit: BoxFit.fitHeight,
                  );
                },
                itemCount: swiperDataList.length,
                // viewportFraction: 0.9,
                // scale: 0.9,
                pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                      color: Colors.black54,
                      activeColor: Colors.white,
                    )),
                control: SwiperControl(),
                scrollDirection: Axis.horizontal,
                // viewportFraction: 0.8,
                // scale: 0.9,
                autoplay: true,
                loop: true,
                onTap: (index) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(movieItem: swiperDataList[index])));
                },
              ));
        });
  }
}
/*-----------------------轮播组件------------------------*/