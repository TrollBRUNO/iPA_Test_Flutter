// ignore_for_file: deprecated_member_use

import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:flutter/material.dart';

Widget buildJackpotRow(
  String label,
  double value,
  String range, {
  Widget Function(double value)? valueBuilder,
  Widget Function(String range)? rangeBuilder,
}) {
  // Цвет в зависимости от типа джекпота
  Color labelColor;
  Color shadowColor;
  double labelSize;
  double countSize;
  String rangeMystery;
  IconData iconJackpot;
  switch (label.toLowerCase()) {
    case 'mini':
      labelColor = Colors.cyanAccent;
      shadowColor = const Color.fromARGB(255, 0, 124, 128).withOpacity(0.5);
      labelSize = AdaptiveSizes.getIconBackSettingsSize2(false);
      countSize = AdaptiveSizes.getJackpotCountSize();
      iconJackpot = Icons.star_border_purple500_rounded;
      rangeMystery = "(300 - 800 BGN)";
      break;
    case 'middle':
      labelColor = Colors.blueAccent;
      shadowColor = const Color.fromARGB(255, 0, 0, 128).withOpacity(0.6);
      labelSize = AdaptiveSizes.getIconBackSettingsSize2(false);
      countSize = AdaptiveSizes.getJackpotCountSize();
      iconJackpot = Icons.grade_outlined;
      rangeMystery = "(1200 - 2500 BGN)";
      break;
    case 'mega':
      labelColor = Colors.deepPurpleAccent;
      shadowColor = const Color.fromARGB(255, 92, 0, 128).withOpacity(0.9);
      labelSize = AdaptiveSizes.getIconBackSettingsSize2(false);
      countSize = AdaptiveSizes.getJackpotCountSize();
      iconJackpot = Icons.auto_awesome_outlined;
      rangeMystery = "(7000 - 10000 BGN)";
      break;
    case 'major':
      labelColor = Colors.greenAccent;
      shadowColor = const Color.fromARGB(255, 15, 128, 0).withOpacity(0.5);
      labelSize = AdaptiveSizes.getJackpotRowSize();
      countSize = AdaptiveSizes.getIconBackSettingsSize2(true);
      iconJackpot = Icons.grade_outlined;
      rangeMystery = "(500 - 1500 BGN)";
      break;
    case 'grand':
      labelColor = Colors.redAccent;
      shadowColor = const Color.fromARGB(255, 128, 0, 0).withOpacity(0.9);
      labelSize = AdaptiveSizes.getJackpotRowSize();
      countSize = AdaptiveSizes.getIconBackSettingsSize2(true);
      iconJackpot = Icons.auto_awesome_outlined;
      rangeMystery = "(8000 - 20000 BGN)";
      break;
    default:
      labelColor = Colors.white;
      shadowColor = Colors.white;
      labelSize = AdaptiveSizes.getJackpotCountSize();
      countSize = AdaptiveSizes.getJackpotCountSize();
      iconJackpot = Icons.abc;
      rangeMystery = "10000-20000";
  }

  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Icon(
          iconJackpot,
          color: labelColor,
          size: labelSize + 3,
          shadows: [
            Shadow(color: shadowColor, blurRadius: 10, offset: Offset(2, 2)),
          ],
        ),

        SizedBox(width: AdaptiveSizes.w(0.01388)),

        Text(
          '$label: ',
          style: TextStyle(
            color: labelColor,
            fontWeight: FontWeight.bold,
            fontSize: labelSize,
            shadows: [
              Shadow(
                color: shadowColor,
                blurRadius: 25,
                offset: const Offset(2, -3),
              ),
            ],
          ),
        ),

        /*Text(
          '${value.toStringAsFixed(2)} BGN',
          style: TextStyle(color: Colors.white, fontSize: countSize),
        ),*/
        valueBuilder != null
            ? valueBuilder(value)
            : Text(
                '${value.toStringAsFixed(2)} EUR',
                style: TextStyle(color: Colors.white, fontSize: countSize),
              ),

        SizedBox(width: AdaptiveSizes.w(0.01388)),

        rangeBuilder != null
            ? rangeBuilder(range)
            : Text(
                '${range}',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: AdaptiveSizes.getRangeJackpotSize(),
                ),
              ),

        /* Text(
          rangeMystery,
          style: TextStyle(
            color: Colors.white70,
            fontSize: AdaptiveSizes.getRangeJackpotSize(),
          ),
        ), */
      ],
    ),
  );
}
