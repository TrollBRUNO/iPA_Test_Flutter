/* import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/web.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final Logger logger = Logger();

  Future<void> initNotification() async {
    /* TimezoneInfo currentTimeZone;

    try {
      currentTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(
        tz.getLocation(
          currentTimeZone.localizedName?.name ?? 'Europe/Sofia',
        ), //currentTimeZone.identifier
      );
    } catch (e) {
      currentTimeZone = 'Europe/Sofia' as TimezoneInfo;
      tz.setLocalLocation(tz.getLocation('Europe/Sofia'));
    }

    logger.i('Current timezone: ${currentTimeZone.identifier.toString()}'); */
    //setLocalLocation(getLocation('Europe/Sofia'));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    //Разрешения на уведомления
    if (kIsWeb) {
      print("Notifications are disabled on Web");
      return;
    }

    if (Platform.isAndroid) {
      await Permission.notification.request();

      final androidPlugin = notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      // Только для Android 12+ (API 31 и выше)
      if (androidPlugin != null) {
        await androidPlugin.requestExactAlarmsPermission();
      }
    } else if (Platform.isIOS) {
      await notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    await notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
            // обработчик нажатия на уведомление
          },
    );

    tz.initializeTimeZones();

    TimezoneInfo currentTimeZone;

    try {
      currentTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));
    } catch (e) {
      //currentTimeZone = 'Europe/Sofia' as TimezoneInfo;
      tz.setLocalLocation(tz.getLocation('Europe/Sofia'));
    }

    //logger.i('Current timezone: ${currentTimeZone.identifier.toString()}');
  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        channelDescription: 'Channel for instant notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await notificationsPlugin.show(
      id,
      title,
      body,
      await notificationDetails(),
    );
  }

  /* Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = now.add(const Duration(seconds: 5));

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel_id',
          'Daily Notifications',
          channelDescription: 'Daily Notification Channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  } */

  Future<void> showDailyNotification({
    required int id,
    required String title,
    required String body,
    String? payLoad,
    //required DateTime scheduledNotificationDateTime,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    logger.i('TZDateTime.now(local): $now');

    var scheduled = tz.TZDateTime(
      //scheduledNotificationDateTime,
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    logger.i('Scheduled notification for: $scheduled');

    print('Scheduling immediate test id=$id at $scheduled');

    // Если время уже прошло сегодня — переносим на завтра
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
      logger.w('Scheduled moved to next day: $scheduled');
    }

    logger.i("Press showDailyNotification");
    return notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      await notificationDetails(),
      /* androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime, */
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // повтор ежедневно
    );
  }

  Future<void> showOneTimeNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    final tzDateTime = tz.TZDateTime.from(dateTime, tz.local);
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzDateTime,
      await notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }

  /// Отменяет все запланированные уведомления
  /// Это также удалит файл scheduled_notifications.xml на Android
  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }

  /// Получает список всех запланированных уведомлений
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await notificationsPlugin.pendingNotificationRequests();
  }
}
 */

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/services/local_notification.dart';
import 'package:first_app_flutter/class/notification.dart';
import 'package:first_app_flutter/services/spin_time_service.dart'; // тут лежит UserNotificationSettings

class NotificationService {
  static const String _baseUrl = 'https://magicity.top';

  static Future<void> initFCM() async {
    try {
      await LocalNotification.init();

      final fcm = FirebaseMessaging.instance;
      await fcm.requestPermission();

      final token = await fcm.getToken();
      if (token != null) {
        await AuthService.sendFcmToken(token);
      }

      FirebaseMessaging.onMessage.listen((message) {
        LocalNotification.show(
          title: message.notification?.title ?? '',
          body: message.notification?.body ?? '',
        );
      });
    } catch (e, s) {
      logger.w('FCM init failed: $e');
    }
  }

  static Future<UserNotificationSettings> loadSettings() async {
    final res = await AuthService.dio.get('$_baseUrl/account/notifications');
    return UserNotificationSettings.fromJson(res.data);
  }

  static Future<void> saveSettings(UserNotificationSettings s) async {
    try {
      final res = await AuthService.dio.put(
        '$_baseUrl/account/notifications',
        data: s.toJson(),
      );
      logger.i('Notification settings saved: ${res.statusCode} ${res.data}');
    } on DioException catch (e, st) {
      logger.w(
        'Save notification settings failed: ${e.response?.statusCode} ${e.response?.data}\n$st',
      );
    }
  }
}
