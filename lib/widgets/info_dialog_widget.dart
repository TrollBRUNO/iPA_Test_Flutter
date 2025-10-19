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
          width: 480,
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
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Извините!",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Следующий бонус будет доступен завтра.",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 24),
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
                      child: const Text("Окей"),
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
