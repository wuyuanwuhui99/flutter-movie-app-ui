const serviceUrl = 'http://192.168.0.102:5000'; //此端口针对于正版用户开放，可自行fiddle获取。
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
  "getViewRecord": serviceUrl + "/service/movie/getViewRecord", //获取浏览记录
  "saveViewRecord": serviceUrl + "/service/movie/saveViewRecord", //浏览历史
  "getPlayRecord": serviceUrl + "/service/movie/getPlayRecord", //获取农房记录
  "savePlayRecord": serviceUrl + "/service/movie/savePlayRecord", //播放记录
  "getFavorite": serviceUrl + "/service/movie/getFavorite", //获取收藏电影
  "saveFavorite": serviceUrl + "/service/movie/saveFavorite", //添加收藏
  "deleteFavorite": serviceUrl + "/service/movie/saveFavorite", //删除收藏
};
