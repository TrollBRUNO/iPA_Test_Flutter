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
    logger.i("🔵 Splash: запуск приложения");

    // 1. Инициализация FCM
    unawaited(NotificationService.initFCM());
    logger.i("🔵 FCM инициализирован");

    // 2. Загружаем access token
    final loadedAccess = await TokenService.loadAccessToken();
    logger.i("🔵 Загруженный accessToken: $loadedAccess");

    // 3. Загружаем refresh token
    final refreshToken = await TokenService.getRefreshToken();
    logger.i("🔵 Загруженный refreshToken: $refreshToken");

    await Future.delayed(const Duration(milliseconds: 500));

    // 4. Если refreshToken есть — пробуем обновить
    if (refreshToken != null) {
      logger.i("🟡 Refresh token найден. Пробуем обновить access token...");

      final success = await AuthService.refreshToken();

      logger.i("🟡 Результат refreshToken(): $success");

      if (success) {
        logger.i("🟢 Refresh успешен! Загружаем профиль...");

        try {
          // 5. Проверка спина
          try {
            final canSpin = await AccountTimeService.canSpin();
            logger.i("🔵 Проверка спина: $canSpin");
          } catch (e) {
            logger.w("⚠️ Ошибка при проверке спина: $e");
          }

          await AuthService.loadProfile();
          logger.i(
            "🟢 Профиль загружен: "
            "username=${UserSession.username}, "
            "balance=${UserSession.balance}, "
            "bonus=${UserSession.bonusBalance}, "
            "fake=${UserSession.fakeBalance}",
          );

          context.go('/wheel');
          return;
        } catch (e, st) {
          logger.e("🔴 Ошибка загрузки профиля: $e\n$st");
        }
      } else {
        logger.w("🔴 Refresh не удался. Чистим токены...");
        await TokenService.clearTokens();
      }
    } else {
      logger.w("🔴 Refresh token отсутствует!");
    }

    // 6. Переход на авторизацию
    logger.w("🔴 Переходим на экран авторизации");
    context.go('/authorization');
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
