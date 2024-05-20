const servicePath = {
  'getUserData': '/service/user/getUserData', // 获取用户信息
  'getCategoryList': '/service/movie/getCategoryList', //获取分类影片
  'getKeyWord': '/service/movie/getKeyWord', //按照classify查询搜索栏的关键词
  'getAllCategoryByClassify': '/service/movie/getAllCategoryByClassify', //按classify大类查询所有catory小类
  'getAllCategoryListByPageName': '/service/movie/getAllCategoryListByPageName', //按页面获取要展示的category小类
  'getUserMsg': '/service/movie-getway/getUserMsg', //获取用户四个指标信息，使用天数，关注，观看记录，浏览记录
  'getSearchResult': '/service/movie/search', //搜索
  'login': '/service/user/login', //登录
  'getStar': '/service/movie/getStar/', //获取演员
  'getMovieUrl': '/service/movie/getMovieUrl', //获取演员
  'getViewRecord': '/service/movie-getway/getViewRecord', //获取浏览记录
  'saveViewRecord': '/service/movie-getway/saveViewRecord', //浏览历史
  'getPlayRecord': '/service/movie-getway/getPlayRecord', //获取观看记录
  'savePlayRecord': '/service/movie-getway/savePlayRecord', //播放记录
  'getFavorite': '/service/movie-getway/getFavoriteList', //获取收藏电影
  'saveFavorite': '/service/movie-getway/saveFavorite', //添加收藏
  'deleteFavorite': '/service/movie-getway/deleteFavorite', //删除收藏
  'getYourLikes': '/service/movie/getYourLikes',//猜你想看
  'getRecommend': '/service/movie/getRecommend',//获取推荐
  'isFavorite': '/service/movie-getway/isFavorite',//查询是否已经收藏
  'updateUser': '/service/user-getway/updateUser',//更新用户信息
  'updatePassword': '/service/user-getway/updatePassword',//更新密码wq
  'getCommentCount':'/service/social/getCommentCount',//获取评论总数
  'getTopCommentList':'/service/social/getTopCommentList',//获取一级评论
  'getReplyCommentList':'/service/social/getReplyCommentList',//获取一级评论
  'insertCommentService':'/service/social-getway/insertComment',//新增评论
  'updateAvaterService':'/service/user-getway/updateAvater',//更新头像
};
