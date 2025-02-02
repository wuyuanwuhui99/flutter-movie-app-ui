class CategoryModel {
  String category; //小分类
  String classify; //大分类

  CategoryModel({
    required this.category,
    required this.classify
  });

  //工厂模式-用这种模式可以省略New关键字
  factory CategoryModel.fromJson(dynamic json){
    return CategoryModel(
        category:json['category'],
        classify:json['classify']
    );
  }
}