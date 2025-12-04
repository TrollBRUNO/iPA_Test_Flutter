import 'dart:convert';
import 'package:first_app_flutter/class/news.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:first_app_flutter/widgets/news_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsTab extends StatefulWidget {
  const NewsTab({super.key});

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  List<News> news = [];
  bool isLoading = true;

  final List<News> newsList = [
    News(
      title: 'Открытие нового казино в Пловдиве!',
      description: 'УРАААААААА',
      imageUrl: 'assets/images/3.jpg',
      publicationDate: DateTime(2023, 8, 8),
    ),
    News(
      title: 'БОЛЬШАЯ НОВОСТЬ',
      description: 'БОЛЬШАЯ НОВОСТЬ ' * 20,
      imageUrl: 'assets/images/4.jpg',
      publicationDate: DateTime(2022, 10, 8),
    ),
    // ...добавь другие новости...
  ];

  @override
  void initState() {
    super.initState();
    loadNews();
  }

  Future<void> loadNews() async {
    try {
      final res = await http.get(Uri.parse("http://localhost:3000/news"));
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);

        news = decoded
            .map<News>(
              (item) => News(
                title: item['title'],
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

    if (news.isEmpty) {
      return const Center(child: Text("Новостей нет"));
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: AdaptiveSizes.h(0.025))),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final item = news[index];
            return NewsWidget(news: item);
          }, childCount: news.length),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ),
      ],
    );
  }
}
