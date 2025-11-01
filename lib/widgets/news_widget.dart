import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/class/news.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:first_app_flutter/widgets/smart_marquee_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsWidget extends StatelessWidget {
  final News news;

  const NewsWidget({super.key, required this.news});

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
                    color: Colors.lightBlue.withOpacity(0.4),
                    spreadRadius: 2, // Насколько тень расширяется
                    blurRadius: 8, // Насколько тень размыта
                    offset: Offset(0, 2), // Смещение тени (x, y)
                  ),
                ],
                //color: const Color.fromARGB(255, 24, 75, 141),
                color: Colors.lightBlue[900],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: EdgeInsets.fromLTRB(30, 50, 30, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,

                children: [
                  SmartMarquee(
                    text: news.title,
                    style: AdaptiveSizes.getCityJackpotTextStyle(),
                  ),

                  SizedBox(height: AdaptiveSizes.h(0.00769)),
                  Text(
                    news.description,
                    style: AdaptiveSizes.getInputTextStyle(),
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
              news.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: AdaptiveSizes.getNewsWidgetHeight(),
            ),
          ),

          // Дата
          Positioned(
            top: -8,
            left: -12,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${DateFormat("d MMMM y", context.locale.languageCode).format(news.publicationDate)} ${'year'.tr()}',
                style: TextStyle(
                  //color: const Color.fromARGB(255, 0, 40, 92),
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
