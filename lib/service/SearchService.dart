import 'dart:convert';

import 'package:kuku_app_flutter/const/Consts.dart';
import 'package:kuku_app_flutter/dto/SearchKeywordsItem.dart';
import 'package:kuku_app_flutter/service/HttpService.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 封装搜索服务，解耦与Http请求的代码
class SearchService {

  static const HttpService httpService = HttpService();
  const SearchService();

  /// 获取搜索推荐词
  Future<List<SearchKeywordsItem>> getSearchRcmdItems() async{
    List<SearchKeywordsItem> list = List();
    HttpService httpService = HttpService();
    Map<String, dynamic> result = await httpService.callSearchRcmdKeywordsAPI();
    if(result == null || result.isEmpty || !result.containsKey("list")) return list;
    List<dynamic> mapList = result['list'];
    mapList.forEach( (json) {
      SearchKeywordsItem item = SearchKeywordsItem.ofNull().fromJson(json);
      list.add(item);
    });
    return list;
  }

  /// 获取搜索热门词
  Future<List<SearchKeywordsItem>> getSearchHotItems() async{
    List<SearchKeywordsItem> list = List();
    HttpService httpService = HttpService();
    Map<String, dynamic> result = await httpService.callSearchHotKeywordsAPI();
    if(result == null || result.isEmpty || !result.containsKey("list")) return list;
    List<dynamic> mapList = result['list'];
    mapList.forEach( (json) {
      SearchKeywordsItem item = SearchKeywordsItem.ofNull().fromJson(json);
      list.add(item);
    });
    return list;
  }

  /// 用户搜索历史词
  Future<List<SearchKeywordsItem>> getHisSearchItems() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<SearchKeywordsItem> list = List();

    String hisJson = prefs.getString(SearchHisKey);

    if(hisJson==null || hisJson.isEmpty) return list;

    Map<String, dynamic> mapJson = json.decode(hisJson);

    if(mapJson.containsKey("list")){
      List<dynamic> listmap =  mapJson["list"];
      listmap.forEach((json){
        SearchKeywordsItem item = SearchKeywordsItem.ofNull().fromJson(json);
        list.add(item);
      });
    }
    return list;
  }
  /// 添加历史搜索词
  void setHisSearchItems(String searchKeyword) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String hisJson = prefs.getString(SearchHisKey);
    Set<SearchKeywordsItem> items = Set();
    SearchKeywordsItem item = SearchKeywordsItem(1, searchKeyword, searchKeyword, null);
    Map<String, dynamic> data = Map<String, dynamic>();
    if(hisJson != null && hisJson.isNotEmpty){
      data = json.decode(hisJson);
    }
    items.add(item);
    /// 已经存在
    if(data.containsKey("list")){
      List<dynamic> mapList = data['list'];
      mapList.forEach( (json) {
        SearchKeywordsItem item = SearchKeywordsItem.ofNull().fromJson(json);
        items.add(item);
      });
    }

    //组装JSON Map
    Map<String, dynamic> result = Map<String, dynamic>();
    List<Map<String, dynamic>> mapList = List<Map<String, dynamic>>();
    items.forEach((item){
      mapList.add(item.toJson());
    });
    result['list'] = mapList;
    prefs.setString(SearchHisKey, json.encode(result));
  }

}
