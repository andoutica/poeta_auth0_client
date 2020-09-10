import 'dart:convert';

import 'package:poeta_auth0_client/helpers/http.helper.dart';
import 'package:poeta_auth0_client/network/api.provider.dart';

class UserService {
  Future<Map<String, dynamic>> getUserDetails() async {
    ApiProvider _provider = await ApiProvider.getInstance();
    final url = 'https://${_provider.domain}/userinfo';

    final response = HttpHelper.get(url);

    await response.then((res) {
      return jsonDecode(res.data);
    }).catchError((e) {
      throw Exception(e);
    });
  }
}
