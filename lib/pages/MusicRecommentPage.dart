import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/serverMethod.dart';
import '../provider/UserInfoProvider.dart';
import '../component/MovieListComponent.dart';
import '../component/AvaterComponent.dart';
import '../model/UserInfoModel.dart';
import '../model/UserMsgModel.dart';
import '../theme/ThemeStyle.dart';
import '../theme/ThemeSize.dart';
import '../theme/ThemeColors.dart';


class MusicRecommentPage extends StatefulWidget {
  MusicRecommentPage({Key key}) : super(key: key);

  @override
  _MusicRecommentPageState createState() => _MusicRecommentPageState();
}

class _MusicRecommentPageState extends State<MusicRecommentPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("推荐"),
    );
  }
}

