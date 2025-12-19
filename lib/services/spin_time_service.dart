import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountTimeService {
  static const String _baseUrl = 'http://192.168.33.187:3000';

  static Dio get _dio => AuthService.dio;

  // ---------- CAN SPIN ----------
  /* static Future<SpinAvailability> canSpin() async {
    final res = await _dio.get('http://192.168.33.187:3000/account/can-spin');

    return SpinAvailability(
      canSpin: res.data['canSpin'] == true,
      nextSpin: res.data['nextSpin'] != null
          ? DateTime.parse(res.data['nextSpin'])
          : null,
    );
  } */

  // ---------- CAN SPIN ----------
  static Future<bool> canSpin() async {
    final res = await _dio.get('$_baseUrl/account/can-spin');
    return res.data['canSpin'] == true;
  }

  // ---------- NEXT SPIN ----------
  static Future<DateTime?> nextSpin() async {
    final res = await _dio.get('$_baseUrl/account/can-spin');

    if (res.data['canSpin'] == true) return null;
    return DateTime.parse(res.data['nextSpin']);
  }

  // ---------- SPIN ----------
  static Future<SpinResult> spin(List<int> wheel) async {
    final res = await _dio.post('$_baseUrl/wheel', data: {'wheel': wheel});

    return SpinResult.fromJson(res.data);
  }

  // ---------- ПРОВЕРКА возможности взять кредит ----------
  static Future<Map<String, dynamic>> canTakeCredit() async {
    final res = await _dio.get('$_baseUrl/account/can-take');
    return {
      'canTake': res.data['canTake'] == true,
      'nextTake': res.data['nextTake'] != null
          ? DateTime.parse(res.data['nextTake'])
          : null,
    };
  }

  // ---------- Фактическое начисление fake_balance ----------
  static Future<int> saveCreditTake({int amount = 1000}) async {
    final res = await _dio.post(
      '$_baseUrl/account/take-credit',
      data: {'amount': amount},
    );
    // возвращаем новый fake_balance
    return res.data['fake_balance'] as int;
  }
}

class SpinResult {
  final int index;
  final int prize;

  SpinResult({required this.index, required this.prize});

  factory SpinResult.fromJson(Map<String, dynamic> json) {
    return SpinResult(index: json['index'], prize: json['prize']);
  }
}

class SpinAvailability {
  final bool canSpin;
  final DateTime? nextSpin;

  SpinAvailability({required this.canSpin, this.nextSpin});
}
