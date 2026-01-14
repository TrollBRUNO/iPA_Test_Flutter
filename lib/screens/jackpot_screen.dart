// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/class/jackpot.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/services/mqtt_jackpot_service.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:first_app_flutter/widgets/jackpot_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
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
  //final MqttJackpotService mqttService = MqttJackpotService();

  List<Jackpot> _jackpots = [];

  double miniMystery = 0;
  double middleMystery = 0;
  double megaMystery = 0;

  double majorBellLink = 0;
  double grandBellLink = 0;

  //ДЛЯ ТЕСТА АНИМАЦИИ
  Timer? _timer;
  int _counter = 0;

  Timer? _refreshTimer;

  void startLiveUpdates() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateJackpots();
    });
  }

  @override
  void initState() {
    super.initState();

    // Тестовые данные джекпотов
    //List<Jackpot> get jackpots => [
    /* _jackpots = [
      Jackpot(
        city: 'address_plovdiv_city',
        address: 'address_plovdiv_address',
        imageUrl: 'assets/images/logo_magic_city5.png',
        isMysteryProgressive: true,
        miniMystery: 359.76,
        middleMystery: 1535.53,
        megaMystery: 8321.84,
      ),

      // Остальные адреса
      Jackpot(
        city: 'address_kirkovo_city',
        address: 'address_kirkovo_address',
        imageUrl: 'assets/images/logo5.png',
        isMysteryProgressive: false,
        majorBellLink: 876.19,
        grandBellLink: 13369.97,
      ),
      Jackpot(
        city: 'address_velingrad_city',
        address: 'address_velingrad_address',
        imageUrl: 'assets/images/logo3.png',
        isMysteryProgressive: true,
        miniMystery: 466.92,
        middleMystery: 1877.11,
        megaMystery: 9487.66,
      ),
      Jackpot(
        city: 'address_gotse_delchev_city',
        address: 'address_gotse_delchev_address',
        imageUrl: 'assets/images/logo_magic_city5.png',
        isMysteryProgressive: true,
        miniMystery: 533.09,
        middleMystery: 1456.43,
        megaMystery: 10876.23,
      ),
      Jackpot(
        city: 'address_satovcha_city',
        address: 'address_satovcha_address',
        imageUrl: 'assets/images/logo_magic_city5.png',
        isMysteryProgressive: true,
        miniMystery: 376.12,
        middleMystery: 999.86,
        megaMystery: 7631.18,
      ),
    ]; */

    loadData().then((_) {
      startLiveUpdates();
    });

    /* _loadMqtt();

    mqttService.jackpotStream.listen((json) {
      final jackpots = json['jackpots'] as List<dynamic>;
      if (!mounted) return;
      setState(() {
        if (_jackpots.isEmpty) return;
        for (var j in jackpots) {
          final name = (j['name'] ?? '').toString();
          final value = (j['value'] is num)
              ? (j['value'] as num).toDouble()
              : double.tryParse('${j['value']}') ?? 0.0;

          switch (name) {
            case 'Mini':
              miniMystery = value + _counter;
              _jackpots[0].miniMystery = miniMystery;
              break;
            case 'Middle':
              middleMystery = value + _counter;
              majorBellLink = value + _counter;
              _jackpots[0].middleMystery = middleMystery;
              _jackpots[0].majorBellLink = majorBellLink;
              break;
            case 'sadf':
              megaMystery = value + _counter;
              grandBellLink = value + _counter;
              _jackpots[0].megaMystery = megaMystery;
              _jackpots[0].grandBellLink = grandBellLink;
              break;
            // при необходимости добавь mapping для major/grand
          }
        }
      });
    }); */

    //ДЛЯ ТЕСТА АНИМАЦИИ
    startTimer();
  }

  Future<void> loadData() async {
    await loadCasinosFromServer();
  }

  Future<void> loadCasinosFromServer() async {
    try {
      final res = await AuthService.dio.get("https://magicity.top/casino");

      if (res.statusCode == 200) {
        final data = res.data as List<dynamic>;

        _jackpots = data.map((c) {
          return Jackpot(
            id: c["_id"] ?? "",
            city: c["city"] ?? "",
            address: c["address"] ?? "",
            imageUrl: c["image_url"],
            isMysteryProgressive: c["mystery_progressive"] == true,
            jackpotUrl: c["jackpot_url"] ?? "",
            uuIdList: (c["uu_id_list"] != null && c["uu_id_list"] is List)
                ? List<String>.from(c["uu_id_list"])
                : [],
            miniMystery: 0,
            middleMystery: 0,
            megaMystery: 0,
            majorBellLink: 0,
            grandBellLink: 0,
            miniRange: "(0 - 0) EUR",
            middleRange: "(0 - 0) EUR",
            megaRange: "(0 - 0) EUR",
            majorBellLinkRange: "(0 - 0) EUR",
            grandBellLinkRange: "(0 - 0) EUR",
          );
        }).toList();

        setState(() {});
      }
    } catch (e) {
      logger.e("Ошибка загрузки казино: $e");
    }
  }

  Future<void> updateJackpots() async {
    for (var j in _jackpots) {
      if (j.jackpotUrl.isEmpty) continue;

      try {
        //final res = await http.get(Uri.parse(j.jackpotUrl));
        final res = await http.get(
          Uri.parse("https://magicity.top/casino/${j.id}/jackpots"),
        );
        if (res.statusCode == 200) {
          final jsonData = jsonDecode(res.body);

          logger.i("Обновление джекпота для ${j.city}: $jsonData");

          final jackpotsList = jsonData["jackpots"] as List<dynamic>?;

          if (jackpotsList != null) {
            for (var jackpotItem in jackpotsList) {
              final name = jackpotItem["name"] ?? "";
              final value = (jackpotItem["value"] is num)
                  ? (jackpotItem["value"] as num).toDouble()
                  : double.tryParse('${jackpotItem["value"]}') ?? 0.0;

              final range = (jackpotItem["range"] is String)
                  ? jackpotItem["range"].toString()
                  : "(0 - 0) EUR";

              if (j.isMysteryProgressive) {
                switch (name) {
                  case "Mini":
                    j.miniMystery = value;
                    j.miniRange = "(" + range + ")";
                    break;
                  case "Middle":
                    j.middleMystery = value;
                    j.middleRange = "(" + range + ")";
                    break;
                  case "Super":
                    j.megaMystery = value;
                    j.megaRange = "(" + range + ")";
                    break;
                }
              } else {
                switch (name) {
                  case "Major":
                    j.majorBellLink = value;
                    j.majorBellLinkRange = "(" + range + ")";
                    break;
                  case "Grand":
                    j.grandBellLink = value;
                    j.grandBellLinkRange = "(" + range + ")";
                    break;
                }
              }
            }
          }
        }
      } catch (err) {
        logger.w("Ошибка обновления джекпота: $err");
      }
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    _refreshTimer?.cancel();
    // если mqttService имеет метод для остановки, вызови его; иначе просто супер
    super.dispose();
  }

  //ДЛЯ ТЕСТА АНИМАЦИИ
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _counter++;
      });

      // Остановить после 100 секунд
      if (_counter >= 1000) {
        timer.cancel();
      }
    });
  }

  /* Future<void> _loadMqtt() async {
    try {
      final result = await mqttService.main();
      // Выводим результат в консоль через logger
      logger.i('MQTT result: $result');
    } catch (e) {
      logger.w('Ошибка MQTT: $e');
    }
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: AdaptiveSizes.h(0.10256),
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final percent =
                    (constraints.maxHeight - kToolbarHeight) /
                    (AdaptiveSizes.getJackpotPercentSize() - kToolbarHeight);
                final double fontSize =
                    AdaptiveSizes.getJackpotLogoFontSize2() +
                    (AdaptiveSizes.getJackpotLogoFontSecondSize() -
                            AdaptiveSizes.getJackpotLogoFontSize2()) *
                        percent;

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
                        padding: const EdgeInsets.only(bottom: 10),
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
              final jackpot = _jackpots[index];
              return JackpotWidget(
                jackpot: jackpot,
                //mqttService: mqttService,
                miniBuilder: (value) => TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: value, end: jackpot.miniMystery),
                  duration: const Duration(milliseconds: 8000),
                  builder: (context, animatedValue, child) {
                    return Text(
                      '${animatedValue.toStringAsFixed(2)} EUR',
                      style: TextStyle(
                        fontSize: AdaptiveSizes.getJackpotCountSize(),
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                middleBuilder: (value) => TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: value,
                    end: jackpot.middleMystery,
                  ),
                  duration: const Duration(milliseconds: 8000),
                  builder: (context, animatedValue, child) {
                    return Text(
                      '${animatedValue.toStringAsFixed(2)} EUR',
                      style: TextStyle(
                        fontSize: AdaptiveSizes.getJackpotCountSize(),
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                megaBuilder: (value) => TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: value, end: jackpot.megaMystery),
                  duration: const Duration(milliseconds: 8000),
                  builder: (context, animatedValue, child) {
                    return Text(
                      '${animatedValue.toStringAsFixed(2)} EUR',
                      style: TextStyle(
                        fontSize: AdaptiveSizes.getJackpotCountSize(),
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                majorBuilder: (value) => TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: value,
                    end: jackpot.majorBellLink,
                  ),
                  duration: const Duration(milliseconds: 8000),
                  builder: (context, animatedValue, child) {
                    return Text(
                      '${animatedValue.toStringAsFixed(2)} EUR',
                      style: TextStyle(
                        fontSize: AdaptiveSizes.getIconBackSettingsSize(),
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                grandBuilder: (value) => TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: value,
                    end: jackpot.grandBellLink,
                  ),
                  duration: const Duration(milliseconds: 8000),
                  builder: (context, animatedValue, child) {
                    return Text(
                      '${animatedValue.toStringAsFixed(2)} EUR',
                      style: TextStyle(
                        fontSize: AdaptiveSizes.getIconBackSettingsSize(),
                        color: Colors.white,
                      ),
                    );
                  },
                ),

                miniRangeBuilder: (range) => Text(
                  jackpot.miniRange,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: AdaptiveSizes.getRangeJackpotSize(),
                  ),
                ),
                middleRangeBuilder: (range) => Text(
                  jackpot.middleRange,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: AdaptiveSizes.getRangeJackpotSize(),
                  ),
                ),
                megaRangeBuilder: (range) => Text(
                  jackpot.megaRange,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: AdaptiveSizes.getRangeJackpotSize(),
                  ),
                ),
                majorBellLinkRangeBuilder: (range) => Text(
                  jackpot.majorBellLinkRange,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: AdaptiveSizes.getRangeJackpotSize(),
                  ),
                ),
                grandBellLinkRangeBuilder: (range) => Text(
                  jackpot.grandBellLinkRange,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: AdaptiveSizes.getRangeJackpotSize(),
                  ),
                ),
              );
            }, childCount: _jackpots.length),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
          ),
        ],
      ),
    );
  }
}
