import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/services/spin_time_service.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:first_app_flutter/widgets/statistics_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/web.dart';
import 'package:lottie/lottie.dart';
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
  final _formKey = GlobalKey<FormState>();
  Logger logger = Logger();

  static const String _login = 'login';
  static const String _password = 'password';

  String? username = "";
  String? balanceCount = "0";
  String? bonusBalanceCount = "0";
  String? balanceCreditCount = "0";

  bool canShowCreditButton = false;
  bool isLoading = true;

  Timer? _balanceTimer;

  @override
  void initState() {
    super.initState();
    _loadAll();

    _balanceTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) _loadBalance();
    });
    /* _loadBalance();

    _loadUsername();

    _loadButtonState();

    _balanceTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) _loadBalance();
    }); */
  }

  Future<void> _loadAll() async {
    final results = await Future.wait([
      _loadBalance(),
      _loadUsername(),
      _loadButtonState(),
    ]);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadButtonState() async {
    canShowCreditButton = await TimeService.canTakeCredit();
    setState(() {});
  }

  void showStatisticsDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "StatisticsDialog",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeIn);
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: curved,
            child: StatisticsDialogWidget(
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
        balanceCreditCount = prefs.getString('credit_balance') ?? "0";
      });

      //logger.i("BALANCE: $balanceCount BONUS: $bonusBalanceCount");
    } catch (e, st) {
      logger.w('Error loading balance: $e\n$st');
    }
  }

  Future<void> _loadUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var _username = prefs.getString(_login);

      if (!mounted) return;
      setState(() {
        username = _username;
      });

      //logger.i("BALANCE: $balanceCount BONUS: $bonusBalanceCount");
    } catch (e, st) {
      logger.w('Error loading username: $e\n$st');
    }
  }

  @override
  Widget build(BuildContext context) {
    AdaptiveSizes.init(context);

    if (isLoading) {
      /* return Center(
        child: CircularProgressIndicator(color: Colors.orangeAccent[200]),
      ); */
      return Scaffold(
        body: Center(
          child: Lottie.asset(
            "assets/lottie/8_bit_coin.json",
            width: 200,
            height: 200,
            repeat: true,
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: context.locale.languageCode == 'bg'
                                ? AdaptiveSizes.h(0.01923)
                                : AdaptiveSizes.h(0.01282),
                          ),
                          child: Text(
                            'your_profile'.tr(),
                            style: GoogleFonts.daysOne(
                              fontSize: AdaptiveSizes.getProfileTitleSize(
                                context.locale.languageCode,
                              ),
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

                        /* SizedBox(
                          height: context.locale.languageCode == 'bg'
                              ? AdaptiveSizes.h(0.01923)
                              : AdaptiveSizes.h(0.01282),
                        ), */
                        Card(
                          color: Colors.orangeAccent[200],
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(48),
                          ),
                          margin: EdgeInsets.all(
                            AdaptiveSizes.getDividerProfileHeight(),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(AdaptiveSizes.h(0.0179)),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius:
                                      AdaptiveSizes.getIconProfileSize() / 2,
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/images/profile4.png',
                                      fit: BoxFit.cover,
                                      width: AdaptiveSizes.getIconProfileSize(),
                                      height:
                                          AdaptiveSizes.getIconProfileSize(),
                                    ),
                                  ),
                                  //child: Icon(Icons.person, size: 72),
                                ),
                                SizedBox(width: AdaptiveSizes.w(0.04444) - 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$username',
                                      style: GoogleFonts.roboto(
                                        fontSize:
                                            AdaptiveSizes.getFontUsernameSize(),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: AdaptiveSizes.h(0.0064)),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.account_balance_wallet,
                                          color: Colors.green[700],
                                          size:
                                              AdaptiveSizes.getFontBalanceSize(),
                                        ),
                                        SizedBox(
                                          width: AdaptiveSizes.w(0.01111),
                                        ),
                                        // --------- УБРАЛ РЕАЛИЗАЦИЮ ИЗ-ЗА ТОГО ЧТОБЫ БЫЛО ПРОЩЕ ----------------
                                        /* Text(
                                          '${'balance'.tr()} $balanceCount',
                                          style: GoogleFonts.manrope(
                                            fontSize:
                                                AdaptiveSizes.getFontBalanceSize(),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          width: AdaptiveSizes.w(0.01111),
                                        ),
                                        Text(
                                          '(+$bonusBalanceCount ${'bonus'.tr()})',
                                          style: GoogleFonts.manrope(
                                            fontSize:
                                                AdaptiveSizes.getFontPrizeSize(),
                                            color: const Color.fromARGB(
                                              255,
                                              71,
                                              71,
                                              71,
                                            ),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ), */

                                        // --------- ДОБАВИЛ ВРЕМЕННУЮ РЕАЛИЗАЦИЮ ЧТОБЫ БЫЛО ПРОЩЕ ----------------
                                        Text(
                                          '${'balance'.tr()} $balanceCount',
                                          style: GoogleFonts.manrope(
                                            fontSize:
                                                AdaptiveSizes.getFontBalanceSize(),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: AdaptiveSizes.h(0.0064)),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.hotel_class_outlined,
                                          //color: Colors.blue[700],
                                          color: Colors.deepPurple[700],
                                          size:
                                              AdaptiveSizes.getFontBalanceSize(),
                                        ),
                                        SizedBox(
                                          width: AdaptiveSizes.w(0.01111),
                                        ),
                                        Text(
                                          '${'chips'.tr()} $balanceCreditCount ${'credits'.tr()}',
                                          style: GoogleFonts.manrope(
                                            fontSize:
                                                AdaptiveSizes.getFontCreditBalanceSize(),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          width: AdaptiveSizes.w(0.011111),
                                        ),

                                        if (canShowCreditButton)
                                          _buildCreditButton(),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        Card(
                          color: Colors.orangeAccent[200],
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(48),
                          ),
                          margin: EdgeInsets.symmetric(
                            vertical: AdaptiveSizes.h(0.03076),
                            horizontal: AdaptiveSizes.w(0.06667),
                          ),
                          child: Padding(
                            padding: AdaptiveSizes.getProfileSettingsPadding(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.settings,
                                    size: AdaptiveSizes.getIconSettingsSize(),
                                    color: Color.fromARGB(221, 22, 20, 20),
                                  ),
                                  title: Text(
                                    'settings'.tr(),
                                    style: GoogleFonts.openSans(
                                      fontSize:
                                          AdaptiveSizes.getFontSettingsSize(
                                            false,
                                          ),
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
                                Divider(
                                  height:
                                      AdaptiveSizes.getDividerProfileHeight(),
                                  color: Colors.black38,
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.bar_chart,
                                    size: AdaptiveSizes.getIconSettingsSize(),
                                    color: Color.fromARGB(221, 22, 20, 20),
                                  ),
                                  title: Text(
                                    'statistics'.tr(),
                                    style: GoogleFonts.openSans(
                                      fontSize:
                                          AdaptiveSizes.getFontSettingsSize(
                                            false,
                                          ),
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(221, 22, 20, 20),
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                  onTap: () {
                                    showStatisticsDialog();
                                  },
                                ),
                                Divider(
                                  height:
                                      AdaptiveSizes.getDividerProfileHeight(),
                                  color: Colors.black38,
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.notifications,
                                    size: AdaptiveSizes.getIconSettingsSize(),
                                    color: Color.fromARGB(221, 22, 20, 20),
                                  ),
                                  title: Text(
                                    'notice'.tr(),
                                    style: GoogleFonts.openSans(
                                      fontSize:
                                          AdaptiveSizes.getFontSettingsSize(
                                            false,
                                          ),
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
                                Divider(
                                  height:
                                      AdaptiveSizes.getDividerProfileHeight(),
                                  color: Colors.black38,
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.support_agent_rounded,
                                    size: AdaptiveSizes.getIconSettingsSize(),
                                    color: Color.fromARGB(221, 22, 20, 20),
                                  ),
                                  title: Text(
                                    'support'.tr(),
                                    style: GoogleFonts.openSans(
                                      fontSize:
                                          AdaptiveSizes.getFontSettingsSize(
                                            false,
                                          ),
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
                                Divider(
                                  height:
                                      AdaptiveSizes.getDividerProfileHeight(),
                                  color: Colors.black38,
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.privacy_tip,
                                    size: AdaptiveSizes.getIconSettingsSize(),
                                    color: Color.fromARGB(221, 22, 20, 20),
                                  ),
                                  title: Text(
                                    'confidentiality'.tr(),
                                    style: GoogleFonts.openSans(
                                      fontSize:
                                          context.locale.languageCode == 'ru'
                                          ? AdaptiveSizes.getFontSettingsSize(
                                                  false,
                                                ) -
                                                1
                                          : AdaptiveSizes.getFontSettingsSize(
                                              false,
                                            ),
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
                                Divider(
                                  height:
                                      AdaptiveSizes.getDividerProfileHeight(),
                                  color: Colors.black38,
                                ),
                                ListTile(
                                  minVerticalPadding:
                                      AdaptiveSizes.getMinVerticalPadding(),
                                  contentPadding: EdgeInsets.symmetric(
                                    //vertical: 16.0,
                                    horizontal: 24.0,
                                  ),
                                  leading: Icon(
                                    Icons.logout,
                                    size: AdaptiveSizes.getIconSettingsSize(),
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
                                      fontSize:
                                          context.locale.languageCode == 'bg'
                                          ? AdaptiveSizes.getFontSettingsSize(
                                              true,
                                            )
                                          : AdaptiveSizes.getFontSettingsSize(
                                              false,
                                            ),
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(221, 22, 20, 20),
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                  onTap: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.remove(_login);
                                    await prefs.remove(_password);
                                    context.go('/authorization');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        //SizedBox(height: AdaptiveSizes.h(0.06)),
                        SizedBox(height: AdaptiveSizes.h(0.16)),

                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/icon_app4.png',
                                  fit: BoxFit.cover,
                                  width: AdaptiveSizes.getLogoSize(),
                                  height: AdaptiveSizes.getLogoSize(),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'version'.tr(),
                                style: TextStyle(
                                  fontSize: AdaptiveSizes.getSelectedFontSize(),
                                  fontStyle: FontStyle.italic,
                                  color: Color.fromARGB(255, 120, 120, 120),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),
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

  Widget _buildCreditButton() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurpleAccent.withOpacity(0.6),
            spreadRadius: 0.2,
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: SizedBox(
        width: AdaptiveSizes.getButtonWidth() / 2.6,
        height: AdaptiveSizes.getButtonHeight() / 1.6,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple[700],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AdaptiveSizes.getFontCreditBalanceSize2(),
            ),
          ),
          onPressed: () async {
            setState(() => canShowCreditButton = false);

            // Добавляем 1000 кредитов
            final prefs = await SharedPreferences.getInstance();

            final creditBalance = prefs.getString('credit_balance') ?? "0";

            final creditBalanceToDouble = int.tryParse(creditBalance) ?? 0.0;

            final currentCreditBalance = creditBalanceToDouble + 1000;

            await prefs.setString(
              'credit_balance',
              currentCreditBalance.toString(),
            );

            await TimeService.saveCreditTake();
          },
          child: Text('+1000'),
        ),
      ),
    );
  }
}
