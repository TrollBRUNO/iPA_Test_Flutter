import 'package:flutter/material.dart';

class DragDropUploader extends StatelessWidget {
  final Function(String imageUrl) onUploaded;

  const DragDropUploader({super.key, required this.onUploaded});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white54),
      ),
      child: const Text(
        "Загрузка изображений доступна только в Web",
        style: TextStyle(color: Colors.white70),
      ),
    );
  }
}
