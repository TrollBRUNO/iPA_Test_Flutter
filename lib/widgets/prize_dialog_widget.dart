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
          width: isBigWin ? 600 : 480,
          height: isBigWin ? 500 : 320,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isBigWin ? Colors.orangeAccent[200] : Colors.white,
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
                      color: isBigWin ? Colors.yellow[100] : Colors.green[400],
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 16),
                  isBigWin
                      ? Text(
                          "BIG WIN",
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w800,
                          ),
                        )
                      : Text(
                          //isBigWin ? "Большой выигрыш!" : "Поздравляем!",
                          "Поздравляем!",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  isBigWin ? SizedBox(height: 24) : SizedBox(height: 8),
                  Text(
                    "Вы выиграли ${widget.prize}",
                    style: isBigWin
                        ? const TextStyle(
                            fontSize: 48,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          )
                        : const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                          ),
                  ),
                  isBigWin ? SizedBox(height: 72) : SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onClaim,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isBigWin
                            ? Colors.orangeAccent[100]
                            : Colors.green[200],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Забрать",
                        style: isBigWin
                            ? const TextStyle(fontSize: 40, color: Colors.black)
                            : const TextStyle(
                                fontSize: 24,
                                color: Colors.black,
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
