import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:first_app_flutter/screens/admin/drag_drop_uploader.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:flutter/material.dart';

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

  static const String _baseUrl = 'https://magicity.top';

  @override
  void initState() {
    super.initState();
    loadNews();
  }

  Future<void> loadNews() async {
    setState(() => isLoading = true);

    try {
      final res = await AuthService.dio.get("$_baseUrl/news");
      news = res.data;
    } catch (_) {}

    setState(() => isLoading = false);
  }

  Future<void> deleteNews(String id) async {
    try {
      await AuthService.dio.delete("$_baseUrl/news/$id");
      await loadNews();
    } catch (e) {
      print("Delete error: $e");
    }
  }

  Future<void> editOrCreateNews({Map? item}) async {
    String? uploadedImageUrl;

    // --- Контроллеры для мультиязычных полей ---
    final titleEn = TextEditingController(text: item?["title"]?["en"] ?? "");
    final titleRu = TextEditingController(text: item?["title"]?["ru"] ?? "");
    final titleBg = TextEditingController(text: item?["title"]?["bg"] ?? "");

    final descEn = TextEditingController(
      text: item?["description"]?["en"] ?? "",
    );
    final descRu = TextEditingController(
      text: item?["description"]?["ru"] ?? "",
    );
    final descBg = TextEditingController(
      text: item?["description"]?["bg"] ?? "",
    );

    final imgController = TextEditingController(
      text: item?["image_url"] != null
          ? item!["image_url"].toString().split('/').last
          : "",
    );

    int tabIndex = 0;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              title: Text(
                item == null ? "Add News" : "Edit News",
                style: const TextStyle(color: Colors.white),
              ),
              content: SizedBox(
                width: 450,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --- Переключатель языков ---
                    DefaultTabController(
                      length: 3,
                      initialIndex: tabIndex,
                      child: Column(
                        children: [
                          TabBar(
                            onTap: (i) => setStateDialog(() => tabIndex = i),
                            indicatorColor: Colors.orangeAccent,
                            labelColor: Colors.orangeAccent,
                            unselectedLabelColor: Colors.white70,
                            tabs: const [
                              Tab(text: "EN"),
                              Tab(text: "RU"),
                              Tab(text: "BG"),
                            ],
                          ),
                          SizedBox(
                            height: 260,
                            child: TabBarView(
                              children: [
                                _langEditor(titleEn, descEn),
                                _langEditor(titleRu, descRu),
                                _langEditor(titleBg, descBg),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    DragDropUploader(
                      onUploaded: (url) {
                        uploadedImageUrl = url;
                        imgController.text = url.split('/').last;
                        imgController.selection = TextSelection.collapsed(
                          offset: imgController.text.length,
                        );
                      },
                    ),

                    if ((uploadedImageUrl ?? imgController.text).isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Image.network(
                          "$_baseUrl/uploads/${uploadedImageUrl ?? imgController.text}",
                          height: 120,
                          errorBuilder: (_, __, ___) => const Text(
                            "Файл не найден",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ),

                    SizedBox(height: 20),

                    TextField(
                      controller: imgController,
                      onChanged: (_) => setStateDialog(() {}),
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
                    final body = {
                      "title": {
                        "en": titleEn.text,
                        "ru": titleRu.text,
                        "bg": titleBg.text,
                      },
                      "description": {
                        "en": descEn.text,
                        "ru": descRu.text,
                        "bg": descBg.text,
                      },
                      "image_url": uploadedImageUrl ?? imgController.text,
                    };

                    try {
                      if (item == null) {
                        await AuthService.dio.post(
                          "$_baseUrl/news/json",
                          data: jsonEncode(body),
                          options: Options(
                            headers: {"Content-Type": "application/json"},
                          ),
                        );
                      } else {
                        await AuthService.dio.put(
                          "$_baseUrl/news/${item["_id"]}",
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
                    await loadNews();
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _langEditor(TextEditingController title, TextEditingController desc) {
    return Column(
      children: [
        TextField(
          controller: title,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: "Title",
            labelStyle: TextStyle(color: Colors.white70),
          ),
        ),
        TextField(
          controller: desc,
          maxLines: 5,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: "Description",
            labelStyle: TextStyle(color: Colors.white70),
          ),
        ),
      ],
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
                  DataColumn(label: Text("Title (EN)")),
                  DataColumn(label: Text("Description (EN)")),
                  DataColumn(label: Text("Actions")),
                ],
                rows: [
                  for (var item in news)
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
                        DataCell(Text(item["title"]?["en"] ?? "")),
                        DataCell(Text(item["description"]?["en"] ?? "")),
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
