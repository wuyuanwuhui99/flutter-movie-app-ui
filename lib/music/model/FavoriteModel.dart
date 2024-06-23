class FavoriteModel{
  int id;
  String name;// 收藏夹名称
  String userId;// 用户id
  String createTime;// 创建时间
  String updateTime;// 更新时间

  FavoriteModel({
    this.id,
    this.name,
    this.userId,
    this.createTime,
    this.updateTime
  });

  //工厂模式-用这种模式可以省略New关键字
  factory FavoriteModel.fromJson(dynamic json){
    return FavoriteModel(
        id: json["id"],
        name: json["name"],
        userId: json["userId"],
        createTime: json["createTime"],
        updateTime: json["updateTime"]
    );
  }
}