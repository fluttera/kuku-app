
import 'package:flutter/material.dart';
import 'package:kuku_app_flutter/common/EventBus.dart';

class SearchItem extends StatefulWidget {
  @required
  final String title;
  final bool calDel;
  const SearchItem({Key key, this.title, this.calDel}) : super(key: key);
  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {

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
        child: widget.calDel ? InkWell( child: Chip(
          onDeleted: (){
            /// 向事件总线发射一个删除搜索关键词事件
            print('-----fire delete search key event...');
            eventBus.fire(DelSearchKeyEvent(widget.title));
          },
          label: Text(widget.title),
          shape: shape,
          backgroundColor: Colors.black12,
        )
        )
                :
        /// 大家都在搜索VIEW， 不允许对搜索词删除操作
        Chip(
          label: Text(widget.title),
          backgroundColor: Colors.black12,
          shape: shape,
        ),
      ),
    );
  }
}
