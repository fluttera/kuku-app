
import 'dart:io';

import 'SearchHandler.dart';

import 'package:kuku_app_flutter/const/Consts.dart';

main() async {

  SearchKeywordsHandler searchKeywordsHandler =  SearchKeywordsHandler();


  HttpServer.bind('0.0.0.0', 8080).then((HttpServer server){
    server.listen((request){
      print('request uri path ${request.requestedUri}');
      String url = request.requestedUri.toString();

      if(url.indexOf(API.search_rcmd_keywords_api) != -1){
        searchKeywordsHandler.handleSearchRecommendService(request);
      }else if(url.indexOf(API.seach_hot_keywords_api) != -1){
        searchKeywordsHandler.handleSearchRecommendService(request);
      }else if(url.indexOf(API.seach_auto_keywords_api) != -1){
        searchKeywordsHandler.handleSearchAutoService(request);
      }else{
        request.response.write('Not Found');
        request.response.close();
      }
    });
  });

}
