
import 'dart:convert';

import 'package:kuku_app_flutter/dto/SearchKeywordsItem.dart';

void main(){
  Set<SearchKeywordsItem> items = Set<SearchKeywordsItem>();
  SearchKeywordsItem item1 = SearchKeywordsItem(1, '1', '2', null);
  SearchKeywordsItem item2 = SearchKeywordsItem(1, '11', '2', null);
  items.addAll([item1, item2]);

  Map<String, dynamic> result = Map<String, dynamic>();
  List<Map<String, dynamic>> mapList = List<Map<String, dynamic>>();
  items.forEach((item){
    mapList.add(item.toJson());
  });
  result['list'] = mapList;
  print(result);
  print(json.encode(result));
}
