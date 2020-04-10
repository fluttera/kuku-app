import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kuku_app_flutter/common/EventBus.dart';
import 'package:kuku_app_flutter/dto/GameInfoDto.dart';
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
  List<GameInfoDto> searchList = [
    GameInfoDto(loadingTagType, 'loadingTat', 'loadingTag', '')
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
                    padding: const EdgeInsets.all(10.0),
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

              GameInfoDto dto = searchList[index];
              String buttonText = '';
              if(dto.getType == 1){ // 游戏分H5，原生
                buttonText = '秒 玩';
              }else if(dto.getType == 2){ // 去到礼包页面
                buttonText = '领礼包';
              }else if(dto.getType == 3){ // 资讯活动
                buttonText = '详 情';
              }else if(dto.getType == 4){
                buttonText = '下 载';
              }
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 6, bottom: 6),
                      child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                            child: dto.getIcon != null && dto.getIcon.isNotEmpty ?
                            FadeInImage.assetNetwork(
                              image: '${dto.getIcon}',
                              placeholder: 'images/icon_place_holder.png',
                              height: 60.0,
                              fit: BoxFit.fitHeight,
                            )  : Container(height: 0, width: 0,)
                        )
                    ),
                    ///  自适应宽度
                    Expanded(child:Container(
                      // color: Colors.red,
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 6),
                            child:
                              RichText(
                                text: _bold(dto.getShow, widget.query),
                                overflow: TextOverflow.ellipsis,
                                maxLines:1,
                              )
                          ),
                          dto.getSelfdom !=null && dto.getSelfdom.isNotEmpty ?
                          Container(
                            child: Text(
                              searchList[index].getSelfdom,
                              style: listItemChildTitle,
                              overflow: TextOverflow.ellipsis,
                              maxLines:2,
                            )
                          ):
                          Container(height: 0,)
                        ],
                      )
                    )
                    ),
                    InkWell(
                      onTap: (){
                        print('--->inkwell click.');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32.0),
                          border: Border.all(color: Colors.orange, width: 1),
                        ),
                        width: 64,
                        height: 32,
                        alignment: Alignment.center,
                        child: Text(
                          buttonText,
                          style: buttonTextBlack,
                        ),
                      )
                    ),
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
    if(title==null || title.isEmpty) return TextSpan();
    query = query.trim();
    int index = title.indexOf(query);
    if(index == -1 || query.length > title.length) {
      return TextSpan(
        text: title,
        style: listItemTitle,
        children: null,
      );
    }else{ /// 构建富文本，对输入的字符加粗显示
      String before = title.substring(0, index);
      String hit = title.substring(index, index+query.length);
      String after = title.substring(index+query.length);
      return TextSpan(
        text: '',
        style: listItemTitle,
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
        GameInfoDto(loadingTagType, 'loadingTat', 'loadingTag', '')
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
