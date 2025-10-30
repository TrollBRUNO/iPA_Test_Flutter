import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdsDialogWidget extends StatefulWidget {
  final VoidCallback onTry;
  final VoidCallback onClose;

  const AdsDialogWidget({required this.onTry, required this.onClose});

  @override
  State<AdsDialogWidget> createState() => _AdsDialogState();
}

class _AdsDialogState extends State<AdsDialogWidget>
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
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: ScaleTransition(
                  scale: _scaleAnim,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: AdaptiveSizes.getAdsDialogMaxWidth(),
                      padding: AdaptiveSizes.getAdsPadding(),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 206, 25, 161),
                            Color.fromARGB(255, 85, 89, 232),
                            /* Colors.orangeAccent.shade100,
                            Colors.pinkAccent.shade100, */
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: AdaptiveSizes.getAdsDialogRadius(),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pinkAccent.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 10,
                            offset: const Offset(0, 0),
                          ),
                          BoxShadow(
                            color: const Color.fromARGB(255, 244, 105, 179),
                            blurRadius: 1,
                            spreadRadius: 2,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: AdaptiveSizes.h(0.02564)),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.asset(
                                  'assets/images/site.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: AdaptiveSizes.h(0.19230),
                                ),
                              ),
                              SizedBox(height: AdaptiveSizes.h(0.01923)),
                              Text(
                                "play_home".tr(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.pacifico(
                                  fontSize:
                                      AdaptiveSizes.getBigWinYouWinPrizeSize(),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepOrange.shade900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(height: AdaptiveSizes.h(0.01282)),
                              Text(
                                "description_ads".tr(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: AdaptiveSizes.getJackpotCountSize(),
                                  color: Colors.brown.shade800,
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: AdaptiveSizes.h(0.02564)),
                              _buildFancyButton(),
                            ],
                          ),
                          Positioned(
                            top: -10,
                            right: -10,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                size: 34,
                                color: Colors.black54,
                              ),
                              onPressed: widget.onClose,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFancyButton() {
    return GestureDetector(
      onTap: widget.onTry,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.orangeAccent.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "lets_try".tr(),
            style: GoogleFonts.poppins(
              fontSize: AdaptiveSizes.getFancyButtonTextSize(),
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
