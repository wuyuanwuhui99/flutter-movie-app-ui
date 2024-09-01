import 'package:flutter/material.dart';
import '../../utils/common.dart';
import '../../theme/ThemeSize.dart';

/*-----------------------头像组件------------------------*/
class MusicAvaterComponent extends StatelessWidget {
  final String avater;
  final double size;
  const MusicAvaterComponent({Key key,this.avater,this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
        child: avater != null ?   Image.network(
          //从全局的provider中获取用户信息
          getMusicCover(avater),
          height: size,
          width: size,
          fit: BoxFit.cover,
        ): Image.asset(
          //从全局的provider中获取用户信息
          'lib/assets/images/default_cover.jpg',
          height: size,
          width: size,
          fit: BoxFit.cover,
        ));
  }
}
/*-----------------------头像组件------------------------*/