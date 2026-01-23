// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/class/games.dart';
import 'package:first_app_flutter/class/jackpot.dart';
import 'package:first_app_flutter/screens/jackpot_details_screen.dart';
import 'package:first_app_flutter/services/mqtt_jackpot_service.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:first_app_flutter/widgets/jackpot_row_widget.dart';
import 'package:flutter/material.dart';

class GamesWidget extends StatelessWidget {
  final Games games;

  const GamesWidget({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    //ебланская анимация перехода к подробной информации казино
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {},
      child: Hero(
        tag: games.name, // Уникальный идентификатор
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
              Image.asset(games.imageUrl, fit: BoxFit.fitWidth),

              Positioned(
                top: 10,
                left: 10,
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
                    games.name,
                    style: AdaptiveSizes.getLiveJackpotTextStyle(),
                  ),
                ),
              ),

              // DEMO в правом верхнем углу
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
                          0,
                          255,
                          0,
                        ).withOpacity(0.6),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    color: Colors.green,
                    borderRadius:
                        AdaptiveSizes.getLiveJackpotWidgetBorderRadius(),
                  ),
                  child: Text(
                    'DEMO VERSION',
                    style: AdaptiveSizes.getDemoTextStyle(),
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
