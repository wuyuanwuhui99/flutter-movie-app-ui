import 'package:flutter/material.dart';
import 'package:movie/config/common.dart';
import 'package:movie/theme/ThemeSize.dart';
import '../service/serverMethod.dart';
import '../../theme/ThemeStyle.dart';
import '../../theme/ThemeColors.dart';
import '../model/FavoriteDirectoryModel.dart';

class FavoriteComponent extends StatefulWidget {
  final int musicId;

  FavoriteComponent({Key key, this.musicId}) : super(key: key);

  @override
  _FavoriteComponentState createState() => _FavoriteComponentState();
}

class _FavoriteComponentState extends State<FavoriteComponent> {
  List<FavoriteDirectoryModel> favoriteDirectory = []; // 收藏夹
  List<bool> selectedValues = [];

  @override
  void initState() {
    super.initState();
    getFavoriteDirectoryService(widget.musicId).then((value) {
      setState(() {
        value.data.forEach((item) {
          favoriteDirectory.add(FavoriteDirectoryModel.fromJson(item));
          selectedValues.add(false);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: ThemeStyle.padding,
          child: Text("选择收藏夹"),
        ),
        Divider(height: 1, color: ThemeColors.borderColor),
        Expanded(
            flex: 1,
            child: Padding(
              padding: ThemeStyle.padding,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(ThemeSize.middleRadius),
                          child: Container(
                              decoration:
                                  BoxDecoration(color: ThemeColors.colorBg),
                              width: ThemeSize.bigAvater,
                              height: ThemeSize.bigAvater,
                              child: Center(
                                  child: Image.asset(
                                "lib/assets/images/icon_add.png",
                                width: ThemeSize.middleIcon,
                                height: ThemeSize.middleIcon,
                              ))),
                        ),
                        Text('新建收藏夹')
                      ],
                    ),
                    Column(children: this.favoriteDirectory.map((item) {
                          return Column(
                              children: [
                            SizedBox(height: ThemeSize.containerPadding),
                            Row(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        ThemeSize.middleRadius),
                                    child: item.cover != null
                                        ? Image.network(HOST + item.cover,
                                            width: ThemeSize.bigAvater,
                                            height: ThemeSize.bigAvater)
                                        : Container(
                                            width: ThemeSize.bigAvater,
                                            height: ThemeSize.bigAvater,
                                            decoration: BoxDecoration(
                                                color: ThemeColors.colorBg),
                                            child: Center(
                                                child: Image.asset(
                                              "lib/assets/images/icon_music_default_cover.png",
                                              width: ThemeSize.middleIcon,
                                              height: ThemeSize.middleIcon,
                                            )))),
                                SizedBox(width: ThemeSize.containerPadding),
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.name),
                                        SizedBox(height: ThemeSize.smallMargin),
                                        Text(item.total.toString() + "首",style: TextStyle(color:ThemeColors.disableColor),)
                                      ],
                                    ),
                                    flex: 1),
                                Checkbox(value: item.checked == 1, onChanged: (value){
                                  setState(() {
                                    item.checked = value ? 1 : 0;
                                  });
                                })
                              ],
                            )
                          ]);

                    }).toList())
                  ],
                ),
              ),
            ))
      ],
    );
  }
}
