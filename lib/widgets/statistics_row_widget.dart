// ignore_for_file: deprecated_member_use, unnecessary_string_interpolations

import 'package:easy_localization/easy_localization.dart';
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
      shadowColor = Colors.pinkAccent.shade700;
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
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
    child: Row(
      children: [
        if (isBigWin)
          Icon(
            Icons.star,
            color: labelColor,
            size: 36,
            shadows: [
              Shadow(color: shadowColor, blurRadius: 4, offset: Offset(3, 1)),
            ],
          ),

        SizedBox(width: isBigWin ? 12 : 48),

        Text(
          '${DateFormat("d MMMM y", context.locale.languageCode).format(date)}:  ',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 30),
        ),

        Text(
          '$prize BGN',
          style: GoogleFonts.radioCanada(
            color: labelColor,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            shadows: [
              Shadow(color: shadowColor, blurRadius: 2, offset: Offset(2, 1)),
            ],
          ),
        ),

        const SizedBox(width: 12),

        if (isBigWin)
          Icon(
            Icons.star,
            color: labelColor,
            size: 36,
            shadows: [
              Shadow(color: shadowColor, blurRadius: 4, offset: Offset(-3, 1)),
            ],
          ),
      ],
    ),
  );
}
