import 'package:first_app_flutter/services/notification_service.dart';
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
      body: 'Зайди и проверь новую возможность выиграть!',
      hour: 15,
      minute: 30,
      prefKey: 'notif1',
    ),
    NotificationConfig(
      id: 2,
      title: 'Напоминание забрать бонус',
      body: 'Не забудь забрать бонус!',
      hour: 01,
      minute: 00,
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

  static Future<void> initializeAllNotifications() async {
    try {
      for (var config in notifications) {
        final isEnabled = await loadSwitchState(config.prefKey, true);
        if (isEnabled) {
          await NotificationService().showDailyNotification(
            id: config.id,
            title: config.title,
            body: config.body,
            //scheduledNotificationDateTime: scheduleTime,
            hour: config.hour,
            minute: config.minute,
          );
        }
      }
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  static Future<void> sendSpinAvailableNow() async {
    final prefs = await SharedPreferences.getInstance();
    // Тексты, которые ты указал:
    const nowTitle = 'Колесо удачи снова готово! Проверь свою удачу 🎰';
    const dailyBody =
        'Не забудь использовать колесо удачи! Скорее узнай что тебе выпадет 🎁';

    // Отправляем мгновенное (чтобы пользователь видел сразу)
    await NotificationService().showInstantNotification(
      id: 1,
      title: nowTitle,
      body: dailyBody,
    );

    // Затем планируем ежедневное напоминание (тот же id=1 — оно будет повторяться)
    // В NotificationConfig.notifications у тебя есть объект с id:1 + hour/minute — используем их
    final cfg = notifications.firstWhere((c) => c.id == 1);
    await NotificationService().showDailyNotification(
      id: cfg.id,
      title:
          cfg.title, // можешь оставить cfg.title или использовать другой текст
      body: cfg.body,
      hour: cfg.hour,
      minute: cfg.minute,
    );

    await prefs.setBool('spin_daily_enabled', true);
  }

  static Future<void> cancelRepeatSpinReminder() async {
    final prefs = await SharedPreferences.getInstance();
    await NotificationService().cancelNotification(1);
    await prefs.setBool('spin_daily_enabled', false);
  }
}
