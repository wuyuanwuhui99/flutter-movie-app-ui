import 'dart:convert';

class FavoriteDirectoryModel{
  int id;
  String name;// 收藏夹名称
  String userId;// 用户id
  int total;// 收藏夹总歌曲数
  String cover;
  int checked;
  String createTime;// 创建时间
  String updateTime;// 更新时间

  FavoriteDirectoryModel({
    this.id,
    this.name,
    this.userId,
    this.total,
    this.cover,
    this.checked,
    this.createTime,
    this.updateTime
  });

  //工厂模式-用这种模式可以省略New关键字
  factory FavoriteDirectoryModel.fromJson(dynamic json){
    return FavoriteDirectoryModel(
        id: json["id"],
        name: json["name"],
        userId: json["userId"],
        total:json["total"],
        cover:json["cover"],
        checked:json["checked"],
        createTime: json["createTime"],
        updateTime: json["updateTime"]
    );
  }

  //工厂模式-用这种模式可以省略New关键字
  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "name": name,
      "userId": userId,
      "total":total,
      "cover":cover,
      "checked":checked,
      "createTime": createTime,
      "updateTime": updateTime
    };
  }

  static String stringify(FavoriteDirectoryModel favoriteDirectoryModel) {
    return json.encode(favoriteDirectoryModel.toMap());
  }
}