import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {

  static FlutterSecureStorage _secureStorage ;

  static dynamic _getInstance() async => _secureStorage =  FlutterSecureStorage();

  static Future<String> getString(String key) async {
    await _getInstance();
    return _secureStorage.read(key: key);
  }

  static void setString(String key, String value) async {
    await _getInstance();
    _secureStorage.write(key: key, value: value);
  }

  static void remove(String key) async {
    await _getInstance();
    _secureStorage.delete(key: key);
  }
}
