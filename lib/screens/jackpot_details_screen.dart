// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:developer';
import 'dart:ui';
//import 'package:first_app_flutter/screens/camera_live_screen.dart';
//import 'package:first_app_flutter/trash/camera_viewer_screen.dart';
import 'package:first_app_flutter/screens/video_stream_screen.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
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
            Positioned.fill(
              child: Image.asset(jackpot.imageUrl, fit: BoxFit.scaleDown),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
                ),
              ),
            ),

            // Контент
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Назад
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: Text(
                        jackpot.city,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    Text(
                      "Адрес:",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      jackpot.address,
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),

                    const SizedBox(height: 32),

                    Text(
                      "Джекпоты:",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ..._buildJackpotDetails(jackpot),

                    const Spacer(),

                    Center(
                      child: ElevatedButton(
                        key: Key('live_button'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Color(0xFFFFFFFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          textStyle: TextStyle(
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
                            await Future.delayed(Duration(milliseconds: 100));

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
                        child: Text('LIVE!'),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
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
          Text(label, style: TextStyle(fontSize: 20, color: Colors.white70)),
          Text(
            '${value.toStringAsFixed(2)} BGN',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
