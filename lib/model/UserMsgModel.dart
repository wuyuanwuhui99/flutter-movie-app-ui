class UserMsgModel{
  String userAge;//使用天数
  String favoriteCount;//收藏数
  String playRecordCount;//观看记录
  String viewRecordCount;//浏览记录

  UserMsgModel({
    required this.userAge,
    required this.favoriteCount,
    required this.playRecordCount,
    required this.viewRecordCount
  });
  //工厂模式-用这种模式可以省略New关键字
  factory UserMsgModel.fromJson(dynamic json){
    return UserMsgModel(
      userAge: json["userAge"],
      favoriteCount: json["favoriteCount"],
      playRecordCount: json["playRecordCount"],
      viewRecordCount: json["viewRecordCount"]
    );
  }
}