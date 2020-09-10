import 'dart:convert';

import 'package:auth0_client/network/api.provider.dart';
import 'package:auth0_client/network/user.service.dart';
import 'package:http/http.dart' as http;

class UserRepository {

  final UserService api = UserService();

  Future<Map<String, dynamic>> getUserDetails() async {
    return await this.api.getUserDetails();
  }
}
