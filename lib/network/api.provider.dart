import 'package:poeta_auth0_client/network/custom.exception.dart';
import 'package:poeta_auth0_client/storage/storage.helper.dart';
import 'package:poeta_auth0_client/storage/storage.keys.dart';
import 'package:http/http.dart' as http;
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
      final response = await http.get(domain + url);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}