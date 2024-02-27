class SingerCategoryModel{
  String category;// 分类名称

  SingerCategoryModel({
    this.category,
  });

  //工厂模式-用这种模式可以省略New关键字
  factory SingerCategoryModel.fromJson(dynamic json){
    return SingerCategoryModel(
        category: json["category"]
    );
  }
}