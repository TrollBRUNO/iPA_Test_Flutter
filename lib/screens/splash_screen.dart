import 'package:first_app_flutter/services/spin_time_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
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

    // Предварительная проверка возможности спина
    await _preCheckSpinAvailability(prefs);

    await Future.delayed(const Duration(seconds: 1)); // для красоты

    if (user != null && password != null) {
      context.go('/wheel'); // если авторизован
    } else {
      context.go('/authorization'); // если нет
    }
  }

  Future<void> _preCheckSpinAvailability(SharedPreferences prefs) async {
    try {
      // Предварительно проверяем и сохраняем флаг возможности спина
      final canSpin = await SpinTimeService.canSpinToday();
      await prefs.setBool('can_spin_today', canSpin);

      // чтобы ресетнуть колесо
      await prefs.setString('last_spin_date', '2025-10-19T00:51:39.050430Z');

      await prefs.setBool('can_spin_today', true);
      //await prefs.remove('bonus_balance');
    } catch (e) {
      // В случае ошибки разрешаем спин
      Logger().w('Error during pre-check spin availability: $e');
      await prefs.setBool('can_spin_today', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
