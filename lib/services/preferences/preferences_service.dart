import 'dart:convert';

import 'package:epkk_nganjuk/features/auth/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _userKey = 'user_data';

  /// TOKEN
  static const String _tokenKey = 'token';

  static const String _loginTimestampKey = 'login_timestamp';

  static const int _expiryDuration = 86400;

  /// ================= SAVE USER =================
  static Future<void> saveUser(
    UserData user,
    String token,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    /// SAVE USER
    await prefs.setString(
      _userKey,
      jsonEncode(user.toJson()),
    );

    /// SAVE TOKEN
    await prefs.setString(
      _tokenKey,
      token,
    );

    /// SAVE LOGIN TIME
    await prefs.setInt(
      _loginTimestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// ================= GET USER =================
  static Future<UserData?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    String? userData = prefs.getString(_userKey);

    if (userData != null) {
      final user = UserData.fromJson(
        jsonDecode(userData),
      );

      print('Retrieved User: ${user.toJson()}');

      return user;
    }

    return null;
  }

  /// ================= GET TOKEN =================
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_tokenKey);
  }

  /// ================= LOGIN EXPIRED =================
  static Future<bool> isLoginExpired() async {
    final prefs = await SharedPreferences.getInstance();

    int? loginTimestamp = prefs.getInt(_loginTimestampKey);

    if (loginTimestamp != null) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      final elapsedTime = currentTime - loginTimestamp;

      return elapsedTime > _expiryDuration * 1000;
    }

    return true;
  }

  /// ================= CLEAR USER =================
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_userKey);

    await prefs.remove(_tokenKey);

    await prefs.remove(_loginTimestampKey);
  }
}