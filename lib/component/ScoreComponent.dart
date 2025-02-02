import 'package:flutter/material.dart';

class ScoreComponent extends StatelessWidget {
  final double? score;
  const ScoreComponent({super.key,this.score});

  @override
  Widget build(BuildContext context) {
    List<Widget> result = [];
    if (score == null) {
      result.add(Container());
    } else {
      double count = score! / 2;
      var integer = count.floor();
      for (var i = 0; i < integer; i++) {
        //实心星星
        result
          ..add(Image.asset("lib/assets/images/icon_full_star.png",
              width: 15, height: 15))
          ..add(SizedBox(width: 5));
      }
      var temp = (count * 10 / 5) / 2;
      if (count.round() - temp.floor() == 0.5) {
        //半个星星
        result
          ..add(Image.asset("lib/assets/images/icon_half_star.png",
              width: 15, height: 15))
          ..add(SizedBox(width: 5));
      }
      var leftover = 5 - result.length / 2;
      for (int i = 0; i < leftover; i++) {
        //空心星星
        result
          ..add(Image.asset("lib/assets/images/icon_empty_star.png",
              width: 15, height: 15))
          ..add(SizedBox(width: 5));
      }
      result.add(Text(
        score.toString(),
        style: TextStyle(
            color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),
      ));
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: result,
    );
  }
}
/*-----------------------获取得分星星------------------------*/
