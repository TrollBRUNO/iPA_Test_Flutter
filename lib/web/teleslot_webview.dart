import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class TeleslotLoginWebView extends StatefulWidget {
  final String username;
  final String password;

  const TeleslotLoginWebView({
    super.key,
    required this.username,
    required this.password,
  });

  @override
  State<TeleslotLoginWebView> createState() => _TeleslotLoginWebViewState();
}

class _TeleslotLoginWebViewState extends State<TeleslotLoginWebView> {
  late InAppWebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri("https://live.teleslot.net/"),
        ),

        // Когда сайт загрузился → вводим логин/пароль
        onLoadStop: (controller, url) async {
          await Future.delayed(Duration(milliseconds: 500));

          final jsCode =
              """
            // ищем инпуты (ты можешь уточнить id, если знаешь)
            document.querySelector('input[name="username"]').value = "${widget.username}";
            document.querySelector('input[name="password"]').value = "${widget.password}";

            // автоматически нажать кнопку "Login"
            const submitBtn = document.querySelector('input[type="submit"][value="Login"]');
            if (submitBtn) submitBtn.click();
          """;

          await controller.evaluateJavascript(source: jsCode);
        },

        onWebViewCreated: (controller) {
          _controller = controller;
        },
      ),
    );
  }
}
