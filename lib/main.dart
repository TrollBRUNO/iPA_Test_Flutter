import 'package:first_app_flutter/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('bg', 'BG'), // Болгарский
        Locale('ru', 'RU'), // Русский
        Locale('en', 'US'), // Английский
      ],
      locale: Locale(
        'ru',
        'RU',
      ), // Принудительно установить русский язык (опционально)

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(221, 22, 20, 20),
        //Colors.orange[100], //const Color.fromARGB(255, 197, 222, 255),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 34, 162, 236),
        ),
      ),
    ),
  );
}
