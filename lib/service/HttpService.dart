
import 'package:kuku_app_flutter/const/Consts.dart';
import 'package:kuku_app_flutter/utils/HttpClient.dart';
///
/// 封装http请求服务，方便后续增加参数等操作，不需要去Widget搜索
/// 解析状态200的返回 Map<String, dynamic>， 其他状态返回null
class HttpService {

  const HttpService();

  /// 调用搜索推荐服务
  Future<Map<String, dynamic>> callSearchRcmdKeywordsAPI() async{
    HttpClient httpClient = HttpClient();
    Map<String, dynamic> response = await httpClient.postFuture(API.search_rcmd_keywords_api);
    return response;
  }

  /// 调用搜索热词服务
  Future<Map<String, dynamic>> callSearchHotKeywordsAPI() async{
    HttpClient httpClient = HttpClient();
    Map<String, dynamic> response = await httpClient.postFuture(API.seach_hot_keywords_api);
    return response;
  }

  /// 调用搜索词自动补全服务
  Future<Map<String, dynamic>> callSearchAutoKeywordsAPI(String query) async{
    HttpClient httpClient = HttpClient();
    Map<String, String> params = Map();
    params['query'] = query;
    Map<String, dynamic> response = await httpClient.postFuture(API.seach_auto_keywords_api, queryParameters: params);
    return response;
  }

}
