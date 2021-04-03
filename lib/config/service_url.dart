const serviceUrl = 'http://192.168.0.102:5001'; //此端口针对于正版用户开放，可自行fiddle获取。
const servicePath = {
  'getUserData': serviceUrl + '/service/movie/getUserData', // 获取用户信息
  "getCategoryList": serviceUrl + "/service/movie/getCategoryList", //获取分类影片
  "getKeyWord": serviceUrl + "/service/movie/getKeyWord", //按照classify查询搜索栏的关键词
  "getAllCategoryByClassify": serviceUrl +
      "/service/movie/getAllCategoryByClassify", //按classify大类查询所有catory小类
  "getAllCategoryListByPageName": serviceUrl +
      "/service/movie/getAllCategoryListByPageName", //按页面获取要展示的category小类
  "getUserMsg":
      serviceUrl + "/service/movie/getUserMsg", //获取用户四个指标信息，使用天数，关注，观看记录，浏览记录
  "getSearchResult": serviceUrl + "/service/movie/search", //搜索
  "login": serviceUrl + "/service/movie/login", //登录
  "getStar": serviceUrl + "/service/movie/getStar", //获取演员
  "getMovieUrl": serviceUrl + "/service/movie/getMovieUrl", //获取演员
  "getViewRecord": serviceUrl + "/service/movie-getway/getViewRecord", //获取浏览记录
  "saveViewRecord": serviceUrl + "/service/movie-getway/saveViewRecord", //浏览历史
  "getPlayRecord": serviceUrl + "/service/movie-getway/getPlayRecord", //获取农房记录
  "savePlayRecord": serviceUrl + "/service/movie-getway/savePlayRecord", //播放记录
  "getFavorite": serviceUrl + "/service/movie-getway/getFavorite", //获取收藏电影
  "saveFavorite": serviceUrl + "/service/movie-getway/saveFavorite", //添加收藏
  "deleteFavorite": serviceUrl + "/service/movie-getway/deleteFavorite", //删除收藏
  "getYourLikes": serviceUrl + '/service/movie/getYourLikes',//猜你想看
  "getRecommend": serviceUrl + '/service/movie/getRecommend',//获取推荐
  "isFavorite": serviceUrl + '/service//movie-getway/isFavorite',//查询是否已经收藏
};
