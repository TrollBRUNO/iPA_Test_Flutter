import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/services/background_worker.dart';
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

  static Future<bool> canSpin() async {
    final res = await _dio.get('$_baseUrl/account/can-spin');
    return res.data['canSpin'] == true;
  }

  static Future<bool> canTakeCredit() async {
    final res = await _dio.get('$_baseUrl/account/can-take');
    return res.data['canTake'] == true;
  }

  static Future<int> saveCreditTake({int amount = 1000}) async {
    final res = await _dio.post(
      '$_baseUrl/account/take-credit',
      data: {'amount': amount}, // энивей там по дефолту 1000
    );

    logger.w('TAKE CREDIT RESPONSE: ${res.data}');

    return res.data['fake_balance'] as int;
  }

  /* // ---------- CAN SPIN ----------
  static Future<bool> canSpin() async {
    final res = await _dio.get('$_baseUrl/account/can-spin');
    return res.data['canSpin'] == true;
  } */

  // ---------- NEXT SPIN ----------
  static Future<DateTime?> nextSpin() async {
    final res = await _dio.get('$_baseUrl/account/can-spin');

    if (res.data['canSpin'] == true) return null;
    return DateTime.parse(res.data['nextSpin']);
  }

  // ---------- SPIN ----------
  static Future<SpinResult> spin(List<int> wheel) async {
    final res = await _dio.post('$_baseUrl/wheel/spin', data: {'wheel': wheel});

    return SpinResult.fromJson(res.data);
  }

  // ---------- LOAD WHEEL ----------
  /* static Future<List<int>> loadWheel() async {
    final res = await _dio.get('$_baseUrl/wheel');

    // ожидаем массив объектов [{ value: number }, ...]
    final List data = res.data;

    return data.map<int>((item) => item['value'] as int).toList();
  } */

  static Future<List<int>> loadWheel() async {
    final res = await _dio.get('$_baseUrl/wheel');

    final List data = res.data;

    for (final item in data) {
      if (item['value'] == null) {
        logger.w('Wheel item without value: $item');
      }
    }

    return data
        .map<int?>((item) {
          final v = item['value'];
          if (v == null) return null;
          if (v is int) return v;
          if (v is double) return v.toInt();
          return null;
        })
        .whereType<int>() // 👈 убираем null
        .toList();
  }

  /* // ---------- ПРОВЕРКА возможности взять кредит ----------
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
  } */
}

class SpinResult {
  final int index;
  final int prize;

  SpinResult({required this.index, required this.prize});

  factory SpinResult.fromJson(Map<String, dynamic> json) {
    final prizeRaw = json['prize'];
    final indexRaw = json['index'];

    if (prizeRaw == null || indexRaw == null) {
      throw Exception('Invalid spin response: $json');
    }

    int prize;
    if (prizeRaw is int) {
      prize = prizeRaw;
    } else if (prizeRaw is double) {
      prize = prizeRaw.toInt();
    } else {
      throw Exception('Invalid prize type: ${prizeRaw.runtimeType}');
    }

    int index;
    if (indexRaw is int) {
      index = indexRaw;
    } else if (indexRaw is double) {
      index = indexRaw.toInt();
    } else {
      throw Exception('Invalid index type: ${indexRaw.runtimeType}');
    }

    return SpinResult(index: index, prize: prize);
  }
}

class SpinAvailability {
  final bool canSpin;
  final DateTime? nextSpin;

  SpinAvailability({required this.canSpin, this.nextSpin});
}
