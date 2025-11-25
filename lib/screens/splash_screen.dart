import 'package:first_app_flutter/config/notification_config.dart';
import 'package:first_app_flutter/services/notification_service.dart';
import 'package:first_app_flutter/services/spin_time_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('login');
    final password = prefs.getString('password');

    await NotificationService().initNotification();
    NotificationManager.initializeAllNotifications();

    // Предварительная проверка возможности спина
    await _preCheckSpinAvailability(prefs);

    await Future.delayed(const Duration(seconds: 1)); // для красоты

    if (user != null && password != null) {
      context.go('/news'); // если авторизован
    } else {
      context.go('/authorization'); // если нет
    }
  }

  Future<void> _preCheckSpinAvailability(SharedPreferences prefs) async {
    try {
      // предварительно проверяем и сохраняем флаг возможности спина
      final canSpin = await TimeService.canSpinToday();
      await prefs.setBool('can_spin_today', canSpin);

      /* if (canSpin) {
        // Показываем уведомление №1 только один раз
        final alreadyNotified = prefs.getBool('notified_spin_today') ?? false;
        if (!alreadyNotified) {
          await NotificationManager.sendSpinAvailableNow(); // тут showOneTimeNotification
          await prefs.setBool('notified_spin_today', true);
        }
        await NotificationManager.cancelFollowUpSpinReminder();
        await prefs.setBool('spin_followup_active', false);
      } else {
        // Ежедневное напоминание №11
        await NotificationManager.scheduleFollowUpSpinReminder(); // тут showDailyNotification
        await prefs.setBool('spin_followup_active', true);
        await prefs.setBool('notified_spin_today', false);
      } */

      // чтобы ресетнуть колесо и другое
      await prefs.setString('last_spin_date', '2025-10-19T00:51:39.050430Z');
      await prefs.setBool('can_spin_today', true);

      /* await prefs.setString(
        'last_credit_take_date',
        '2025-10-19T00:51:39.050430Z',
      ); */

      // Отменяем все уведомления и удаляем scheduled_notifications.xml
      // Раскомментируйте следующую строку, если нужно деактивировать все уведомления:
      //await NotificationManager.deactivateAllNotifications();

      //await prefs.remove('bonus_balance');
      //await prefs.setString('bonus_balance', '0');
    } catch (e) {
      // В случае ошибки разрешаем спин
      Logger().w('Error during pre-check spin availability: $e');
      await prefs.setBool('can_spin_today', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          "assets/lottie/Poker_Chip_Shuffle.json",
          width: 300,
          height: 300,
          repeat: true,
        ),
      ),
    );
  }
}
