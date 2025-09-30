import 'package:first_app_flutter/class/gallery.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GalleryWidget extends StatelessWidget {
  final Gallery gallery;

  const GalleryWidget({super.key, required this.gallery});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Нижний блок с текстом
          Padding(
            padding: const EdgeInsets.only(top: 445.0, bottom: 40),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 100, 100, 100),
                    spreadRadius: 2, // Насколько тень расширяется
                    blurRadius: 8, // Насколько тень размыта
                    offset: Offset(0, 4), // Смещение тени (x, y)
                  ),
                ],
                color: const Color.fromARGB(255, 134, 30, 30),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: EdgeInsets.fromLTRB(30, 50, 30, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    gallery.description,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
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
              height: 480,
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
                '${DateFormat("d MMMM y", "bg_BG").format(gallery.publicationDate)} година',
                style: TextStyle(
                  color: const Color.fromARGB(255, 56, 0, 0),
                  fontSize: 18,
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
