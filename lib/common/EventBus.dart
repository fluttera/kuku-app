import 'package:event_bus/event_bus.dart';
/// 创建EventBus
EventBus eventBus = EventBus();

/// Event 搜索
class SearchEvent {
  String keywords;
  SearchEvent(this.keywords);
}

class DelSearchKeyEvent{
  String keywords;
  DelSearchKeyEvent(this.keywords);
}
