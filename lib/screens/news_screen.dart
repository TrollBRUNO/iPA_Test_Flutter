// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:first_app_flutter/screens/gallery_tab.dart';
import 'package:first_app_flutter/screens/news_tab.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NewsPage(title: 'News');
  }
}

class NewsPage extends StatefulWidget {
  const NewsPage({super.key, required this.title});

  final String title;

  @override
  State<NewsPage> createState() => _NewsState();
}

class _NewsState extends State<NewsPage> {
  //final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                //floating: true, // Allow the app bar to float
                //snap: false,
                expandedHeight: 200,
                toolbarHeight:
                    40, // Provide some minimum height to prevent overflow
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // Высчитываем процент открытия панели (0.0 - свернута, 1.0 - полностью)
                    final double percent =
                        ((constraints.maxHeight - kToolbarHeight) /
                                (200 - kToolbarHeight))
                            .clamp(0.0, 1.0);

                    // Keep font size constant
                    final double fontSize = 72; // Constant font size
                    // Smooth fade out - starts fading immediately but completes quickly
                    // Map percent from 0.8-1.0 range to 0.0-1.0 range for a quick fade
                    final double opacity = percent < 0.8
                        ? 0.0
                        : (percent - 0.8) / 0.2;
                    final double translateY = 20 * (1 - percent);

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(
                                  255,
                                  12,
                                  12,
                                  12,
                                ).withOpacity(0.6),
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.white.withOpacity(0.15),
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 80,
                          left: 0,
                          right: 0,
                          child: Visibility(
                            visible:
                                percent > 0.7, // Visible during fade transition
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 100),
                              opacity: opacity,
                              child: Transform.translate(
                                offset: Offset(0, translateY),
                                child: Center(
                                  child: Text(
                                    'Актуални новини',
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.orangeAccent[200],
                                      shadows: const [
                                        Shadow(
                                          color: Color.fromARGB(
                                            255,
                                            51,
                                            51,
                                            51,
                                          ),
                                          offset: Offset(2.5, 3.5),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48), // Reduced height
                  child: Container(
                    // Adaptive padding based on available space
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20, // Reduced vertical padding
                    ),
                    child: Material(
                      shadowColor: const Color.fromARGB(122, 0, 0, 0),
                      color: const Color.fromARGB(255, 51, 51, 51),
                      borderRadius: BorderRadius.circular(12),
                      child: TabBar(
                        dividerHeight: double.infinity,
                        indicator: BoxDecoration(
                          color: Colors.orangeAccent[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: const Color.fromARGB(255, 19, 19, 19),
                        unselectedLabelColor: Colors.orangeAccent[200],
                        labelStyle: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: const [
                          Tab(text: 'Новини'),
                          Tab(text: 'Галерия'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              // Каждая вкладка — свой скроллируемый контент
              // Например, NewsTab может быть CustomScrollView с SliverList и т.д.
              NewsTab(),
              GalleryTab(),
            ],
          ),
        ),
      ),
    );
  }
}
