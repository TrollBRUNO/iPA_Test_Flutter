//import 'dart:developer';

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:first_app_flutter/class/cards.dart';
import 'package:first_app_flutter/class/statistics.dart';
import 'package:first_app_flutter/class/user_session.dart';
import 'package:first_app_flutter/services/token_service.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static var logger = Logger();
  static const String _loginUrl = 'https://live.teleslot.net/login';
  static const String _balanceUrl =
      'https://live.teleslot.net/teleslot_player_api/get_my_balance';
  static const String _jwtKey = 'jwt_token';

  /* static const String _login = 'login';
  static const String _password = 'password'; */

  static const String _baseUrl = 'http://192.168.33.187:3000';

  static final Dio dio = Dio();

  static Future<List<String>> loadCities() async {
    final response = await http.get(Uri.parse('$_baseUrl/casino/cities'));

    if (response.statusCode != 200) return [];

    final List data = jsonDecode(response.body);
    return data.map((e) => e.toString()).toList();
  }

  static Future<bool> login(String login, String password) async {
    try {
      final response = await dio.post(
        '$_baseUrl/auth/login',
        //"http://10.0.2.2:3000/auth/login",
        data: jsonEncode({"login": login, "password": password}),
        //data: jsonEncode({"login": "test123", "password": "test123"}),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        await TokenService.saveAccessToken(data['access_token']);
        await TokenService.saveRefreshToken(data['refresh_token']);
        return true;
      } else {
        logger.w('Auth error');
      }
    } on DioException catch (e) {
      logger.w('DioError: ${e.response?.statusCode} ${e.response?.data}');
      return false;
    }

    return false;
  }

  static Future<bool> refreshToken() async {
    final refreshToken = await TokenService.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await dio.post(
        '$_baseUrl/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final data = response.data;
      await TokenService.saveAccessToken(data['access_token']);
      await TokenService.saveRefreshToken(data['refresh_token']);
      return true;
    } catch (e) {
      await TokenService.clearTokens();
      return false;
    }
  }

  static Future<void> logout() async {
    final refreshToken = await TokenService.getRefreshToken();
    if (refreshToken != null) {
      await dio.post(
        '$_baseUrl/auth/logout',
        data: {'refresh_token': refreshToken},
      );
    }
    await TokenService.clearTokens();
  }

  static Future<String?> registerAndLogin({
    required String login,
    required String password,
    required String realname,
    String? cardId,
    String? city,
  }) async {
    try {
      final body = {
        "login": login,
        "password": password,
        "realname": realname,
        if (cardId != null && city != null)
          "cards": [
            {"card_id": cardId, "city": city, "active": true},
          ],
      };

      logger.i('Registration body: $body');

      /* final response = await http.post(
      Uri.parse('$_baseUrl/account/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    ); */

      final response = await dio.post(
        '$_baseUrl/account/register',
        data: jsonEncode(body),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        try {
          final data = jsonDecode(response.data);

          final message = data['message'] ?? 'registration_failed';

          if (message == 'USERNAME_TAKEN') return 'username_taken';
          if (message == 'CARD_ALREADY_USED') return 'card_already_used';
          if (message == 'MISSING_FIELDS') return 'missing_fields';

          return message.toString().toLowerCase();
        } catch (_) {}

        return 'registration_failed';
      }

      final success = await AuthService.login(login, password);
      if (!success) return 'login_failed';

      return null; // Всё успешно
    } on DioException catch (e, st) {
      final status = e.response?.statusCode;
      final data = e.response?.data;

      logger.w('Registration error [$status]: $data\n$st');

      if (data is Map && data['message'] != null) {
        return data['message'].toString().toLowerCase();
      }

      return 'registration_failed';
    }
  }

  static Future<String?> bindCard({
    required String cardId,
    required String city,
  }) async {
    try {
      await dio.post(
        '$_baseUrl/account/bind-card',
        data: {"card_id": cardId, "city": city},
      );

      return null; // Всё успешно
    } on DioException catch (e, st) {
      final status = e.response?.statusCode;
      final data = e.response?.data;

      logger.w('Bind card error [$status]: $data\n$st');

      if (data is Map && data['message'] != null) {
        return data['message'].toString().toLowerCase();
      }

      return 'bind_card_failed';
    }
  }

  static Future<String?> checkCard(String cardId) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/account/check-card'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'card_id': cardId}),
    );

    if (res.statusCode == 200) return null;

    final data = jsonDecode(res.body);
    return data['message']?.toString().toLowerCase();
  }

  static Future<void> loadProfile() async {
    try {
      final response = await dio.get('$_baseUrl/account/me');
      final data = response.data;
      final dateStr = data['last_credit_take_date'] as String?;

      UserSession.username = data['login']?.toString() ?? '';
      UserSession.balance = data['balance']?.toString() ?? '0';
      UserSession.bonusBalance = data['bonus_balance']?.toString() ?? '0';
      UserSession.fakeBalance = data['fake_balance']?.toString() ?? '0';
      UserSession.imageUrl = data['image_url']?.toString() ?? '';
      UserSession.lastCreditTake = DateTime.tryParse(dateStr ?? '');
    } catch (e, st) {
      logger.w('Error loading profile: $e\n$st');
      rethrow;
    }
  }

  static Future<List<Statistics>> loadStatistics() async {
    try {
      final response = await dio.get('$_baseUrl/statistics/get-profile-stats');
      final List list = response.data['history'];

      return list.map((e) => Statistics.fromJson(e)).toList();
    } catch (e, st) {
      logger.w('Error loading statistics: $e\n$st');
      rethrow;
    }
  }

  static Future<List<Cards>> loadCards() async {
    try {
      final response = await dio.get('$_baseUrl/account/get-profile-cards');
      final List list = response.data['cards'];

      return list.map((e) => Cards.fromJson(e)).toList();
    } catch (e, st) {
      logger.w('Error loading cards: $e\n$st');
      rethrow;
    }
  }

  static Future<void> removeCard(String cardId) async {
    try {
      await dio.patch('$_baseUrl/account/cards/$cardId/deactivate');
      logger.i('Card $cardId deactivated successfully');
    } catch (e, st) {
      logger.w('Error removing card: $e\n$st');
      rethrow;
    }
  }

  static Future<String?> loginAndSaveJwtForCamera() async {
    try {
      final dio = Dio();
      final prefs = await SharedPreferences.getInstance();

      /* var username = prefs.getString(_login);
      var password = prefs.getString(_password); */

      var username = "cvetan";
      var password = "123qweXX";

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

      //logger.i('JWT received: $jwt');

      if (jwt == null || jwt.isEmpty) return null;

      await prefs.setString(_jwtKey, jwt);
      return jwt.toString();
    } catch (e) {
      logger.w('Error getting JWT: $e');
      return null;
    }
  }

  static Future<String?> getJwtForCamera() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_jwtKey);
      return prefs.getString(_jwtKey);
    } catch (e) {
      logger.w('Error getting JWT from storage: $e');
      return null;
    }
  }

  /* static Future<String?> getBalance(String jwt) async {
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
  } */
}
