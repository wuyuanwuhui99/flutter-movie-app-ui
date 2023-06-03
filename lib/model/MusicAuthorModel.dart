class MusicAuthorModel {
  int id;//主键
  int authorId;// 歌手id
  String authorName;// 歌手名称
  String language;// 语言
  int isPublish;// 是否发布
  String avatar;// 头像
  int type;// 类型
  String country;// 国家
  String birthday;// 生日
  int identity;// 身份
  int rank;// 排名
  String createTime;// 创建时间
  String updateTime;// 更新时间

  MusicAuthorModel(
      {this.id,
      this.authorId,
      this.authorName,
      this.language,
      this.isPublish,
      this.avatar,
      this.type,
      this.country,
      this.birthday,
      this.identity,
      this.rank,
      this.createTime,
      this.updateTime
  });

  //工厂模式-用这种模式可以省略New关键字
  factory MusicAuthorModel.fromJson(dynamic json) {
    return MusicAuthorModel(
        id: json["id"],
        authorId: json["authorId"],
        authorName: json["authorName"],
        language: json["language"],
        isPublish: json["isPublish"],
        avatar: json["avatar"],
        type: json["type"],
        country: json["country"],
        birthday: json["birthday"],
        identity: json["identity"],
        rank: json["rank"],
        createTime: json["createTime"],
        updateTime: json["updateTime"]
    );
  }
}
