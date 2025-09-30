import 'package:first_app_flutter/class/news.dart';
import 'package:first_app_flutter/widgets/news_widget.dart';
import 'package:flutter/material.dart';

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

class NewsTab extends StatelessWidget {
  const NewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: newsList.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final news = newsList[index];
        return NewsWidget(news: news);
      },
    );
  }
}
