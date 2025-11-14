import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/config/notification_config.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:first_app_flutter/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationPage(title: 'Notification');
  }
}

//DateTime scheduleTime = DateTime.now().add(const Duration(minutes: 1));

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key, required this.title});

  final String title;

  @override
  State<NotificationPage> createState() => _NotificationState();
}

// Стили для заголовков
Widget sectionTitle(String title) {
  return Padding(
    padding: AdaptiveSizes.getNotificationPadding(),
    child: Text(
      title,
      style: GoogleFonts.raleway(
        fontSize: AdaptiveSizes.getFontBigPrizeSize(),
        fontWeight: FontWeight.bold,
        color: Colors.orangeAccent[200],
      ),
    ),
  );
}

// Стили для подпунктов с переключателем
Widget settingOption(String title, bool value, Function(bool) onChanged) {
  return Padding(
    padding: AdaptiveSizes.getNotificationPadding2(),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.raleway(
                fontSize: AdaptiveSizes.getFontInfoSize(),
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 30),
          Transform.scale(
            scale: AdaptiveSizes.getNotificationSwitchSize(),
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: Colors.orangeAccent[400],
              inactiveThumbColor: Colors.grey[600],
              inactiveTrackColor: Colors.grey[800],
            ),
          ),
        ],
      ),
    ),
  );
}

class _NotificationState extends State<NotificationPage> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, bool> _notificationStates;

  Future<void> saveSwitchState(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<bool> loadSwitchState(String key, bool def) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? def;
  }

  @override
  void initState() {
    super.initState();
    _loadAllNotifications();
    NotificationService().initNotification();
  }

  Future<void> _loadAllNotifications() async {
    _notificationStates = {};
    for (var config in NotificationManager.notifications) {
      final isEnabled = await NotificationManager.loadSwitchState(
        config.prefKey,
        true,
      );
      _notificationStates[config.prefKey] = isEnabled;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AdaptiveSizes.init(context);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12,
                          left: 8,
                          right: 8,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Кнопка "назад" — слева
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.orangeAccent[200],
                                  size: AdaptiveSizes.getIconBackSettingsSize(),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),

                            Text(
                              'notice'.tr(),
                              style: GoogleFonts.daysOne(
                                fontSize: AdaptiveSizes.getFontUsernameSize(),
                                fontWeight: FontWeight.w100,
                                fontStyle: FontStyle.italic,
                                color: Colors.orangeAccent[200],
                                shadows: const [
                                  Shadow(
                                    color: Color.fromARGB(255, 51, 51, 51),
                                    offset: Offset(3.5, 4.5),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Весь список
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle("Колесо удачи"),
                          ..._buildNotificationSection([
                            NotificationManager.notifications[0],
                            //NotificationManager.notifications[1],
                          ]),

                          /* sectionTitle("Подписаться на новости"),
                          ..._buildNotificationSection([
                            NotificationManager.notifications[2],
                            NotificationManager.notifications[3],
                          ]),
                          sectionTitle("Дополнительные"),
                          ..._buildNotificationSection([
                            NotificationManager.notifications[4],
                          ]), */
                          const SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildNotificationSection(List<NotificationConfig> configs) {
    return configs.map((config) {
      final isEnabled = _notificationStates[config.prefKey] ?? true;
      return settingOption(config.title, isEnabled, (val) async {
        setState(() {
          _notificationStates[config.prefKey] = val;
        });
        await NotificationManager.toggleNotification(config, val);
      });
    }).toList();
  }
}
