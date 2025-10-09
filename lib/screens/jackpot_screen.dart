// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/class/jackpot.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/services/mqtt_jackpot_service.dart';
import 'package:first_app_flutter/widgets/jackpot_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

class JackpotScreen extends StatelessWidget {
  const JackpotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return JackpotPage(title: 'Jackpot');
  }
}

class JackpotPage extends StatefulWidget {
  const JackpotPage({super.key, required this.title});

  final String title;

  @override
  State<JackpotPage> createState() => _JackpotState();
}

class _JackpotState extends State<JackpotPage> {
  Logger logger = Logger();
  final MqttJackpotService mqttService = MqttJackpotService();

  double miniMystery = 0;
  double middleMystery = 0;
  double megaMystery = 0;

  double majorBellLink = 0;
  double grandBellLink = 0;

  //ДЛЯ ТЕСТА АНИМАЦИИ
  Timer? _timer;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadMqtt();
    mqttService.jackpotStream.listen((json) {
      final jackpots = json['jackpots'] as List<dynamic>;
      for (var jackpot in jackpots) {
        switch (jackpot['name']) {
          case 'Mini':
            setState(
              () => miniMystery = jackpot['value']?.toDouble() + _counter ?? 0,
            );
            break;
          case 'Middle':
            setState(() {
              middleMystery = jackpot['value']?.toDouble() + _counter ?? 0;
              majorBellLink = jackpot['value']?.toDouble() + _counter ?? 0;
            });
            break;
          case 'sadf':
            setState(() {
              megaMystery = jackpot['value']?.toDouble() + _counter ?? 0;
              grandBellLink = jackpot['value']?.toDouble() + _counter ?? 0;
            });
            break;
        }
      }
    });
    //ДЛЯ ТЕСТА АНИМАЦИИ
    startTimer();
  }

  //ДЛЯ ТЕСТА АНИМАЦИИ
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _counter++;
      });

      // Остановить после 100 секунд
      if (_counter >= 10) {
        timer.cancel();
      }
    });
  }

  Future<void> _loadMqtt() async {
    try {
      final result = await mqttService.main();
      // Выводим результат в консоль через logger
      logger.i('MQTT result: $result');
    } catch (e) {
      logger.w('Ошибка MQTT: $e');
    }
  }

  // Тестовые данные джекпотов
  List<Jackpot> get jackpots => [
    Jackpot(
      city: 'Пловдив: Magic City',
      address: 'бул. Източен 48',
      imageUrl: 'assets/images/logo_magic_city5.png',
      isMysteryProgressive: true,
      //miniMystery: miniMystery,
      //middleMystery: middleMystery,
      //megaMystery: megaMystery,
      miniMystery: 359.76,
      middleMystery: 1535.53,
      megaMystery: 8321.84,
    ),

    // Остальные адреса
    Jackpot(
      city: 'Кирково: MegaBet',
      address: 'ул. Димитър Благоев 23',
      imageUrl: 'assets/images/logo5.png',
      isMysteryProgressive: false,
      majorBellLink: 876.19,
      grandBellLink: 13369.97,
    ),
    Jackpot(
      city: 'Велинград: Amon',
      address: 'бул. Съединение 2',
      imageUrl: 'assets/images/logo3.png',
      isMysteryProgressive: true,
      miniMystery: 466.92,
      middleMystery: 1877.11,
      megaMystery: 9487.66,
    ),
    Jackpot(
      city: 'Гоце Делчев: Magic City',
      address: 'ул. Дунав 75',
      imageUrl: 'assets/images/logo_magic_city5.png',
      isMysteryProgressive: true,
      miniMystery: 533.09,
      middleMystery: 1456.43,
      megaMystery: 10876.23,
    ),
    Jackpot(
      city: 'Сатовча: Magic City',
      address: 'ул. Тодор Шопов 87',
      imageUrl: 'assets/images/logo_magic_city5.png',
      isMysteryProgressive: true,
      miniMystery: 376.12,
      middleMystery: 999.86,
      megaMystery: 7631.18,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final percent =
                    (constraints.maxHeight - kToolbarHeight) /
                    (180 - kToolbarHeight);
                final double fontSize = 32 + (62 - 32) * percent;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // 👇 ЭФФЕКТ СТЕКЛА: блюр + полупрозрачный фон + граница снизу
                    ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                              255,
                              12,
                              12,
                              12,
                            ).withOpacity(0.6),
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.white.withOpacity(0.15),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 👇 Заголовок по центру, с динамическим размером
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 10),
                        child: Text(
                          'online_jackpot'.tr(),
                          style: GoogleFonts.daysOne(
                            fontSize: fontSize,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
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
                    ),
                  ],
                );
              },
            ),
          ),

          // Список карточек джекпотов
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return JackpotWidget(
                jackpot: jackpots[index],
                miniBuilder: (value) => TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: value, end: miniMystery),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, animatedValue, child) {
                    return Text(
                      '${animatedValue.toStringAsFixed(2)} BGN',
                      style: const TextStyle(fontSize: 26, color: Colors.white),
                    );
                  },
                ),
                middleBuilder: (value) => TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: value, end: middleMystery),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, animatedValue, child) {
                    return Text(
                      '${animatedValue.toStringAsFixed(2)} BGN',
                      style: const TextStyle(fontSize: 26, color: Colors.white),
                    );
                  },
                ),
                megaBuilder: (value) => TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: value, end: megaMystery),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, animatedValue, child) {
                    return Text(
                      '${animatedValue.toStringAsFixed(2)} BGN',
                      style: const TextStyle(fontSize: 26, color: Colors.white),
                    );
                  },
                ),
                majorBuilder: (value) => TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: value, end: majorBellLink),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, animatedValue, child) {
                    return Text(
                      '${animatedValue.toStringAsFixed(2)} BGN',
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                    );
                  },
                ),
                grandBuilder: (value) => TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: value, end: grandBellLink),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, animatedValue, child) {
                    return Text(
                      '${animatedValue.toStringAsFixed(2)} BGN',
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                    );
                  },
                ),
              );
            }, childCount: jackpots.length),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).padding.bottom + 40),
          ),
        ],
      ),
    );
  }
}
