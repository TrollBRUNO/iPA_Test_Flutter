// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/class/jackpot.dart';
import 'package:first_app_flutter/screens/jackpot_details_screen.dart';
import 'package:first_app_flutter/services/mqtt_jackpot_service.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:first_app_flutter/widgets/jackpot_row_widget.dart';
import 'package:flutter/material.dart';

class JackpotWidget extends StatelessWidget {
  final Jackpot jackpot;
  //final MqttJackpotService? mqttService;
  final Widget Function(double value)? miniBuilder;
  final Widget Function(double value)? middleBuilder;
  final Widget Function(double value)? megaBuilder;

  final Widget Function(double value)? majorBuilder;
  final Widget Function(double value)? grandBuilder;

  final Widget Function(String range)? miniRangeBuilder;
  final Widget Function(String range)? middleRangeBuilder;
  final Widget Function(String range)? megaRangeBuilder;

  final Widget Function(String range)? majorBellLinkRangeBuilder;
  final Widget Function(String range)? grandBellLinkRangeBuilder;

  const JackpotWidget({
    super.key,
    required this.jackpot,
    //this.mqttService,
    this.miniBuilder,
    this.middleBuilder,
    this.megaBuilder,
    this.majorBuilder,
    this.grandBuilder,

    this.miniRangeBuilder,
    this.middleRangeBuilder,
    this.megaRangeBuilder,
    this.majorBellLinkRangeBuilder,
    this.grandBellLinkRangeBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // Собираем список отображаемых полей динамически
    final List<Widget> jackpotValues = [];

    if (jackpot.isMysteryProgressive) {
      if (jackpot.miniMystery > 0) {
        jackpotValues.add(
          buildJackpotRow(
            "Mini",
            jackpot.miniMystery,
            jackpot.miniRange,
            valueBuilder: miniBuilder,
            rangeBuilder: miniRangeBuilder,
          ),
        );
      }
      if (jackpot.middleMystery > 0) {
        jackpotValues.add(
          buildJackpotRow(
            "Middle",
            jackpot.middleMystery,
            jackpot.middleRange,
            valueBuilder: middleBuilder,
            rangeBuilder: middleRangeBuilder,
          ),
        );
      }
      if (jackpot.megaMystery > 0) {
        jackpotValues.add(
          buildJackpotRow(
            "Mega",
            jackpot.megaMystery,
            jackpot.megaRange,
            valueBuilder: megaBuilder,
            rangeBuilder: megaRangeBuilder,
          ),
        );
      }
    } else {
      if (jackpot.majorBellLink > 0) {
        jackpotValues.add(
          buildJackpotRow(
            "Major",
            jackpot.majorBellLink,
            jackpot.majorBellLinkRange,
            valueBuilder: majorBuilder,
            rangeBuilder: majorBellLinkRangeBuilder,
          ),
        );
      }
      if (jackpot.grandBellLink > 0) {
        jackpotValues.add(
          buildJackpotRow(
            "Grand",
            jackpot.grandBellLink,
            jackpot.grandBellLinkRange,
            valueBuilder: grandBuilder,
            rangeBuilder: grandBellLinkRangeBuilder,
          ),
        );
      }
    }

    //ебланская анимация перехода к подробной информации казино
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (context, animation, secondaryAnimation) =>
                JackpotDetailsScreen(
                  jackpot: jackpot,
                  //mqttService: mqttService,
                ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  // Новый вариант: масштабирование + затемнение сразу
                  final scaleAnimation = Tween<double>(
                    begin: 0.92,
                    end: 1.0,
                  ).chain(CurveTween(curve: Curves.linear)).animate(animation);

                  return Stack(
                    children: [
                      // Мгновенное затемнение фона
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: animation,
                          builder: (context, child) {
                            // opacity от 0 до 0.85
                            final opacity = 1 * animation.value;
                            return Container(
                              color: Colors.black.withOpacity(opacity),
                            );
                          },
                        ),
                      ),
                      // Анимация раскрытия карточки
                      ScaleTransition(scale: scaleAnimation, child: child),
                    ],
                  );
                },
          ),
        );
      },
      child: Hero(
        tag: jackpot.city, // Уникальный идентификатор
        child: Container(
          margin: AdaptiveSizes.getJackpotWidgetPadding(),
          height: AdaptiveSizes.getJackpotWidgetHeight(),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9),
            borderRadius: AdaptiveSizes.getJackpotWidgetBorderRadius(),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.6),
                //Color.fromARGB(255, 46, 178, 255)
                spreadRadius: 0.2,
                blurRadius: 1,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Фоновое изображение
              Image.network(
                "https://magicity.top${jackpot.imageUrl}",
                fit: BoxFit.fitWidth,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, color: Colors.white),
              ),

              // Blur + затемнение
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 11, sigmaY: 11),
                child: Container(
                  color: const Color.fromARGB(
                    255,
                    0,
                    0,
                    0,
                  ).withOpacity(0.7), // затемнение
                ),
              ),

              // Контент карточки
              Padding(
                padding: AdaptiveSizes.getJackpotContentWidgetPadding(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Название города
                    Center(
                      child: Text(
                        jackpot.city.tr(),
                        style: AdaptiveSizes.getCityJackpotTextStyle(),
                      ),
                    ),

                    SizedBox(height: AdaptiveSizes.h(0.00769)),

                    Padding(
                      padding:
                          AdaptiveSizes.getJackpotContentWidgetThirdPadding(
                            jackpot.isMysteryProgressive,
                          ),
                      child: Container(
                        padding:
                            AdaptiveSizes.getJackpotContentWidgetSecondPadding(),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(
                                255,
                                126,
                                126,
                                126,
                              ).withOpacity(0.06),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          color: const Color.fromARGB(20, 212, 212, 212),
                          borderRadius:
                              AdaptiveSizes.getJackpotWidgetBorderSecondRadius(),
                        ),
                        // Джекпоты
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: jackpotValues,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 16,
                bottom: 8,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    jackpot.address.tr(),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: AdaptiveSizes.getAddressSize(),
                    ),
                  ),
                ),
              ),

              // LIVE в правом верхнем углу
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
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
                        offset: const Offset(0, 2),
                      ),
                    ],
                    color: Colors.red,
                    borderRadius:
                        AdaptiveSizes.getLiveJackpotWidgetBorderRadius(),
                  ),
                  child: Text(
                    'LIVE',
                    style: AdaptiveSizes.getLiveJackpotTextStyle(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
