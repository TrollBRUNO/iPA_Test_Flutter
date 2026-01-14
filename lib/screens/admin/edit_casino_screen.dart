import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:first_app_flutter/screens/admin/jackpot_viewer_screen.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditCasinoScreen extends StatelessWidget {
  const EditCasinoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EditCasinoPage(title: 'Edit Casino');
  }
}

class EditCasinoPage extends StatefulWidget {
  const EditCasinoPage({super.key, required this.title});
  final String title;

  @override
  State<EditCasinoPage> createState() => _EditCasinoState();
}

class _EditCasinoState extends State<EditCasinoPage> {
  List<dynamic> casino = [];
  bool isLoading = false;

  static const String _baseUrl = 'https://magicity.top';

  @override
  void initState() {
    super.initState();
    loadCasino();
  }

  Future<void> loadCasino() async {
    setState(() => isLoading = true);
    try {
      final res = await AuthService.dio.get("$_baseUrl/casino");
      casino = res.data;
    } catch (_) {}

    setState(() => isLoading = false);
  }

  Future<void> deleteCasino(String id) async {
    try {
      await AuthService.dio.delete("$_baseUrl/casino/$id");
      await loadCasino();
    } catch (e) {
      print("Delete error: $e");
    }
  }

  Future<void> editOrCreateCasino({Map? item}) async {
    final cityController = TextEditingController(text: item?["city"] ?? "");
    final addressController = TextEditingController(
      text: item?["address"] ?? "",
    );
    final jackpotController = TextEditingController(
      text: item?["jackpot_url"] ?? "",
    );
    final imgController = TextEditingController(
      text: item?["image_url"] != null
          ? item!["image_url"].toString().split('/').last
          : "",
    );
    bool mysteryProgressive = item?["mystery_progressive"] ?? true;

    final uuIdListController = TextEditingController(
      text: item?["uu_id_list"] != null
          ? (item!["uu_id_list"] as List).join(", ")
          : "",
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text(
            item == null ? "Add Casino" : "Edit Casino",
            style: const TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: cityController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "City",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                TextField(
                  controller: addressController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Address",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                TextField(
                  controller: imgController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Image filename",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                TextField(
                  controller: jackpotController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Jackpot URL",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      "Mystery Progressive",
                      style: TextStyle(color: Colors.white70),
                    ),
                    Checkbox(
                      value: mysteryProgressive,
                      onChanged: (val) {
                        setState(() {
                          mysteryProgressive = val ?? false;
                        });
                      },
                    ),
                  ],
                ),
                TextField(
                  controller: uuIdListController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Camera IDs",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final body = {
                  "city": cityController.text,
                  "address": addressController.text,
                  "mystery_progressive": mysteryProgressive,
                  "jackpot_url": jackpotController.text,
                  "image_url": imgController.text,
                  "uu_id_list": uuIdListController.text
                      .split(",")
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList(),
                };

                try {
                  if (item == null) {
                    await AuthService.dio.post(
                      "$_baseUrl/casino/json",
                      data: jsonEncode(body),
                      options: Options(
                        headers: {"Content-Type": "application/json"},
                      ),
                    );
                  } else {
                    await AuthService.dio.put(
                      "$_baseUrl/casino/${item["_id"]}",
                      data: jsonEncode(body),
                      options: Options(
                        headers: {"Content-Type": "application/json"},
                      ),
                    );
                  }
                } catch (e) {
                  print("Save error: $e");
                }

                Navigator.pop(context);
                await loadCasino();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AdaptiveSizes.init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.orangeAccent[200],
        actions: [
          TextButton(
            onPressed: () => editOrCreateCasino(),
            child: Text(
              "Add New",
              style: TextStyle(
                color: Colors.orangeAccent[200],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingTextStyle: const TextStyle(color: Colors.white),
                dataTextStyle: const TextStyle(color: Colors.white70),
                columns: const [
                  DataColumn(label: Text("Image")),
                  DataColumn(label: Text("City")),
                  DataColumn(label: Text("Address")),
                  DataColumn(label: Text("Jackpot URL")),
                  DataColumn(label: Text("Mystery Progressive")),
                  DataColumn(label: Text("Camera ID's")),
                  DataColumn(label: Text("Actions")),
                ],
                rows: [
                  for (var item in casino)
                    DataRow(
                      cells: [
                        DataCell(
                          item["image_url"] != null
                              ? Image.network(
                                  "$_baseUrl${item["image_url"]}",
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.broken_image,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.image, color: Colors.white),
                        ),
                        DataCell(Text(item["city"] ?? "")),
                        DataCell(Text(item["address"] ?? "")),
                        DataCell(Text(item["jackpot_url"] ?? "")),
                        DataCell(
                          Text(
                            (item["mystery_progressive"] ?? false)
                                ? "Yes"
                                : "No",
                          ),
                        ),
                        DataCell(
                          Text(
                            item["uu_id_list"] != null
                                ? (item["uu_id_list"] as List).join(", ")
                                : "",
                          ),
                        ),

                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => editOrCreateCasino(item: item),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => deleteCasino(item["_id"]),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.orange,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => JackpotViewerScreen(
                                        id: item["_id"],
                                        url: item["jackpot_url"],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
    );
  }
}
