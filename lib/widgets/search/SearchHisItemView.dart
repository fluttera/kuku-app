import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kuku_app_flutter/common/EventBus.dart';
import 'package:kuku_app_flutter/dto/SearchKeywordsDto.dart';
import 'package:kuku_app_flutter/service/SearchService.dart';

import 'SearchItem.dart';

class SearchHisItemView extends StatefulWidget {
  @override
  _SearchHisItemViewState createState() => _SearchHisItemViewState();
}

class _SearchHisItemViewState extends State<SearchHisItemView> {
  static const SearchService searchService = SearchService();
  StreamSubscription _searchDelSubscription;

  List<SearchKeywordsDto> hisSearchKeywords;

  @override
  void initState(){
    _getHisSearchItem();
    /// 监听删除事件
    _searchDelSubscription = eventBus.on<DelSearchKeyEvent>().listen((event){
      this._delHisKeywords(event.keywords);
    });
    super.initState();
  }

  /// 之所以定义为async，因为后续需要改造为从SharedPreferences本地获删除
  Future<void> _delHisKeywords(String keywords) async {
    searchService.delHisKeywordsItem(keywords).then((v){
      _getHisSearchItem();
    });
  }

  @override
  Widget build(BuildContext context) {
    return  hisSearchKeywords!=null && hisSearchKeywords.isNotEmpty ? Container(
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 6,
        children: hisSearchKeywords.map((item) {
          /// 构造Item widget
          return SearchItem(title: item.getShow, calDel: true,);
        }).toList(),
      ),
    ) : Container(height: 0,);
  }
  @override
  void dispose(){
    super.dispose();
    /// 取消监听，节省系统资源
    _searchDelSubscription.cancel();
  }

  void _getHisSearchItem() {
    searchService.getHisSearchItems().then((value){
      this.hisSearchKeywords = value;
      setState(() {

      });
    });
  }
}
