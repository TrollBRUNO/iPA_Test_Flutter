// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/screens/gallery_tab.dart';
import 'package:first_app_flutter/screens/news_tab.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                expandedHeight: AdaptiveSizes.getNewsTabHeight(),
                toolbarHeight: AdaptiveSizes.h(
                  0.02564,
                ), // Provide some minimum height to prevent overflow
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // Высчитываем процент открытия панели (0.0 - свернута, 1.0 - полностью)
                    final double percent =
                        ((constraints.maxHeight - kToolbarHeight) /
                                (AdaptiveSizes.getVisibleTitleNewsHeight() -
                                    kToolbarHeight))
                            .clamp(0.0, 1.0);

                    // Keep font size constant
                    final double fontSize =
                        context.locale.languageCode == "ru" ||
                            context.locale.languageCode == "bg"
                        ? AdaptiveSizes.getFontNewsTitleSize()
                        : AdaptiveSizes.getFontNewsTitleSecondSize(); // Constant font size
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
                          bottom: AdaptiveSizes.getTitleNewsHeight(),
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
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      'breaking_news'.tr(),
                                      style: GoogleFonts.daysOne(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.orangeAccent[200],
                                        shadows: const [
                                          Shadow(
                                            color: Color.fromARGB(
                                              255,
                                              51,
                                              51,
                                              51,
                                            ),
                                            offset: Offset(3.5, 4.5),
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
                        ),
                      ],
                    );
                  },
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(52), // Reduced height
                  /* preferredSize: Size.fromHeight(
                    AdaptiveSizes.getNewsTabSecondHeight(),
                  ),  */
                  // Reduced height
                  child: Container(
                    height: AdaptiveSizes.getNewsTabContainerHeight(),
                    // Adaptive padding based on available space
                    padding: EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: AdaptiveSizes.h(
                        0.01282,
                      ), // Reduced vertical padding
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
                        indicatorPadding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: const Color.fromARGB(255, 19, 19, 19),
                        unselectedLabelColor: Colors.orangeAccent[200],
                        labelStyle: TextStyle(
                          fontSize: AdaptiveSizes.getFontInfoSize(),
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: [
                          Tab(text: 'news'.tr()),
                          Tab(text: 'gallery'.tr()),
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
