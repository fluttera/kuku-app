import 'package:event_bus/event_bus.dart';
/// 创建EventBus
EventBus eventBus = EventBus();

/// Event 搜索
class SearchEvent {
  String keywords;
  SearchEvent(this.keywords);
}
/// Event 删除搜索历史记录
class DelSearchKeyEvent{
  String keywords;
  DelSearchKeyEvent(this.keywords);
}
/// Event 输入query改变
class SearchQueryChangedEvent{
  String keywords;
  SearchQueryChangedEvent(this.keywords);
}
