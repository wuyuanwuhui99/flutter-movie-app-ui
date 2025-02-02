class MovieUrlModel{
  int id;//主键
  String movieName;//电影名称
  int movieId;//对应的电影的id
  String href;//源地址
  String? label;//集数
  String? createTime;//创建时间
  String? updateTime;//更新时间
  String url;//播放地址
  String? playGroup;//播放分组，1, 2
  MovieUrlModel({
    required this.id,
    required this.movieName,
    required this.movieId,
    required this.href,
    this.label,
    this.createTime,
    this.updateTime,
    required this.url,
    this.playGroup
  });
  //工厂模式-用这种模式可以省略New关键字
  factory MovieUrlModel.fromJson(dynamic json){
    return MovieUrlModel(
        id:json["id"],
        movieName:json["movieName"],
        movieId:json["movieId"],
        href:json["href"],
        label:json["label"],
        createTime:json["createTime"].toString(),
        updateTime:json["updateTime"].toString(),
        url:json["url"],
        playGroup: json["playGroup"]
    );
  }
}