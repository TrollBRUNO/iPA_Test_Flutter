import 'dart:async';
//import 'dart:ffi';
//import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:first_app_flutter/class/prize.dart';
import 'package:first_app_flutter/services/spin_time_service.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:first_app_flutter/widgets/ads_dialog_widget.dart';
import 'package:first_app_flutter/widgets/info_dialog_widget.dart';
import 'package:first_app_flutter/widgets/prize_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class WheelWidget extends StatefulWidget {
  const WheelWidget({super.key});

  @override
  State<WheelWidget> createState() => _WheelState();
}

class _WheelState extends State<WheelWidget> {
  StreamController<int> selected = StreamController<int>();
  int? lastSelectedIndex;
  bool _canSpinToday = true;

  @override
  void initState() {
    super.initState();
    _loadSpinAvailability();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Обновляем статус при каждом возвращении на экран
    _loadSpinAvailability();
  }

  Future<void> _loadSpinAvailability() async {
    final prefs = await SharedPreferences.getInstance();
    final canSpin = prefs.getBool('can_spin_today') ?? true;

    setState(() {
      _canSpinToday = canSpin;
    });
  }

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  void startSpin(int length) async {
    if (!_canSpinToday) {
      showInfoDialog();
      return;
    }

    final index = Fortune.randomInt(0, length);
    setState(() {
      lastSelectedIndex = index;
      selected.add(index);
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('can_spin_today', false);
    setState(() {
      _canSpinToday = false;
    });

    await SpinTimeService.saveSpinDate(); // сохраняем дату после начала кручения
  }

  void showPrizeDialog(String prize) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "PrizeDialog",
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: curved,
            child: PrizeDialogWidget(
              prize: prize,
              onClaim: () {
                Navigator.of(context).pop();
                showAdsDialog();
              },
            ),
          ),
        );
      },
    );
  }

  void showAdsDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "AdsDialog",
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: curved,
            child: AdsDialogWidget(
              onTry: () async {
                Navigator.of(context).pop();

                const url = 'https://live.teleslot.net/login';

                final uri = Uri.parse(url);

                try {
                  final launched = await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );

                  if (!launched) {
                    throw 'Не удалось открыть сайт: $url';
                  }
                } catch (e) {
                  debugPrint('Ошибка при открытии ссылки: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Не удалось открыть сайт'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },

              onClose: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }

  void showInfoDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "InfoDialog",
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: curved,
            child: InfoDialogWidget(onClaim: () => Navigator.of(context).pop()),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AdaptiveSizes.init(context);

    final prizeList = <Prize>[
      const Prize(20),
      const Prize(10),
      const Prize(50),
      const Prize(20),
      const Prize(10),
      const Prize(40),
      const Prize(20),
      const Prize(10),
      const Prize(40),
      const Prize(20),
      const Prize(10),
      const Prize(50),
      const Prize(20),
      const Prize(10),
      const Prize(40),
      const Prize(20),
      const Prize(10),
      const Prize(40),
      const Prize(20),
      const Prize(10),
      const Prize(50),
      const Prize(20),
      const Prize(10),
      const Prize(40),
      const Prize(20),
      const Prize(10),
      const Prize(40),
      const Prize(20),
      const Prize(10),
      const Prize(100),
      const Prize(20),
      const Prize(10),
      const Prize(40),
      const Prize(20),
      const Prize(10),
      const Prize(40),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: GestureDetector(
        onTap: () => startSpin(prizeList.length),
        child: Column(
          children: [
            Expanded(
              child: FortuneWheel(
                rotationCount: 30,
                curve: Curves.easeOutCirc,
                duration: Duration(milliseconds: 20000),
                animateFirst: false,
                hapticImpact: HapticImpact.medium,
                selected: selected.stream,
                indicators: [
                  FortuneIndicator(
                    alignment: Alignment.topCenter,
                    child: TriangleIndicator(
                      color: Colors.orangeAccent[200],
                      width: 20,
                      height: 20,
                      elevation: 20,
                    ),
                  ),
                ],
                items: List.generate(prizeList.length, (index) {
                  final prize = prizeList[index];
                  final Color bgColor;

                  double fontSize = AdaptiveSizes.getFontPrizeSize();
                  Color textColor = Colors.white;
                  switch (prize.value) {
                    case 10:
                      bgColor = const Color.fromARGB(
                        255,
                        255,
                        182,
                        193,
                      ); // светло-розовый
                      break;
                    case 20:
                      bgColor = const Color.fromARGB(
                        255,
                        244,
                        105,
                        179,
                      ); // розовый
                      break;
                    case 40:
                      bgColor = const Color.fromARGB(
                        255,
                        224,
                        67,
                        146,
                      ); // фуксия
                      break;
                    case 50:
                      bgColor = const Color.fromARGB(
                        255,
                        205,
                        25,
                        119,
                      ); // малиновый
                      break;
                    case 100:
                      // для градиента создаём контейнер ниже
                      bgColor = Colors.transparent;
                      fontSize = AdaptiveSizes.getFontBigPrizeSize();
                      textColor = const Color.fromARGB(255, 255, 190, 51);
                      break;
                    default:
                      bgColor = Colors.grey;
                  }

                  final bool isBigWin = prize.value == 100;

                  return FortuneItem(
                    style: isBigWin
                        ? const FortuneItemStyle(
                            color: Colors.transparent,
                            borderColor: Colors.white,
                            borderWidth: 1.5,
                          )
                        : FortuneItemStyle(
                            color: bgColor,
                            borderColor: Color.fromARGB(0, 206, 25, 161),
                            borderWidth: 3,
                          ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Transform.rotate(
                        angle: 3.14,
                        child: isBigWin
                            ? Container(
                                alignment: Alignment.centerLeft,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 206, 25, 161),
                                      Color.fromARGB(255, 85, 89, 232),
                                    ],
                                  ),
                                ),
                                padding: AdaptiveSizes.getLeftPrizePadding(),
                                child: Text(
                                  prize.formatted,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    color: textColor,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: AdaptiveSizes.getLeftPrizePadding(),
                                child: Text(
                                  prize.formatted,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    color: textColor,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  );
                }),

                onFling: () => startSpin(prizeList.length),

                onAnimationEnd: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final prize = prizeList[lastSelectedIndex ?? 0];

                  final bonusBalance = prefs.getString('bonus_balance') ?? "0";
                  final bonusBalanceToDouble =
                      int.tryParse(bonusBalance) ?? 0.0;

                  final currentBalance = bonusBalanceToDouble + prize.value;

                  await prefs.setString(
                    'bonus_balance',
                    currentBalance.toString(),
                  );
                  showPrizeDialog(prize.formatted);
                  //showPrizeDialog('100 BGN');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
