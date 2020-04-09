import 'package:flutter/material.dart' show BuildContext;
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, Consumer, Consumer2, MultiProvider, Provider;
import 'package:kuku_app_flutter/models/search/SearchKeywordsModel.dart';

class Store {

  static BuildContext context;
  static BuildContext widgetCtx;

  //  我们将会在main.dart中runAPP实例化init
  static init({context, child}) {
    return MultiProvider(
      // 需要管理多个状态，在这里添加
      providers: [
        ChangeNotifierProvider(
          create: (context) => SearchKeywordsModel(count: 3),
        ),
      ],
      child: child,
    );
  }

  //  通过Provider.value<T>(context)获取状态数据
  static T value<T> (context, listen) {
    return Provider.of<T>(context, listen: listen);
  }

  //  通过Consumer获取状态数据
  static Consumer connect<T>({builder, child}) {
    return Consumer<T>(builder: builder, child: child);
  }

  static Consumer2 connect2<A, B>({builder, child}) {
    return Consumer2<A, B>(builder: builder, child: child);
  }

}
