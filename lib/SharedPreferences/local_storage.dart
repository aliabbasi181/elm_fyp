import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? _preferences;
  static const _keyId = '_id';
  static const _keyEmail = 'email';
  static const _keyPassword = 'password';
  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setCredentials(String email, String password, String id) async {
    await _preferences?.setString(_keyEmail, email);
    await _preferences?.setString(_keyPassword, password);
    await _preferences?.setString(_keyId, id);
    print("saved credentials");
  }

  static Future<List<String?>> getUser() async {
    List<String?> user = [];
    user.add(await _preferences?.getString(_keyId).toString());
    user.add(await _preferences?.getString(_keyEmail).toString());
    user.add(await _preferences?.getString(_keyPassword).toString());
    return user;
  }

  static Future removeUser() async {
    await _preferences?.remove(_keyId);
    await _preferences?.remove(_keyEmail);
    await _preferences?.remove(_keyPassword);
    print("removed user");
  }
}
