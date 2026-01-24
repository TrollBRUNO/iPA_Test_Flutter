//import 'package:first_app_flutter/config/notification_config.dart';
import 'package:first_app_flutter/router/router.dart';
import 'package:first_app_flutter/interceptor/auth_interceptor.dart';
import 'package:first_app_flutter/services/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
//import 'package:workmanager/workmanager.dart';
//import 'package:first_app_flutter/services/background_worker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  //await NotificationService().initNotification();
  //await NotificationService.initFCM();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  configureInterceptors();
  // Инициализируем Workmanager
  /* if (!kIsWeb) {
    await Workmanager().initialize(
      callbackDispatcher, // callbackDispatcher из background_worker.dart
      isInDebugMode:
          false, // true — для отладки (показывает дополнительные логи)
    );

    // Регистрируем периодическую задачу (каждые 15 минут — минимально приемлемо)
    await Workmanager().registerPeriodicTask(
      "spinCheckUnique",
      spinCheckTask,
      frequency: const Duration(minutes: 5),
      initialDelay: const Duration(minutes: 1),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
  } */

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
    /* return MaterialApp.router(
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
    ); */
    return MaterialApp(
      home: Scaffold(body: Center(child: Text('iOS test OK'))),
    );
  }
}
