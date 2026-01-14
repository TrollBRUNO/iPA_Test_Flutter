import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';

class EditAccountsScreen extends StatelessWidget {
  const EditAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EditAccountsPage(title: 'Accounts Admin');
  }
}

class EditAccountsPage extends StatefulWidget {
  const EditAccountsPage({super.key, required this.title});
  final String title;

  @override
  State<EditAccountsPage> createState() => _EditAccountsState();
}

class _EditAccountsState extends State<EditAccountsPage> {
  List<dynamic> accounts = [];
  bool isLoading = false;

  String searchQuery = "";
  String sortField = "login";
  String sortDirection = "asc";

  static const String _baseUrl = 'https://magicity.top';

  @override
  void initState() {
    super.initState();
    loadAccounts();
  }

  Future<void> loadAccounts() async {
    setState(() => isLoading = true);

    try {
      Response res;

      if (searchQuery.isNotEmpty) {
        res = await AuthService.dio.get(
          "$_baseUrl/account/search/$searchQuery",
        );
      } else {
        res = await AuthService.dio.get(
          "$_baseUrl/account/sort/$sortField/$sortDirection",
        );
      }

      accounts = res.data;
    } catch (e) {
      print("Load error: $e");
    }

    setState(() => isLoading = false);
  }

  // ----------------------------------------------------------
  // RESET PASSWORD
  // ----------------------------------------------------------
  Future<void> resetPassword(String id) async {
    try {
      final res = await AuthService.dio.post(
        "$_baseUrl/account/$id/reset-password",
      );
      final tempPass = res.data["temp_password"];

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            "Temporary Password",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            "New password: $tempPass",
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Reset error: $e");
    }
  }

