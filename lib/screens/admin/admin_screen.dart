import 'package:easy_localization/easy_localization.dart';
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminPage(title: 'Admin');
  }
}

class AdminPage extends StatefulWidget {
  const AdminPage({super.key, required this.title});
  final String title;

  @override
  State<AdminPage> createState() => _AdminState();
}

class _AdminState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();

  // ------------------------------
  //      ФУНКЦИЯ АДАПТИВНОЙ КНОПКИ
  // ------------------------------
  Widget createAdaptiveButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orangeAccent[200],
          foregroundColor: const Color.fromARGB(221, 22, 20, 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(18),
          textStyle: AdaptiveSizes.getLabelStyleButton(),
        ),
        onPressed: onPressed,
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }

  // ------------------------------
  //     ФУНКЦИЯ БЛОКА (ЗАГОЛОВОК + КНОПКА)
  // ------------------------------
  Widget buildSection(
    BuildContext context, {
    required String title,
    required String buttonText,
    required String path,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.daysOne(
              fontSize: AdaptiveSizes.getUniversalTitleSize(),
              color: Colors.orangeAccent[200],
            ),
          ),
          const SizedBox(height: 12),
          createAdaptiveButton(
            context: context,
            text: buttonText,
            onPressed: () => context.go(path),
          ),
        ],
      ),
    );
  }

  // ------------------------------
  //     АДАПТИВНАЯ СЕТКА (1 / 2 / 3 КОЛОНКИ)
  // ------------------------------
  Widget buildAdminButtons(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    int columns;
    if (screenWidth > 1400) {
      columns = 3;
    } else if (screenWidth > 900) {
      columns = 2;
    } else {
      columns = 1;
    }

    double itemWidth = (screenWidth / columns) - 60;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 30,
        runSpacing: 40,
        children: [
          buildSection(
            context,
            title: "Новости",
            width: itemWidth,
            buttonText:
                "Добавление / Удаление / Редактирование данных Новостей",
            path: '/admin/edit_news',
          ),
          buildSection(
            context,
            title: "Галерея",
            width: itemWidth,
            buttonText: "Добавление / Удаление / Редактирование данных Галереи",
            path: '/admin/edit_gallery',
          ),
          buildSection(
            context,
            title: "Казино",
            width: itemWidth,
            buttonText:
                "Добавление / Удаление / Редактирование адреса Казино + возможность изменять джекпот каждого адреса",
            path: '/admin/edit_casino',
          ),
          buildSection(
            context,
            title: "Приложение",
            width: itemWidth,
            buttonText:
                "Редактирование значений в приложении (значения и цвета в колесе, цвет виджетов и заднего плана)",
            path: '/admin/edit_app',
          ),
          buildSection(
            context,
            title: "Служба поддержки",
            width: itemWidth,
            buttonText:
                "Добавление / Удаление / Редактирование сообщений в поддержку",
            path: '/admin/edit_reports',
          ),
          buildSection(
            context,
            title: "Статистика игроков",
            width: itemWidth,
            buttonText:
                "Просмотр статистики каждого игрока (Время последней крутки, Баланс, Бонусный баланс, Фантиковый баланс)",
            path: '/admin/view_statistics',
          ),

          buildSection(
            context,
            title: "Приложение",
            width: itemWidth,
            buttonText: "Переход в само приложение для просмотра изменений",
            path: '/wheel',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AdaptiveSizes.init(context);

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
          return 'assets/images/russia.png';
        case 'en':
          return 'assets/images/england.png';
        case 'bg':
          return 'assets/images/bulgaria.png';
        default:
          return 'assets/images/england.png';
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showLanguageDialog(context);
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.orangeAccent[200],
                          radius: AdaptiveSizes.getIconProfileSize() / 4,
                          child: ClipOval(
                            child: Image.asset(
                              _getCurrentLanguageText(context),
                              fit: BoxFit.cover,
                              width: AdaptiveSizes.getIconProfileSize() / 2.2,
                              height: AdaptiveSizes.getIconProfileSize() / 2.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          "admin_title".tr(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.daysOne(
                            fontSize:
                                AdaptiveSizes.getUniversalTitleSize() * 1.2,
                            color: Colors.orangeAccent[200],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  buildAdminButtons(context),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
