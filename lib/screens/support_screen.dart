import 'package:another_flushbar/flushbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SupportPage(title: 'Support');
  }
}

class SupportPage extends StatefulWidget {
  const SupportPage({super.key, required this.title});

  final String title;

  @override
  State<SupportPage> createState() => _SupportState();
}

class _SupportState extends State<SupportPage> {
  Logger logger = Logger();
  final _formKey = GlobalKey<FormState>();
  final _appealController = TextEditingController();
  final _appealFocus = FocusNode();
  static const String _appeal = 'appeal';
  String? serverError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            // Верхняя панель со стрелкой и заголовком
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.orangeAccent[200],
                      size: 30,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Основное содержимое по центру
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'support'.tr(),
                        style: GoogleFonts.daysOne(
                          fontSize: 34,
                          fontWeight: FontWeight.w100,
                          fontStyle: FontStyle.italic,
                          color: Colors.orangeAccent[200],
                          shadows: const [
                            Shadow(
                              color: Color.fromARGB(255, 51, 51, 51),
                              offset: Offset(3.5, 4.5),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                      // Пояснительный текст
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'welcome_support'.tr(),
                          style: GoogleFonts.openSans(
                            fontSize: 18,
                            color: Colors.white70,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),

                      const SizedBox(height: 50),

                      // Поле ввода
                      Form(
                        key: _formKey,
                        child: SizedBox(
                          width: 650,
                          child: TextFormField(
                            key: const Key('appeal_controller'),
                            controller: _appealController,
                            focusNode: _appealFocus,
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            minLines: 3,
                            maxLines: null,
                            expands: false,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1000),
                            ],
                            textAlignVertical: TextAlignVertical.top,
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white70,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.orangeAccent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.orangeAccent.shade100,
                                  width: 2.0,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.05),
                              labelText: 'describe_problem'.tr(),
                              alignLabelWithHint: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle: const TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                color: Colors.white54,
                              ),
                              icon: Icon(
                                Icons.help_outline_outlined,
                                size: 30,
                                color: Colors.orangeAccent[200],
                              ),
                              errorText: serverError,
                              counterText:
                                  '${_appealController.text.length}/1000',
                              counterStyle: const TextStyle(
                                color: Colors.white38,
                                fontSize: 14,
                              ),
                            ),
                            onChanged: (_) => setState(() {}),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'warning_describe_problem'.tr();
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Кнопка отправки
                      SizedBox(
                        width: 350,
                        height: 60,
                        child: ElevatedButton(
                          key: const Key('appeal_button'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent[200],
                            foregroundColor: const Color.fromARGB(
                              221,
                              22,
                              20,
                              20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              letterSpacing: 2.5,
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final appeal = _appealController.text;

                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString(_appeal, appeal);

                              setState(() {
                                serverError = null;
                              });

                              Flushbar(
                                messageText: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Text(
                                        'Дорогой пользователь, ваша заявка отправлена в поддержку. Мы свяжемся с вами в ближайшее время и решим проблему.',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                flushbarPosition: FlushbarPosition.TOP,
                                flushbarStyle: FlushbarStyle.FLOATING,
                                margin: const EdgeInsets.all(16),
                                borderRadius: BorderRadius.circular(12),
                                backgroundGradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF00C853),
                                    Color(0xFF64DD17),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadows: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: const Offset(0, 3),
                                    blurRadius: 6,
                                  ),
                                ],
                                duration: const Duration(seconds: 2),
                                animationDuration: const Duration(
                                  milliseconds: 600,
                                ),
                              ).show(context);

                              await Future.delayed(const Duration(seconds: 2));
                              if (mounted) Navigator.of(context).pop();
                            }
                          },
                          child: Text('send'.tr()),
                        ),
                      ),

                      const SizedBox(height: 50),
                    ],
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
