// lib/services/background_worker.dart
import 'package:logger/web.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_app_flutter/services/spin_time_service.dart';
import 'package:first_app_flutter/config/notification_config.dart';
import 'package:first_app_flutter/services/notification_service.dart';

const String spinCheckTask = "spin_check_task";
final Logger logger = Logger();

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await checkAndSendBonusNotification();

      if (task == spinCheckTask) {
        final prefs = await SharedPreferences.getInstance();
        final canSpin = await TimeService.canSpinToday();

        await prefs.setBool('can_spin_today', canSpin);

        final alreadyNotified = prefs.getBool('notified_spin_today') ?? false;
        //final followUpActive = prefs.getBool('spin_followup_active') ?? false;

        if (canSpin) {
          // Показываем уведомление №1 только один раз
          if (alreadyNotified == true) {
            logger.i('SEND NOTIF #1.');
            await prefs.setBool('notified_spin_today', false);

            //await prefs.setBool('spin_followup_active', true);
            await NotificationManager.scheduleFollowUpSpinReminder();
            await NotificationService().cancelNotification(1);
          } else {
            logger.i('SEND NOTIF #11.');
            await NotificationService().cancelNotification(1);
            await prefs.setBool('notified_spin_today', false);

            //await prefs.setBool('spin_followup_active', true);
            await NotificationManager.scheduleFollowUpSpinReminder();
          }
          // Ежедневное напоминание №11
          /* if (followUpActive) {
            await NotificationManager.scheduleFollowUpSpinReminder();
            await prefs.setBool('spin_followup_active', true);
          } */
        } /* else {
          // Ежедневное напоминание №11
          await NotificationManager.scheduleFollowUpSpinReminder(); // тут showDailyNotification
          await prefs.setBool('spin_followup_active', true);
          await prefs.setBool('notified_spin_today', false);
        } */
      }
    } catch (e) {
      // Логирование опционально
      logger.w('Background worker error: $e');
    }
    return Future.value(true);
  });
}

Future<void> checkAndSendBonusNotification() async {
  final prefs = await SharedPreferences.getInstance();
  final bonusBalanceCount =
      int.tryParse(prefs.getString('bonus_balance') ?? "0") ?? 0;

  final cfg = NotificationManager.notifications.firstWhere((c) => c.id == 2);
  final isBonusReminderEnabled = await NotificationManager.loadSwitchState(
    cfg.prefKey,
    true,
  );

  if (bonusBalanceCount > 0 && isBonusReminderEnabled) {
    await NotificationService().showDailyNotification(
      id: cfg.id,
      title: cfg.title,
      body: cfg.body,
      hour: cfg.hour,
      minute: cfg.minute,
    );
  } else {
    //await NotificationService().cancelNotification(cfg.id);
    // Баланс 0 — уведомление не отправляем
  }
}
