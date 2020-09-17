import 'package:poeta_auth0_client/network/api.provider.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FlutterAppAuth appAuth = FlutterAppAuth();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<TokenResponse> login() async {
    ApiProvider _provider = await ApiProvider.getInstance();
    try {
      final result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _provider.clientId,
          _provider.redirectUri,
          issuer: _provider.issuer,
          scopes: ['openid', 'profile', 'offline_access'],
            promptValues: ['login'] // ignore any existing session; force interactive login prompt
        ),
      );
      await secureStorage.write(
          key: 'refresh_token', value: result.refreshToken);

      await secureStorage.write(key: 'access_token', value: result.accessToken);

      return result;
    } catch (e, s) {
      print('login error: $e - stack: $s');
      throw Exception(e);
    }
  }

  Future<TokenResponse> refreshToken() async {
    final storedRefreshToken = await secureStorage.read(key: 'refresh_token');
    if (storedRefreshToken == null) return null;

    ApiProvider _provider = await ApiProvider.getInstance();
    try {
      final result = await appAuth.token(
        TokenRequest(
          _provider.clientId,
          _provider.redirectUri,
          issuer: _provider.issuer,
          refreshToken: storedRefreshToken,
        ),
      );
      if(result.refreshToken ==null || result.refreshToken.isEmpty)
        secureStorage.write(key: 'refresh_token', value: storedRefreshToken);
      else
        secureStorage.write(key: 'refresh_token', value: result.refreshToken);
      secureStorage.write(key: 'access_token', value: result.accessToken);

      return result;
    } catch (e, s) {
      print('error on refresh token: $e - stack: $s');
      logout();
      throw Exception(e);
    }
  }

  Future<void> logout() async {
    await secureStorage.delete(key: 'refresh_token');
  }

  Future<String> getRefreshToken() async {
    return await secureStorage.read(key: 'refresh_token');
  }
}
