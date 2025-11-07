import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/class/gallery.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GalleryWidget extends StatelessWidget {
  final Gallery gallery;

  const GalleryWidget({super.key, required this.gallery});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AdaptiveSizes.getFontStatisticsIconSize(),
        vertical: 0,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Нижний блок с текстом
          Padding(
            padding: AdaptiveSizes.getWidgetNewsPadding(),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4), // Цвет тени
                    spreadRadius: 2, // Насколько тень расширяется
                    blurRadius: 8, // Насколько тень размыта
                    offset: Offset(0, 2), // Смещение тени (x, y)
                  ),
                ],
                //color: const Color.fromARGB(255, 134, 30, 30),
                color: Colors.red[900],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: EdgeInsets.fromLTRB(30, 50, 30, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    gallery.description,
                    style: AdaptiveSizes.getUniversalTextStyle(),
                  ),
                ],
              ),
            ),
          ),

          // Фото поверх
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            child: Image.asset(
              gallery.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: AdaptiveSizes.getNewsWidgetHeight(),
            ),
          ),

          // Дата
          Positioned(
            top: -8,
            right: -12,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${DateFormat("d MMMM y", context.locale.languageCode).format(gallery.publicationDate)} ${'year'.tr()}',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: AdaptiveSizes.getUnselectedFontSize(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
