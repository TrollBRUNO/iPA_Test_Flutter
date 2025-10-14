// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:developer';
import 'dart:ui';
//import 'package:first_app_flutter/screens/camera_live_screen.dart';
//import 'package:first_app_flutter/trash/camera_viewer_screen.dart';
import 'package:first_app_flutter/screens/video_stream_screen.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/widgets/camera_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../class/jackpot.dart';

class JackpotDetailsScreen extends StatelessWidget {
  final Jackpot jackpot;

  const JackpotDetailsScreen({super.key, required this.jackpot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Hero(
        tag: jackpot.city,
        child: Stack(
          children: [
            // Фоновое изображение + blur
            Positioned(
              top: -1150,
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(jackpot.imageUrl, fit: BoxFit.fitWidth),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 11, sigmaY: 11),
                child: Container(
                  color: const Color.fromARGB(221, 22, 20, 20).withOpacity(0.7),
                ),
              ),
            ),

            // Контент БЕЗ SafeArea, но с кастомными отступами
            Padding(
              padding: EdgeInsets.only(
                top:
                    MediaQuery.of(context).padding.top +
                    24, // Отступ как у SafeArea
                left: 24,
                right: 24,
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Назад
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Center(
                    child: Text(
                      jackpot.city,
                      style: GoogleFonts.daysOne(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 64),

                  // ОСТАВШИЙСЯ КОНТЕНТ...

                  // Важно: добавить Expanded чтобы контент мог скроллиться
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Адрес:",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            jackpot.address,
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),

                          const SizedBox(height: 48),

                          Text(
                            "Джекпоты:",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),

                          ..._buildJackpotDetails(jackpot),

                          const SizedBox(height: 48),

                          // ВСТРОЕННАЯ КАМЕРА ВМЕСТО КНОПКИ
                          CameraWidget(
                            // ← Используем виджет камеры
                            cameraId: '82dee2d3-0893-4a4d-b9bc-129179b692c2',
                            cameraName: 'Камера ${jackpot.city}',
                          ),

                          const SizedBox(height: 24),

                          // Метка "LIVE трансляция"
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'LIVE ТРАНСЛЯЦИЯ',
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          /* const SizedBox(height: 420),

                          Center(
                            child: ElevatedButton(
                              key: Key('live_button'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Color(0xFFFFFFFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                textStyle: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                  color: Colors.white,
                                  wordSpacing: 5.5,
                                  letterSpacing: 3.5,
                                ),
                              ),
                              onPressed: () async {
                                try {
                                  /*final jwt =
                                await AuthService.getJwt() ??
                                await AuthService.loginAndSaveJwt();

                            if (jwt == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Не удалось авторизоваться'),
                                ),
                              );
                              return;
                            }*/

                                  // Добавляем небольшую задержку для плавного перехода
                                  await Future.delayed(
                                    Duration(milliseconds: 100),
                                  );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => VideoStreamScreen(
                                        cameraId:
                                            '82dee2d3-0893-4a4d-b9bc-129179b692c2', // Первая камера
                                        cameraName: 'Камера ${jackpot.city}',
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  log('Ошибка при переходе к трансляциям: $e');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Ошибка: $e')),
                                  );
                                }
                              },
                              child: Text('SHOW CAMERA!'),
                            ),
                          ), */
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildJackpotDetails(Jackpot jackpot) {
    final List<Widget> rows = [];

    if (jackpot.isMysteryProgressive) {
      if (jackpot.miniMystery > 0) {
        rows.add(_buildRow("Mini", jackpot.miniMystery));
      }
      if (jackpot.middleMystery > 0) {
        rows.add(_buildRow("Middle", jackpot.middleMystery));
      }
      if (jackpot.megaMystery > 0) {
        rows.add(_buildRow("Mega", jackpot.megaMystery));
      }
    } else {
      if (jackpot.majorBellLink > 0) {
        rows.add(_buildRow("Major", jackpot.majorBellLink));
      }
      if (jackpot.grandBellLink > 0) {
        rows.add(_buildRow("Grand", jackpot.grandBellLink));
      }
    }

    return rows;
  }

  Widget _buildRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.openSans(fontSize: 24, color: Colors.white70),
          ),
          Text(
            '${value.toStringAsFixed(2)} BGN',
            style: GoogleFonts.openSans(fontSize: 24, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
