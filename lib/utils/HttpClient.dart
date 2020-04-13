import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kuku_app_flutter/const/Consts.dart';

/// 单例HttpClient
class HttpClient {
  Dio dio = Dio();

  HttpClient._internal({
    bool refresh,
    bool noCache
  }){
    dio.options
        ..connectTimeout = 5000
        ..receiveTimeout = 10000
        ..validateStatus = (int status){
          return status > 0;
        }
        ..headers = {
          HttpHeaders.userAgentHeader: 'Dio',
          HttpHeaders.authorizationHeader: ''//authorization
        }
        ..extra = {
          'refresh': refresh ?? false,
          'noCache': noCache ?? true
        }
    ;

  }

  /// refresh = true 表示下拉刷新，不从缓存获取数，但数据会缓存到本地
  /// noCache = true 表示不使用缓存，不从缓存获取数据，也不会缓存到本地
  factory HttpClient({
    bool refresh,
    bool noCache
  }) => _getInstance(refresh: refresh, noCache: noCache);

  static get getInstance => _instance;
  static HttpClient _instance;

  static HttpClient _getInstance({
    bool refresh,
    bool noCache
  }){
    if(_instance == null ){
      _instance = HttpClient._internal(refresh: refresh, noCache: noCache);
    }
    return _instance;
  }
  /// 封装Post方法，采用Callback回调请求方
  void post (
      String path, {
        data,
        Map<String, dynamic> queryParameters,
        Options options,
        CancelToken cancelToken,
        ProgressCallback onSendProgress,
        ProgressCallback onReceiveProgress,
        ResponseCallBack responseCallBack
      }) {
    Map<String, dynamic> result;
    dio.post(path, data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress:onReceiveProgress
    ).then((response){
        print('http post $path, status code=${response.statusCode} , response: $response');
        if( response.statusCode == 200 ){
          result = json.decode(response.data.toString());
          responseCallBack(200, result);
        }else{
          responseCallBack(response.statusCode, null);
        }
    });
  }

  Future<Map<String, dynamic>> postFuture (
      String path, {
        data,
        Map<String, dynamic> queryParameters,
        Options options,
        CancelToken cancelToken,
        ProgressCallback onSendProgress,
        ProgressCallback onReceiveProgress,
      }) async {
    Map<String, dynamic> result;

    Response<String> response  = await dio.post(path, data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress:onReceiveProgress
    );

    print('http post future $path, status code=${response.statusCode} , response: $response');

    if( response.statusCode == 200 && response.data !=null && response.data.isNotEmpty ){
      result = json.decode(response.data);
      return result;
    }else{
      return null;
    }
  }

  /// 封装Get方法，采用Callback回调请求方
  Future<Map<String, dynamic>> getFuture (
      String path, {
        Map<String, dynamic> queryParameters,
        Options options,
        CancelToken cancelToken,
        ProgressCallback onReceiveProgress,
      }) async {
    Map<String, dynamic> result;
    Response<String> response = await dio.get(path,
      queryParameters: queryParameters ,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );

    print('http get future $path, status code=${response.statusCode} , response: $response');

    if( response.statusCode == 200 && response.data != null && response.data.isNotEmpty){
      result = json.decode(response.data);
      return result;
    }else{
      return null;
    }
  }


  void get (
      String path, {
        Map<String, dynamic> queryParameters,
        Options options,
        CancelToken cancelToken,
        ProgressCallback onReceiveProgress,
        ResponseCallBack responseCallBack
      }) {
    Map<String, dynamic> result;
    dio.get(path,
      queryParameters: queryParameters ,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    ).then((response){
      print('http get $path, status code=${response.statusCode} , response: $response');
      if( response.statusCode == 200 && response.data != null && response.data.isNotEmpty){
        result = json.decode(response.data.toString());
        responseCallBack(200, result);
      }else{
        responseCallBack(response.statusCode, null);
      }
    });
  }

  /// 封装download方法，采用Callback回调请求方
  void download (
      String path, savePath, {
        ProgressCallback onReceiveProgress,
        Map<String, dynamic> queryParameters,
        CancelToken cancelToken,
        bool deleteOnError = true,
        String lengthHeader = Headers.contentLengthHeader,
        data,
        Options options,
        ResponseCallBack responseCallBack,
      }) {
    dio.download(path, savePath,
      queryParameters: queryParameters ,
      options: options,
      cancelToken: cancelToken,
      deleteOnError: deleteOnError,
      lengthHeader: lengthHeader,
      onReceiveProgress: onReceiveProgress,
      data: data
    ).then((response){
      print('http download $path, status code=${response.statusCode} , response: $response');
      if( response.statusCode == 200 ){
        responseCallBack(200, null);
      }else{
        responseCallBack(response.statusCode, null);
      }
    });
  }
}

class CacheObject{
  Response response;
  int timeStamp;
  CacheObject(this.response):timeStamp = DateTime.now().millisecondsSinceEpoch;

  @override
  bool operator ==(other) {
    return response.hashCode == other.hashCode;
  }

  @override
  int get hashCode => response.realUri.hashCode;
}

class NetCache  extends Interceptor {

}
