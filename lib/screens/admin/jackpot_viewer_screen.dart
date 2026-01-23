import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class JackpotViewerScreen extends StatefulWidget {
  final String id;
  final String url;

  const JackpotViewerScreen({super.key, required this.id, required this.url});

  @override
  State<JackpotViewerScreen> createState() => _JackpotViewerScreenState();
}

class _JackpotViewerScreenState extends State<JackpotViewerScreen> {
  Map<String, dynamic>? data;
  bool error = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    // refresh every second
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1));
      if (!mounted) return false;
      await _loadData();
      return true;
    });
  }

  Future<void> _loadData() async {
    try {
      final res = await http.get(
        Uri.parse("https://magicity.top/casino/${widget.id}/jackpots"),
      );

      if (res.statusCode == 200) {
        setState(() {
          data = jsonDecode(res.body);
          error = false;
        });
      } else {
        setState(() => error = true);
      }
    } catch (e) {
      setState(() => error = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Live Jackpot Viewer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // URL отображение
            Text(
              "URL: ${widget.url}",
              style: TextStyle(color: Colors.orangeAccent, fontSize: 16),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: error
                    ? const Text(
                        "ERROR loading JSON",
                        style: TextStyle(color: Colors.redAccent),
                      )
                    : data == null
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Text(
                          const JsonEncoder.withIndent("  ").convert(data),
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontFamily: "monospace",
                            fontSize: 14,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
