import 'dart:async';

import 'package:first_app_flutter/class/user_session.dart';
import 'package:first_app_flutter/config/notification_config.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/services/background_worker.dart';
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

    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        context.go('/authorization');
      }
    });

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    //await NotificationService().initNotification();
    //NotificationManager.initializeAllNotifications();
    //TokenService.accessToken = null;

    // параллельно уведомления
    unawaited(NotificationService.initFCM());

    // Загружаем токен из хранилища
    await TokenService.loadAccessToken();

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

        logger.i(
          'UserSession loaded in SplashScreen init: '
          'username=${UserSession.username}, '
          'balance=${UserSession.balance}, '
          'bonusBalance=${UserSession.bonusBalance}, '
          'fakeBalance=${UserSession.fakeBalance}, '
          'lastCreditTake=${UserSession.lastCreditTake}, '
          'imageUrl=${UserSession.imageUrl}',
        );

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

  Future<void> _preCheckSpinAvailability() async {
    try {
      // предварительно проверяем и сохраняем флаг возможности спина
      final canSpin = await AccountTimeService.canSpin();

      Logger().i('Can spin today: $canSpin');
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
