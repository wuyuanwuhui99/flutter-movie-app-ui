class UserInfoModel{
  String avater;
  String birthday;
  String createDate;
  String email;
  String role;
  String sex;
  String telephone;
  String updateDate;
  String userId;
  String username;
  String sign;
  String region;
  UserInfoModel({
    this.avater,
    this.birthday,
    this.createDate,
    this.email,
    this.role,
    this.sex,
    this.telephone,
    this.updateDate,
    this.userId,
    this.username,
    this.sign,
    this.region
  });
  //工厂模式-用这种模式可以省略New关键字
  factory UserInfoModel.fromJson(dynamic json){
    return UserInfoModel(
      avater: json["avater"],
      birthday: json["birthday"],
      createDate: json["createDate"],
      email: json["email"],
      role: json["role"],
      sex: json["sex"],
      telephone: json["telephone"],
      updateDate: json["updateDate"],
      userId: json["userId"],
      username: json["username"],
      sign: json["sign"],
      region: json["region"],
    );
  }
}