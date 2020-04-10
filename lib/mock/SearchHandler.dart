import 'dart:convert';
import 'dart:io';

import 'package:kuku_app_flutter/dto/GameInfoDto.dart';

class SearchKeywordsHandler {

  List<GameInfoDto> initData = List();

  SearchKeywordsHandler(){

    GameInfoDto item1 = GameInfoDto(2, '大神捕鱼-新手礼包', '大神捕鱼', 'http://game.kuku168.cn/public/img/91qixi-logo@2x.png');
    GameInfoDto item2 = GameInfoDto(1, '魔界战记', '魔界战记', 'http://game.kuku168.cn/public/img/91qixi-logo@2x.png');
    GameInfoDto item3 = GameInfoDto(3, '真封神外传-线下返利活动', '真封神外传', 'https://imgweb.kuku168.cn/3103af6eaa6e4ff996a7b90ee9844be4');
    GameInfoDto item4 = GameInfoDto(1, '双倍传奇', '双倍传奇', 'https://imgweb.kuku168.cn/696e1f2817804654a8b3a5721e83fa85');
    GameInfoDto item5 = GameInfoDto(1, '赤焰号角', '赤焰号角', 'https://imgweb.kuku168.cn/ab01bc3e1e34477793594c3ad95445f3');
    GameInfoDto item6 = GameInfoDto(1, '永恒幻剑', '永恒幻剑', 'https://imgweb.kuku168.cn/c1dc546b582c4b599b3944634dfbe248');
    GameInfoDto item7 = GameInfoDto(1, '剑荡江湖', '剑荡江湖', 'https://imgweb.kuku168.cn/3d4c091bacab4edc9a861c988204aa1c');
    GameInfoDto item8 = GameInfoDto(1, '神龙猎手', '神龙猎手', 'https://imgweb.kuku168.cn/2676ceaf4e0b45e88572e75639df3995');
    GameInfoDto item9 = GameInfoDto(1, '少年封神', '少年封神', 'https://imgweb.kuku168.cn/e1843f084dbc4f96b9a2e4dfc8478ff7');
    GameInfoDto item10 = GameInfoDto(1, '闪烁之光', '闪烁之光', 'https://imgweb.kuku168.cn/d8f4f5398fb4471bbfefc01d1b39ff4b');
    GameInfoDto item11 = GameInfoDto(1, '凡人飞仙传', '凡人飞仙传', 'https://imgweb.kuku168.cn/820c2d3057eb46cf826c111e7c48b392', selfdom: 'H5  |  跨服空战仙侠,快加入千人同屏大战！');
    GameInfoDto item12 = GameInfoDto(1, '神道', '神道', 'https://imgweb.kuku168.cn/f54ccee01ecd411bab21669fd1e06a6b',selfdom: '神道，神神叨叨到天明');
    GameInfoDto item13 = GameInfoDto(1, '封神传奇', '封神传奇', 'https://imgweb.kuku168.cn/545ae5f488f0492f8681595d5060170b');
    GameInfoDto item14 = GameInfoDto(1, '大神捕鱼', '大神捕鱼', 'https://imgweb.kuku168.cn/34f2b71ac871462c842d345108038b9b');
    GameInfoDto item15 = GameInfoDto(1, '纵剑仙界', '纵剑仙界', 'https://imgweb.kuku168.cn/e739dc6adf6649009a8ea45bc61e884b');
    GameInfoDto item16 = GameInfoDto(1, '驯龙物语', '驯龙物语', 'https://imgweb.kuku168.cn/7ecc46232bd34e94bb061a74b490e110');

    initData..add(item1)..add(item2)..add(item3)
      ..add(item4)..add(item5)..add(item6)..add(item7)
      ..add(item8)..add(item9)..add(item10)..add(item11)
      ..add(item12)..add(item13)..add(item14)..add(item15)
      ..add(item16);
  }

  handleSearchRecommendService(HttpRequest request) {
    print('handleSearchRcmdService');
    Map<String, dynamic> data = Map();
    data['list'] = initData.sublist(0,5);
    String respStr = json.encode(data);
    request.response.write(respStr);
    request.response.close();
  }

  handleSearchAutoService(HttpRequest request) {
    print('${request.requestedUri.queryParameters}');
    String query = request.requestedUri.queryParameters['query'];
    Map<String, dynamic> data = Map();
    List<GameInfoDto> result = initData.where((one){
      // print('${one.getKeywords},${one.getKeywords.contains(query)},${query}');
      return one.getKeywords.contains(query);
    }).toList();
    data['total'] = result.length;
    data['list'] = result;
    String respStr = json.encode(data);
    request.response.write(respStr);
    request.response.close();
  }
}
