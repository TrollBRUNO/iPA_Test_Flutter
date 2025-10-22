import 'package:confetti/confetti.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrizeDialogWidget extends StatefulWidget {
  final String prize;
  final VoidCallback onClaim;

  const PrizeDialogWidget({required this.prize, required this.onClaim});

  @override
  State<PrizeDialogWidget> createState() => _PrizeDialogState();
}

class _PrizeDialogState extends State<PrizeDialogWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.ease);
    _controller.forward();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 12),
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBigWin = widget.prize == '100 BGN';

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 🎉 Конфетти поверх всего
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: isBigWin ? 140 : 100,
              gravity: 0.1,
              colors: const [
                Colors.yellow,
                Colors.orange,
                Colors.white,
                Colors.greenAccent,
                Colors.pinkAccent,
              ],
            ),

            // Основной контейнер с тенью
            Container(
              width: isBigWin ? 600 : 480,
              height: isBigWin ? 500 : 320,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isBigWin
                      ? [
                          Colors.orangeAccent.shade200,
                          Colors.deepOrangeAccent.shade200,
                        ]
                      : [
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
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleTransition(
                        scale: _scaleAnim,
                        child: Icon(
                          isBigWin ? Icons.star : Icons.attach_money,
                          color: isBigWin
                              ? Colors.yellow[100]
                              : Colors.green[400],
                          size: 80,
                        ),
                      ),
                      const SizedBox(height: 16),
                      isBigWin
                          ? const Text(
                              "BIG WIN",
                              style: TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.w800,
                                shadows: [
                                  Shadow(
                                    color: Colors.black38,
                                    blurRadius: 6,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            )
                          : Text(
                              "congratulate".tr(),
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
                      SizedBox(height: isBigWin ? 24 : 8),
                      Text(
                        "${"you_win".tr()} ${widget.prize}",
                        style: TextStyle(
                          fontSize: isBigWin ? 52 : 28,
                          fontStyle: isBigWin
                              ? FontStyle.italic
                              : FontStyle.normal,
                          fontWeight: isBigWin
                              ? FontWeight.w500
                              : FontWeight.w400,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 3,
                              offset: const Offset(1, 2),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isBigWin ? 72 : 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: widget.onClaim,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isBigWin
                                ? Colors.orangeAccent[100]
                                : Colors.green[200],
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'take_it'.tr(),
                            style: TextStyle(
                              fontSize: isBigWin ? 40 : 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
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

  Widget _buildButton() {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
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
            'take_it'.tr(),
            style: TextStyle(
              fontSize: 40,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
