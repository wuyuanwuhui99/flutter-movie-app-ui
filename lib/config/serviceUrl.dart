const host = 'http://192.168.137.1:5001';
const servicePath = {
  'getUserData': host + '/service/movie/getUserData', // 获取用户信息
  'getCategoryList': host + '/service/movie/getCategoryList', //获取分类影片
  'getKeyWord': host + '/service/movie/getKeyWord', //按照classify查询搜索栏的关键词
  'getAllCategoryByClassify': host + '/service/movie/getAllCategoryByClassify', //按classify大类查询所有catory小类
  'getAllCategoryListByPageName': host + '/service/movie/getAllCategoryListByPageName', //按页面获取要展示的category小类
  'getUserMsg': host + '/service/movie-getway/getUserMsg', //获取用户四个指标信息，使用天数，关注，观看记录，浏览记录
  'getSearchResult': host + '/service/movie/search', //搜索
  'login': host + '/service/movie/login', //登录
  'getStar': host + '/service/movie/getStar/', //获取演员
  'getMovieUrl': host + '/service/movie/getMovieUrl', //获取演员
  'getViewRecord': host + '/service/movie-getway/getViewRecord', //获取浏览记录
  'saveViewRecord': host + '/service/movie-getway/saveViewRecord', //浏览历史
  'getPlayRecord': host + '/service/movie-getway/getPlayRecord', //获取观看记录
  'savePlayRecord': host + '/service/movie-getway/savePlayRecord', //播放记录
  'getFavorite': host + '/service/movie-getway/getFavorite', //获取收藏电影
  'saveFavorite': host + '/service/movie-getway/saveFavorite', //添加收藏
  'deleteFavorite': host + '/service/movie-getway/deleteFavorite', //删除收藏
  'getYourLikes': host + '/service/movie/getYourLikes',//猜你想看
  'getRecommend': host + '/service/movie/getRecommend',//获取推荐
  'isFavorite': host + '/service/movie-getway/isFavorite',//查询是否已经收藏
  'updateUser': host + '/service/movie-getway/updateUser',//更新用户信息
  'updatePassword': host + '/service/movie-getway/updatePassword',//更新密码wq
  'getCommentCount':host + '/service/social/getCommentCount',//获取评论总数
  'getTopCommentList':host + '/service/social/getTopCommentList',//获取一级评论
  'getReplyCommentList':host + '/service/social/getReplyCommentList',//获取一级评论
  'insertCommentService':host + '/service/social-getway/insertComment',//新增评论
  'updateAvaterService':host + '/service/movie-getway/updateAvater',//更新头像
  'getKeywordMusic': host + '/service/myMusic/getKeywordMusic',//获取搜索关键词
  'getMusicClassify': host + '/service/myMusic/getMusicClassify',//获取分类歌曲
  'getMusicListByClassifyId': host + '/service/myMusic/getMusicListByClassifyId',//获取推荐音乐列表
  'getSingerList': host + '/service/myMusic/getSingerList',// 获取歌手列表
  'getCircleListByType': host + '/service/circle/getCircleListByType',// 获取歌手列表
};
