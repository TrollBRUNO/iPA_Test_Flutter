import 'package:flutter/material.dart';

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
    final isBigWin = widget.prize == '100 BGN';

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 320,
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
                      isBigWin ? Icons.star : Icons.attach_money,
                      color: isBigWin ? Colors.amber : Colors.green,
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isBigWin ? "Большой выигрыш!" : "Поздравляем!",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Вы выиграли ${widget.prize}",
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
                      child: const Text("Забрать"),
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
