import 'package:first_app_flutter/config/mystery_notification_config.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MysteryNotificationTile extends StatefulWidget {
  final MysteryNotificationConfig config;

  const MysteryNotificationTile({super.key, required this.config});

  @override
  State<MysteryNotificationTile> createState() =>
      _MysteryNotificationTileState();
}

class _MysteryNotificationTileState extends State<MysteryNotificationTile> {
  bool enabled = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    enabled = await MysteryNotificationManager.loadSwitchState(
      widget.config.prefKey,
      true,
    );

    await widget.config.loadMysteryValues();
    setState(() {});
  }

  Future<void> toggle(bool v) async {
    setState(() => enabled = v);
    await MysteryNotificationManager.toggleMysteryNotification(
      widget.config,
      v,
    );
  }

  Widget sliderRow({
    required String label,
    required double value,
    required double min,
    required double max,
    required Color labelColor,
    required Color shadowColor,
    required IconData iconJackpot,
    required Function(double) onChange,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 5),
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
              ) /* 
              const Spacer(),
              Text(
                value.toStringAsFixed(0),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: AdaptiveSizes.getJackpotCountSize(),
                ),
              ), */,

              SizedBox(width: AdaptiveSizes.w(0.01)),

              // Слайдер с value над ползунком
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
                            min: min,
                            max: max,
                            value: value,
                            onChanged: (v) {
                              setState(() => onChange(v));
                              widget.config.saveMysteryValues();
                            },
                          ),
                        ),
                        Positioned(
                          left: thumbPos - 15, // сдвиг для центрирования
                          bottom: 37.5, // над слайдером
                          child: Text(
                            value.toStringAsFixed(0),
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
                              min.toStringAsFixed(0),
                              style: TextStyle(
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
                              max.toStringAsFixed(0),
                              style: TextStyle(
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
    final cfg = widget.config;

    return Padding(
      padding: AdaptiveSizes.getNotificationPadding2(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            // Header row (TITLE + SWITCH)
            Row(
              children: [
                Expanded(
                  child: Text(
                    cfg.title,
                    style: GoogleFonts.raleway(
                      fontSize: AdaptiveSizes.getFontInfoSize(),
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Transform.scale(
                  scale: AdaptiveSizes.getNotificationSwitchSize(),
                  child: Switch(
                    // первые два мб надо будет поменять на что-то по типу:
                    // value: value,
                    // onChanged: onChanged,
                    value: enabled,
                    onChanged: toggle,
                    activeColor: Colors.white,
                    activeTrackColor: Colors.orangeAccent[400],
                    inactiveThumbColor: Colors.grey[600],
                    inactiveTrackColor: Colors.grey[800],
                  ),
                ),
              ],
            ),
            /* Divider(
              height: AdaptiveSizes.getDividerProfileHeight(),
              color: Colors.white,
            ), */
            // --- MINI ---
            sliderRow(
              label: "Mini:",
              value: cfg.miniMystery,
              min: cfg.miniMin,
              max: cfg.miniMax,
              labelColor: Colors.cyanAccent,
              shadowColor: const Color.fromARGB(
                255,
                0,
                124,
                128,
              ).withOpacity(0.5),
              iconJackpot: Icons.star_border_purple500_rounded,
              onChange: (v) => cfg.miniMystery = v,
            ),

            // --- MIDDLE ---
            sliderRow(
              label: "Middle:",
              value: cfg.middleMystery,
              min: cfg.middleMin,
              max: cfg.middleMax,
              labelColor: Colors.blueAccent,
              shadowColor: const Color.fromARGB(
                255,
                0,
                0,
                128,
              ).withOpacity(0.6),
              iconJackpot: Icons.grade_outlined,
              onChange: (v) => cfg.middleMystery = v,
            ),

            // --- MEGA ---
            sliderRow(
              label: "Mega:",
              value: cfg.megaMystery,
              min: cfg.megaMin,
              max: cfg.megaMax,
              labelColor: Colors.deepPurpleAccent,
              shadowColor: const Color.fromARGB(
                255,
                115,
                1,
                160,
              ).withOpacity(0.8),
              iconJackpot: Icons.auto_awesome_outlined,
              onChange: (v) => cfg.megaMystery = v,
            ),
          ],
        ),
      ),
    );
  }
}
