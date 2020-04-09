import 'AbstractBaseDto.dart';

class SearchKeywordsItem extends BaseDto{

  int _type; // 搜索类型 1=游戏 2=礼包 3=资讯
  set seType(int type) => _type = type;
  int get getType => _type;

  String _show; // 显示的词
  set setShow(String show) => _show = show;
  String get getShow => _show;

  String _keywords; // 实际用来搜索匹配的词
  set setKeywords(String keywords) => _keywords = keywords;
  String get getKeywords => _keywords;

  String _icon; // 展示图标
  set setIcon(String icon) => _icon = icon;
  String get getIcon => _icon;

  SearchKeywordsItem(this._type, this._show, this._keywords, this._icon);
  SearchKeywordsItem.ofNull();

  @override
  BaseDto fromJson(Map<String, dynamic> json) {
    return  SearchKeywordsItem(json['type'], json['show'], json['keywords'], json['icon']);
  }

  @override
  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'type': _type,
        'show': _show,
        'icon': _icon,
        'keywords': _keywords
      };

  @override
  bool operator == (other) {
    if(other is! SearchKeywordsItem){
      return false;
    }
    final SearchKeywordsItem item = other;
    return _show == item._show;
  }

  @override
  int get hashCode => 1;

}
