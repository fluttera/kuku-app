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
    searchService.getSearchRcmdItems().then((items){
      this.list = items;
      selected = 0;
      this.count = this.list.length;
      updateSelected();
      notifyListeners();
    });
  /*
    Future.delayed(Duration(seconds: 1)).then((e){
      _SearchKeywordsRcmdItem item1 = _SearchKeywordsRcmdItem(2, '大神捕鱼-新手礼包', '大神捕鱼', 'http://game.kuku168.cn/public/img/91qixi-logo@2x.png');
      _SearchKeywordsRcmdItem item2 = _SearchKeywordsRcmdItem(1, '魔界战记', '魔界战记', 'https://imgweb.kuku168.cn/35803606e5964c91b9e6e675ace19bbe');
      _SearchKeywordsRcmdItem item3 = _SearchKeywordsRcmdItem(3, '真封神外传-线下返利活动', '真封神外传', 'https://imgweb.kuku168.cn/3103af6eaa6e4ff996a7b90ee9844be4');
      list = [item1, item2, item3];
      selected = 0;
      notifyListeners();
    });*/
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

