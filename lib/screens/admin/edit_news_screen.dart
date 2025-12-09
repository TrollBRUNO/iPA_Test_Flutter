import 'dart:convert';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditNewsScreen extends StatelessWidget {
  const EditNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EditNewsPage(title: 'Edit News');
  }
}

class EditNewsPage extends StatefulWidget {
  const EditNewsPage({super.key, required this.title});
  final String title;

  @override
  State<EditNewsPage> createState() => _EditNewsState();
}

class _EditNewsState extends State<EditNewsPage> {
  List<dynamic> news = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadNews();
  }

  Future<void> loadNews() async {
    setState(() => isLoading = true);
    final res = await http.get(Uri.parse("http://192.168.33.187:3000/news"));
    if (res.statusCode == 200) {
      news = jsonDecode(res.body);
    }
    setState(() => isLoading = false);
  }

  Future<void> deleteNews(String id) async {
    await http.delete(Uri.parse("http://192.168.33.187:3000/news/$id"));
    await loadNews();
  }

  Future<void> editOrCreateNews({Map? item}) async {
    final titleController = TextEditingController(text: item?["title"] ?? "");
    final descController = TextEditingController(
      text: item?["description"] ?? "",
    );
    final imgController = TextEditingController(
      text: item?["image_url"] != null
          ? item!["image_url"].toString().split('/').last
          : "",
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text(
            item == null ? "Add News" : "Edit News",
            style: const TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Title",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                TextField(
                  controller: descController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Description",
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
                final body = jsonEncode({
                  "title": titleController.text,
                  "description": descController.text,
                  "image_url": imgController.text,
                });

                if (item == null) {
                  await http.post(
                    Uri.parse("http://192.168.33.187:3000/news/json"),
                    headers: {"Content-Type": "application/json"},
                    body: body,
                  );
                } else {
                  await http.put(
                    Uri.parse("http://192.168.33.187:3000/news/${item["_id"]}"),
                    headers: {"Content-Type": "application/json"},
                    body: body,
                  );
                }

                Navigator.pop(context);
                await loadNews();
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
            onPressed: () => editOrCreateNews(),
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
                  DataColumn(label: Text("Title")),
                  DataColumn(label: Text("Description")),
                  DataColumn(label: Text("Actions")),
                ],
                rows: [
                  for (var item in news)
                    DataRow(
                      cells: [
                        // ==== IMAGE PREVIEW ====
                        DataCell(
                          item["image_url"] != null
                              ? Image.network(
                                  "http://192.168.33.187:3000${item["image_url"]}",
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

                        DataCell(Text(item["title"] ?? "")),
                        DataCell(Text(item["description"] ?? "")),

                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => editOrCreateNews(item: item),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => deleteNews(item["_id"]),
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
