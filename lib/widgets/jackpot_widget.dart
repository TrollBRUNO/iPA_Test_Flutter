// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:first_app_flutter/class/jackpot.dart';
import 'package:first_app_flutter/screens/jackpot_details_screen.dart';
import 'package:first_app_flutter/widgets/jackpot_row_widget.dart';
import 'package:flutter/material.dart';

class JackpotWidget extends StatelessWidget {
  final Jackpot jackpot;
  final Widget Function(double value)? miniBuilder;
  final Widget Function(double value)? middleBuilder;
  final Widget Function(double value)? megaBuilder;

  final Widget Function(double value)? majorBuilder;
  final Widget Function(double value)? grandBuilder;

  const JackpotWidget({
    super.key,
    required this.jackpot,
    this.miniBuilder,
    this.middleBuilder,
    this.megaBuilder,
    this.majorBuilder,
    this.grandBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // Собираем список отображаемых полей динамически
    final List<Widget> jackpotValues = [];
    final EdgeInsets topAddress;

    if (jackpot.isMysteryProgressive) {
      topAddress = EdgeInsets.only(top: 16);

      if (jackpot.miniMystery > 0) {
        jackpotValues.add(
          buildJackpotRow(
            "Mini",
            jackpot.miniMystery,
            valueBuilder: miniBuilder,
          ),
        );
      }
      if (jackpot.middleMystery > 0) {
        jackpotValues.add(
          buildJackpotRow(
            "Middle",
            jackpot.middleMystery,
            valueBuilder: middleBuilder,
          ),
        );
      }
      if (jackpot.megaMystery > 0) {
        jackpotValues.add(
          buildJackpotRow(
            "Mega",
            jackpot.megaMystery,
            valueBuilder: megaBuilder,
          ),
        );
      }
    } else {
      topAddress = EdgeInsets.only(top: 48);

      if (jackpot.majorBellLink > 0) {
        jackpotValues.add(
          buildJackpotRow(
            "Major",
            jackpot.majorBellLink,
            valueBuilder: majorBuilder,
          ),
        );
      }
      if (jackpot.grandBellLink > 0) {
        jackpotValues.add(
          buildJackpotRow(
            "Grand",
            jackpot.grandBellLink,
            valueBuilder: grandBuilder,
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
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                JackpotDetailsScreen(jackpot: jackpot),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  // Анимация появления с масштабом и плавной прозрачностью
                  const beginScale = 0.95;
                  const endScale = 1.0;

                  const beginOpacity = 0.0;
                  const endOpacity = 1.0;

                  final curve = Curves.easeInOut;

                  final scaleAnimation = Tween(
                    begin: beginScale,
                    end: endScale,
                  ).chain(CurveTween(curve: curve)).animate(animation);

                  final opacityAnimation = Tween(
                    begin: beginOpacity,
                    end: endOpacity,
                  ).chain(CurveTween(curve: curve)).animate(animation);

                  return FadeTransition(
                    opacity: opacityAnimation,
                    child: ScaleTransition(scale: scaleAnimation, child: child),
                  );
                },
          ),
        );
      },
      child: Hero(
        tag: jackpot.city, // Уникальный идентификатор
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          height: 310, // задай нужную высоту
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.orangeAccent.withOpacity(0.4),
                //Color.fromARGB(255, 46, 178, 255)
                spreadRadius: 0.2,
                blurRadius: 8,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Фоновое изображение
              Image.asset(jackpot.imageUrl, fit: BoxFit.fitWidth),

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
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Название города
                    Center(
                      child: Text(
                        jackpot.city,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 6,
                        ),
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
                          borderRadius: BorderRadius.circular(36),
                        ),
                        // Джекпоты
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: jackpotValues,
                          ),
                        ),
                      ),
                    ),

                    // Адрес внизу слева
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: topAddress,
                        child: Text(
                          jackpot.address,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
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
