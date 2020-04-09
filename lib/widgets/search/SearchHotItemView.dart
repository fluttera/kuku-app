import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kuku_app_flutter/dto/SearchKeywordsDto.dart';
import 'package:kuku_app_flutter/service/SearchService.dart';

import 'SearchItem.dart';

class SearchHotItemView extends StatefulWidget {
  @override
  _SearchHotItemViewState createState() => _SearchHotItemViewState();
}

class _SearchHotItemViewState extends State<SearchHotItemView> {
  static const SearchService searchService = SearchService();

  List<SearchKeywordsDto> hisSearchKeywords;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder(
          future: _getHotSearchItem(),
          builder: (BuildContext context, AsyncSnapshot<List<SearchKeywordsDto>> snapshot){
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
                    return SearchItem(title: item.getShow, calDel: false,);
                  }).toList(),
                ),
              );
            }else{
              return CircularProgressIndicator(backgroundColor: Colors.white30, strokeWidth: 2.0,);
            }
          }
      );
  }
  @override
  void dispose(){
    super.dispose();
  }

  Future<List<SearchKeywordsDto>> _getHotSearchItem() async{
    return searchService.getSearchHotItems();
  }
}