  // ----------------------------------------------------------
  // VIEW & EDIT CARDS
  // ----------------------------------------------------------
  Future<void> showCards(Map acc) async {
    final accountId = acc["id"];

    List cards = acc["cards"] ?? [];

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text(
            "Cards of ${acc["login"]}",
            style: const TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var card in cards)
                  ListTile(
                    title: Text(
                      "${card["card_id"]} (${card["city"]})",
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      card["active"] ? "Active" : "Inactive",
                      style: TextStyle(
                        color: card["active"] ? Colors.green : Colors.red,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => editCard(accountId, card),
                        ),
                        if (card["active"])
                          IconButton(
                            icon: const Icon(Icons.block, color: Colors.orange),
                            onPressed: () =>
                                deactivateCard(accountId, card["card_id"]),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => addCard(accountId),
                  child: const Text("Add Card"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> addCard(String accountId) async {
    final cardId = TextEditingController();
    final city = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Add Card", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_field("Card ID", cardId), _field("City", city)],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await AuthService.dio.post(
                  "$_baseUrl/account/bind-card",
                  data: {"card_id": cardId.text, "city": city.text},
                );
                Navigator.pop(context);
                await loadAccounts();
              } catch (e) {
                print("Add card error: $e");
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> editCard(String accountId, Map card) async {
    final cardId = TextEditingController(text: card["card_id"]);
    final city = TextEditingController(text: card["city"]);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Edit Card", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_field("Card ID", cardId), _field("City", city)],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await AuthService.dio.put(
                  "$_baseUrl/account/$accountId/cards/${card["card_id"]}",
                  data: {"card_id": cardId.text, "city": city.text},
                );
                Navigator.pop(context);
                await loadAccounts();
              } catch (e) {
                print("Edit card error: $e");
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> deactivateCard(String accountId, String cardId) async {
    try {
      await AuthService.dio.patch("$_baseUrl/account/cards/$cardId/deactivate");
      await loadAccounts();
    } catch (e) {
      print("Deactivate error: $e");
    }
  }

  // ----------------------------------------------------------
  // CREATE / EDIT ACCOUNT
  // ----------------------------------------------------------
  Future<void> editOrCreateAccount({Map? item}) async {
    final loginController = TextEditingController(text: item?["login"] ?? "");
    final realnameController = TextEditingController(
      text: item?["realname"] ?? "",
    );
    final balanceController = TextEditingController(
      text: item?["balance"] ?? "0",
    );
    final bonusBalanceController = TextEditingController(
      text: item?["bonus_balance"] ?? "0",
    );
    final fakeBalanceController = TextEditingController(
      text: item?["fake_balance"] ?? "0",
    );
    final imageController = TextEditingController(
      text: item?["image_url"]?.toString().split('/').last ?? "",
    );

    bool isBlocked = item?["is_blocked"] ?? false;
    final blockReasonController = TextEditingController(
      text: item?["block_reason"] ?? "",
    );

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text(
            item == null ? "Create Account" : "Edit Account",
            style: const TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _field("Login", loginController),
                  _field("Real Name", realnameController),
                  _field("Balance", balanceController),
                  _field("Bonus Balance", bonusBalanceController),
                  _field("Fake Balance", fakeBalanceController),
                  _field("Image filename", imageController),

                  Row(
                    children: [
                      Checkbox(
                        value: isBlocked,
                        onChanged: (v) => setState(() => isBlocked = v!),
                      ),
                      const Text(
                        "Blocked",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  if (isBlocked) _field("Block Reason", blockReasonController),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final body = {
                  "login": loginController.text,
                  "realname": realnameController.text,
                  "balance": balanceController.text,
                  "bonus_balance": bonusBalanceController.text,
                  "fake_balance": fakeBalanceController.text,
                  "image_url": imageController.text,
                  "is_blocked": isBlocked,
                  "block_reason": blockReasonController.text,
                };

                try {
                  if (item == null) {
                    await AuthService.dio.post(
                      "$_baseUrl/account/json",
                      data: jsonEncode(body),
                    );
                  } else {
                    await AuthService.dio.put(
                      "$_baseUrl/account/${item["id"]}",
                      data: jsonEncode(body),
                    );
                  }
                } catch (e) {
                  print("Save error: $e");
                }

                Navigator.pop(context);
                await loadAccounts();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // ----------------------------------------------------------
  // UI HELPERS
  // ----------------------------------------------------------
  Widget _field(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  void toggleSort(String field) {
    if (sortField == field) {
      sortDirection = sortDirection == "asc" ? "desc" : "asc";
    } else {
      sortField = field;
      sortDirection = "asc";
    }
    loadAccounts();
  }

  // ----------------------------------------------------------
  // MAIN UI
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.orangeAccent[200],
        title: SizedBox(
          width: 300,
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Search...",
              hintStyle: TextStyle(color: Colors.white54),
            ),
            onChanged: (v) {
              searchQuery = v;
              loadAccounts();
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => editOrCreateAccount(),
            child: Text(
              "Create Account",
              style: TextStyle(color: Colors.orangeAccent[200], fontSize: 18),
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
                columns: [
                  DataColumn(
                    label: Row(
                      children: [
                        const Text("Login"),
                        IconButton(
                          icon: const Icon(
                            Icons.swap_vert,
                            color: Colors.white,
                          ),
                          onPressed: () => toggleSort("login"),
                        ),
                      ],
                    ),
                  ),
                  DataColumn(label: const Text("Realname")),
                  DataColumn(label: const Text("Image")),
                  DataColumn(label: const Text("Balance")),
                  DataColumn(label: const Text("Bonus")),
                  DataColumn(label: const Text("Fake")),
                  DataColumn(label: const Text("Blocked")),
                  const DataColumn(label: Text("Cards")),
                  const DataColumn(label: Text("Actions")),
                ],
                rows: [
                  for (var acc in accounts)
                    DataRow(
                      cells: [
                        DataCell(Text(acc["login"])),
                        DataCell(Text(acc["realname"])),
                        DataCell(
                          acc["image_url"] != null
                              ? Image.network(
                                  "$_baseUrl${acc["image_url"]}",
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
                        DataCell(Text(acc["balance"].toString())),
                        DataCell(Text(acc["bonus_balance"].toString())),
                        DataCell(Text(acc["fake_balance"].toString())),
                        DataCell(Text(acc["is_blocked"] ? "Yes" : "No")),

                        DataCell(
                          IconButton(
                            icon: const Icon(
                              Icons.credit_card,
                              color: Colors.green,
                            ),
                            onPressed: () => showCards(acc),
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
                                onPressed: () => editOrCreateAccount(item: acc),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.lock_reset,
                                  color: Colors.orange,
                                ),
                                onPressed: () => resetPassword(acc["id"]),
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
