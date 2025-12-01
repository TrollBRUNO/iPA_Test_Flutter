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
            title: "Приложение",
            width: itemWidth,
            buttonText:
                "Редактирование значений в приложении (значения и цвета в колесе, цвет виджетов и заднего плана)",
            path: '/admin/edit_app',
          ),
          buildSection(
            context,
            title: "Джекпоты",
            width: itemWidth,
            buttonText:
                "Добавление / Удаление / Редактирование адреса Казино + возможность изменять джекпот каждого адреса",
            path: '/admin/edit_jackpot',
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AdaptiveSizes.init(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Text(
                    "Интерфейс для администратора",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.daysOne(
                      fontSize: AdaptiveSizes.getUniversalTitleSize() * 1.2,
                      color: Colors.orangeAccent[200],
                    ),
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
