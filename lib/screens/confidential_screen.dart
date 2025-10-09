import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfidentialScreen extends StatelessWidget {
  const ConfidentialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConfidentialPage(title: 'Confidential');
  }
}

class ConfidentialPage extends StatefulWidget {
  const ConfidentialPage({super.key, required this.title});

  final String title;

  @override
  State<ConfidentialPage> createState() => _ConfidentialState();
}

class _ConfidentialState extends State<ConfidentialPage> {
  //final _formKey = GlobalKey<FormState>();
  String _fileContent = 'Загрузка...';

  @override
  void initState() {
    super.initState();
    _loadFileContent();
  }

  Future<void> _loadFileContent() async {
    try {
      final content = await rootBundle.loadString('assets/conf_example.txt');
      setState(() {
        _fileContent = content;
      });
    } catch (e) {
      setState(() {
        _fileContent = 'Ошибка загрузки файла: $e';
      });
    }
  }

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
                'Конфидициалност и условия',
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

            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _fileContent,
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      //height: 1.5,
                      color: Color.fromARGB(221, 22, 20, 20),
                    ),
                    textAlign: TextAlign.justify, // Выравнивание по ширине
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
