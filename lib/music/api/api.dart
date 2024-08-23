const servicePath = {
  'getKeywordMusic': '/service/myMusic/getKeywordMusic',//获取搜索关键词
  'getMusicClassify': '/service/myMusic/getMusicClassify',//获取分类歌曲
  'getMusicListByClassifyId': '/service/myMusic/getMusicListByClassifyId',//获取推荐音乐列表
  'getMusicAuthorList': '/service/myMusic/getMusicAuthorList',// 获取歌手列表
  'getCircleListByType': '/service/circle/getCircleListByType',// 获取歌手列表
  'getMyLikeMusicAuthor': '/service/myMusic-getway/getMyLikeMusicAuthor',// 获取我关注的歌手
  'getMusicRecord': '/service/myMusic-getway/getMusicRecord',// 获取播放记录
  'insertMusicRecord': '/service/myMusic-getway/insertMusicRecord',// 记录播放日志
  'insertMusicLike': '/service/myMusic-getway/insertMusicLike/',// 插入收藏
  'deleteMusicLike': '/service/myMusic-getway/deleteMusicLike/',// 删除收藏
  'queryMusicLike': '/service/myMusic-getway/queryMusicLike',// 查询收藏
  'searchMusic': '/service/myMusic/searchMusic',// 音乐搜索
  'getMusicAuthorCategory':'/service/myMusic/getMusicAuthorCategory',// 获取歌手分类
  'saveLike':'/service/social-getway/saveLike',// 新增点赞
  'deleteLike': '/service/social-getway/deleteLike',// 删除点赞
  'insertComment':'/service/social-getway/insertComment',// 新增评论
  'getTopCommentList':'/service/social/getTopCommentList',// 获取一级评论列表
  'getCommentCount': '/service/social/getCommentCount',// 获取评论总数
  'isMusicFavorite':'/service/myMusic-getway/isMusicFavorite/', // 查询音乐是否收藏
  'getFavoriteDirectory':'/service/myMusic-getway/getFavoriteDirectory',// 查询收藏夹
  'insertMusicFavorite':'/service/myMusic-getway/insertMusicFavorite/',// 查询收藏夹
  'insertFavoriteDirectory':'/service/myMusic-getway/insertFavoriteDirectory',// 创建收藏夹
  'insertCircle':'/service/circle-getway/insertCircle',// 插入一条朋友圈说说
  'getMusicListByFavoriteId':'/service/myMusic-getway/getMusicListByFavoriteId'// 按照收藏夹的id查询音乐列表
};
