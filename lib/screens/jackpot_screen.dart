// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:first_app_flutter/class/jackpot.dart';
import 'package:first_app_flutter/widgets/jackpot_widget.dart';
import 'package:flutter/material.dart';

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
  // Тестовые данные джекпотов
  final List<Jackpot> jackpots = [
    Jackpot(
      city: 'Пловдив: Magic City',
      address: 'бул. Източен 48',
      imageUrl: 'assets/images/logo_magic_city5.png',
      isMysteryProgressive: true,
      miniMystery: 359.76,
      middleMystery: 1535.53,
      megaMystery: 8321.84,
    ),
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
                final double fontSize = 32 + (72 - 32) * percent;

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
                          'Онлайн джакпот',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.orangeAccent[200],
                            shadows: const [
                              Shadow(
                                color: Color.fromARGB(255, 51, 51, 51),
                                offset: Offset(2.5, 3.5),
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
              return JackpotWidget(jackpot: jackpots[index]);
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
