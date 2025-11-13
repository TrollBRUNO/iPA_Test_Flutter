import 'package:first_app_flutter/config/notification_config.dart';
import 'package:first_app_flutter/router/router.dart';
import 'package:first_app_flutter/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await NotificationService().initNotification();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ru', 'RU'),
        Locale('bg', 'BG'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('ru', 'RU'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(221, 22, 20, 20),
        //Colors.orange[100], //const Color.fromARGB(255, 197, 222, 255),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 34, 162, 236),
        ),
      ),

      // локализация
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
