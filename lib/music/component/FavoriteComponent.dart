import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../common/constant.dart';
import 'package:movie/theme/ThemeSize.dart';
import '../service/serverMethod.dart';
import '../../theme/ThemeStyle.dart';
import '../../theme/ThemeColors.dart';
import '../model/FavoriteDirectoryModel.dart';

class FavoriteComponent extends StatefulWidget {
  final int musicId;
  final bool isFavorite;
  final Function onFavorite;

  FavoriteComponent({Key key, this.musicId, this.isFavorite, this.onFavorite})
      : super(key: key);

  @override
  _FavoriteComponentState createState() => _FavoriteComponentState();
}

class _FavoriteComponentState extends State<FavoriteComponent> {
  List<FavoriteDirectoryModel> favoriteDirectory = []; // 收藏夹
  List<int> selectedValues = [];// 选中的收藏夹id
  bool isCreateFavoriteDirectory = false; // 是否显示创建收藏夹界面
  TextEditingController favoriteNameController = TextEditingController();
  bool disableCreateBtn = true;

  @override
  void initState() {
    super.initState();
    getFavoriteDirectoryService(widget.musicId).then((value) {
      setState(() {
        value.data.forEach((item) {
          FavoriteDirectoryModel favoriteDirectoryModel =
              FavoriteDirectoryModel.fromJson(item);
          favoriteDirectory.add(favoriteDirectoryModel);
          if (favoriteDirectoryModel.checked == 1)
            selectedValues.add(favoriteDirectoryModel.id);
        });
      });
    });
  }

