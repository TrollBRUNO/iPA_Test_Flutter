// ignore_for_file: deprecated_member_use, unnecessary_string_interpolations

import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildStatisticsRow(BuildContext context, DateTime date, int prize) {
  // Цвет в зависимости от типа джекпота
  Color labelColor;
  Color shadowColor;

  final isBigWin = prize == 100;

  switch (prize) {
    case 10:
      labelColor = Colors.pinkAccent.shade200;
      shadowColor = Colors.pink.shade900;
      break;
    case 20:
      labelColor = Colors.pink.shade500;
      shadowColor = Colors.pink.shade900;
      break;
    case 40:
      labelColor = Colors.pink.shade700;
      shadowColor = Colors.pinkAccent.shade100;
      break;
    case 50:
      labelColor = Colors.deepPurple.shade600; // малиновый
      shadowColor = Colors.deepPurple.shade300;
      break;
    case 100:
      labelColor = Colors.orange.shade400;
      shadowColor = Colors.black87;
      break;
    default:
      labelColor = Colors.white;
      shadowColor = Colors.white;
  }

  return Padding(
    padding: AdaptiveSizes.getStatisticsRowPadding(),
    child: Row(
      children: [
        if (isBigWin)
          Icon(
            Icons.star,
            color: labelColor,
            size: AdaptiveSizes.getFontStatisticsIconSize(),
            shadows: [
              Shadow(color: shadowColor, blurRadius: 4, offset: Offset(3, 1)),
            ],
          ),

        SizedBox(
          width: isBigWin ? AdaptiveSizes.h(0.00769) : AdaptiveSizes.h(0.03076),
        ),

        Text(
          '${DateFormat("d MMMM y", context.locale.languageCode).format(date)}:  ',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: AdaptiveSizes.getIconBackSettingsSize(),
          ),
        ),

        Text(
          '$prize BGN',
          style: GoogleFonts.radioCanada(
            color: labelColor,
            fontSize: AdaptiveSizes.getIconBackSettingsSize(),
            fontWeight: FontWeight.w700,
            shadows: [
              Shadow(color: shadowColor, blurRadius: 2, offset: Offset(2, 2)),
            ],
          ),
        ),

        SizedBox(width: AdaptiveSizes.w(0.01666)),

        if (isBigWin)
          Icon(
            Icons.star,
            color: labelColor,
            size: AdaptiveSizes.getFontStatisticsIconSize(),
            shadows: [
              Shadow(color: shadowColor, blurRadius: 4, offset: Offset(-3, 1)),
            ],
          ),
      ],
    ),
  );
}
