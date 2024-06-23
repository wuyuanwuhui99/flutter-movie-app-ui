import 'package:flutter/material.dart';
import '../service/serverMethod.dart';
import '../../theme/ThemeStyle.dart';
import '../../theme/ThemeColors.dart';
import '../model/FavoriteModel.dart';

class FavoriteComponent extends StatefulWidget {
  final int musicId;
  FavoriteComponent({Key key,this.musicId}) : super(key: key);

  @override
  _FavoriteComponentState createState() => _FavoriteComponentState();
}

class _FavoriteComponentState extends State<FavoriteComponent>{
  List<FavoriteModel> favoriteDirectory = [];// 收藏夹
  List<bool> selectedValues = [];

  @override
  void initState() {
    super.initState();
    getFavoriteDirectoryService().then((value){
      setState(() {
        value.data.forEach((item) {
          favoriteDirectory.add(FavoriteModel.fromJson(item));
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
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: this.favoriteDirectory.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        title: Text(this.favoriteDirectory[index].name),
                        value: selectedValues[index],
                        selected: selectedValues[index],
                        onChanged: (value) {
                          setState(() {
                            selectedValues[index] = value;
                          });
                        },
                      );
                    })
            ))
      ],
    );
  }
}