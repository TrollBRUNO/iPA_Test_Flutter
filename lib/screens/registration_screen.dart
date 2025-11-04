import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  String? serverError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Registration',
                style: TextStyle(
                  fontSize: 90,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 51, 51, 51),
                  shadows: [
                    Shadow(
                      color: Color.fromARGB(223, 134, 134, 134),
                      offset: Offset(4, 5),
                      blurRadius: 4,
                    ),
                  ],
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

                    style: TextStyle(fontSize: 24),

                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: 'Username',
                      labelStyle: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
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
                    key: Key('real_name_controller'),
                    controller: _realNameController,
                    focusNode: _realNameFocus,
                    style: TextStyle(fontSize: 24),

                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: 'Real Name',
                      labelStyle: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),

                      icon: Icon(Icons.person_4_outlined, size: 30),
                      errorText: serverError,
                    ),
                    validator: (val) {
                      if (val == null || val.length < 2) {
                        return 'Real name empty.';
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

                    style: TextStyle(fontSize: 24),

                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
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

              SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: SizedBox(
                  width: 450,
                  child: TextFormField(
                    key: Key('password_again_controller'),
                    controller: _passwordAgainController,
                    focusNode: _passwordAgainFocus,

                    style: TextStyle(fontSize: 24),

                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: 'Password again',
                      labelStyle: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),

                      icon: Icon(Icons.lock_reset, size: 30),
                      errorText: serverError,
                    ),
                    validator: (val) {
                      if (val != null && val != _passwordController.text) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                    onSaved: (val) => _passwordController.text == val,
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
                    backgroundColor: Color.fromARGB(255, 84, 144, 255),
                    foregroundColor: Color(0xFFFFFFFF),
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
                          title: Text('Registration'),
                          content: Text(
                            'Registration Successful! Welcome dear $user!',
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                context.go('/authorization');
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Text('Create Account'),
                ),
              ),

              SizedBox(height: 25),

              InkWell(
                onTap: () {
                  context.go('/authorization'); // Переход на экран регистрации
                },
                child: const Text(
                  "Go authorization",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 51, 51, 51),
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
