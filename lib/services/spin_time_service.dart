//import 'dart:developer';

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpinTimeService {
  static var logger = Logger();
  static const String _apiUrl =
      'https://timeapi.io/api/Time/current/zone?timeZone=Europe/Sofia';

  static Future<DateTime> getServerTime() async {
    try {
      final response = await http
          .get(Uri.parse(_apiUrl))
          .timeout(
            const Duration(seconds: 1),
            onTimeout: () {
              logger.i(
                'Время сервера превысило лимит ожидания, используем локальное время',
              );
              throw Exception('⏱ Таймаут при обращении к API');
            },
          );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.i('Используем глобальное время: ${data['dateTime']}');
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

    if (lastSpinString == null) return true;

    final lastSpin = DateTime.parse(lastSpinString);

    // Сравниваем только календарные даты в UTC — если сегодня позже даты последнего спина, разрешаем
    final todayUtc = DateTime.utc(now.year, now.month, now.day);
    final lastDayUtc = DateTime.utc(
      lastSpin.year,
      lastSpin.month,
      lastSpin.day,
    );
    return todayUtc.isAfter(lastDayUtc);
  }

  static Future<void> saveSpinDate() async {
    final prefs = await SharedPreferences.getInstance();
    final now = await getServerTime();
    await prefs.setString('last_spin_date', now.toIso8601String());
    logger.i('Я записал!');
  }
}
