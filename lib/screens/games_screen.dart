// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/class/games.dart';
import 'package:first_app_flutter/class/jackpot.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/services/mqtt_jackpot_service.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:first_app_flutter/widgets/games_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GamesPage(title: 'Games');
  }
}

class GamesPage extends StatefulWidget {
  const GamesPage({super.key, required this.title});

  final String title;

  @override
  State<GamesPage> createState() => _JackpotState();
}

class _JackpotState extends State<GamesPage> {
  Logger logger = Logger();
  final MqttJackpotService mqttService = MqttJackpotService();

  List<Games> _games = [];

  @override
  void initState() {
    super.initState();

    // Тестовые данные джекпотов
    //List<Jackpot> get jackpots => [
    _games = [
      Games(
        name: 'Pateplay Super 44',
        imageUrl: 'assets/images/pateplay.jpg',
        addressUrl: 'https://example.com/game',
      ),

      Games(
        name: 'Pateplay Hot Line',
        imageUrl: 'assets/images/pateplay.jpg',
        addressUrl: 'https://example.com/game',
      ),

      Games(
        name: 'Pateplay Vampire',
        imageUrl: 'assets/images/pateplay.jpg',
        addressUrl: 'https://example.com/game',
      ),

      Games(
        name: 'Pateplay Bank Robbery',
        imageUrl: 'assets/images/pateplay.jpg',
        addressUrl: 'https://example.com/game',
      ),

      Games(
        name: 'Pateplay Secret Formula',
        imageUrl: 'assets/images/pateplay.jpg',
        addressUrl: 'https://example.com/game',
      ),
    ];
  }

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
                          'online_games'.tr(),
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
              final games = _games[index];
              return GamesWidget(games: games);
            }, childCount: _games.length),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
          ),
        ],
      ),
    );
  }
}
