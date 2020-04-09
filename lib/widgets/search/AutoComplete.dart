import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

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
  /// 加载时显示loading
  static const loadingTag = '##loadingTag##';
  List<String> searchList = [
    loadingTag
  ];

  @override
  void initState(){
    super.initState();
    _receiveList();
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
              if(searchList[index] == loadingTag){ // 最后一个词等于加载Tag
                if(searchList.length -1 < 100){ // 搜索量小于100 表示还有更多
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
                  // 已经加载了100条数据，不再获取数据
                  return Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16.0),
                      child: Text("没有更多了", style: TextStyle(color: Colors.grey),)
                  );
                }
              }
              return ListTile(
                title: RichText(
                    text: bold(searchList[index], widget.query)
                ),
                onTap: (){
                  widget.setSearchKeyword(searchList[index]);
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
  TextSpan bold(String title, String query){
    query = query.trim();
    int index = title.indexOf(query);
    if(index == -1 || query.length > title.length) {
      return TextSpan(
        text: title,
        style: TextStyle(color: Colors.black, fontSize: 12),
        children: null,
      );
    }else{ /// 构建富文本，对输入的字符加粗显示
      String before = title.substring(0, index);
      String hit = title.substring(index, index+query.length);
      String after = title.substring(index+query.length);
      return TextSpan(
        text: '',
        style: TextStyle(color: Colors.black, fontSize: 12),
        children: <TextSpan>[
          TextSpan(
              text: before
          ),
          TextSpan(
              text: hit,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
          ),
          TextSpan(
              text:after
          ),
        ],
      );
    }

  }

  /// 模拟网络延迟加载，需要依赖词包 english_words: ^3.1.0
  void _receiveList(){
    Future.delayed(Duration(seconds: 2)).then((e){
      searchList.insertAll(searchList.length-1,
          generateWordPairs().take(20).map((e) => e.asPascalCase).toList()
      );
      setState(() {

      });
    });
  }
}
