import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final _formKey = GlobalKey<FormState>();

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  final _loginFocus = FocusNode();
  final _passwordFocus = FocusNode();

  String? serverError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ), */
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'authorization'.tr(),
                style: GoogleFonts.daysOne(
                  fontSize: 84,
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

              SizedBox(height: 70),

              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: SizedBox(
                  width: 450,
                  child: TextFormField(
                    key: Key('login_controller'),
                    controller: _loginController,
                    focusNode: _loginFocus,

                    style: TextStyle(fontSize: 24, color: Colors.white70),

                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: 'Username',
                      labelStyle: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.white54,
                      ),

                      icon: Icon(Icons.person_4_sharp, size: 30),
                      errorText: serverError,
                    ),
                    validator: (val) {
                      if (val == null || val.length < 6) {
                        return 'Username too short.';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: SizedBox(
                  width: 450,
                  child: TextFormField(
                    key: Key('password_controller'),
                    controller: _passwordController,
                    focusNode: _passwordFocus,

                    style: TextStyle(fontSize: 24, color: Colors.white70),

                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.white54,
                      ),

                      icon: Icon(Icons.lock, size: 30),
                      errorText: serverError,
                    ),
                    validator: (val) {
                      if (val == null || val.length < 6) {
                        return 'Password too short.';
                      }
                      if (RegExp(r'^\d+$').hasMatch(val)) {
                        return 'Password cannot be only numbers.';
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                ),
              ),

              SizedBox(height: 70),

              SizedBox(
                width: 350,
                height: 60,
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final user = _loginController.text;
                      final password = _passwordController.text;

                      debugPrint('Email: $user, Password: $password');

                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('Authorization'),
                          content: Text(
                            'Authorization Successful! Welcome dear $user!',
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Закрыть диалог
                                context.go(
                                  '/wheel',
                                ); // Переход на окно wheel через роутер
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Text('sign_in'.tr()),
                ),
              ),

              SizedBox(height: 25),

              InkWell(
                onTap: () {
                  context.go('/registration'); // Переход на экран регистрации
                },
                child: Text(
                  'no_account'.tr(),
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 90, 90, 90),
                    decoration:
                        TextDecoration.underline, // чтобы выглядело как ссылка
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
