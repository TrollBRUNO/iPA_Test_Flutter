import 'package:first_app_flutter/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MysteryNotificationConfig {
  final int id;
  final String title;
  final String body;
  final int hour;
  final int minute;
  final String prefKey; // для switch

  // Mystery значения
  double miniMystery;
  double middleMystery;
  double megaMystery;

  // Диапазоны для Slider
  final double miniMin;
  final double miniMax;

  final double middleMin;
  final double middleMax;

  final double megaMin;
  final double megaMax;

  MysteryNotificationConfig({
    required this.id,
    required this.title,
    required this.body,
    required this.hour,
    required this.minute,
    required this.prefKey,

    // значения по умолчанию
    this.miniMystery = 99.99,
    this.middleMystery = 555.55,
    this.megaMystery = 7777.77,

    // диапазоны slider
    this.miniMin = 30,
    this.miniMax = 300,

    this.middleMin = 500,
    this.middleMax = 1000,

    this.megaMin = 3000,
    this.megaMax = 10000,
  });

  /// ======== Ключи для хранения ========
  String get miniKey => '${prefKey}_mini';
  String get middleKey => '${prefKey}_middle';
  String get megaKey => '${prefKey}_mega';

  /// Загрузка всех mystery значений
  Future<void> loadMysteryValues() async {
    final prefs = await SharedPreferences.getInstance();
    miniMystery = prefs.getDouble(miniKey) ?? miniMystery;
    middleMystery = prefs.getDouble(middleKey) ?? middleMystery;
    megaMystery = prefs.getDouble(megaKey) ?? megaMystery;
  }

  /// Сохранение всех mystery значений
  Future<void> saveMysteryValues() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(miniKey, miniMystery);
    await prefs.setDouble(middleKey, middleMystery);
    await prefs.setDouble(megaKey, megaMystery);
  }
}

/// ======
/// 2. Менеджер Mystery уведомлений
/// ======
class MysteryNotificationManager {
  /// Список mystery уведомлений
  static final MysteryNotificationConfig mysteryConfig =
      MysteryNotificationConfig(
        id: 101,
        title: 'Достижение Mystery Jackpot',
        body: 'Один из уровней достиг порога',
        hour: 21,
        minute: 00,
        prefKey: 'mystery_main',
      );

  /// ===== Switch SAVE =====
  static Future<void> saveSwitchState(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  /// ===== Switch LOAD =====
  static Future<bool> loadSwitchState(String key, bool def) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? def;
  }

  /// ===== Включение / отключение уведомления =====
  static Future<void> toggleMysteryNotification(
    MysteryNotificationConfig config,
    bool enabled,
  ) async {
    await saveSwitchState(config.prefKey, enabled);

    if (!enabled) {
      await NotificationService().cancelNotification(config.id);
      return;
    }

    // Подгружаем mystery значения перед запуском
    await config.loadMysteryValues();
    await config.saveMysteryValues();

    await NotificationService().showDailyNotification(
      id: config.id,
      title: config.title,
      body:
          '${config.body}\nMini: ${config.miniMystery.toStringAsFixed(2)}, Middle: ${config.middleMystery.toStringAsFixed(2)}, Mega: ${config.megaMystery.toStringAsFixed(2)}',
      hour: config.hour,
      minute: config.minute,
    );
  }

  static Future<void> initializeMysteryNotifications() async {
    final config = mysteryConfig;

    final isEnabled = await loadSwitchState(config.prefKey, true);

    await config.loadMysteryValues();

    if (isEnabled) {
      await NotificationService().showDailyNotification(
        id: config.id,
        title: config.title,
        body:
            '${config.body}\nMini: ${config.miniMystery.toStringAsFixed(2)}, Middle: ${config.middleMystery.toStringAsFixed(2)}, Mega: ${config.megaMystery.toStringAsFixed(2)}',
        hour: config.hour,
        minute: config.minute,
      );
    } else {
      await NotificationService().cancelNotification(config.id);
    }
  }

  static Future<void> deactivateAll() async {
    final config = mysteryConfig;
    await NotificationService().cancelNotification(config.id);
    await saveSwitchState(config.prefKey, false);
  }
}
