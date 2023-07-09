class MuiscMySingerModel{
  int id;//主键
  String authorId;// 歌手id
  String authorName;// 歌单名称
  String userId;// 用户id
  String avatar;// 歌手头像
  int total;// 歌单里面的歌曲总数
  String createTime;// 创建时间
  String updateTime;// 更新时间

  MuiscMySingerModel({
    this.id,
    this.authorId,
    this.authorName,
    this.userId,
    this.avatar,
    this.total,
    this.createTime,
    this.updateTime
  });
  //工厂模式-用这种模式可以省略New关键字
  factory MuiscMySingerModel.fromJson(dynamic json){
    return MuiscMySingerModel(
        id: json["id"],
        authorId: json["authorId"],
        authorName: json["authorName"],
        userId: json["userId"],
        total: json["total"],
        avatar: json["avatar"],
        createTime: json["createTime"],
        updateTime: json["updateTime"]
    );
  }
}