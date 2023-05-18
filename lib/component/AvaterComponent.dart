import 'package:flutter/material.dart';
import '../config/serviceUrl.dart';
import '../provider/UserInfoProvider.dart';
import '../pages/UserPage.dart';
import 'package:provider/provider.dart';

/*-----------------------头像组件------------------------*/
class AvaterComponent extends StatelessWidget {
  final double size;
  const AvaterComponent({Key key,this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UserPage()));
      },
      child: Container(
          width: size,
          height: size,
          child: ClipOval(
            child: Image.network(
              //从全局的provider中获取用户信息
              movieServiceUrl +
                  Provider.of<UserInfoProvider>(context).userInfo.avater,
              height: size,
              width: size,
              fit: BoxFit.cover,
            ),
          )),
    );
  }
}
/*-----------------------头像组件------------------------*/