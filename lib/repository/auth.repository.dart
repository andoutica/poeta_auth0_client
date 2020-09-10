import 'package:poeta_auth0_client/network/auth.service.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

class AuthRepository {
  final AuthService api = AuthService();

  Future<TokenResponse> login() async {
    return await this.api.login();
  }

  Future<TokenResponse> refreshToken() async {
    return await this.api.refreshToken();
  }

  Future<void> logout() async {
    return await this.api.logout();
  }

  Future<String> getRefreshToken() async {
    return await this.api.getRefreshToken();
  }

  Future<bool> checkLoggedId() async {
    final storedRefreshToken = await getRefreshToken();
    return storedRefreshToken != null;
  }
}
