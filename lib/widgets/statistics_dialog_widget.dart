import 'package:confetti/confetti.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/class/statistics.dart';
import 'package:first_app_flutter/widgets/statistics_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatisticsDialogWidget extends StatefulWidget {
  final String prize;
  final VoidCallback onClaim;

  const StatisticsDialogWidget({required this.prize, required this.onClaim});

  @override
  State<StatisticsDialogWidget> createState() => _StatisticsDialogState();
}

final List<Statistics> galleryList = [
  Statistics(publicationDate: DateTime(2025, 10, 20), prizeCount: 100),

  Statistics(publicationDate: DateTime(2025, 10, 12), prizeCount: 50),

  Statistics(publicationDate: DateTime(2025, 9, 30), prizeCount: 10),

  Statistics(publicationDate: DateTime(2025, 9, 22), prizeCount: 20),

  Statistics(publicationDate: DateTime(2025, 10, 20), prizeCount: 100),

  Statistics(publicationDate: DateTime(2025, 10, 12), prizeCount: 40),

  Statistics(publicationDate: DateTime(2025, 9, 30), prizeCount: 40),

  Statistics(publicationDate: DateTime(2025, 9, 22), prizeCount: 20),

  Statistics(publicationDate: DateTime(2025, 10, 20), prizeCount: 100),

  Statistics(publicationDate: DateTime(2025, 10, 12), prizeCount: 50),

  Statistics(publicationDate: DateTime(2025, 9, 30), prizeCount: 10),

  Statistics(publicationDate: DateTime(2025, 9, 22), prizeCount: 20),

  Statistics(publicationDate: DateTime(2025, 10, 20), prizeCount: 100),

  Statistics(publicationDate: DateTime(2025, 10, 12), prizeCount: 50),

  Statistics(publicationDate: DateTime(2025, 9, 30), prizeCount: 10),

  Statistics(publicationDate: DateTime(2025, 9, 22), prizeCount: 20),
];

class _StatisticsDialogState extends State<StatisticsDialogWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.ease);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Основной контейнер с тенью
            Container(
              width: 600,
              constraints: BoxConstraints(maxHeight: 900, minHeight: 320),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.lightGreen.shade100,
                    Colors.greenAccent.shade100,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.yellow.shade100,
                    blurRadius: 20,
                    spreadRadius: 4,
                    offset: const Offset(0, 0),
                  ),
                  BoxShadow(
                    color: Colors.yellow.shade200,
                    blurRadius: 1,
                    spreadRadius: 2,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleTransition(
                        scale: _scaleAnim,
                        child: Icon(
                          Icons.insert_drive_file_outlined,
                          color: Colors.green[400],
                          size: 80,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "statistics".tr(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(1, 2),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          color: Colors.black.withOpacity(0.02),
                          constraints: BoxConstraints(maxHeight: 600),
                          child: Scrollbar(
                            thumbVisibility:
                                false, // <- полоса будет всегда видна
                            radius: const Radius.circular(20),
                            thickness: 4, // толщина полосы
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: galleryList
                                    .map(
                                      (stat) => buildStatisticsRow(
                                        context,
                                        stat.publicationDate,
                                        stat.prizeCount,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: -10,
                    right: -10,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: widget.onClaim,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
