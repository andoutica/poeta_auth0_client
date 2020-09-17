import 'package:poeta_auth0_client/network/user.service.dart';

class UserRepository {
  final UserService api = UserService();

  Future<Map<String, dynamic>> getUserDetails() async {
    return await this.api.getUserDetails();
  }
}
