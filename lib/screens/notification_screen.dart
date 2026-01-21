import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:first_app_flutter/class/notification.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/services/notification_service.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:first_app_flutter/widgets/mystery_notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotificationPage(title: 'Notification');
  }
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key, required this.title});

  final String title;

  @override
  State<NotificationPage> createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage> {
  UserNotificationSettings? settings;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    NotificationService.initFCM();
  }

  Future<void> _loadSettings() async {
    settings = await NotificationService.loadSettings();
    setState(() {});
  }

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

  Widget switchTile({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: AdaptiveSizes.getNotificationPadding2(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: AdaptiveSizes.getJackpotWidgetBorderRadius(),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.6),
              spreadRadius: 0.2,
              blurRadius: 1,
              offset: const Offset(0, 0),
            ),
          ],
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

  @override
  Widget build(BuildContext context) {
    AdaptiveSizes.init(context);

    if (settings == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(
          child: CircularProgressIndicator(color: Colors.orangeAccent),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
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

              // SECTIONS
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle("wheel".tr()),
                  switchTile(
                    title: "notification_wheel".tr(),
                    value: settings!.wheelReady,
                    onChanged: (v) {
                      setState(() => settings!.wheelReady = v);
                      NotificationService.saveSettings(settings!);
                    },
                  ),
                  switchTile(
                    title: "notification_remind_bonus".tr(),
                    value: settings!.bonusReminder,
                    onChanged: (v) {
                      setState(() => settings!.bonusReminder = v);
                      NotificationService.saveSettings(settings!);
                    },
                  ),

                  sectionTitle("subscribe_news".tr()),
                  switchTile(
                    title: "notification_news".tr(),
                    value: settings!.newsPost,
                    onChanged: (v) {
                      setState(() => settings!.newsPost = v);
                      NotificationService.saveSettings(settings!);
                    },
                  ),
                  switchTile(
                    title: "notification_big_win".tr(),
                    value: settings!.jackpotWin,
                    onChanged: (v) {
                      setState(() => settings!.jackpotWin = v);
                      NotificationService.saveSettings(settings!);
                    },
                  ),

                  sectionTitle("notification_additional".tr()),
                  MysteryNotificationTile(settings: settings!),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: AdaptiveSizes.getButtonSupportWidth(),
                    height: AdaptiveSizes.getButtonSupportHeight(),
                    child: ElevatedButton(
                      key: const Key('test_notification_button'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent[200],
                        foregroundColor: const Color.fromARGB(221, 22, 20, 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AdaptiveSizes.getButtonSupportTextSize(),
                          letterSpacing: 2.5,
                        ),
                      ),
                      onPressed: () async {
                        await AuthService.testNotification(
                          await FirebaseMessaging.instance.getToken() ?? '',
                        );
                      },

                      child: Text('Send Test Notification'.tr()),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
