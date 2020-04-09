import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kuku_app_flutter/common/EventBus.dart';
import 'package:kuku_app_flutter/dto/SearchKeywordsItem.dart';
import 'package:kuku_app_flutter/service/SearchService.dart';

class SearchItemView extends StatefulWidget {
  final bool isHisSearch ;
  /// 是否允许删除
  const SearchItemView({this.isHisSearch});
  @override
  _SearchItemViewState createState() => _SearchItemViewState();
}

class _SearchItemViewState extends State<SearchItemView> {
  static const SearchService searchService = SearchService();
  StreamSubscription _searchDelSubscription;

  @override
  void initState(){
    super.initState();
    // _getHisKeywords();
    /// 监听删除事件
    _searchDelSubscription = eventBus.on<DelSearchKeyEvent>().listen((event){
      this._delHisKeywords(event.keywords);
    });
  }

  /// 之所以定义为async，因为后续需要改造为从SharedPreferences本地获删除
  Future<void> _delHisKeywords(String keywords) async {
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    String hisJson = prefs.get(SearchHisKey);
    if(hisJson!=null && hisJson.isNotEmpty) {
      Search_keywords searchKeywords = Search_keywords.fromJson(
          jsonDecode(hisJson));
      this.items = searchKeywords.list == null ? [] : searchKeywords.list;
      this.items.remove(keywords);

      if (this.items.isNotEmpty) {
        prefs.setString(SearchHisKey, jsonEncode((searchKeywords.toJson())));
      } else {
        prefs.setString(SearchHisKey, null);
      }
      setState(() {

      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return  widget.isHisSearch ? FutureBuilder(
          future: _getSearchItem(),
          builder: (BuildContext context, AsyncSnapshot<List<SearchKeywordsItem>> snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasError){
                return Text('Error: ${snapshot.error}');
              }
              return Container(
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 6,
                  children: snapshot.data.map((item) {
                    /// 构造Item widget
                    return SearchItem(title: item.getShow, isHisSearch: widget.isHisSearch,);
                  }).toList(),
                ),
              );
            }else{
              return CircularProgressIndicator(backgroundColor: Colors.white30, strokeWidth: 2.0,);
            }
          }
      ) :
      FutureBuilder(
          future: _getSearchItem(),
          builder: (BuildContext context, AsyncSnapshot<List<SearchKeywordsItem>> snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasError){
                return Text('Error: ${snapshot.error}');
              }
              return Container(
                // color: Colors.blue,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 6,
                  children: snapshot.data.map((item) {
                    /// 构造Item widget
                    return SearchItem(title: item.getShow, isHisSearch: widget.isHisSearch,);
                  }).toList(),
                ),
              );
            }else{
              return CircularProgressIndicator(backgroundColor: Colors.white30, strokeWidth: 2.0,);
            }
          }
      );
    /*return Padding(padding: EdgeInsets.all(10),
      child: Container(
        child: Wrap(
          spacing: 10,
          children: items.map((item) {
            /// 构造Item widget
            return SearchItem(title: item, isHisSearch: widget.isHisSearch,);
          }).toList(),
        ),
      )
    );*/
  }
  @override
  void dispose(){
    super.dispose();
    /// 取消监听，节省系统资源
    _searchDelSubscription.cancel();
  }

  Future<List<SearchKeywordsItem>> _getSearchItem() async{
    if(widget.isHisSearch){
      return searchService.getHisSearchItems();
    }else{
      return searchService.getSearchHotItems();
    }
  }
}

class SearchItem extends StatefulWidget {
  @required
  final String title;
  final bool isHisSearch;
  const SearchItem({Key key, this.title, this.isHisSearch}) : super(key: key);
  @override
  _SearchItemState createState() => _SearchItemState(isHisSearch: this.isHisSearch);
}

class _SearchItemState extends State<SearchItem> {
  bool isHisSearch;
  _SearchItemState({this.isHisSearch});

  @override
  Widget build(BuildContext context) {
    /// 圆角处理
    RoundedRectangleBorder shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
    );
    return Container(
      child: InkWell(
        onTap: () {
          /// 点击搜索词，发射一个搜索事件，让接收方开始搜索结果
          eventBus.fire(SearchEvent(widget.title));
        },
        /// 历史搜索VIEW, 允许对搜索词进行删除操作
        child: widget.isHisSearch ? Chip(
          onDeleted: (){
            /// 向事件总线发射一个删除搜索关键词事件
            eventBus.fire(DelSearchKeyEvent(widget.title));
          },
          label: Text(widget.title),
          shape: shape,
        ) :
        /// 大家都在搜索VIEW， 不允许对搜索词删除操作
        Chip(
          label: Text(widget.title),
          shape: shape,
        ),
      ),
    );
  }
}
