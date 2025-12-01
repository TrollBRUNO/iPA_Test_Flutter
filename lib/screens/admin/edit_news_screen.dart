import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class EditNewsScreen extends StatelessWidget {
  const EditNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EditNewsPage(title: 'Edit News');
  }
}

class EditNewsPage extends StatefulWidget {
  const EditNewsPage({super.key, required this.title});

  final String title;

  @override
  State<EditNewsPage> createState() => _EditNewsState();
}

class _EditNewsState extends State<EditNewsPage> {
  final _formKey = GlobalKey<FormState>();

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: Text(
            'select_language'.tr(),
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'english'.tr(),
                  style: GoogleFonts.raleway(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  await context.setLocale(const Locale('en', 'US'));
                  Navigator.of(context).pop();
                  setState(() {}); // Обновить текущий язык на кнопке
                },
              ),
              ListTile(
                title: Text(
                  'bulgarian'.tr(),
                  style: GoogleFonts.raleway(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  await context.setLocale(const Locale('bg', 'BG'));
                  Navigator.of(context).pop();
                  setState(() {}); // Обновить текущий язык на кнопке
                },
              ),
              ListTile(
                title: Text(
                  'russian'.tr(),
                  style: GoogleFonts.raleway(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  await context.setLocale(const Locale('ru', 'RU'));
                  Navigator.of(context).pop();
                  setState(() {}); // Обновить текущий язык на кнопке
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _getCurrentLanguageText(BuildContext context) {
    switch (context.locale.languageCode) {
      case 'ru':
        return 'Русский';
      case 'en':
        return 'English';
      case 'bg':
        return 'Български';
      default:
        return 'Язык';
    }
  }

  @override
  Widget build(BuildContext context) {
    AdaptiveSizes.init(context);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12,
                          left: 8,
                          right: 8,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Кнопка "назад" — слева
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.orangeAccent[200],
                                  size: AdaptiveSizes.getIconBackSettingsSize(),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),

                            // Заголовок — по центру
                            Text(
                              'settings'.tr(),
                              style: GoogleFonts.daysOne(
                                fontSize: AdaptiveSizes.getFontUsernameSize(),
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
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Padding(
                        padding: AdaptiveSizes.getSettingsRowPadding(),
                        child: Container(
                          height: AdaptiveSizes.getSettingsLanguageHeight(),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: AdaptiveSizes.w(0.03472),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'app_language'.tr(),
                                      style: GoogleFonts.raleway(
                                        fontSize:
                                            AdaptiveSizes.getFontLanguageSize(),
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Открыть выбор языка
                                  _showLanguageDialog(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Text(
                                    _getCurrentLanguageText(context),
                                    style: GoogleFonts.raleway(
                                      fontSize:
                                          AdaptiveSizes.getFontLanguageSize(),
                                      color: Colors.orangeAccent[200],
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
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
