import 'package:flutter/material.dart';
import 'package:movie/theme/ThemeColors.dart';
import '../../utils/common.dart';

/*-----------------------头像组件------------------------*/
class MusicAvaterComponent extends StatelessWidget {
  final String avater;
  final double size;
  final String type;
  final String name;

  const MusicAvaterComponent({Key key, this.avater, this.size, this.type,this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == 'music'
        ? ClipOval(
            child: avater != null
                ? Image.network(
                    //从全局的provider中获取用户信息
                    getMusicCover(avater),
                    height: size,
                    width: size,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    //从全局的provider中获取用户信息
                    'lib/assets/images/default_cover.jpg',
                    height: size,
                    width: size,
                    fit: BoxFit.cover,
                  ))
        : (avater != null
            ? ClipOval(
                child: Image.network(
                //从全局的provider中获取用户信息
                getMusicCover(avater),
                height: size,
                width: size,
                fit: BoxFit.cover,
              ))
            : Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                    color: ThemeColors.colorBg,
                    borderRadius: BorderRadius.all(Radius.circular(size))),
                child: Center(child: Text(name)),
              )
    );
  }
}
/*-----------------------头像组件------------------------*/
