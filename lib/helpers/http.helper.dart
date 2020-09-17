import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HttpHelper {
  static Dio _client;

  static Future<Dio> _getInstance() async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final accessToken = await secureStorage.read(key: 'access_token');

    if (_client == null) _client = Dio();

    Map<String, dynamic> headers = {};
    headers['Content-Type'] = 'application/json';
    if (accessToken != null) headers['Authorization'] = 'Bearer $accessToken';

    _client.options.headers = headers;
    return _client;
  }

  static Future<Response> get(String url) async {
    final instance = await _getInstance();
    return instance.get(url);
  }

  static Future<Response> post(String url, {dynamic body}) async {
    final instance = await _getInstance();
    return instance.post(url, data: jsonEncode(body));
  }

  static Future<Response> put(String url, {dynamic body}) async {
    final instance = await _getInstance();
    return instance.put(url, data: jsonEncode(body));
  }

  static Future<Response> delete(String url, {dynamic body}) async {
    final instance = await _getInstance();
    return instance.delete(url);
  }
}
