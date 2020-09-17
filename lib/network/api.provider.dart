import 'package:dio/dio.dart';
import 'package:poeta_auth0_client/helpers/http.helper.dart';
import 'package:poeta_auth0_client/network/custom.exception.dart';
import 'package:poeta_auth0_client/storage/storage.helper.dart';
import 'package:poeta_auth0_client/storage/storage.keys.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class ApiProvider {

  static ApiProvider _instance;


   static Future<ApiProvider> getInstance() async {
     if (_instance == null) {
       _instance = ApiProvider._internal();
       await _instance.init();
     }
     return _instance;
   }

  ApiProvider._internal();

  String domain;
  String clientId;
  String redirectUri;

  String get issuer => 'https://$domain';

  Future init() async{
    domain = await StorageHelper.getString(StorageKeys.domain);
    clientId = await StorageHelper.getString(StorageKeys.clientId);
    redirectUri = await StorageHelper.getString(StorageKeys.redirectUri);
  }

  Future<dynamic> get(String url) async {
    var responseJson;
    try {

      final response = await HttpHelper.get(domain + url);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.data.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.data.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}