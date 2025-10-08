import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfilePage(title: 'Profile');
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title});

  final String title;

  @override
  State<ProfilePage> createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  //final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),*/
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 120),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'Вашият профил',
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

            const SizedBox(height: 20),

            Card(
              color: Colors.orangeAccent[100],
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(48),
              ),
              margin: EdgeInsets.all(24),
              child: Padding(
                padding: EdgeInsets.all(28),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/profile4.png',
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        ),
                      ),
                      //child: Icon(Icons.person, size: 72),
                    ),
                    SizedBox(width: 32),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Йордан Атанасов',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.account_balance_wallet,
                              color: Colors.green,
                              size: 28,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Balance: 999999.99 BGN',
                              style: TextStyle(fontSize: 28),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              color: Colors.orangeAccent[100],
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(48),
              ),
              margin: EdgeInsets.all(48),
              child: Padding(
                padding: EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      leading: Icon(Icons.settings, size: 48),
                      title: Text(
                        'Настройки',
                        style: TextStyle(
                          fontSize: 38,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      onTap: () {
                        context.go('/profile/settings');
                      },
                    ),
                    Divider(height: 24, color: Colors.black45),
                    ListTile(
                      leading: Icon(Icons.bar_chart, size: 48),
                      title: Text(
                        'Статистика',
                        style: TextStyle(
                          fontSize: 38,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('Статистика'),
                            content: Text('СТАТИСТИКА НА ИГРАЧА\n\n'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Закрыть диалог
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Divider(height: 24, color: Colors.black45),
                    ListTile(
                      leading: Icon(Icons.notifications, size: 48),
                      title: Text(
                        'Известие',
                        style: TextStyle(
                          fontSize: 38,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      onTap: () {
                        context.go('/profile/settings');
                      },
                    ),
                    Divider(height: 24, color: Colors.black45),
                    ListTile(
                      leading: Icon(Icons.privacy_tip, size: 48),
                      title: Text(
                        'Конфидициалност',
                        style: TextStyle(
                          fontSize: 38,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      onTap: () {
                        context.go('/profile/settings');
                      },
                    ),
                    Divider(height: 24, color: Colors.black45),
                    ListTile(
                      minVerticalPadding: 16,
                      contentPadding: EdgeInsets.symmetric(
                        //vertical: 16.0,
                        horizontal: 56.0,
                      ),
                      leading: Icon(Icons.logout, size: 48),
                      title: Text(
                        'Излизане от акаунта',
                        style: TextStyle(
                          fontSize: 38,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      onTap: () {
                        context.go('/authorization');
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/images/icon_app4.png',
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 120, 120, 120),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
