import 'dart:convert';

import 'package:kuku_app_flutter/const/Consts.dart';
import 'package:kuku_app_flutter/dto/SearchAutoKeywordsDto.dart';
import 'package:kuku_app_flutter/dto/SearchKeywordsDto.dart';
import 'package:kuku_app_flutter/service/HttpService.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 封装搜索服务，解耦与Http请求的代码
class SearchService {

  static const HttpService httpService = HttpService();
  const SearchService();

  /// 获取搜索推荐词
  Future<List<SearchKeywordsDto>> getSearchRecommendItems() async{
    HttpService httpService = HttpService();
    Map<String, dynamic> result = await httpService.callSearchRcmdKeywordsAPI();
    return _fromJson(result);
  }

  /// 获取搜索热门词
  Future<List<SearchKeywordsDto>> getSearchHotItems() async{
    HttpService httpService = HttpService();
    Map<String, dynamic> result = await httpService.callSearchHotKeywordsAPI();
    return _fromJson(result);
  }

  /// 用户搜索历史词
  Future<List<SearchKeywordsDto>> getHisSearchItems() async{
    Set<SearchKeywordsDto> set = Set();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String hisJson = prefs.getString(SearchHisKey);

    if(hisJson==null || hisJson.isEmpty) return set.toList();

    Map<String, dynamic> mapJson = json.decode(hisJson);
    set.addAll(_fromJson(mapJson));
    return set.toList();
  }

  /// 搜索自动补全
  Future<SearchAutoKeywordsDto> getAutoSearchItems(String query) async{
    HttpService httpService = HttpService();
    Map<String, dynamic> result = await httpService.callSearchAutoKeywordsAPI(query);
    return SearchAutoKeywordsDto.ofNull().fromJson(result);
  }

  /// 添加历史搜索词
  void setHisSearchItems(String searchKeyword) async{
    List<SearchKeywordsDto> items = await getHisSearchItems();
    // 加入
    SearchKeywordsDto item = SearchKeywordsDto(1, searchKeyword, searchKeyword, null);
    items.add(item);
    _store(items);
  }

  /// 删除1个历史关键词
  Future<void> delHisKeywordsItem(String searchKeyword) async{
    List<SearchKeywordsDto> items = await getHisSearchItems();

    if(items == null || items.isEmpty) return;

    SearchKeywordsDto item = SearchKeywordsDto(1, searchKeyword, searchKeyword, null);
    items.remove(item);
    await _store(items);
  }

  /// 本地存储历史搜索记录
  Future<void> _store(List<SearchKeywordsDto> items) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(items == null || items.isEmpty) {
     prefs.remove(SearchHisKey);
     return;
    }

    //组装JSON Map
    prefs.setString(SearchHisKey, _toJson(items));
  }

  /// 针对SearchKeywordsItem List 处理Json转换
  List<SearchKeywordsDto> _fromJson(Map<String, dynamic> json){
    List<SearchKeywordsDto> list = List();

    if(json == null || json.isEmpty || !json.containsKey("list")) return list;

    List<dynamic> mapList = json['list'];

    mapList.forEach( (json) {
      SearchKeywordsDto item = SearchKeywordsDto.ofNull().fromJson(json);
      list.add(item);
    });
    return list;
  }
  /// 针对SearchKeywordsItem List 处理Json转换
  String _toJson(List<SearchKeywordsDto> items){

    if(items == null || items.isEmpty) return null;

    //组装JSON Map
    Map<String, dynamic> data = Map<String, dynamic>();
    List<Map<String, dynamic>> mapList = List<Map<String, dynamic>>();
    items.forEach((item){
      mapList.add(item.toJson());
    });

    data['list'] = mapList;
    return json.encode(data);
  }
}
