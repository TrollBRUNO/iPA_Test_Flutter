import 'dart:html' as html;
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DragDropUploader extends StatefulWidget {
  final Function(String imageUrl) onUploaded;

  const DragDropUploader({super.key, required this.onUploaded});

  @override
  State<DragDropUploader> createState() => _DragDropUploaderState();
}

class _DragDropUploaderState extends State<DragDropUploader> {
  Uint8List? previewBytes;
  String? previewUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white54, width: 2),
          color: Colors.black26,
        ),
        child: previewBytes != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(previewBytes!, fit: BoxFit.cover),
              )
            : const Center(
                child: Text(
                  "Drag & Drop Image Here\nor Click to Select",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
      ),
    );
  }

  Future<void> _pickFile() async {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) async {
      final file = uploadInput.files!.first;
      final reader = html.FileReader();

      reader.readAsArrayBuffer(file);

      reader.onLoadEnd.listen((event) async {
        final bytes = reader.result as Uint8List;

        setState(() => previewBytes = bytes);

        await _uploadFile(file.name, bytes);
      });
    });
  }

  Future<void> _uploadFile(String filename, Uint8List bytes) async {
    try {
      final formData = FormData.fromMap({
        "image": MultipartFile.fromBytes(bytes, filename: filename),
      });

      final res = await AuthService.dio.post(
        "https://magicity.top/news/upload",
        data: formData,
      );
      final imageUrl = res.data["image_url"];

      widget.onUploaded(imageUrl);
    } catch (e) {
      print("Upload error: $e");
    }
  }
}
