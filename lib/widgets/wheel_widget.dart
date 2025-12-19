import 'dart:async';
import 'dart:convert';
//import 'dart:ffi';
//import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:first_app_flutter/class/prize.dart';
import 'package:first_app_flutter/config/notification_config.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/services/background_worker.dart';
import 'package:first_app_flutter/services/notification_service.dart';
import 'package:first_app_flutter/services/spin_time_service.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:first_app_flutter/web/teleslot_webview.dart';
import 'package:first_app_flutter/widgets/ads_dialog_widget.dart';
import 'package:first_app_flutter/widgets/info_dialog_widget.dart';
import 'package:first_app_flutter/widgets/prize_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
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
  bool canSpin = true;
  List<Prize> prizeList = [];
  bool isLoading = true;
  bool isSpinning = false;

  @override
  void initState() {
    super.initState();
    _loadSpinAvailability();
    loadWheel();
  }

  Future<void> loadWheel() async {
    try {
      final res = await http.get(Uri.parse("http://192.168.33.187:3000/wheel"));
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);

        prizeList = decoded.map<Prize>((item) => Prize(item['value'])).toList();
      }
    } catch (e) {
      print("Ошибка загрузки: $e");
    }

    setState(() => isLoading = false);
  }

  Future<void> _loadSpinAvailability() async {
    /* final prefs = await SharedPreferences.getInstance();
    final canSpin = prefs.getBool('can_spin_today') ?? true;

    setState(() {
      _canSpinToday = canSpin;
      isLoading = false;
    }); */
    setState(() => isLoading = true);

    try {
      final res = await AccountTimeService.canSpin();

      setState(() {
        canSpin = res;
        /* canSpin = res.canSpin;
         nextSpinDate = res.nextSpin != null
            ? DateTime.parse(res.nextSpin)
            : null; */
      });
    } catch (e) {
      canSpin = false;
      //nextSpinDate = null;
      logger.w("Ошибка при загрузке статуса спина: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void trySpin() {
    if (!canSpin) {
      showInfoDialog();
      return;
    }
    startSpin();
  }
  // --------- УБРАЛ РЕАЛИЗАЦИЮ ИЗ-ЗА ТОГО ЧТОБЫ БЫЛО ПРОЩЕ ----------------
  /* void openTeleslotAutoLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('login');
    final password = prefs.getString('password');

    if (username == null || password == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Нет сохранённых данных для входа")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            TeleslotLoginWebView(username: username, password: password),
      ),
    );
  } */

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  /* void startSpin(int length) async {
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
    await prefs.setBool('notified_spin_today', true);
    await prefs.setBool('spin_followup_active', false);
    setState(() {
      _canSpinToday = false;
    });

    await AccountTimeService.saveSpinDate(); // сохраняем дату после начала кручения

    await NotificationService().cancelNotification(11);

    await NotificationManager.sendSpinAvailableNow();
    //await NotificationService().cancelNotification(1);
    //await NotificationManager.cancelRepeatSpinReminder(); // отключаем уведомление id=1
    //await NotificationManager.scheduleFollowUpSpinReminder(); // включаем напоминание id=11
  } */

  /* Future<void> startSpin() async {
    if (isSpinning) return;

    setState(() => isSpinning = true);

    try {
      final canSpin = await AccountTimeService.canSpin();
      if (!canSpin) {
        showInfoDialog();
        return;
      }

      final result = await AccountTimeService.spin(
        prizeList.map((e) => e.value).toList(),
      );

      lastSelectedIndex = result.index;
      selected.add(result.index);
    } catch (e) {
      showInfoDialog();
    } finally {
      setState(() => isSpinning = false);
    }
  } */

  Future<void> startSpin() async {
    if (isSpinning) return;
    setState(() => isSpinning = true);

    try {
      final result = await AccountTimeService.spin(
        prizeList.map((e) => e.value).toList(),
      );

      lastSelectedIndex = result.index;
      selected.add(result.index);
    } catch (e) {
      showInfoDialog();
    } finally {
      setState(() => isSpinning = false);
    }
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

                // --------- УБРАЛ РЕАЛИЗАЦИЮ ИЗ-ЗА ТОГО ЧТОБЫ БЫЛО ПРОЩЕ ----------------
                //showAdsDialog();
              },
            ),
          ),
        );
      },
    );
  }

  // --------- УБРАЛ РЕАЛИЗАЦИЮ ИЗ-ЗА ТОГО ЧТОБЫ БЫЛО ПРОЩЕ ----------------
  /* void showAdsDialog() {
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
              /* onTry: () async {
                Navigator.of(context).pop();

                const url = 'https://live.teleslot.net/';

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
              }, */
              onTry: () async {
                Navigator.of(context).pop();

                try {
                  openTeleslotAutoLogin(context);
                } catch (e) {
                  debugPrint("Ошибка перехода: $e");
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
  } */

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

    /* final prizeList = <Prize>[
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
    ]; */

    if (isLoading) {
      /* return Center(
        child: CircularProgressIndicator(color: Colors.orangeAccent[200]),
      ); */
      return Scaffold(
        body: Center(
          child: Lottie.asset(
            "assets/lottie/8_bit_coin.json",
            width: 200,
            height: 200,
            repeat: true,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: GestureDetector(
        onTap: () => trySpin(),
        child: Column(
          children: [
            Expanded(
              child: FortuneWheel(
                rotationCount: 30,
                curve: Curves.easeOutCirc,
                duration: Duration(milliseconds: 2000),
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

                onFling: () => trySpin(),

                onAnimationEnd: () async {
                  final prize = prizeList[lastSelectedIndex ?? 0];
                  /* final prefs = await SharedPreferences.getInstance();

                  final bonusBalance = prefs.getString('bonus_balance') ?? "0";
                  final bonusBalanceToDouble =
                      int.tryParse(bonusBalance) ?? 0.0;

                  final currentBalance = bonusBalanceToDouble + prize.value;

                  await prefs.setString(
                    'bonus_balance',
                    currentBalance.toString(),
                  ); */
                  showPrizeDialog(prize.formatted);
                  //showPrizeDialog('100 EUR');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
