import 'package:first_app_flutter/class/gallery.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:first_app_flutter/widgets/Gallery_widget.dart';
import 'package:flutter/material.dart';

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
];

class GalleryTab extends StatelessWidget {
  const GalleryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: AdaptiveSizes.h(0.025))),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final gallery = galleryList[index];
            return GalleryWidget(gallery: gallery);
          }, childCount: galleryList.length),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ),
      ],
    );
  }
}
