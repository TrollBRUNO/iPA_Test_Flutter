import 'package:first_app_flutter/widgets/wheel_widget.dart';
import 'package:flutter/material.dart';

class WheelScreen extends StatelessWidget {
  const WheelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WheelPage(title: 'Wheel');
  }
}

class WheelPage extends StatefulWidget {
  const WheelPage({super.key, required this.title});

  final String title;

  @override
  State<WheelPage> createState() => _WheelState();
}

class _WheelState extends State<WheelPage> {
  //final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const SizedBox(height: 120),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Ежедневен бонус',
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.orangeAccent[200],
                shadows: const [
                  Shadow(
                    color: Color.fromARGB(255, 51, 51, 51),
                    offset: Offset(2.5, 3.5),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 160),

          SizedBox(
            height: MediaQuery.of(context).size.width * 0.95,
            width: MediaQuery.of(context).size.width * 0.95,
            child: const WheelWidget(),
          ),
        ],
      ),
    );
  }
}
