import 'AbstractBaseDto.dart';
import 'GameInfoDto.dart';

class SearchAutoKeywordsDto extends BaseDto{
  int _total;
  int get getTotal => _total;

  List<GameInfoDto> _list;
  List<GameInfoDto> get getList => _list;

  SearchAutoKeywordsDto(total, list){
    this._total = total;
    this._list = list;
  }

  SearchAutoKeywordsDto.ofNull();

  @override
  BaseDto fromJson(Map<String, dynamic> json) {
    if(json == null || json.isEmpty) return null;
    _total = json.containsKey('total') ? json['total'] : 0;
    List<dynamic> jsonList = json['list'];
    if(jsonList == null || jsonList.isEmpty) return SearchAutoKeywordsDto(_total, null);

    List<GameInfoDto> listTmp = List();
    jsonList.forEach((one){
      GameInfoDto it = GameInfoDto.ofNull().fromJson(one);
      listTmp.add(it);
    });

    return SearchAutoKeywordsDto(_total, listTmp);
  }

  @override
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> jsonList = List();
    if(_list == null || _list.isEmpty) {
      return <String, dynamic>{
        'total': _total,
        'list': _list,
      };
    }
    _list.forEach((one){
      jsonList.add(one.toJson());
    });

    return <String, dynamic>{
      'total': _total,
      'list': jsonList,
    };
  }
}
