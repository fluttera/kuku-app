const API_HOST = "http://192.168.0.99:8080";
const SearchHisKey = "search_k_his_key";
class API {
  static const String search_rcmd_keywords_api = '${API_HOST}/search/recmd';
  static const String seach_hot_keywords_api = '${API_HOST}/search/hot';
}


typedef ResponseCallBack = void Function(int statusCode, Map<String, dynamic> data);
