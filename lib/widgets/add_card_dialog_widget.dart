import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/services/auth_service.dart';

class AddCardDialogWidget extends StatefulWidget {
  const AddCardDialogWidget({Key? key}) : super(key: key);

  @override
  State<AddCardDialogWidget> createState() => _AddCardDialogWidgetState();

  static Future<Map<String, String>?> show(BuildContext context) {
    return showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AddCardDialogWidget(),
    );
  }
}

class _AddCardDialogWidgetState extends State<AddCardDialogWidget> {
  late TextEditingController _cardController;
  String? _cardError;
  bool _loading = false;
  List<String> _cities = [];
  String? _selectedCity;

  void showError(String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  @override
  void initState() {
    super.initState();
    _cardController = TextEditingController();
    _loadCities();
  }

  Future<void> _loadCities() async {
    final cities = await AuthService.loadCities();
    setState(() {
      _cities = cities;
      _selectedCity = cities.isNotEmpty ? cities.first : null;
    });
  }

  bool _isValidLocal(String value) {
    return RegExp(r'^[A-Z]{2}-\d{6}$').hasMatch(value);
  }

  Future<void> _submit() async {
    final cardId = _cardController.text.trim();

    if (!_isValidLocal(cardId)) {
      setState(() {
        _cardError = 'wrong_card_format'.tr();
      });
      showError('wrong_card_format'.tr());
      return;
    }

    setState(() => _loading = true);
    final error = await AuthService.checkCard(cardId);
    setState(() => _loading = false);

    if (error == 'card_already_used') {
      setState(() {
        _cardError = 'card_already_used'.tr();
      });
      showError('card_already_used'.tr());
      return;
    }

    Navigator.pop(context, {'card_id': cardId, 'city': _selectedCity!});
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('have_card').tr(),
      content: _cities.isEmpty
          ? const SizedBox(
              height: 80,
              child: Center(child: CircularProgressIndicator()),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _cardController,
                  maxLength: 9,
                  decoration: InputDecoration(
                    labelText: 'card_id'.tr(),
                    errorText: _cardError,
                    counterText: '',
                  ),
                  onChanged: (_) {
                    if (_cardError != null) {
                      setState(() => _cardError = null);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedCity,
                  items: _cities
                      .map(
                        (city) =>
                            DropdownMenuItem(value: city, child: Text(city)),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedCity = v),
                  decoration: InputDecoration(labelText: 'city'.tr()),
                ),
              ],
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('no').tr(),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('yes').tr(),
        ),
      ],
    );
  }
}
