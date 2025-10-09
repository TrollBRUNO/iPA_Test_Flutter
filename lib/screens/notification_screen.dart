import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationPage(title: 'Notification');
  }
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key, required this.title});

  final String title;

  @override
  State<NotificationPage> createState() => _NotificationState();
}

// Стили для заголовков
Widget sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
    child: Text(
      title,
      style: GoogleFonts.raleway(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.orangeAccent[200],
      ),
    ),
  );
}

// Стили для подпунктов с переключателем
Widget settingOption(String title, bool value, Function(bool) onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 6),
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
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Transform.scale(
            scale: 1.2,
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
  //final _formKey = GlobalKey<FormState>();

  // Пример состояний переключателей
  bool notif1 = true;
  bool notif2 = false;
  bool notif3 = true;
  bool notif4 = true;
  bool notif5 = false;
  bool notif6 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 100),

            Positioned(
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.orangeAccent[200],
                  size: 32,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Известие',
                style: GoogleFonts.daysOne(
                  fontSize: 36,
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
            ),

            const SizedBox(height: 20),

            // Весь список
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle("Колесо удачи"),
                settingOption("Уведомление о новой возможности", notif1, (val) {
                  setState(() => notif1 = val);
                }),
                settingOption("Напоминание забрать бонус", notif2, (val) {
                  setState(() => notif2 = val);
                }),

                sectionTitle("Подписаться на новости"),
                settingOption("Свежие новости и розыгрыши", notif3, (val) {
                  setState(() => notif3 = val);
                }),
                settingOption("Уведомление о больших выигрышах", notif4, (val) {
                  setState(() => notif4 = val);
                }),

                sectionTitle("Дополнительные"),
                settingOption("Уведомление в рекламных целях", notif5, (val) {
                  setState(() => notif5 = val);
                }),
                settingOption("Объявление о пиковом джекпоте", notif6, (val) {
                  setState(() => notif6 = val);
                }),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
