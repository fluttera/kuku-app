import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kuku_app_flutter/service/SearchService.dart';

import 'package:kuku_app_flutter/widgets/search/AutoComplete.dart';
import 'package:kuku_app_flutter/widgets/search/Suggestions.dart';

import 'package:kuku_app_flutter/common/EventBus.dart';

/// 实现SearchDelegate
class MySearchDelegate extends SearchDelegate<String>{

  static const SearchService searchService = SearchService();
  StreamSubscription _searchSubscription;

  MySearchDelegate(searchFieldLabel):super(searchFieldLabel: searchFieldLabel) ;

   /* @override
    String get searchFieldLabel => '搜索全网精品游戏';*/

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation
        ),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = "";
            showSuggestions(context);
          }        }  //点击时关闭整个搜索页面
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // 取消搜索侦听
    if(query==null || query.isEmpty){
      query = searchFieldLabel;
    }
    _searchSubscription.cancel();
    _addSearchHisKey(query);

    return Container(
      width: 100.0,
      height:100.0,
      child: Card(
        color:Colors.redAccent,
        child: Center(
          child: Text(query),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // 事件侦听
    _searchSubscription = eventBus.on<SearchEvent>().listen((event){
      this.popResults(context);
      this.setSearchKeyword(event.keywords);
    });
    /// 将方法作为参数传递给子组件调用
    return query.isEmpty ? Suggestions() : AutoComplete(query, this.popResults, this.setSearchKeyword);
  }

  /// 搜索结果展示
  void popResults(BuildContext context){
    showResults(context);
  }

  /// 设置query
  Future<void> setSearchKeyword(String searchKeyword) async {
    query = searchKeyword;
  }

  _addSearchHisKey(searchKeyword) async {
    searchService.setHisSearchItems(searchKeyword);
  }

}
