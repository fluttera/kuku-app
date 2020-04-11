import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

void main() async{
  HttpClient httpClient = HttpClient();
  // 设置连接超时时间
  httpClient.connectionTimeout = Duration(seconds: 5);
  // 设置连接空闲时间，默认为15s
  httpClient.idleTimeout = Duration(seconds: 5);
  // 开启body压缩，默认是true不压缩的，在body大的时候，压缩是不错的选择
  httpClient.autoUncompress = false;
  // 设置到单个主机Host请求的最大连接数，值越大系统开销越大，默认设置null禁用
  httpClient.maxConnectionsPerHost = null;
  // 修改请求UA
  httpClient.userAgent = "KUKUAPP(V-1.0.1)";


  Uri uri = Uri(
    scheme: 'https',
    host: 'game.kuku168.cn',
    // query: 'name=纵剑仙界&other=123', // 和queryParameters一样,2个只能存在一个，推荐使用queryParameters
    queryParameters: {
      'name':'纵剑仙界',
      'other':'123'
    },
    userInfo: '' ,// 需要带权限用户认证信息， 比如user:password@host...
    // path: '/game/search', // 域名后的一段，不包含?后面
    pathSegments: ['game','search'] // 和path作用一样，2个只能存在一个， 这种方式默认会拼接上 /
  );
  HttpClientRequest request = await httpClient.getUrl(uri);
  // 等待连接服务，done之后返回response
  HttpClientResponse response = await request.close();
  // 读取响应内容
  String responseBody = await response.transform(utf8.decoder).join();
  // 关闭client后，通过该client发起的所有请求都会中止。
  httpClient.close();
  print('request $uri, response-> $responseBody');


  //// dio

  Dio dio = Dio();
  dio.options..connectTimeout = 5000
  ..receiveTimeout = 10000
  ..headers = {
    'user-agent' : 'KUKUAPP(V-1.0.1)'
  }
  ..sendTimeout = 3000
  ..validateStatus = (int status){
    return status > 0;
  };

  Response resp = await dio.getUri(uri);
  print('Dio response -> ${resp.data.toString()}');
}
