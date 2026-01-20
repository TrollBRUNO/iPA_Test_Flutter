import 'package:another_flushbar/flushbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/class/user_session.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/services/background_worker.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:first_app_flutter/widgets/add_card_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RegistrationPage(title: 'Registration'); // или любое другое название
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key, required this.title});

  final String title;

  @override
  State<RegistrationPage> createState() => _RegistrationState();
}

class _RegistrationState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _loginController = TextEditingController();
  final _realNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordAgainController = TextEditingController();

  final _loginFocus = FocusNode();
  final _realNameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _passwordAgainFocus = FocusNode();

  String? username = "";
  String? balanceCount = "0";
  String? bonusBalanceCount = "0";
  String? fakeBalanceCount = "0";
  String? image_url = "";

  String? serverError;

  void showError(String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  /* Future<Map<String, String>?> askForCard(BuildContext context) async {
    return showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final cardController = TextEditingController();
            String? cardError;
            bool loading = false;

            return FutureBuilder<List<String>>(
              future: AuthService.loadCities(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const AlertDialog(
                    content: SizedBox(
                      height: 80,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                final cities = snapshot.data!;
                String selectedCity = cities.first;

                bool isValidLocal(String value) {
                  return RegExp(r'^[A-Z]{2}-\d{6}$').hasMatch(value);
                }

                return AlertDialog(
                  title: const Text('have_card').tr(),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: cardController,
                        maxLength: 9,
                        decoration: InputDecoration(
                          labelText: 'card_id'.tr(),
                          errorText: cardError,
                          counterText: '',
                        ),
                        onChanged: (_) {
                          if (cardError != null) {
                            setModalState(() => cardError = null);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedCity,
                        items: cities
                            .map(
                              (city) => DropdownMenuItem(
                                value: city,
                                child: Text(city),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => selectedCity = v!,
                        decoration: const InputDecoration(labelText: 'City'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, null),
                      child: const Text('no').tr(),
                    ),
                    ElevatedButton(
                      onPressed: loading
                          ? null
                          : () async {
                              final cardId = cardController.text.trim();

                              // ---------- ЭТАП 1: локальная проверка ----------
                              if (!isValidLocal(cardId)) {
                                setModalState(() {
                                  cardError = 'wrong_card_format'.tr();
                                });
                                showError('wrong_card_format'.tr());
                                return;
                              }

                              // ---------- ЭТАП 2: сервер ----------
                              setModalState(() => loading = true);

                              final error = await AuthService.checkCard(cardId);

                              setModalState(() => loading = false);

                              if (error == 'card_already_used') {
                                setModalState(() {
                                  cardError = 'card_already_used'.tr();
                                });
                                showError('card_already_used'.tr());
                                return;
                              }

                              Navigator.pop(context, {
                                'card_id': cardId,
                                'city': selectedCity,
                              });
                            },
                      child: loading
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
              },
            );
          },
        );
      },
    );
  } */

  @override
  Widget build(BuildContext context) {
    AdaptiveSizes.init(context);

    //AdaptiveSizes.printSizes();

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              // Добавляем скролл для маленьких экранов
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'registration'.tr(),
                          style: GoogleFonts.daysOne(
                            fontSize: AdaptiveSizes.getUniversalTitleSize(),
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            color: Colors.orangeAccent[200],
                            /* shadows: const [
                              Shadow(
                                color: Color.fromARGB(255, 51, 51, 51),
                                offset: Offset(3.5, 4.5),
                                blurRadius: 3,
                              ),
                            ], */
                          ),
                        ),

                        SizedBox(height: AdaptiveSizes.screenHeight * 0.04),

                        Padding(
                          padding: AdaptiveSizes.getMainPadding(),
                          child: SizedBox(
                            width: AdaptiveSizes.getInputFieldWidth(),
                            child: TextFormField(
                              key: Key('login_controller'),
                              controller: _loginController,
                              focusNode: _loginFocus,

                              textInputAction: TextInputAction.next,

                              style: AdaptiveSizes.getInputTextStyle(),

                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                labelText: 'username'.tr(),
                                labelStyle: AdaptiveSizes.getLabelStyle(),

                                icon: Icon(
                                  Icons.person_4_sharp,
                                  size:
                                      AdaptiveSizes.getIconAuthorizationSize(),
                                ),
                                errorText: serverError,
                              ),
                              validator: (val) {
                                if (val == null || val.length < 6) {
                                  return 'to_short_username'.tr();
                                }
                                if (serverError == 'username_taken') {
                                  return 'username_taken'.tr();
                                }
                                return null;
                              },
                              onChanged: (_) {
                                if (serverError != null) {
                                  setState(() => serverError = null);
                                }
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: AdaptiveSizes.screenHeight * 0.02),

                        Padding(
                          padding: AdaptiveSizes.getMainPadding(),
                          child: SizedBox(
                            width: AdaptiveSizes.getInputFieldWidth(),
                            child: TextFormField(
                              key: Key('real_name_controller'),
                              controller: _realNameController,
                              focusNode: _realNameFocus,
                              textInputAction: TextInputAction.next,

                              style: AdaptiveSizes.getInputTextStyle(),

                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                labelText: 'realname'.tr(),
                                labelStyle: AdaptiveSizes.getLabelStyle(),

                                icon: Icon(
                                  Icons.person_4_outlined,
                                  size:
                                      AdaptiveSizes.getIconAuthorizationSize(),
                                ),
                                errorText: serverError,
                              ),
                              validator: (val) {
                                if (val == null || val.length < 2) {
                                  return 'realname_empty'.tr();
                                }
                                return null;
                              },
                              onChanged: (_) {
                                if (serverError != null) {
                                  setState(() => serverError = null);
                                }
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: AdaptiveSizes.screenHeight * 0.02),

                        Padding(
                          padding: AdaptiveSizes.getMainPadding(),
                          child: SizedBox(
                            width: AdaptiveSizes.getInputFieldWidth(),
                            child: TextFormField(
                              key: Key('password_controller'),
                              controller: _passwordController,
                              focusNode: _passwordFocus,

                              textInputAction: TextInputAction.next,

                              style: AdaptiveSizes.getInputTextStyle(),

                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                labelText: 'password'.tr(),
                                labelStyle: AdaptiveSizes.getLabelStyle(),

                                icon: Icon(
                                  Icons.lock,
                                  size:
                                      AdaptiveSizes.getIconAuthorizationSize(),
                                ),
                                errorText: serverError,
                              ),
                              validator: (val) {
                                if (val == null || val.length < 6) {
                                  return 'to_short_password'.tr();
                                }
                                if (RegExp(r'^\d+$').hasMatch(val)) {
                                  return 'only_number_password'.tr();
                                }
                                return null;
                              },
                              onChanged: (_) {
                                if (serverError != null) {
                                  setState(() => serverError = null);
                                }
                              },
                              obscureText: true,
                            ),
                          ),
                        ),

                        SizedBox(height: AdaptiveSizes.screenHeight * 0.02),

                        Padding(
                          padding: AdaptiveSizes.getMainPadding(),
                          child: SizedBox(
                            width: AdaptiveSizes.getInputFieldWidth(),
                            child: TextFormField(
                              key: Key('password_again_controller'),
                              controller: _passwordAgainController,
                              focusNode: _passwordAgainFocus,

                              textInputAction: TextInputAction.done,

                              style: AdaptiveSizes.getInputTextStyle(),

                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                labelText: 'password_again'.tr(),
                                labelStyle: AdaptiveSizes.getLabelStyle(),

                                icon: Icon(
                                  Icons.lock_reset,
                                  size:
                                      AdaptiveSizes.getIconAuthorizationSize(),
                                ),
                                errorText: serverError,
                              ),
                              validator: (val) {
                                if (val != null &&
                                    val != _passwordController.text) {
                                  return 'passwords_do_not_match'.tr();
                                }
                                return null;
                              },
                              onChanged: (_) {
                                if (serverError != null) {
                                  setState(() => serverError = null);
                                }
                              },
                              //onSaved: (val) => _passwordController.text == val,
                              obscureText: true,
                            ),
                          ),
                        ),

                        SizedBox(height: AdaptiveSizes.screenHeight * 0.045),

                        SizedBox(
                          width: AdaptiveSizes.getButtonWidth2(),
                          height: AdaptiveSizes.getButtonHeight(),
                          child: ElevatedButton(
                            key: Key('register_button'),

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent[200],
                              foregroundColor: Color.fromARGB(221, 22, 20, 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              textStyle: AdaptiveSizes.getLabelStyleButton(),
                            ),
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;

                              final login = _loginController.text;
                              final password = _passwordController.text;
                              final realname = _realNameController.text;

                              //final cardData = await askForCard(context);
                              final cardData = await AddCardDialogWidget.show(
                                context,
                              );

                              final errorCode =
                                  await AuthService.registerAndLogin(
                                    login: login,
                                    password: password,
                                    realname: realname,
                                    cardId: cardData?['card_id'],
                                    city: cardData?['city'],
                                  );

                              if (errorCode != null) {
                                setState(() => serverError = errorCode);

                                if (errorCode == 'card_already_used') {
                                  Flushbar(
                                    message: 'card_already_used'.tr(),
                                    duration: const Duration(seconds: 3),
                                  ).show(context);
                                }

                                _formKey.currentState!.validate();
                                return;
                              }

                              await AuthService.loadProfile();

                              Flushbar(
                                messageText: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        '${'welcome'.tr()} $realname!',
                                        style: const TextStyle(
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
                              context.go('/wheel');
                            },
                            child: Text('create_account'.tr()),
                          ),
                        ),

                        SizedBox(height: AdaptiveSizes.screenHeight * 0.015),

                        InkWell(
                          onTap: () {
                            context.go(
                              '/authorization',
                            ); // Переход на экран авторизации
                          },
                          child: Text(
                            'go_auth'.tr(),
                            style: AdaptiveSizes.getLabelLinkStyle(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
