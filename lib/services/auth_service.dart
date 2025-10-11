//import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static var logger = Logger();
  static const String _loginUrl = 'https://live.teleslot.net/login';
  static const String _balanceUrl =
      'https://live.teleslot.net/teleslot_player_api/get_my_balance';
  //static const String _username = 'cvetan';
  //static const String _password = '123qweXX';
  static const String _jwtKey = 'jwt_token';

  static const String _login = 'login';
  static const String _password = 'password';

  static Future<String?> loginAndSaveJwt() async {
    try {
      final dio = Dio();
      final prefs = await SharedPreferences.getInstance();

      var username = prefs.getString(_login);
      var password = prefs.getString(_password);

      final response = await dio.post(
        _loginUrl,
        data: 'username=$username&password=$password',
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json',
          },
        ),
      );

      // Проверяем разные возможные форматы ответа
      String? jwt;
      if (response.data is String) {
        jwt = response.data;
      } else if (response.data is Map) {
        jwt = response.data['token'] ?? response.data['jwt'];
      }

      logger.i('JWT received: $jwt');

      if (jwt == null || jwt.isEmpty) return null;

      await prefs.setString(_jwtKey, jwt);
      return jwt.toString();
    } catch (e) {
      logger.w('Error getting JWT: $e');
      return null;
    }
  }

  static Future<String?> getBalance(String jwt) async {
    try {
      final dio = Dio();

      final response = await dio.get(
        _balanceUrl,
        options: Options(headers: {'Cookie': 'jwt_token=$jwt'}),
      );

      if (response.data is Map) {
        final balance = response.data['balance'];
        final currency = response.data['currency'];
        return '${balance / 1000000} $currency';
      } else {
        return "0";
      }
    } catch (e) {
      logger.w('Error getting JWT from storage: $e');
      return null;
    }
  }

  static Future<String?> getJwt() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_jwtKey);
      return prefs.getString(_jwtKey);
    } catch (e) {
      logger.w('Error getting JWT from storage: $e');
      return null;
    }
  }
}
