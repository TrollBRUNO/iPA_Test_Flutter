/* import 'package:first_app_flutter/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationConfig {
  final int id;
  final String title;
  final String body;
  //final DateTime scheduledNotificationDateTime;
  final int hour;
  final int minute;
  final String prefKey;

  NotificationConfig({
    required this.id,
    required this.title,
    required this.body,
    //required this.scheduledNotificationDateTime,
    required this.hour,
    required this.minute,
    required this.prefKey,
  });
}

DateTime scheduleTime = DateTime.now();

class NotificationManager {
  static final List<NotificationConfig> notifications = [
    NotificationConfig(
      id: 1,
      title: 'Уведомление о новой возможности',
      body: 'Колесо удачи снова готово! Проверь свою удачу 🎰',
      hour: 00,
      minute: 01,
      prefKey: 'notif1',
    ),
    NotificationConfig(
      id: 2,
      title: 'Напоминание забрать бонус',
      body: 'Не забудь забрать бонус!',
      hour: 17,
      minute: 55,
      prefKey: 'notif2',
    ),
    NotificationConfig(
      id: 3,
      title: 'Свежие новости и розыгрыши',
      body: 'Проверь колесо удачи!',
      hour: 01,
      minute: 00,
      prefKey: 'notif3',
    ),
    NotificationConfig(
      id: 4,
      title: 'Уведомление о больших выигрышах',
      body: 'Кто-то только что сорвал джекпот!',
      hour: 01,
      minute: 00,
      prefKey: 'notif4',
    ),
    NotificationConfig(
      id: 5,
      title: 'Объявление о пиковом джекпоте',
      body: 'Загляни, пока не поздно!',
      hour: 01,
      minute: 00,
      prefKey: 'notif5',
    ),
    NotificationConfig(
      id: 6,
      title: 'Загляни, пока не поздно!',
      body: 'Попробуй новые автоматы не выходя из дома',
      hour: 01,
      minute: 00,
      prefKey: 'notif6',
    ),
    NotificationConfig(
      id: 7,
      title: 'Загляни, пока не поздно!',
      body: 'Попробуй новые автоматы не выходя из дома',
      hour: 01,
      minute: 00,
      prefKey: 'notif7',
    ),
    NotificationConfig(
      id: 8,
      title: 'Загляни, пока не поздно!',
      body: 'Попробуй новые автоматы не выходя из дома',
      hour: 01,
      minute: 00,
      prefKey: 'notif8',
    ),
    NotificationConfig(
      id: 9,
      title: 'Загляни, пока не поздно!',
      body: 'Попробуй новые автоматы не выходя из дома',
      hour: 01,
      minute: 00,
      prefKey: 'notif9',
    ),

    NotificationConfig(
      id: 11,
      title: 'Уведомление о новой возможности',
      body:
          'Не забудь использовать колесо удачи! Скорее узнай что тебе выпадет 🎁',
      hour: 14,
      minute: 55,
      prefKey: 'notif11',
    ),
  ];

  /* static List<NotificationConfig> get notifications {
    final now = DateTime.now();
    return List.generate(6, (i) {
      final scheduled = now.add(Duration(minutes: i + 1)); // +1, +2, ...
      return NotificationConfig(
        id: i + 1,
        title: [
          'Колесо удачи!',
          'Напоминание!',
          'Новый шанс!',
          'Большой выигрыш!',
          'Ночная активность',
          'Пиковый джекпот',
        ][i],
        body: [
          'Зайди и проверь новую возможность выиграть!',
          'Не забудь забрать бонус!',
          'Проверь колесо удачи!',
          'Кто-то только что сорвал джекпот!',
          'Загляни, пока не поздно!',
          'Загляни, пока не поздно!',
        ][i],
        scheduledNotificationDateTime: DateTime.now(),
        hour: scheduled.hour,
        minute: scheduled.minute,
        prefKey: 'notif${i + 1}',
      );
    });
  } */

  static Future<void> saveSwitchState(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool> loadSwitchState(String key, bool defaultValue) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }

  static Future<void> toggleNotification(
    NotificationConfig config,
    bool enabled,
  ) async {
    await saveSwitchState(config.prefKey, enabled);

    if (enabled) {
      final canSchedule = await _shouldScheduleNotification(config);
      if (!canSchedule) {
        await NotificationService().cancelNotification(config.id);
        return;
      }
      await NotificationService().showDailyNotification(
        id: config.id,
        title: config.title,
        body: config.body,
        //scheduledNotificationDateTime: scheduleTime,
        hour: config.hour,
        minute: config.minute,
      );
    } else {
      await NotificationService().cancelNotification(config.id);
    }
  }

  static NotificationConfig _configById(int id) {
    return notifications.firstWhere((c) => c.id == id);
  }

  static Future<void> initializeAllNotifications() async {
    try {
      for (var config in notifications) {
        final defaultEnabled = config.id == 11 ? false : true;
        final isEnabled = await loadSwitchState(config.prefKey, defaultEnabled);
        if (isEnabled && await _shouldScheduleNotification(config)) {
          await NotificationService().showDailyNotification(
            id: config.id,
            title: config.title,
            body: config.body,
            //scheduledNotificationDateTime: scheduleTime,
            hour: config.hour,
            minute: config.minute,
          );
        } else {
          await NotificationService().cancelNotification(config.id);
        }
      }
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  static Future<void> sendSpinAvailableNow() async {
    final cfg = _configById(1);

    final now = DateTime.now();
    final nextTime =
        DateTime(
          now.year,
          now.month,
          now.day,
          cfg.hour,
          cfg.minute,
        ).isAfter(now)
        ? DateTime(now.year, now.month, now.day, cfg.hour, cfg.minute)
        : DateTime(now.year, now.month, now.day + 1, cfg.hour, cfg.minute);

    await NotificationService().showOneTimeNotification(
      id: cfg.id,
      title: cfg.title,
      body: cfg.body,
      dateTime: nextTime,
    );

    //await prefs.setBool('spin_daily_enabled', true);

    await (await SharedPreferences.getInstance()).setBool(
      'notified_spin_today',
      false,
    );

    await NotificationManager.scheduleFollowUpSpinReminder();
    await NotificationService().cancelNotification(1);
  }

  static Future<void> cancelRepeatSpinReminder() async {
    await NotificationService().cancelNotification(1);
  }

  /// Деактивирует все уведомления и отменяет их
  /// Это удалит файл scheduled_notifications.xml на Android
  static Future<void> deactivateAllNotifications() async {
    final notificationService = NotificationService();

    // Отменяем все запланированные уведомления
    await notificationService.cancelAllNotifications();

    // Деактивируем все переключатели уведомлений
    for (var config in notifications) {
      await saveSwitchState(config.prefKey, false);
    }

    // Также отменяем уведомление о спине, если оно активно
  }

  static Future<void> scheduleFollowUpSpinReminder() async {
    final cfg = _configById(11);
    await NotificationService().showDailyNotification(
      id: cfg.id,
      title: cfg.title,
      body: cfg.body,
      hour: cfg.hour,
      minute: cfg.minute,
    );
  }

  static Future<void> cancelFollowUpSpinReminder() async {
    await NotificationService().cancelNotification(11);
  }

  static Future<bool> _shouldScheduleNotification(
    NotificationConfig config,
  ) async {
    if (config.id == 2) {
      final bonusBalanceCount =
          int.tryParse(
            (await SharedPreferences.getInstance()).getString(
                  'bonus_balance',
                ) ??
                "0",
          ) ??
          0;
      return bonusBalanceCount > 0;
    }
    return true;
  }
}
 */
