import 'package:flutter/material.dart';
import 'package:kuku_app_flutter/models/search/SearchKeywordsModel.dart';
import 'package:kuku_app_flutter/widgets/search/MySearchDelegate.dart';
import 'package:kuku_app_flutter/styles/SearchStyles.dart';
import 'package:kuku_app_flutter/common/Store.dart';

class SearchBar extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>{
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Store.connect<SearchKeywordsModel>(builder: (context, model, _) {
      SearchKeywordsModel m = (model as SearchKeywordsModel);
      String show = (m.list != null && m.list.isNotEmpty) ? m.list[m.selected].getShow : '输入您想要的游戏名称';
      String iconUrl = (m.list != null && m.list.isNotEmpty) ? m.list[m.selected].getIcon : '';
      return GestureDetector(
        child: Container(
          // color: Colors.grey,
            alignment: Alignment.center,
            constraints: BoxConstraints.tightFor(width: 230, height: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.all(
                Radius.circular(30),
              ),
              gradient: RadialGradient(
                  colors: [Colors.black12, Colors.black12],
                  center: Alignment.topLeft,
                  radius: .98
              ),
            ),
            child: Padding(padding: EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: iconUrl != null && iconUrl.isNotEmpty ? FadeInImage.assetNetwork(
                            image: '$iconUrl',
                            placeholder: 'images/icon_place_holder.png',
                            height: 20,
                            fit: BoxFit.fitHeight,
                          ) : Container(height: 0, width: 0,),
                        ),
                        Padding(padding: EdgeInsets.only(left: 10), child: Text('$show', style: searchStyle )),
                      ]
                  ),
                  Icon(
                    Icons.search,
                    color: Colors.white30,
                  ),
                ],
              ),)
        ),
        onTap: (){showSearch(context: context, delegate: MySearchDelegate('$show'));},
      );
    });
  }
}
