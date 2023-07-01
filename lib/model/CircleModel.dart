class CircleModel{
  int id;
  String relationId;// 关联音乐audio_id或者电影movie_id
  String content;// 朋友圈内容
  String imgs;// 朋友圈图片
  String type;// 类型
  String userId;// 用户id
  String username;// 用户的昵称
  String useravater;// 用户头像
  String createTime;// 创建时间
  String updateTime;// 更新时间
  String musicSongName;// 歌曲名称
  String musicAudioId;// 歌曲id
  String musicAuthorName;// 歌曲作者
  String musicAlbumName;// 专辑名称
  String musicCover;// 音乐图片
  String musicPlayUrl;// 音乐播放地址
  String musicLocalPlayUrl;// 音乐本地播放地址
  String musicLyrics;// 歌词
  String movieId;// 电影id
  String movieName;// 电影名称
  String movieDirector;// 电影导演
  String movieStar;// 电影主演
  String movieType;// 电影类型
  String movieCountryLanguage;// 电影上映国家
  String movieViewingState;// 电影状态
  String movieReleaseTime;// 上映时间
  String movieImg;// 电影海报
  String movieClassify;// 电影分类
  String movieLocalImg;// 电影本地图片
  String movieScore;// 电影得分

  CircleModel({
    this.id,
    this.relationId,
    this.content,
    this.imgs,
    this.type,
    this.userId,
    this.username,
    this.useravater,
    this.createTime,
    this.updateTime,
    this.musicSongName,
    this.musicAudioId,
    this.musicAuthorName,
    this.musicAlbumName,
    this.musicCover,
    this.musicPlayUrl,
    this.musicLocalPlayUrl,
    this.musicLyrics,
    this.movieId,
    this.movieName,
    this.movieDirector,
    this.movieStar,
    this.movieType,
    this.movieCountryLanguage,
    this.movieViewingState,
    this.movieReleaseTime,
    this.movieImg,
    this.movieClassify,
    this.movieLocalImg,
    this.movieScore
  });
  //工厂模式-用这种模式可以省略New关键字
  factory CircleModel.fromJson(dynamic json){
    return CircleModel(
        id: json["id"],
        relationId: json["relationId"],
        content: json["content"],
        imgs: json["imgs"],
        type: json["type"],
        userId: json["userId"],
        username: json["username"],
        useravater: json["useravater"],
        createTime: json["createTime"],
        updateTime: json["updateTime"],
        musicSongName: json["musicSongName"],
        musicAudioId: json["musicAudioId"],
        musicAuthorName: json["musicAuthorName"],
        musicAlbumName: json["musicAlbumName"],
        musicCover: json["musicCover"],
        musicPlayUrl: json["musicPlayUrl"],
        musicLocalPlayUrl: json["musicLocalPlayUrl"],
        musicLyrics: json["musicLyrics"],
        movieId: json["movieId"],
        movieName: json["movieName"],
        movieDirector: json["movieDirector"],
        movieStar: json["movieStar"],
        movieType: json["movieType"],
        movieCountryLanguage: json["movieCountryLanguage"],
        movieViewingState: json["movieViewingState"],
        movieReleaseTime: json["movieReleaseTime"],
        movieImg: json["movieImg"],
        movieClassify: json["movieClassify"],
        movieLocalImg: json["movieLocalImg"],
        movieScore: json["movieScore"],
    );
  }
}