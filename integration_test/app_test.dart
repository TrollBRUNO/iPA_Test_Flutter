import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:first_app_flutter/screens/registration_screen.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Registration end-to-end test', () {
    testWidgets('Проверка ошибки: не заполнено настоящие имя', (tester) async {
      app.RegistrationScreen();
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key('login_controller')), 'TrollBRUNO');
      await tester.enterText(find.byKey(Key('real_name_controller')), '');
      await tester.enterText(
        find.byKey(Key('password_controller')),
        'qwerty123',
      );
      await tester.enterText(
        find.byKey(Key('password_again_controller')),
        'qwerty123',
      );

      //await Future.delayed(const Duration(seconds: 1));
      await tester.tap(find.byKey(Key('register_button')));
      await tester.pumpAndSettle();

      expect(find.text('Real name empty.'), findsOneWidget);
    });

    testWidgets('Проверка ошибки: пароль только из цифр', (tester) async {
      app.RegistrationScreen();
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key('login_controller')), 'TrollBRUNO');
      await tester.enterText(
        find.byKey(Key('real_name_controller')),
        'Petr Atanasov',
      );
      await tester.enterText(find.byKey(Key('password_controller')), '123456');
      await tester.enterText(
        find.byKey(Key('password_again_controller')),
        '123456',
      );

      //await Future.delayed(const Duration(seconds: 1));
      await tester.tap(find.byKey(Key('register_button')));
      await tester.pumpAndSettle();

      expect(find.text('Password cannot be only numbers.'), findsOneWidget);
    });

    testWidgets('Проверка успешной регистрации', (WidgetTester tester) async {
      app.RegistrationScreen();
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(Key('login_controller')), 'TrollBRUNO');
      await tester.enterText(
        find.byKey(Key('real_name_controller')),
        'Petr Atanasov',
      );
      await tester.enterText(
        find.byKey(Key('password_controller')),
        'qwerty123',
      );
      await tester.enterText(
        find.byKey(Key('password_again_controller')),
        'qwerty123',
      );

      await tester.tap(find.byKey(Key('register_button')));
      await tester.pumpAndSettle();

      expect(
        find.text('Registration Successful! Welcome dear TrollBRUNO!'),
        findsOneWidget,
      );
    });
  });
}
