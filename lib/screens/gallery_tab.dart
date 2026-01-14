import 'dart:convert';
import 'package:first_app_flutter/class/gallery.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:first_app_flutter/widgets/gallery_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GalleryTab extends StatefulWidget {
  const GalleryTab({super.key});

  @override
  State<GalleryTab> createState() => _GalleryTabState();
}

class _GalleryTabState extends State<GalleryTab> {
  List<Gallery> gallery = [];
  bool isLoading = true;

  final List<Gallery> galleryList = [
    Gallery(
      description: 'BIG WIN в Пловдив! в играта "Horse Legend" е 11500 лева!',
      imageUrl: 'assets/images/1.jpg',
      publicationDate: DateTime(2025, 8, 22),
    ),

    Gallery(
      description:
          'Класически BIG WIN във Велинград! Редица седем! Поздравления за 4000 лева!',
      imageUrl: 'assets/images/2.jpg',
      publicationDate: DateTime(2024, 6, 1),
    ),

    Gallery(
      description:
          'Класически BIG WIN във Велинград! Редица седем! Поздравления за 4000 лева!',
      imageUrl: 'assets/images/2.jpg',
      publicationDate: DateTime(2024, 6, 1),
    ),
  ];

  @override
  void initState() {
    super.initState();
    loadGallery();
  }

  Future<void> loadGallery() async {
    try {
      final res = await AuthService.dio.get("https://magicity.top/gallery");
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.data);

        gallery = decoded
            .map<Gallery>(
              (item) => Gallery(
                description: item['description'],
                imageUrl: item['image_url'],
                publicationDate: DateTime.parse(item['create_date']),
              ),
            )
            .toList();
      }
    } catch (e) {
      print("Ошибка загрузки: $e");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (gallery.isEmpty) {
      return const Center(child: Text("Галерея пуста"));
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: AdaptiveSizes.h(0.025))),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final item = gallery[index];
            return GalleryWidget(gallery: item);
          }, childCount: gallery.length),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ),
      ],
    );
  }
}
