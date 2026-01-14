import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditSupportScreen extends StatelessWidget {
  const EditSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EditSupportPage(title: 'Edit Support');
  }
}

class EditSupportPage extends StatefulWidget {
  const EditSupportPage({super.key, required this.title});
  final String title;

  @override
  State<EditSupportPage> createState() => _EditSupportState();
}

class _EditSupportState extends State<EditSupportPage> {
  List<dynamic> support = [];
  bool isLoading = false;

  static const String _baseUrl = 'https://magicity.top';

  @override
  void initState() {
    super.initState();
    loadSupport();
  }

  Future<void> loadSupport() async {
    setState(() => isLoading = true);
    try {
      final res = await AuthService.dio.get("$_baseUrl/support");
      support = res.data;
    } catch (_) {}

    setState(() => isLoading = false);
  }

  Future<void> deleteSupport(String id) async {
    try {
      await AuthService.dio.delete("$_baseUrl/support/$id");
      await loadSupport();
    } catch (e) {
      print("Delete error: $e");
    }
  }

  Future<void> editOrCreateSupport({Map? item}) async {
    final descriptionController = TextEditingController(
      text: item?["description_problem"] ?? "",
    );

    final userIdController = TextEditingController(
      text: item?["user_id"] ?? "",
    );

    String status = item?["status"] ?? "open";

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text(
            item == null ? "Add Support Ticket" : "Edit Support Ticket",
            style: const TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Problem Description",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: userIdController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "User ID",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: status,
                  dropdownColor: Colors.black87,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Status",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                  items: const [
                    DropdownMenuItem(value: "open", child: Text("Open")),
                    DropdownMenuItem(value: "pending", child: Text("Pending")),
                    DropdownMenuItem(value: "closed", child: Text("Closed")),
                  ],
                  onChanged: (v) => status = v!,
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
                  "description_problem": descriptionController.text,
                  "user_id": userIdController.text,
                  "status": status,
                };

                try {
                  if (item == null) {
                    await AuthService.dio.post(
                      "$_baseUrl/support/json",
                      data: jsonEncode(body),
                      options: Options(
                        headers: {"Content-Type": "application/json"},
                      ),
                    );
                  } else {
                    await AuthService.dio.put(
                      "$_baseUrl/support/${item["_id"]}",
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
                await loadSupport();
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
        backgroundColor: Color(0xFF121212),
        foregroundColor: Colors.orangeAccent[200],
        actions: [
          TextButton(
            onPressed: () => editOrCreateSupport(),
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
              scrollDirection: Axis.vertical,
              child: DataTable(
                headingTextStyle: const TextStyle(color: Colors.white),
                dataTextStyle: const TextStyle(color: Colors.white70),
                columns: const [
                  DataColumn(label: Text("Description")),
                  DataColumn(label: Text("User ID")),
                  DataColumn(label: Text("Status")),
                  DataColumn(label: Text("Actions")),
                ],
                rows: [
                  for (var item in support)
                    DataRow(
                      cells: [
                        DataCell(Text(item["description_problem"] ?? "")),
                        DataCell(Text(item["user_id"] ?? "")),
                        DataCell(Text(item["status"] ?? "")),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () =>
                                    editOrCreateSupport(item: item),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => deleteSupport(item["_id"]),
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
