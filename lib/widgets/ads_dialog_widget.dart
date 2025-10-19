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
    return Center(
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 650,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orangeAccent.shade100,
                  Colors.pinkAccent.shade100,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.pinkAccent.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 40),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        'assets/images/site.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 300,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Играйте из дома!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.pacifico(
                        fontSize: 52,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepOrange.shade900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Примите возможность поучаствовать в новом проекте! "
                      "Играйте в любимые игры прямо из дома — "
                      "в реальном времени, как на настоящем игровом автомате!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        color: Colors.brown.shade800,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 40),
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
            "Попробовать",
            style: GoogleFonts.poppins(
              fontSize: 38,
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
