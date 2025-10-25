import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/widgets/statistics_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/web.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Logger logger = Logger();

  static const String _login = 'login';
  static const String _password = 'password';

  String? balanceCount = "0";
  String? bonusBalanceCount = "0";

  Timer? _balanceTimer;

  @override
  void initState() {
    super.initState();
    _loadBalance();

    _balanceTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) _loadBalance();
    });
  }

  void showStatisticsDialog(String prize) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "PrizeDialog",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeIn);
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: curved,
            child: StatisticsDialogWidget(
              prize: prize,
              onClaim: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadBalance() async {
    // Получаем JWT токен
    String? jwtToken = await AuthService.getJwt();
    if (jwtToken == null) {
      jwtToken = await AuthService.loginAndSaveJwt();
      if (jwtToken == null) {
        throw Exception('Не удалось получить JWT токен');
      }
    }

    try {
      final balance = await AuthService.getBalance(jwtToken);

      final prefs = await SharedPreferences.getInstance();

      if (!mounted) return;
      setState(() {
        balanceCount = balance;
        bonusBalanceCount = prefs.getString('bonus_balance') ?? "0";
      });

      //logger.i("BALANCE: $balanceCount BONUS: $bonusBalanceCount");
    } catch (e, st) {
      logger.w('Error loading balance: $e\n$st');
    }
  }

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
              padding: EdgeInsets.symmetric(
                horizontal: context.locale.languageCode == 'bg' ? 24 : 36,
              ),
              child: Text(
                'your_profile'.tr(),
                style: GoogleFonts.daysOne(
                  fontSize: context.locale.languageCode == 'bg' ? 76 : 84,
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
            ),

            SizedBox(height: context.locale.languageCode == 'bg' ? 30 : 20),

            Card(
              color: Colors.orangeAccent[200],
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
                          style: GoogleFonts.roboto(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.account_balance_wallet,
                              color: Colors.green[700],
                              size: 28,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${'balance'.tr()} $balanceCount',
                              style: GoogleFonts.manrope(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '(+$bonusBalanceCount ${'bonus'.tr()})',
                              style: GoogleFonts.manrope(
                                fontSize: 24,
                                color: const Color.fromARGB(255, 71, 71, 71),
                                fontWeight: FontWeight.w600,
                              ),
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
              color: Colors.orangeAccent[200],
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(48),
              ),
              margin: EdgeInsets.all(48),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.settings,
                        size: 48,
                        color: Color.fromARGB(221, 22, 20, 20),
                      ),
                      title: Text(
                        'settings'.tr(),
                        style: GoogleFonts.openSans(
                          fontSize: 40,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(221, 22, 20, 20),
                          letterSpacing: 0.1,
                        ),
                      ),
                      onTap: () {
                        context.go('/profile/settings');
                      },
                    ),
                    Divider(height: 24, color: Colors.black45),
                    ListTile(
                      leading: Icon(
                        Icons.bar_chart,
                        size: 48,
                        color: Color.fromARGB(221, 22, 20, 20),
                      ),
                      title: Text(
                        'statistics'.tr(),
                        style: GoogleFonts.openSans(
                          fontSize: 40,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(221, 22, 20, 20),
                          letterSpacing: 0.1,
                        ),
                      ),
                      onTap: () {
                        showStatisticsDialog("1000");
                      },
                    ),
                    Divider(height: 24, color: Colors.black45),
                    ListTile(
                      leading: Icon(
                        Icons.notifications,
                        size: 48,
                        color: Color.fromARGB(221, 22, 20, 20),
                      ),
                      title: Text(
                        'notice'.tr(),
                        style: GoogleFonts.openSans(
                          fontSize: 40,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(221, 22, 20, 20),
                          letterSpacing: 0.1,
                        ),
                      ),
                      onTap: () {
                        context.go('/profile/notification');
                      },
                    ),
                    Divider(height: 24, color: Colors.black45),
                    ListTile(
                      leading: Icon(
                        Icons.support_agent_rounded,
                        size: 48,
                        color: Color.fromARGB(221, 22, 20, 20),
                      ),
                      title: Text(
                        'support'.tr(),
                        style: GoogleFonts.openSans(
                          fontSize: 40,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(221, 22, 20, 20),
                          letterSpacing: 0.1,
                        ),
                      ),
                      onTap: () {
                        context.go('/profile/support');
                      },
                    ),
                    Divider(height: 24, color: Colors.black45),
                    ListTile(
                      leading: Icon(
                        Icons.privacy_tip,
                        size: 48,
                        color: Color.fromARGB(221, 22, 20, 20),
                      ),
                      title: Text(
                        'confidentiality'.tr(),
                        style: GoogleFonts.openSans(
                          fontSize: context.locale.languageCode == 'ru'
                              ? 39
                              : 40,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(221, 22, 20, 20),
                          letterSpacing: 0.1,
                        ),
                      ),
                      onTap: () {
                        context.go('/profile/confidential');
                      },
                    ),
                    Divider(height: 24, color: Colors.black45),
                    ListTile(
                      minVerticalPadding: 16,
                      contentPadding: EdgeInsets.symmetric(
                        //vertical: 16.0,
                        horizontal: 24.0,
                      ),
                      leading: Icon(
                        Icons.logout,
                        size: 48,
                        color: Color.fromARGB(221, 22, 20, 20),
                        shadows: [
                          Shadow(
                            blurRadius: 3,
                            offset: Offset(0.5, 0.5),
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                      title: Text(
                        'logout'.tr(),
                        style: GoogleFonts.openSans(
                          fontSize: 40,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(221, 22, 20, 20),
                          letterSpacing: 0.1,
                        ),
                      ),
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove(_login);
                        await prefs.remove(_password);
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
                  Text(
                    'version'.tr(),
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