  ///@author: wuwenqiang
  ///@description: 音乐收藏夹列表
  ///@date: 2024-07-3 22:15
  Widget buildFavoriteDirectory() {
    return SingleChildScrollView(
      child: Column(
        children: [
          InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(ThemeSize.middleRadius),
                    child: Container(
                        decoration: BoxDecoration(color: ThemeColors.colorBg),
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
              onTap: () {
                setState(() {
                  isCreateFavoriteDirectory = true;
                });
              }),
          Column(
              children: this.favoriteDirectory.map((item) {
            return Column(children: [
              SizedBox(height: ThemeSize.containerPadding),
              Row(
                children: [
                  item.cover == null
                      ? Container(
                          width: ThemeSize.bigAvater,
                          height: ThemeSize.bigAvater,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ThemeSize.middleRadius)),
                              color: ThemeColors.colorBg),
                          child: Center(
                              child: Image.asset(
                            "lib/assets/images/icon_music_default_cover.png",
                            width: ThemeSize.middleIcon,
                            height: ThemeSize.middleIcon,
                          )))
                      : ClipRRect(
                          borderRadius:
                              BorderRadius.circular(ThemeSize.middleRadius),
                          child: Image.network(HOST + item.cover,
                              width: ThemeSize.bigAvater,
                              height: ThemeSize.bigAvater)),
                  SizedBox(width: ThemeSize.containerPadding),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name),
                          SizedBox(height: ThemeSize.smallMargin),
                          Text(
                            item.total.toString() + "首",
                            style: TextStyle(color: ThemeColors.disableColor),
                          )
                        ],
                      ),
                      flex: 1),
                  Checkbox(
                      value: item.checked == 1,
                      onChanged: (value) {
                        setState(() {
                          item.checked = value ? 1 : 0;
                          this.selectedValues.clear();
                          this.favoriteDirectory.forEach((item) {
                            if (item.checked == 1)
                              this.selectedValues.add(item.id);
                          });
                        });
                      })
                ],
              )
            ]);
          }).toList())
        ],
      ),
    );
  }

  ///@author: wuwenqiang
  ///@description: 创建音乐收藏夹
  ///@date: 2024-07-3 22:15
  Widget buildCreateFavoriteDirectory() {
    return Column(
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(
            '*',
            style: TextStyle(color: Colors.red),
          ),
          Text('名称'),
          SizedBox(width: ThemeSize.containerPadding),
          Expanded(
            flex: 1,
            child: Container(
                height: ThemeSize.buttonHeight,
                padding: EdgeInsets.only(left: ThemeSize.containerPadding),
                decoration: BoxDecoration(
                    color: ThemeColors.colorBg,
                    borderRadius: BorderRadius.all(
                        Radius.circular(ThemeSize.middleRadius))),
                child: TextField(
                  onChanged: (String value){
                    setState(() {
                      disableCreateBtn = value == '';
                    });
                  },
                    textAlign: TextAlign.start,
                    controller: favoriteNameController,
                    cursorColor: Colors.grey, //设置光标
                    decoration: InputDecoration(
                      hintText: "请输入收藏夹名称",
                      hintStyle: TextStyle(
                          fontSize: ThemeSize.smallFontSize,
                          color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.only(bottom: ThemeSize.smallMargin),
                    ))
            ),
          )
        ]),
        SizedBox(height: ThemeSize.containerPadding),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Opacity(
                opacity: 0,
                child: Text('*', style: TextStyle(color: Colors.red))),
            Text('封面'),
            SizedBox(width: ThemeSize.containerPadding),
            Container(
              decoration: BoxDecoration(
                  color: ThemeColors.colorBg,
                  borderRadius: BorderRadius.all(
                      Radius.circular(ThemeSize.middleRadius))),
              width: ThemeSize.bigAvater,
              height: ThemeSize.bigAvater,
              child: Center(
                child: Image.asset('lib/assets/images/icon_add.png',
                    width: ThemeSize.middleIcon, height: ThemeSize.middleIcon),
              ),
            )
          ],
        ),
        SizedBox(height: ThemeSize.containerPadding),
        Opacity(opacity: disableCreateBtn ? 0.5 : 1,child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius:
            BorderRadius.all(Radius.circular(ThemeSize.superRadius)),
          ),
          width: double.infinity,
          height: ThemeSize.buttonHeight,
          child: InkWell(
              onTap: () {
                if(favoriteNameController.text == ''){
                  return Fluttertoast.showToast(
                      msg: "请输入收藏夹名称",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 1,
                      textColor: Colors.white,
                      fontSize: ThemeSize.middleFontSize);
                }
                insertFavoriteDirectoryService(FavoriteDirectoryModel(name:favoriteNameController.text,cover:null)).then((value){
                  Fluttertoast.showToast(
                      msg: "创建收藏夹成功",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 1,
                      textColor: Colors.white,
                      fontSize: ThemeSize.middleFontSize);
                  favoriteNameController.text = '';
                  setState(() {
                    favoriteDirectory.insert(0, FavoriteDirectoryModel.fromJson(value.data));
                    isCreateFavoriteDirectory = false;
                  });
                });
              },
              child: Center(
                  child: Text(
                    '创建',
                    style: TextStyle(color: ThemeColors.colorWhite),
                  ))),
        )),
        SizedBox(height: ThemeSize.containerPadding),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: ThemeColors.borderColor),
            borderRadius:
                BorderRadius.all(Radius.circular(ThemeSize.superRadius)),
          ),
          height: ThemeSize.buttonHeight,
          child: InkWell(
              onTap: () {
                setState(() {
                  isCreateFavoriteDirectory = false;
                });
              },
              child: Center(child: Text('取消'))),
        )
      ],
    );
  }

  ///@author: wuwenqiang
  ///@description: 创建音乐收藏夹
  ///@date: 2024-07-3 22:15
  Widget buildAddBtnWidget() {
    return Container(
      margin: EdgeInsets.all(ThemeSize.containerPadding),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(ThemeSize.superRadius)),
      ),
      width: double.infinity,
      height: ThemeSize.buttonHeight,
      child: InkWell(
          onTap: !widget.isFavorite && selectedValues.length == 0
              ? null
              : () {
                  insertMusicFavoriteService(widget.musicId, selectedValues)
                      .then((value) {
                    if (value.data > 0) {
                      Fluttertoast.showToast(
                          msg: selectedValues.length > 0 ? "收藏成功" : "取消收藏成功",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 1,
                          textColor: Colors.white,
                          fontSize: ThemeSize.middleFontSize);
                      widget.onFavorite(selectedValues.length > 0);
                    }
                  });
                },
          child: Center(
              child: Text(
            widget.isFavorite && selectedValues.length == 0
                ? '取消收藏'
                : '添加${selectedValues.length > 0 ? '（已选${selectedValues.length}个）' : ''}',
            style: TextStyle(color: ThemeColors.colorWhite),
          ))),
    );
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
              child: isCreateFavoriteDirectory
                  ? buildCreateFavoriteDirectory()
                  : buildFavoriteDirectory(),
            )),
        isCreateFavoriteDirectory ? SizedBox() : buildAddBtnWidget(),
      ],
    );
  }
}
