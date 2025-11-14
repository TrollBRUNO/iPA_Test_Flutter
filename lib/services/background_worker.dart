// lib/services/background_worker.dart
import 'dart:io';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_app_flutter/services/spin_time_service.dart';
import 'package:first_app_flutter/config/notification_config.dart';
import 'package:first_app_flutter/services/notification_service.dart';

const String spinCheckTask = "spin_check_task";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      if (task == spinCheckTask) {
        final prefs = await SharedPreferences.getInstance();
        final canSpin = await SpinTimeService.canSpinToday();

        // Сброс флага уведомления, если спин недоступен
        if (!canSpin) {
          await prefs.setBool('notified_spin_today', false);
          await prefs.setBool('can_spin_today', false);
          await NotificationManager.cancelRepeatSpinReminder();
          return Future.value(true);
        }

        // Если уже уведомляли ранее — пропускаем
        final alreadyNotified = prefs.getBool('notified_spin_today') ?? false;
        if (!alreadyNotified && canSpin) {
          // Инициализируем NotificationService (без UI)
          await NotificationService().initNotification();

          // Отправляем моментальное и планируем ежедневное
          await NotificationManager.sendSpinAvailableNow();

          // пометим что уже уведомили об этом цикле
          await prefs.setBool('notified_spin_today', true);
          await prefs.setBool('can_spin_today', true);
        }
      }
    } catch (e) {
      // Логирование опционально
      // print('Background worker error: $e');
    }
    return Future.value(true);
  });
}
