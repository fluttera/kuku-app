
import 'dart:io';

main() async {

  handleSearchRcmdService(HttpRequest request) {
    print('handleSearchRcmdService');
    request.response.write(
        """{
    "list":[
        {
        "show": "大神捕鱼-新手礼包",
        "keywords": "大神捕鱼",
        "type": 2,
        "icon": "http://game.kuku168.cn/public/img/91qixi-logo@2x.png"
        },
        {
        "show": "魔界战记",
        "keywords": "魔界战记",
        "type": 1,
        "icon": "https://imgweb.kuku168.cn/35803606e5964c91b9e6e675ace19bbe"
        },
        {
        "show": "真封神外传-线下返利活动",
        "keywords": "真封神外传",
        "type": 3,
        "icon": "https://imgweb.kuku168.cn/3103af6eaa6e4ff996a7b90ee9844be4"
        },
         {
        "show": "双倍传奇",
        "keywords": "双倍传奇",
        "type": 1,
        "icon": "https://imgweb.kuku168.cn/696e1f2817804654a8b3a5721e83fa85"
        }
        
        ]
    }""");
    request.response.close();
  }


  HttpServer.bind('0.0.0.0', 8080).then((HttpServer server){
    server.listen((request){
      print('request uri path ${request.uri.path}');
      String path = request.uri.path;
      if(path.indexOf("/search/recmd") != -1){
        handleSearchRcmdService(request);
      }else if(path.indexOf('/search/hot') != -1){
        handleSearchRcmdService(request);
      }else{
        request.response.write('Not Found');
        request.response.close();
      }
    });
  });

}
