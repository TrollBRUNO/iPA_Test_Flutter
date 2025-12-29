import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/class/bonus_code.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:flutter/material.dart';

class CodeBonusProfileDialogWidget extends StatefulWidget {
  final BonusCodeResponse data;
  final VoidCallback onClose;

  const CodeBonusProfileDialogWidget({
    required this.data,
    required this.onClose,
    super.key,
  });

  @override
  State<CodeBonusProfileDialogWidget> createState() =>
      _CodeBonusProfileDialogState();
}

class _CodeBonusProfileDialogState extends State<CodeBonusProfileDialogWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  late Duration _serverOffset;
  late Duration _remaining;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();

    _serverOffset = DateTime.now().difference(widget.data.serverTime);

    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final serverNow = DateTime.now().subtract(_serverOffset);
    final diff = widget.data.expiresAt.difference(serverNow);

    if (diff.isNegative) {
      _timer.cancel();
      widget.onClose();
      return;
    }

    setState(() => _remaining = diff);
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Container(
            width: AdaptiveSizes.getInfoDialogMaxWidth(),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF4CAF50), // основной оранжевый
                  Color(0xFFFFA726), // чуть темнее
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orangeAccent.withOpacity(0.5),
                  blurRadius: 30,
                ),
                BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Заголовок
                    Text(
                      'Покажите этот код кассиру\nдля взятия бонуса',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.85),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// Код
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
                        ),
                      ),
                      child: Text(
                        widget.data.code.replaceAllMapped(
                          RegExp(r'.{3}'),
                          (m) => '${m.group(0)} ',
                        ),
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Таймер
                    Text(
                      'Код действителен: ${_format(_remaining)}',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// Дисклеймер
                    Text(
                      'Чтобы забрать бонус, нужно добавить карту в аккаунт.\n'
                      'Если у вас нет карты — её можно бесплатно получить у кассира.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),

                /// Кнопка закрытия
                Positioned(
                  right: -6,
                  top: -6,
                  child: IconButton(
                    onPressed: widget.onClose,
                    icon: const Icon(Icons.close),
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
