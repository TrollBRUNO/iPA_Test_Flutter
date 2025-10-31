import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:flutter/material.dart';

class InfoDialogWidget extends StatefulWidget {
  final VoidCallback onClaim;

  const InfoDialogWidget({required this.onClaim});

  @override
  State<InfoDialogWidget> createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialogWidget>
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
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: AdaptiveSizes.getInfoDialogMaxWidth(),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: AdaptiveSizes.getLogoSize(),
                    ),
                  ),
                  SizedBox(height: AdaptiveSizes.h(0.01026)),
                  Text(
                    "sorry".tr(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AdaptiveSizes.h(0.00513)),
                  Text(
                    "next_time".tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: AdaptiveSizes.h(0.01539)),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onClaim,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'okay'.tr(),
                        style: TextStyle(
                          fontSize: AdaptiveSizes.getFontInfoSize(),
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
      ),
    );
  }
}
