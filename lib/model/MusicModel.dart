class MusicModel {
  int id;//主键
  int albumId;// 专辑id
  String songName;// 歌曲名称
  String authorName;// 歌手名称
  int authorId;// 歌手id
  String albumName;// 专辑
  String version;// 版本
  String language;// 语言
  String publishDate;// 发布时间
  int wideAudioId;// 未使用字段
  int isPublish;// 是否发布
  int bigPackId;// 未使用字段
  int finalId;// 未使用字段
  int audioId;// 音频id
  int similarAudioId;// 未使用字段
  int isHot;// 是否热门
  int albumAudioId;// 音频专辑id
  int audioGroupId;// 歌曲组id
  String cover;// 歌曲图片
  String playUrl;// 网络播放地址
  String localPlayUrl;// 本地播放地址
  String sourceName;// 歌曲来源
  String sourceUrl;// 来源地址
  String createTime;// 创建时间
  String updateTime;// 更新时间
  String label;// 标签
  String lyrics;// 歌词

  MusicModel(
      {this.id,//主键
  this.albumId,// 专辑id
  this.songName,// 歌曲名称
  this.authorName,// 歌手名称
  this.authorId,// 歌手id
  this.albumName,// 专辑
  this.version,// 版本
  this.language,// 语言
  this.publishDate,// 发布时间
  this.wideAudioId,// 未使用字段
  this.isPublish,// 是否发布
  this.bigPackId,// 未使用字段
  this.finalId,// 未使用字段
  this.audioId,// 音频id
  this.similarAudioId,// 未使用字段
  this.isHot,// 是否热门
  this.albumAudioId,// 音频专辑id
  this.audioGroupId,// 歌曲组id
  this.cover,// 歌曲图片
  this.playUrl,// 网络播放地址
  this.localPlayUrl,// 本地播放地址
  this.sourceName,// 歌曲来源
  this.sourceUrl,// 来源地址
  this.createTime,// 创建时间
  this.updateTime,// 更新时间
  this.label,// 标签
  this.lyrics,// 歌词
  });

  //工厂模式-用这种模式可以省略New关键字
  factory MusicModel.fromJson(dynamic json) {
    return MusicModel(
      id:json["id"],//主键
      albumId:json["albumId"],// 专辑id
      songName:json["songName"],// 歌曲名称
      authorName:json["authorName"],// 歌手名称
      authorId:json["authorId"],// 歌手id
      albumName:json["albumName"],// 专辑
      version:json["version"],// 版本
      language:json["language"],// 语言
      publishDate:json["publishDate"],// 发布时间
      wideAudioId:json["wideAudioId"],// 未使用字段
      isPublish:json["isPublish"],// 是否发布
      bigPackId:json["isPublish"],// 未使用字段
      finalId:json["finalId"],// 未使用字段
      audioId:json["audioId"],// 音频id
      similarAudioId:json["similarAudioId"],// 未使用字段
      isHot:json["isHot"],// 是否热门
      albumAudioId:json["albumAudioId"],// 音频专辑id
      audioGroupId:json["audioGroupId"],// 歌曲组id
      cover:json["cover"],// 歌曲图片
      playUrl:json["playUrl"],// 网络播放地址
      localPlayUrl:json["localPlayUrl"],// 本地播放地址
      sourceName:json["sourceName"],// 歌曲来源
      sourceUrl:json["sourceUrl"],// 来源地址
      createTime:json["createTime"],// 创建时间
      updateTime:json["updateTime"],// 更新时间
      label:json["label"],// 标签
      lyrics:json["lyrics"],// 歌词
    );
  }
}
