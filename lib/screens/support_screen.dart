import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SupportPage(title: 'Support');
  }
}

class SupportPage extends StatefulWidget {
  const SupportPage({super.key, required this.title});

  final String title;

  @override
  State<SupportPage> createState() => _SupportState();
}

class _SupportState extends State<SupportPage> {
  //final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 100),

            Positioned(
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.orangeAccent[200],
                  size: 32,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Поддържка',
                style: GoogleFonts.daysOne(
                  fontSize: 36,
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
            ),

            const SizedBox(height: 20),

            // Тут код
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
