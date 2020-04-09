import 'package:flutter/material.dart';
import 'package:kuku_app_flutter/styles/SearchStyles.dart';
import 'package:kuku_app_flutter/widgets/search/SearchItemView.dart';

/// 搜索词建议widget
class Suggestions extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView( child: Container(
      padding: EdgeInsets.all(10),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
                '大家都在搜',
                style: searchRecommendTitle
            ),
          ),
          //Expanded(
          //  child:
            Container(
              padding: EdgeInsets.all(6.0) ,
              alignment: Alignment.center,
              // color: Colors.cyan,
              child: SearchItemView(isHisSearch: false,),), // isHisSearch 是否历史搜索词View
          //),
          Container(
            child: Text(
              '历史搜索记录',
              style: searchRecommendTitle
            ),
          ),
         // Expanded(child:
            Container(
                padding: EdgeInsets.all(6.0) ,
                alignment: Alignment.center,
                // color: Colors.red,
                child: SearchItemView(isHisSearch: true,)
            )
         // )
        ],
      ),
      )
    );
  }
}
