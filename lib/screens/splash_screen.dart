import 'package:first_app_flutter/class/user_session.dart';
import 'package:first_app_flutter/config/notification_config.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/services/notification_service.dart';
import 'package:first_app_flutter/services/spin_time_service.dart';
import 'package:first_app_flutter/services/token_service.dart';
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
  String? username = "";
  String? balanceCount = "0";
  String? bonusBalanceCount = "0";
  String? fakeBalanceCount = "0";
  String? image_url = "";

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /* Future<void> _checkAuth() async {
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
  } */

  Future<void> _initializeApp() async {
    await NotificationService().initNotification();
    NotificationManager.initializeAllNotifications();
    //await TokenService.loadAccessToken();
    TokenService.accessToken = null;

    // Предварительная проверка возможности спина
    await _preCheckSpinAvailability();

    await Future.delayed(const Duration(seconds: 1)); // для красоты

    // Проверяем токены
    final refreshToken = await TokenService.getRefreshToken();

    if (refreshToken != null) {
      // Пробуем обновить access_token
      final success = await AuthService.refreshToken();
      if (success) {
        await AuthService.loadProfile();
        context.go('/wheel');
        return;
      } else {
        // Токен просрочен или невалиден — очистка
        await TokenService.clearTokens();
      }
    }

    // Если токена нет или не удалось обновить
    context.go('/authorization');
  }

  /* Future<void> _preCheckSpinAvailability(SharedPreferences prefs) async {
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
  } */

  Future<void> _preCheckSpinAvailability() async {
    try {
      // предварительно проверяем и сохраняем флаг возможности спина
      final canSpin = await AccountTimeService.canSpin();

      // В новых реалиях можно хранить флаги в памяти или локально через secure storage,
      // но для совместимости пока оставим SharedPreferences только для таких флагов
      // (не для логина/пароля)
      /* final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('can_spin_today', canSpin); */

      // для теста или сброса состояния
      Logger().i('Can spin today: $canSpin');

      // чтобы ресетнуть колесо и другое
      /* await prefs.setString('last_spin_date', '2025-10-19T00:51:39.050430Z');
      await prefs.setBool('can_spin_today', true); */
    } catch (e) {
      Logger().w('Error during pre-check spin availability: $e');
      // в случае ошибки разрешаем спин по умолчанию
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
