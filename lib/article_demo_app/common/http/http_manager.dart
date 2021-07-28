import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app01/article_demo_app/common/http/api.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class HttpManager {
  late Dio _dio;
  static late final HttpManager _instance = HttpManager._internal();
  late PersistCookieJar _cookieJar;

  factory HttpManager.getInstance() {
    return _instance;
  }

  HttpManager._internal() {
    var baseOptions = BaseOptions(
      baseUrl: Api.baseUrl,
      connectTimeout: 10000,
      receiveTimeout: 10000,
    );
    _dio = Dio(baseOptions);
    _initDio();
  }

  void _initDio() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = Directory(join(directory.path, "cookie")).path;

    ///cookie_jar 官方 example 见dart pub
    ///final cj = PersistCookieJar(storage: FileStorage('./example/.cookies'));
    _cookieJar = PersistCookieJar(storage: FileStorage(path));
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  request(url, {data, String method = "get"}) async {
    try {
      var options = Options(method: method);
      var response = await _dio.request(url, data: data, options: options);
      debugPrint("响应数据: ${response.data}");
      return response.data;
    } catch (e) {
      return null;
    }
  }

  void clearCookie() {
    _cookieJar.deleteAll();
  }
}
