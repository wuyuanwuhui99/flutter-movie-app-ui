import 'package:flutter/material.dart';
import '../router/index.dart';
import '../common/constant.dart';
import '../provider/UserInfoProvider.dart';
import 'package:provider/provider.dart';

/*-----------------------头像组件------------------------*/
class AvaterComponent extends StatelessWidget {
  final double size;
  const AvaterComponent({super.key,required this.size});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Routes.router.navigateTo(context, '/UserPage');
      },
      child: Container(
          width: size,
          height: size,
          child: ClipOval(
            child: Image.network(
              //从全局的provider中获取用户信息
              HOST +
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