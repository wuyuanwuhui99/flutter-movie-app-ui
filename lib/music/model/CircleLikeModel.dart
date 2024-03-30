class CircleLikeModel{
  int id;
  int relationId;// 朋友圈id
  String type;// 类型
  String userId;// 用户id
  String username;// 用户名称
  String createTime;// 创建时间
  String updateTime;// 更新时间

  CircleLikeModel({
    this.id,
    this.type,
    this.relationId,
    this.userId,
    this.username,
    this.createTime,
    this.updateTime
  });

  //工厂模式-用这种模式可以省略New关键字
  factory CircleLikeModel.fromJson(dynamic json){
    return CircleLikeModel(
        id: json["id"],
        type: json['type'],
        relationId: json["relationId"],
        userId: json["userId"],
        username: json["username"],
        createTime: json["createTime"],
        updateTime: json["updateTime"]
    );
  }

  //工厂模式-用这种模式可以省略New关键字
  Map<String,dynamic> toMap(){
    return {
      "id": id,
      "type": type,
      "relationId": relationId,
      "userId": userId,
      "username": username,
      "createTime": createTime,
      "updateTime": updateTime
    };
  }
}