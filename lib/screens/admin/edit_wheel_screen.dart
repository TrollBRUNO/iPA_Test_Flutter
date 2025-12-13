import 'dart:convert';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditWheelScreen extends StatelessWidget {
  const EditWheelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EditWheelPage(title: 'Edit Wheel');
  }
}

class EditWheelPage extends StatefulWidget {
  const EditWheelPage({super.key, required this.title});
  final String title;

  @override
  State<EditWheelPage> createState() => _EditWheelState();
}

class _EditWheelState extends State<EditWheelPage> {
  List<dynamic> wheel = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadWheel();
  }

  Future<void> loadWheel() async {
    setState(() => isLoading = true);
    final res = await http.get(Uri.parse("http://192.168.33.187:3000/wheel"));
    if (res.statusCode == 200) {
      wheel = jsonDecode(res.body);
    }
    setState(() => isLoading = false);
  }

  Future<void> deleteWheel(String id) async {
    await http.delete(Uri.parse("http://192.168.33.187:3000/wheel/$id"));
    await loadWheel();
  }

  Future<void> editOrCreateWheel({Map? item}) async {
    final valueController = TextEditingController(
      text: item?["value"]?.toString() ?? "",
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text(
            item == null ? "Add New Wheel" : "Edit Wheel",
            style: const TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: valueController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Value",
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
                final intValue = int.tryParse(valueController.text);

                if (intValue == null) {
                  return;
                }

                final body = jsonEncode({"value": intValue});

                if (item == null) {
                  await http.post(
                    Uri.parse("http://192.168.33.187:3000/wheel/json"),
                    headers: {"Content-Type": "application/json"},
                    body: body,
                  );
                } else {
                  await http.put(
                    Uri.parse(
                      "http://192.168.33.187:3000/wheel/${item["_id"]}",
                    ),
                    headers: {"Content-Type": "application/json"},
                    body: body,
                  );
                }

                Navigator.pop(context);
                await loadWheel();
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
            onPressed: () => editOrCreateWheel(),
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
                  DataColumn(label: Text("Value")),
                  DataColumn(label: Text("Actions")),
                ],
                rows: [
                  for (var item in wheel)
                    DataRow(
                      cells: [
                        DataCell(Text(item["value"].toString())),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => editOrCreateWheel(item: item),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => deleteWheel(item["_id"]),
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
