import 'package:flutter/material.dart';
import '../config/service_url.dart';
import '../provider/UserInfoProvider.dart';
import '../pages/user_page.dart';
import 'package:provider/provider.dart';

/*-----------------------头像组件------------------------*/
class AvaterComponent extends StatelessWidget {
  const AvaterComponent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UserPage()));
      },
      child: Container(
          width: 40,
          height: 40,
          child: ClipOval(
            child: Image.network(
              //从全局的provider中获取用户信息
              serviceUrl +
                  Provider.of<UserInfoProvider>(context).userInfo["avater"],
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
          )),
    );
  }
}
/*-----------------------头像组件------------------------*/