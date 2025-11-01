// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'dart:ui';
//import 'package:first_app_flutter/screens/camera_live_screen.dart';
//import 'package:first_utter/trash/camera_viewer_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/services/mqtt_jackpot_service.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:first_app_flutter/widgets/camera_widget.dart';
import 'package:first_app_flutter/widgets/jackpot_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../class/jackpot.dart';

class JackpotDetailsScreen extends StatefulWidget {
  final Jackpot jackpot;
  final MqttJackpotService? mqttService;

  const JackpotDetailsScreen({
    super.key,
    required this.jackpot,
    this.mqttService,
  });

  @override
  State<JackpotDetailsScreen> createState() => _JackpotDetailsScreenState();
}

class _JackpotDetailsScreenState extends State<JackpotDetailsScreen> {
  late Jackpot _current;
  StreamSubscription? _sub;

  final Map<String, double> _prevValues = {};

  @override
  void initState() {
    super.initState();
    _current = Jackpot.from(
      jackpot: widget.jackpot,
    ); // реализуй copy-конструктор или клонирование в классе Jackpot

    _prevValues['Mini'] = _current.miniMystery;
    _prevValues['Middle'] = _current.middleMystery;
    _prevValues['sadf'] = _current.megaMystery;
    _prevValues['Major'] = _current.majorBellLink;
    _prevValues['Grand'] = _current.grandBellLink;

    // Подписываемся на обновления и обновляем только нужные поля
    if (widget.mqttService != null) {
      _sub = widget.mqttService!.jackpotStream.listen((json) {
        final jackpots = json['jackpots'] as List<dynamic>;
        bool changed = false;
        for (var j in jackpots) {
          final name = (j['name'] ?? '').toString();
          final value = (j['value'] is num)
              ? (j['value'] as num).toDouble()
              : double.tryParse('${j['value']}') ?? 0.0;
          switch (name) {
            case 'Mini':
              if (_current.miniMystery != value) {
                _prevValues['Mini'] = _current.miniMystery;
                _current.miniMystery = value;
                changed = true;
              }
              break;
            case 'Middle':
              if (_current.middleMystery != value) {
                _prevValues['Middle'] = _current.middleMystery;
                _current.middleMystery = value;
                changed = true;
              }

              if (_current.majorBellLink != value) {
                _prevValues['Middle'] = _current.majorBellLink;
                _current.majorBellLink = value;
                changed = true;
              }
              break;
            case 'sadf':
              if (_current.megaMystery != value) {
                _prevValues['sadf'] = _current.megaMystery;
                _current.megaMystery = value;
                changed = true;
              }

              if (_current.grandBellLink != value) {
                _prevValues['sadf'] = _current.grandBellLink;
                _current.grandBellLink = value;
                changed = true;
              }
              break;
            default:
              break;
          }
        }
        if (changed && mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AdaptiveSizes.init(context);
    final jackpot = _current;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Hero(
        tag: jackpot.city,
        child: Stack(
          children: [
            // Фоновое изображение + blur
            Positioned(
              top: AdaptiveSizes.h(-0.70512),
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
                    AdaptiveSizes.getLikeSafeAreaJackpotPadding(), // Отступ как у SafeArea
                left: 24,
                right: 24,
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    // Назад
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: AdaptiveSizes.getIconBackSettingsSize(),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),

                      //const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "  ${(jackpot.city.tr().replaceAll(': ', ':\n'))}",
                          style: AdaptiveSizes.getCityJackpotDetailTextStyle(),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AdaptiveSizes.h(0.01538)),

                  // Важно: добавить Expanded чтобы контент мог скроллиться
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /* Text(
                            "address".tr(),
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ), 
                          const SizedBox(height: 6), */
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "${_current.address.tr()}  ",
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize:
                                    AdaptiveSizes.getIconBackSettingsSize(),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),

                          SizedBox(height: AdaptiveSizes.h(0.03077)),

                          /* Text(
                            "jackpot".tr(),
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6), */
                          ..._buildJackpotDetails(jackpot),

                          SizedBox(height: AdaptiveSizes.h(0.03077)),

                          // Метка "LIVE трансляция"
                          Center(
                            child: Container(
                              padding:
                                  AdaptiveSizes.getCameraWidgetInfoPadding(),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(
                                      255,
                                      255,
                                      0,
                                      0,
                                    ).withOpacity(0.6),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'live'.tr(),
                                style: AdaptiveSizes.getLiveJackpotTextStyle(),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // ВСТРОЕННАЯ КАМЕРА ВМЕСТО КНОПКИ
                          CameraWidget(
                            cameraIds: [
                              '82dee2d3-0893-4a4d-b9bc-129179b692c2',
                              'a1360da3-09ea-4dde-b0e7-1f23bcc592e1',
                            ],
                            cameraNames: [
                              '${'camera'.tr()} 1',
                              '${'camera'.tr()} 2',
                            ],
                          ),
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

    if (_current.isMysteryProgressive) {
      if (_current.miniMystery > 0) {
        rows.add(_buildRow("Mini", _current.miniMystery));
      }
      if (_current.middleMystery > 0) {
        rows.add(_buildRow("Middle", _current.middleMystery));
      }
      if (_current.megaMystery > 0) {
        rows.add(_buildRow("Mega", _current.megaMystery));
      }
    } else {
      if (_current.majorBellLink > 0) {
        rows.add(_buildRow("Major", _current.majorBellLink));
      }
      if (_current.grandBellLink > 0) {
        rows.add(_buildRow("Grand", _current.grandBellLink));
      }
    }

    return rows;
  }

  Widget _buildRow(String label, double value) {
    Color labelColor;
    Color shadowColor;
    String rangeMystery;
    IconData iconJackpot;
    switch (label.toLowerCase()) {
      case 'mini':
        labelColor = Colors.cyanAccent;
        shadowColor = const Color.fromARGB(255, 0, 124, 128).withOpacity(0.5);
        iconJackpot = Icons.star_border_purple500_rounded;
        rangeMystery = "(300 - 800 BGN)";
        break;
      case 'middle':
        labelColor = Colors.blueAccent;
        shadowColor = const Color.fromARGB(255, 0, 0, 128).withOpacity(0.6);
        iconJackpot = Icons.grade_outlined;
        rangeMystery = "(1200 - 2500 BGN)";
        break;
      case 'mega':
        labelColor = Colors.deepPurpleAccent;
        shadowColor = const Color.fromARGB(255, 92, 0, 128).withOpacity(0.9);
        iconJackpot = Icons.auto_awesome_outlined;
        rangeMystery = "(7000 - 10000 BGN)";
        break;
      case 'major':
        labelColor = Colors.greenAccent;
        shadowColor = const Color.fromARGB(255, 15, 128, 0).withOpacity(0.5);
        iconJackpot = Icons.grade_outlined;
        rangeMystery = "(500 - 1500 BGN)";
        break;
      case 'grand':
        labelColor = Colors.redAccent;
        shadowColor = const Color.fromARGB(255, 128, 0, 0).withOpacity(0.9);
        iconJackpot = Icons.auto_awesome_outlined;
        rangeMystery = "(8000 - 20000 BGN)";
        break;
      default:
        labelColor = Colors.white;
        shadowColor = Colors.white;
        iconJackpot = Icons.abc;
        rangeMystery = "10000-20000";
    }
    final prev = _prevValues[label] ?? value;
    return Padding(
      padding: AdaptiveSizes.getJackpotWidgetRowPadding(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            iconJackpot,
            color: labelColor,
            size: AdaptiveSizes.getFontSettingsSize(),
            shadows: [
              Shadow(color: shadowColor, blurRadius: 10, offset: Offset(2, 2)),
            ],
          ),

          SizedBox(width: AdaptiveSizes.w(0.013888)),

          Text(
            '$label: ',
            style: TextStyle(
              color: labelColor,
              fontWeight: FontWeight.bold,
              fontSize: AdaptiveSizes.getFontUsernameSize(),
              shadows: [
                Shadow(
                  color: shadowColor,
                  blurRadius: 25,
                  offset: const Offset(2, -3),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Плавная анимация числа от предыдущего к новому
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: prev, end: value),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOut,
            builder: (context, animatedValue, child) {
              return Text(
                '${animatedValue.toStringAsFixed(2)} BGN',
                style: GoogleFonts.tourney(
                  fontSize: AdaptiveSizes.getJackpotLogoFontSize(),
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              );
            },

            onEnd: () {
              // обновляем prev чтобы следующий tween начинался корректно
              _prevValues[label] = value;
            },
          ),

          //const SizedBox(width: 10),
          /* Text(
            rangeMystery,
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ), */
        ],
      ),
    );
  }
}
