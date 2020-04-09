import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kuku_app_flutter/common/EventBus.dart';
import 'package:kuku_app_flutter/dto/SearchKeywordsDto.dart';
import 'package:kuku_app_flutter/service/SearchService.dart';
import 'package:kuku_app_flutter/styles/SearchStyles.dart';

class AutoComplete extends StatefulWidget{
  final String query;
  final Function popResults;
  final Function setSearchKeyword;

  /// 这里通过另外一种方式实现自组件调用父组件方法
  AutoComplete(this.query, this.popResults,  this.setSearchKeyword);
  @override
  State<StatefulWidget> createState() => _AutoCompleteState();
}

class _AutoCompleteState extends State<AutoComplete>{
  StreamSubscription _searchSubscription;
  /// 加载时显示loading
  static const int loadingTagType = -9999;
  static const SearchService searchService = const SearchService();
  List<SearchKeywordsDto> searchList = [
    SearchKeywordsDto(loadingTagType, 'loadingTat', 'loadingTag', '')
  ];
  int total = 0;

  @override
  void initState(){
    _receiveList(); // 组件未加载时需要触发
    _searchSubscription = eventBus.on<SearchQueryChangedEvent>().listen((event){
      print('==_searchSubscription==>${event}');
      _receiveList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Expanded(
            // ignore: missing_return
            child: ListView.separated(itemBuilder: (BuildContext context, int index){
              if(searchList[index].getType == loadingTagType){ // 最后一个词等于加载Tag
                if(searchList.length -1 < total){ // 表示还有更多
                  _receiveList();
                  // 加载时显示loading
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: CircularProgressIndicator(strokeWidth: 2.0) // 加载转圈
                    ),
                  );
                }else{
                  // 已经加载了 total 条数据，不再获取数据
                  return Container(
                      height: 0,
                    // alignment: Alignment.center,
                      // padding: EdgeInsets.all(16.0),
                      // child: Text("没有更多了", style: TextStyle(color: Colors.grey),)
                  );
                }
              }

              SearchKeywordsDto dto = searchList[index];

              return ListTile(
                title: Row(
                  children: <Widget>[
                    Container(
                    height: 70.0,
                    child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: dto.getIcon != null && dto.getIcon.isNotEmpty ? Image(
                            image: NetworkImage('${dto.getIcon}'),
                            width: 60,
                          ) : Container(height: 0, width: 0,)
                      )
                    ),
                    Container(
                      padding: EdgeInsets.all(12.0),
                      child: RichText(
                          text: _bold(searchList[index].getShow, widget.query)
                      ),
                    )
                  ],
                ),
                onTap: (){
                  widget.setSearchKeyword(searchList[index].getShow);
                  widget.popResults(context);
                },
              );
            },
              itemCount: searchList.length,
              separatorBuilder: (context, index) => Divider(height: .0,),

            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose(){
    _searchSubscription.cancel();
    super.dispose();
  }
  TextSpan _bold(String title, String query){
    query = query.trim();
    int index = title.indexOf(query);
    if(index == -1 || query.length > title.length) {
      return TextSpan(
        text: title,
        style: autoListTitle,
        children: null,
      );
    }else{ /// 构建富文本，对输入的字符加粗显示
      String before = title.substring(0, index);
      String hit = title.substring(index, index+query.length);
      String after = title.substring(index+query.length);
      return TextSpan(
        text: '',
        style: autoListTitle,
        children: <TextSpan>[
          TextSpan(
              text: before
          ),
          TextSpan(
              text: hit,
              style: autoListTitleBold
          ),
          TextSpan(
              text:after
          ),
        ],
      );
    }

  }

  /// 获取接口数据
  void _receiveList(){
    searchService.getAutoSearchItems(widget.query).then((item){
      searchList = [
        SearchKeywordsDto(loadingTagType, 'loadingTat', 'loadingTag', '')
      ];
      total = 0;
      if(item != null && item.getList != null && item.getList.isNotEmpty) {
        searchList.insertAll(searchList.length - 1, item.getList);
        total = item.getTotal;
      }
      setState(() {

      });
    });
  }
}
