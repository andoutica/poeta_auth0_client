import 'package:poeta_auth0_client/repository/auth.repository.dart';
import 'package:poeta_auth0_client/repository/user.repository.dart';
import 'package:poeta_auth0_client/storage/storage.helper.dart';
import 'package:poeta_auth0_client/storage/storage.keys.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Auth0Client {

  static Auth0Client _auth0;

  static Future<Auth0Client> initial(
      String domain, String clientId, String redirectUri) async {
    StorageHelper.setString(StorageKeys.domain, domain);
    StorageHelper.setString(StorageKeys.clientId, clientId);
    StorageHelper.setString(StorageKeys.redirectUri, redirectUri);
    return getInstance();
  }

  static Future<Auth0Client> getInstance() async {
    if (_auth0 == null) {
      _auth0 = Auth0Client();
    }
    return _auth0;
  }

  static Future<String> login() async{
    AuthRepository authRepository = AuthRepository();
    try{
      final isLogged = await authRepository.checkLoggedId();
      TokenResponse tokenResponse;
      if(!isLogged){
         tokenResponse = await authRepository.login();
      }
      else {
        tokenResponse = await authRepository.refreshToken();
      }
      return tokenResponse.idToken;
    }
    catch(e){
      throw Exception(e);
    }
  }

  static Future<String> refreshToken() async{
    AuthRepository authRepository = AuthRepository();
    try{
      final tokenResponse = await authRepository.refreshToken();
      if(tokenResponse!=null){
        return tokenResponse.idToken;
      }
      else
        throw Exception(["The refresh_token is not found."]);
    }
    catch(e){
      throw Exception(e);
    }
  }

  static Future<Map<String, dynamic>> loginWithJWT() async{
    AuthRepository authRepository = AuthRepository();
    try{
      final isLogged = await authRepository.checkLoggedId();
      TokenResponse tokenResponse;
      if(!isLogged){
        tokenResponse = await authRepository.login();
      }
      else {
        tokenResponse = await authRepository.refreshToken();
      }
      String token =tokenResponse.idToken;
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      print(decodedToken["name"]);
      bool isTokenExpired = JwtDecoder.isExpired(token);
      if (isTokenExpired) {
        throw Exception(["The idToken is Expired"]);
      }
      return decodedToken;
    }
    catch(e){
      throw Exception(e);
    }
  }

  static Future<Map<String, dynamic>> refreshTokenWithJWT() async{
    AuthRepository authRepository = AuthRepository();
    try{
      final tokenResponse = await authRepository.refreshToken();
      if(tokenResponse!=null){
        String token =tokenResponse.idToken;
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        bool isTokenExpired = JwtDecoder.isExpired(token);
        if (isTokenExpired) {
          throw Exception(["The idToken is expired"]);
        }
        return decodedToken;
      }
      else
        throw Exception(["The refresh_token is not found."]);
    }
    catch(e){
      throw Exception(e);
    }
  }

  static Future<void> logout() async{
    AuthRepository authRepository = AuthRepository();
    await authRepository.logout();
  }

  static Future<Map<String, dynamic>> getUserDetails(Function() success) async{
    UserRepository userRepository = UserRepository();
    Map<String, dynamic> userDetails  = await userRepository.getUserDetails();
    return userDetails;
  }

}
