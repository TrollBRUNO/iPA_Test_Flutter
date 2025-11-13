import 'dart:io';
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

  Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }
}
