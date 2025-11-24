import 'package:feature/core/core_language.dart';
import 'package:feature/core/data_source/data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPreserverController {
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const tag = 'AuthPreserverController';

  static Future<bool> refreshAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final String? refreshToken = prefs.getString(_keyRefreshToken);
      Logger.keyValueOff(tag, 'refreshAccessToken', 'response', refreshToken);
      if (refreshToken == null) {
        throw UnauthorizedException();
      }
      final token =
          await ApiFactory.create().auth().readAccessTokenOrThrow(refreshToken);
      await prefs.setString(_keyAccessToken, token.first);
      return true;
    } catch (e) {
      return false;
    }
  }

  ///After successful auth this can be useful
  static Future<void> saveToken({required String accessToken, required String refreshToken}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
    Logger.keyValueOff(tag, 'saveToken', 'access_token', accessToken);
    Logger.keyValueOff(tag, 'saveToken','refresh_token',refreshToken);
  }

  static Future<String> retrieveTokenOrThrow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString(_keyAccessToken);
    final String? refreshToken = prefs.getString(_keyRefreshToken);
    Logger.keyValueOff(tag, '_retrieveTokenOrNull', 'accessToken',  accessToken);
    Logger.keyValueOff(tag, '_retrieveTokenOrNull', 'refreshToken', refreshToken);
    if (accessToken != null) {
      return accessToken;
    }
    throw UnauthorizedException();
  }

  static Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    final String? accessToken = prefs.getString(_keyAccessToken);
    final String? refreshToken = prefs.getString(_keyRefreshToken);
    Logger.keyValueOff(tag, 'clear','accessToken', accessToken);
    Logger.keyValueOff(tag, 'clear','refreshToken', refreshToken);
  }
}