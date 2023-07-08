class MuiscPlayMenuModel{
  int id;//主键
  String name;// 歌单名称
  String userId;// 用户id
  int total;// 歌单里面的歌曲总数
  String cover;// 歌单封面
  String createTime;// 创建时间
  String updateTime;// 更新时间

  MuiscPlayMenuModel({
    this.id,
    this.name,
    this.userId,
    this.total,
    this.cover,
    this.createTime,
    this.updateTime
  });
  //工厂模式-用这种模式可以省略New关键字
  factory MuiscPlayMenuModel.fromJson(dynamic json){
    return MuiscPlayMenuModel(
        id: json["id"],
        name: json["name"],
        userId: json["userId"],
        total: json["total"],
        cover: json["cover"],
        createTime: json["createTime"],
        updateTime: json["updateTime"]
    );
  }
}