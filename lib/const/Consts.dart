const API_HOST = "http://192.168.0.99:8080";
const SearchHisKey = "search_k_his_key";
class API {
  static const String search_rcmd_keywords_api = '${API_HOST}/search/recmd'; // 推荐搜索接口
  static const String seach_hot_keywords_api = '${API_HOST}/search/hot'; // 大家都在搜索接口
  static const String seach_auto_keywords_api = '${API_HOST}/search/auto'; //自动补全接口
}


typedef ResponseCallBack = void Function(int statusCode, Map<String, dynamic> data);
