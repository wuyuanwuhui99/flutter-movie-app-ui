class MusicClassifyModel {
  String classifyName; // 分类时间
  int classifyRank; // 分类排名

  MusicClassifyModel({
    this.classifyName,
    this.classifyRank,
  });

  //工厂模式-用这种模式可以省略New关键字
  factory MusicClassifyModel.fromJson(dynamic json) {
    return MusicClassifyModel(
        classifyName: json["classifyName"], //主键
        classifyRank: json["classifyRank"] // 专辑id
        );
  }
}
