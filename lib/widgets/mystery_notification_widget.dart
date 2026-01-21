import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/services/notification_service.dart';
import 'package:first_app_flutter/class/notification.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MysteryNotificationTile extends StatefulWidget {
  final UserNotificationSettings settings;

  const MysteryNotificationTile({super.key, required this.settings});

  @override
  State<MysteryNotificationTile> createState() =>
      _MysteryNotificationTileState();
}

class _MysteryNotificationTileState extends State<MysteryNotificationTile> {
  late int mini;
  late int middle;
  late int mega;

  @override
  void initState() {
    super.initState();
    mini = widget.settings.mini;
    middle = widget.settings.middle;
    mega = widget.settings.mega;
  }

  Future<void> _save() async {
    widget.settings.mini = mini;
    widget.settings.middle = middle;
    widget.settings.mega = mega;

    await NotificationService.saveSettings(widget.settings);
  }

  Widget sliderRow({
    required String label,
    required int value,
    required int min,
    required int max,
    required Color labelColor,
    required Color shadowColor,
    required IconData iconJackpot,
    required Function(int) onChange,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                iconJackpot,
                color: labelColor,
                size: AdaptiveSizes.getJackpotCountSize() + 3,
                shadows: [
                  Shadow(
                    color: shadowColor,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              SizedBox(width: AdaptiveSizes.w(0.01288)),
              Text(
                label,
                style: TextStyle(
                  color: labelColor,
                  fontWeight: FontWeight.bold,
                  fontSize: AdaptiveSizes.getJackpotCountSize(),
                  shadows: [
                    Shadow(
                      color: shadowColor,
                      blurRadius: 25,
                      offset: const Offset(2, -3),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AdaptiveSizes.w(0.01)),

              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final sliderWidth = constraints.maxWidth;
                    final thumbPos =
                        ((value - min) / (max - min)) * sliderWidth;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 10,
                            ),
                            overlayShape: RoundSliderOverlayShape(
                              overlayRadius: 18,
                            ),
                            trackHeight: 3,
                            activeTrackColor: Colors.orangeAccent[400],
                            inactiveTrackColor: Colors.grey[800],
                            thumbColor: Colors.white,
                            overlayColor: Colors.white12,
                          ),
                          child: Slider(
                            min: min.toDouble(),
                            max: max.toDouble(),
                            value: value.toDouble(),
                            onChanged: (v) {
                              setState(() => onChange(v.toInt()));
                              _save();
                            },
                          ),
                        ),

                        Positioned(
                          left: thumbPos - 15,
                          bottom: 37.5,
                          child: Text(
                            value.toString(),
                            style: GoogleFonts.raleway(
                              color: Colors.white,
                              fontSize:
                                  AdaptiveSizes.getFontCreditBalanceSize(),
                            ),
                          ),
                        ),

                        Positioned(
                          left: 18,
                          bottom: -6,
                          child: Opacity(
                            opacity: 0.5,
                            child: Text(
                              min.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          right: 18,
                          bottom: -6,
                          child: Opacity(
                            opacity: 0.5,
                            child: Text(
                              max.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AdaptiveSizes.getNotificationPadding2(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9),
          borderRadius: AdaptiveSizes.getJackpotWidgetBorderRadius(),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.6),
              spreadRadius: 0.2,
              blurRadius: 1,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "mystery_jackpot_thresholds".tr(),
                    style: GoogleFonts.raleway(
                      fontSize: AdaptiveSizes.getFontInfoSize(),
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            sliderRow(
              label: "Mini:",
              value: mini,
              min: 30,
              max: 300,
              labelColor: Colors.cyanAccent,
              shadowColor: const Color.fromARGB(
                255,
                0,
                124,
                128,
              ).withOpacity(0.5),
              iconJackpot: Icons.star_border_purple500_rounded,
              onChange: (v) => mini = v,
            ),

            sliderRow(
              label: "Middle:",
              value: middle,
              min: 500,
              max: 1000,
              labelColor: Colors.blueAccent,
              shadowColor: const Color.fromARGB(
                255,
                0,
                0,
                128,
              ).withOpacity(0.6),
              iconJackpot: Icons.grade_outlined,
              onChange: (v) => middle = v,
            ),

            sliderRow(
              label: "Mega:",
              value: mega,
              min: 3000,
              max: 10000,
              labelColor: Colors.deepPurpleAccent,
              shadowColor: const Color.fromARGB(
                255,
                115,
                1,
                160,
              ).withOpacity(0.8),
              iconJackpot: Icons.auto_awesome_outlined,
              onChange: (v) => mega = v,
            ),
          ],
        ),
      ),
    );
  }
}
