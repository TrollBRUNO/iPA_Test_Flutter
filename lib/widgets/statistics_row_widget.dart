// ignore_for_file: deprecated_member_use, unnecessary_string_interpolations

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Widget buildStatisticsRow(BuildContext context, DateTime date, int prize) {
  // Цвет в зависимости от типа джекпота
  Color labelColor;
  Color shadowColor;
  IconData iconPrize;
  switch (prize) {
    case 10:
      labelColor = const Color.fromARGB(255, 255, 182, 193); // светло-розовый
      shadowColor = const Color.fromARGB(255, 244, 105, 179).withOpacity(0.5);
      iconPrize = Icons.attach_money;
      break;
    case 20:
      labelColor = const Color.fromARGB(255, 244, 105, 179); // розовый
      shadowColor = const Color.fromARGB(255, 224, 67, 146).withOpacity(0.6);
      iconPrize = Icons.attach_money;
      break;
    case 40:
      labelColor = const Color.fromARGB(255, 224, 67, 146); // фуксия
      shadowColor = const Color.fromARGB(255, 205, 25, 119).withOpacity(0.9);
      iconPrize = Icons.attach_money;
      break;
    case 50:
      labelColor = const Color.fromARGB(255, 205, 25, 119); // малиновый
      shadowColor = const Color.fromARGB(255, 145, 16, 70).withOpacity(0.5);
      iconPrize = Icons.attach_money;
      break;
    case 100:
      labelColor = const Color.fromARGB(255, 255, 190, 51);
      shadowColor = const Color.fromARGB(255, 128, 0, 0).withOpacity(0.9);
      iconPrize = Icons.star;
      break;
    default:
      labelColor = Colors.white;
      shadowColor = Colors.white;
      iconPrize = Icons.abc;
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Icon(
          iconPrize,
          color: labelColor,
          size: 25,
          shadows: [
            Shadow(color: shadowColor, blurRadius: 10, offset: Offset(2, 2)),
          ],
        ),

        const SizedBox(width: 10),

        Text(
          '${DateFormat("d MMMM y", context.locale.languageCode).format(date)}:  ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),

        Text(
          '$prize BGN',
          style: TextStyle(
            color: labelColor,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(width: 10),

        Icon(
          iconPrize,
          color: labelColor,
          size: 25,
          shadows: [
            Shadow(color: shadowColor, blurRadius: 10, offset: Offset(2, 2)),
          ],
        ),
      ],
    ),
  );
}
