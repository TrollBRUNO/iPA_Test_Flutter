import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:another_flushbar/flushbar.dart';

class AuthorizationScreen extends StatelessWidget {
  const AuthorizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthorizationPage(title: 'Authorization');
  }
}

class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage({super.key, required this.title});

  final String title;

  @override
  State<AuthorizationPage> createState() => _AuthorizationState();
}

class _AuthorizationState extends State<AuthorizationPage> {
  Logger logger = Logger();
  final _formKey = GlobalKey<FormState>();

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  final _loginFocus = FocusNode();
  final _passwordFocus = FocusNode();

  static const String _login = 'login';
  static const String _password = 'password';

  String? serverError;

  @override
  Widget build(BuildContext context) {
    AdaptiveSizes.init(context);

    AdaptiveSizes.printSizes();

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
                          'authorization'.tr(),
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

                                icon: Icon(Icons.person_4_sharp, size: 30),
                                errorText: serverError,
                              ),
                              validator: (val) {
                                if (val == null || val.length < 6) {
                                  return 'to_short_username'.tr();
                                }
                                return null;
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: AdaptiveSizes.screenHeight * 0.02),

                        Padding(
                          padding: AdaptiveSizes.getMainPadding(),
                          child: SizedBox(
                            width: 450,
                            child: TextFormField(
                              key: Key('password_controller'),
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              textInputAction: TextInputAction.done,

                              style: AdaptiveSizes.getInputTextStyle(),

                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                labelText: 'password'.tr(),
                                labelStyle: AdaptiveSizes.getLabelStyle(),

                                icon: Icon(Icons.lock, size: 30),
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
                              obscureText: true,
                            ),
                          ),
                        ),

                        SizedBox(height: AdaptiveSizes.screenHeight * 0.045),

                        SizedBox(
                          width: AdaptiveSizes.getButtonWidth(),
                          height: AdaptiveSizes.getButtonHeight(),
                          child: ElevatedButton(
                            key: Key('register_button'),

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent[200],
                              foregroundColor: Color.fromARGB(221, 22, 20, 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                                color: Colors.white,
                                wordSpacing: 5.5,
                                letterSpacing: 3.5,
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final user = _loginController.text;
                                final password = _passwordController.text;

                                logger.i('Email: $user, Password: $password');

                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString(_login, user);
                                await prefs.setString(_password, password);

                                String? jwtToken = await AuthService.getJwt();
                                if (jwtToken == null) {
                                  jwtToken =
                                      await AuthService.loginAndSaveJwt();
                                  if (jwtToken == null) {
                                    setState(() {
                                      serverError = 'wrong'.tr();
                                    });
                                    await prefs.remove(_login);
                                    await prefs.remove(_password);
                                    logger.w('Такого аккаунта нет');
                                    return;
                                  }
                                }

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
                                      Expanded(
                                        child: Text(
                                          '${'welcome'.tr()} $user!',
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

                                await Future.delayed(
                                  const Duration(seconds: 2),
                                );
                                context.go('/wheel');
                              }
                            },
                            child: Text('sign_in'.tr()),
                          ),
                        ),

                        SizedBox(height: AdaptiveSizes.screenHeight * 0.015),

                        InkWell(
                          onTap: () {
                            context.go(
                              '/registration',
                            ); // Переход на экран регистрации
                          },
                          child: Text(
                            'no_account'.tr(),
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
