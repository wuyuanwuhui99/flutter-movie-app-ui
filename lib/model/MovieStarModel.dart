class MovieStarModel{
  int id;//主键
  String starName;//演员名称
  String img;//演员图片地址
  String localImg;//演员本地图片地址
  String? createTime;//创建时间
  String? updateTime;//更新时间
  String movieId;//对应电影的id
  String movieName;//对应电影的名称
  String? role;//角色
  String? href;//演员的豆瓣链接地址
  String? works;//代表作
  MovieStarModel({
    required this.id,
    required this.starName,
    required this.img,
    required this.localImg,
    this.createTime,
    this.updateTime,
    required this.movieId,
    required this.movieName,
    this.role,
    this.href,
    this.works,
  });
  //工厂模式-用这种模式可以省略New关键字
  factory MovieStarModel.fromJson(dynamic json){
    return MovieStarModel(
      id: json["id"],
      starName: json["starName"],
      img: json["img"],
      localImg: json["localImg"],
      createTime: json["createTime"].toString(),
      updateTime: json["updateTime"].toString(),
      movieId: json["movieId"],
      movieName: json["movieName"],
      role: json["role"],
      href: json["href"],
      works: json["works"],
    );
  }
}