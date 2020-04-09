import 'dart:async';

import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:kuku_app_flutter/service/SearchService.dart';

import 'package:kuku_app_flutter/dto/SearchKeywordsItem.dart';

class SearchKeywordsModel with ChangeNotifier {

  static const SearchService searchService = SearchService();

  List<SearchKeywordsItem> list = List();

  int selected;

  int count;

  SearchKeywordsModel ({count: 3}) {
    this._reflush(count);
  }
  get getList => list;

  /// 获取count数量的推荐搜索词
  void _reflush (int count) {
    _receiveList(count);
  }

  /// 请求API获取数据
  void _receiveList(int count) {

    if(list!=null && list.isNotEmpty){
      list = List();
      notifyListeners();
      return ;
    }
    searchService.getSearchRecommendItems().then((items){
      this.list = items;
      selected = 0;
      this.count = this.list.length;
      updateSelected();
      notifyListeners();
    });
  }

  /// 间隔轮换显示搜索词
  Timer timer;
  void updateSelected(){
    if(timer != null) return;
    timer = Timer.periodic(Duration(seconds: 5), (as) {
      if(list==null || list.isEmpty) {
        selected = -1;
        return;
      }
       selected += 1;
       if(selected >= count){
         selected = 0;
       }
       notifyListeners();
    });
  }

  void close(){
    if(timer != null) {
      timer.cancel();
      timer = null;
    }
  }

}

