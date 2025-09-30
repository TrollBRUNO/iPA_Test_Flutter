import 'dart:async';
//import 'dart:ffi';
//import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class WheelWidget extends StatefulWidget {
  const WheelWidget({super.key});

  @override
  State<WheelWidget> createState() => _WheelState();
}

class _WheelState extends State<WheelWidget> {
  StreamController<int> selected = StreamController<int>();
  bool isSpinning = false;
  int? lastSelectedIndex;

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  void startSpin(int length) {
    if (isSpinning) return;
    final index = Fortune.randomInt(0, length);
    setState(() {
      isSpinning = true;
      lastSelectedIndex = index;
      selected.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final prizeList = <String>[
      '20 BGN',
      '10 BGN',
      '50 BGN',
      '20 BGN',
      '10 BGN',
      '40 BGN',
      '20 BGN',
      '10 BGN',
      '40 BGN',
      '20 BGN',
      '10 BGN',
      '50 BGN',
      '20 BGN',
      '10 BGN',
      '40 BGN',
      '20 BGN',
      '10 BGN',
      '40 BGN',
      '20 BGN',
      '10 BGN',
      '50 BGN',
      '20 BGN',
      '10 BGN',
      '40 BGN',
      '20 BGN',
      '10 BGN',
      '40 BGN',
      '20 BGN',
      '10 BGN',
      '100 BGN',
      '20 BGN',
      '10 BGN',
      '40 BGN',
      '20 BGN',
      '10 BGN',
      '40 BGN',
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
                      color: const Color.fromARGB(255, 255, 160, 51),
                      width: 30,
                      height: 40,
                      elevation: 20,
                    ),
                  ),
                ],
                items: List.generate(prizeList.length, (index) {
                  final value = prizeList[index];
                  final Color bgColor;

                  double fontSize = 22.0;
                  Color textColor = Colors.white;
                  switch (value) {
                    case '10 BGN':
                      bgColor = const Color.fromARGB(
                        255,
                        255,
                        182,
                        193,
                      ); // светло-розовый
                      break;
                    case '20 BGN':
                      bgColor = const Color.fromARGB(
                        255,
                        244,
                        105,
                        179,
                      ); // розовый
                      break;
                    case '40 BGN':
                      bgColor = const Color.fromARGB(
                        255,
                        224,
                        67,
                        146,
                      ); // фуксия
                      break;
                    case '50 BGN':
                      bgColor = const Color.fromARGB(
                        255,
                        205,
                        25,
                        119,
                      ); // малиновый
                      break;
                    case '100 BGN':
                      // для градиента создаём контейнер ниже
                      bgColor = Colors.transparent;
                      fontSize = 30.0;
                      textColor = const Color.fromARGB(255, 255, 190, 51);
                      break;
                    default:
                      bgColor = Colors.grey;
                  }

                  final bool isBigWin = value == '100 BGN';

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
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    color: textColor,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  value,
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

                onAnimationEnd: () {
                  final prize = prizeList[lastSelectedIndex ?? 0];

                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('Печалба! 🎉🎉🎉'),

                      content: prize == "100 BGN"
                          ? Text('YOOOOU WIN THE BIG WIN!!! $prize\n\n')
                          : Text('YOU WIN! $prize\n\n'),

                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Закрыть диалог
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
