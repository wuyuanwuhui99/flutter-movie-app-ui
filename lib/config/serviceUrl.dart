const host = 'http://192.168.0.103:';
const movieServiceUrl = '${host}5001'; //电影接口
const musicServiceUrl = '${host}4000'; //音乐端口
const servicePath = {
  'getUserData': movieServiceUrl + '/service/movie/getUserData', // 获取用户信息
  'getCategoryList': movieServiceUrl + '/service/movie/getCategoryList', //获取分类影片
  'getKeyWord': movieServiceUrl + '/service/movie/getKeyWord', //按照classify查询搜索栏的关键词
  'getAllCategoryByClassify': movieServiceUrl + '/service/movie/getAllCategoryByClassify', //按classify大类查询所有catory小类
  'getAllCategoryListByPageName': movieServiceUrl + '/service/movie/getAllCategoryListByPageName', //按页面获取要展示的category小类
  'getUserMsg': movieServiceUrl + '/service/movie-getway/getUserMsg', //获取用户四个指标信息，使用天数，关注，观看记录，浏览记录
  'getSearchResult': movieServiceUrl + '/service/movie/search', //搜索
  'login': movieServiceUrl + '/service/movie/login', //登录
  'getStar': movieServiceUrl + '/service/movie/getStar/', //获取演员
  'getMovieUrl': movieServiceUrl + '/service/movie/getMovieUrl', //获取演员
  'getViewRecord': movieServiceUrl + '/service/movie-getway/getViewRecord', //获取浏览记录
  'saveViewRecord': movieServiceUrl + '/service/movie-getway/saveViewRecord', //浏览历史
  'getPlayRecord': movieServiceUrl + '/service/movie-getway/getPlayRecord', //获取观看记录
  'savePlayRecord': movieServiceUrl + '/service/movie-getway/savePlayRecord', //播放记录
  'getFavorite': movieServiceUrl + '/service/movie-getway/getFavorite', //获取收藏电影
  'saveFavorite': movieServiceUrl + '/service/movie-getway/saveFavorite', //添加收藏
  'deleteFavorite': movieServiceUrl + '/service/movie-getway/deleteFavorite', //删除收藏
  'getYourLikes': movieServiceUrl + '/service/movie/getYourLikes',//猜你想看
  'getRecommend': movieServiceUrl + '/service/movie/getRecommend',//获取推荐
  'isFavorite': movieServiceUrl + '/service/movie-getway/isFavorite',//查询是否已经收藏
  'updateUser': movieServiceUrl + '/service/movie-getway/updateUser',//更新用户信息
  'updatePassword': movieServiceUrl + '/service/movie-getway/updatePassword',//更新密码wq
  'getCommentCount':movieServiceUrl + '/service/movie/getCommentCount',//获取评论总数
  'getTopCommentList':movieServiceUrl + '/service/movie/getTopCommentList',//获取一级评论
  'getReplyCommentList':movieServiceUrl + '/service/movie/getReplyCommentList',//获取一级评论
  'insertCommentService':movieServiceUrl + '/service/movie-getway/insertComment',//新增评论
  'updateAvaterService':movieServiceUrl + '/service/movie-getway/updateAvater',//新增评论
  'getKeywordMusic': musicServiceUrl + '/service/myMusic/getKeywordMusic',//获取搜索关键词
  'getMusicClassify': musicServiceUrl + '/service/myMusic/getMusicClassify',//获取分类歌曲
  'getMusicListByClassifyId': musicServiceUrl + '/service/myMusic/getMusicListByClassifyId',//获取推荐音乐列表
};
