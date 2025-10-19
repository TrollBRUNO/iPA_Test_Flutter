//import 'dart:developer';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpinTimeService {
  static var logger = Logger();
  static const String _apiUrl =
      'https://timeapi.io/api/Time/current/zone?timeZone=Europe/Sofia';

  static Future<DateTime> getServerTime() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.i('Все четко');
        return DateTime.parse(data['dateTime']).toUtc();
      } else {
        // fallback — если API не отвечает, всё же используем локальное время
        logger.w('Используем локальное время');
        return DateTime.now().toUtc();
      }
    } catch (e) {
      logger.w('Server time fetch error: $e');
      // fallback на локальное время
      return DateTime.now().toUtc();
    }
  }

  static Future<bool> canSpinToday() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSpinString = prefs.getString('last_spin_date');
    final now = await getServerTime();

    if (lastSpinString == null) return false;

    final lastSpin = DateTime.parse(lastSpinString);

    // Проверяем, другой ли календарный день (UTC)
    if (now.year > lastSpin.year ||
        now.month > lastSpin.month ||
        now.day > lastSpin.day) {
      return true;
    }

    return false;
  }

  static Future<void> saveSpinDate() async {
    final prefs = await SharedPreferences.getInstance();
    final now = await getServerTime();
    await prefs.setString('last_spin_date', now.toIso8601String());
    logger.i('Я записал!');
  }
}
