class MovieDetailModel {
  int id; //主键
  int? movieId; //电影id
  String movieName; //电影名称
  String? director; //导演
  String? star; //主演
  String? type; //类型
  String? countryLanguage; //国家/语言
  String? viewingState; //观看状态
  String? releaseTime; //上映时间
  String? plot; //剧情
  String? updateTime; //更新时间
  String? isRecommend; //是否推荐，0:不推荐，1:推荐
  String img; //电影海报
  String? classify; //分类 电影,电视剧,动漫,综艺,新片库,福利,午夜,恐怖,其他
  String sourceName; //来源名称，本地，骑士影院，爱奇艺
  String sourceUrl; //来源地址
  String? createTime; //创建时间
  String localImg; //本地图片
  String? label; //标签
  String? description; //简单描述
  String? useStatus; //0代表未使用，1表示正在使用，是banner和carousel图的才有
  double? score; //评分
  String? category; //类目，值为banner首屏，carousel：滚动轮播
  String? ranks; //排名
  String? doubanUrl; //对应豆瓣网的地址
  String? duration;// 时长
  String? privilegeId;// 权限
  MovieDetailModel(
      {
        required this.id,
        this.movieId,
        required this.movieName,
        this.director,
        this.star,
        this.type,
      this.countryLanguage,
      this.viewingState,
        this.releaseTime,
        this.plot,
      this.updateTime,
      this.isRecommend,
        required this.img,
      this.classify,
        required this.sourceName,
        required this.sourceUrl,
      this.createTime,
        required this.localImg,
      this.label,
      this.description,
      this.useStatus,
      this.score,
      this.category,
      this.ranks,
      this.doubanUrl});

  //工厂模式-用这种模式可以省略New关键字
  factory MovieDetailModel.fromJson(dynamic json) {
    return MovieDetailModel(
        id: json["id"],
        movieId: json["movieId"],
        movieName: json["movieName"],
        director: json["director"],
        star: json["star"],
        type: json["type"],
        countryLanguage: json["countryLanguage"],
        viewingState: json["viewingState"],
        releaseTime: json["releaseTime"],
        plot: json["plot"],
        updateTime: json["updateTime"].toString(),
        isRecommend: json["isRecommend"],
        img: json["img"],
        classify: json["classify"],
        sourceName: json["sourceName"],
        sourceUrl: json["sourceUrl"],
        createTime: json["createTime"].toString(),
        localImg: json["localImg"],
        label: json["label"],
        description: json["description"],
        useStatus: json["useStatus"],
        score: json["score"],
        category: json["category"],
        ranks: json["ranks"],
        doubanUrl: json["doubanUrl"]);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, //主键
      'movieId': movieId, //电影id
      'movieName': movieName, //电影名称
      'director': director, //导演
      'star': star, //主演
      'type': type, //类型
      'countryLanguage': countryLanguage, //国家/语言
      'viewingState': viewingState, //观看状态
      'releaseTime': releaseTime, //上映时间
      'plot': plot, //剧情
      'updateTime': updateTime, //更新时间
      'isRecommend': isRecommend, //是否推荐，0:不推荐，1:推荐
      'img': img, //电影海报
      'classify': classify, //分类 电影,电视剧,动漫,综艺,新片库,福利,午夜,恐怖,其他
      'sourceName': sourceName, //来源名称，本地，骑士影院，爱奇艺
      'sourceUrl': sourceUrl, //来源地址
      'createTime': createTime, //创建时间
      'localImg': localImg, //本地图片
      'label': label, //标签
      'description': description, //简单描述
      'useStatus': useStatus, //0代表未使用，1表示正在使用，是banner和carousel图的才有
      'score': score, //评分
      'category': category, //类目，值为banner首屏，carousel：滚动轮播
      'ranks': ranks, //排名
      'doubanUrl': doubanUrl //对应豆瓣网的地址
    };
  }
}
