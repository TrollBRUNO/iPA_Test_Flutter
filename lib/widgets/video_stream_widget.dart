// video_stream_widget.dart
import 'dart:async';

import 'package:first_app_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'video_stream_html.dart';

class VideoStreamWidget extends StatefulWidget {
  const VideoStreamWidget({super.key});

  @override
  State<VideoStreamWidget> createState() => _VideoStreamWidgetState();
}

class _VideoStreamWidgetState extends State<VideoStreamWidget> {
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      //..loadHtmlString('https://live.teleslot.net')
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(false)
      ..setBackgroundColor(Colors.transparent)
      ..loadRequest(Uri.parse('https://www.youtube.com/watch?v=xRU8l2Ig2H4'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WebViewWidget(controller: _webViewController),
    );
  }
}

/*class VideoStreamWidget extends StatefulWidget {
  final String roomId;
  final VoidCallback? onClose;
  final VoidCallback? onStreamFinished;

  const VideoStreamWidget({
    super.key,
    required this.roomId,
    this.onClose,
    this.onStreamFinished,
  });

  @override
  State<VideoStreamWidget> createState() => _VideoStreamWidgetState();
}

class _VideoStreamWidgetState extends State<VideoStreamWidget> {
  var logger = Logger();
  late final WebViewController _webViewController;
  // Добавляем флаги для управления состоянием
  var _isLoading = true;
  var _loadingPercentage = 0;
  var _usingFallback = false; // ← новый флаг
  String _status = 'Загрузка...';

  // Добавляем таймер для отслеживания таймаута
  Timer? _loadTimeoutTimer;

  @override
  void initState() {
    super.initState();
    _initializeWebViewController();
  }

  void _initializeWebViewController() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() {
              _loadingPercentage = progress;
              _status = _usingFallback
                  ? 'Загрузка резервного варианта: $progress%'
                  : 'Загрузка: $progress%';
            });
          },
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
              _status = _usingFallback
                  ? 'Инициализация резервного варианта...'
                  : 'Инициализация...';
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
              _status = _usingFallback
                  ? 'Резервная трансляция активна'
                  : 'Трансляция активна';
            });

            // Отменяем таймер, если страница загрузилась успешно
            _loadTimeoutTimer?.cancel();
          },
          onWebResourceError: (error) {
            _handleLoadError('Web Resource Error: ${error.description}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'VideoChannel',
        onMessageReceived: (JavaScriptMessage message) {
          _handleJavaScriptMessage(message.message);
        },
      );

    _initializeStream();
  }

  // В методе build можно добавить индикатор fallback
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController,),

          if (_isLoading)
            Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: _loadingPercentage / 100.0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _usingFallback ? Colors.orange : Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      _status,
                      style: TextStyle(
                        color: _usingFallback ? Colors.orange : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    if (_usingFallback) ...[
                      SizedBox(height: 10),
                      Text(
                        'Используется резервный режим',
                        style: TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
            ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () {
                _stopStream();
                widget.onClose?.call();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleJavaScriptMessage(String message) {
    logger.i('JS Message: $message');

    if (message.startsWith('status:')) {
      setState(() {
        _status = message.replaceFirst('status:', '');
      });
    } else if (message.startsWith('error:')) {
      setState(() {
        _status = message.replaceFirst('error:', '');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: ${message.replaceFirst('error:', '')}'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      switch (message) {
        case 'videoClosed':
          widget.onClose?.call();
          break;
        case 'streamFinished':
          setState(() {
            _status = 'Трансляция завершена';
          });
          widget.onStreamFinished?.call();
          break;
        case 'connectionEstablished':
          setState(() {
            _status = 'Соединение установлено';
          });
          break;
        case 'trackAdded':
          setState(() {
            _status = 'Видео поток подключен';
          });
          break;
      }
    }
  }

  // В методе _initializeStream() добавьте задержку для инициализации cookies
  /*Future<void> _initializeStream() async {
    try {
      String? jwtToken = await AuthService.getJwt();
      if (jwtToken == null) {
        jwtToken = await AuthService.loginAndSaveJwt();
        if (jwtToken == null) {
          throw Exception('Не удалось получить JWT токен');
        }
      }

      final htmlContent = getVideoStreamHtml(jwtToken, widget.roomId);
      await _webViewController.loadHtmlString(htmlContent);

      // Даем время на установку cookies перед любыми другими действиями
      await Future.delayed(Duration(seconds: 2));
    } catch (e) {
      setState(() {
        _status = 'Ошибка: $e';
        _isLoading = false;
      });
    }
  }
  /*//ОСНОВНОЙ СКОРЕЕ ВСЕГО РАБОЧИЙ МЕТОД
  Future<void> _initializeStream() async {
    try {
      String? jwtToken = await AuthService.getJwt();
      if (jwtToken == null) {
        jwtToken = await AuthService.loginAndSaveJwt();
        if (jwtToken == null) {
          throw Exception('Не удалось получить JWT токен');
        }
      }

      final htmlContent = getVideoStreamHtml(jwtToken, widget.roomId);
      await _webViewController.loadHtmlString(htmlContent);
    } catch (e) {
      setState(() {
        _status = 'Ошибка: $e';
        _isLoading = false;
      });
    }
  }*/

  Future<void> _stopStream() async {
    try {
      await _webViewController.runJavaScript('stopStream();');
    } catch (e) {
      logger.w('Error stopping stream: $e');
    }
  }*/

  // В методе _initializeStream() замените:
  /*Future<void> _initializeStream() async {
    try {
      String? jwtToken = await AuthService.getJwt();
      if (jwtToken == null) {
        jwtToken = await AuthService.loginAndSaveJwt();
        if (jwtToken == null) throw Exception('No JWT token');
      }

      // Используем iframe версию вместо прямого WebRTC
      final htmlContent = getJitsiMeetIframeHtml(jwtToken, widget.roomId);
      await _webViewController.loadHtmlString(htmlContent);
    } catch (e) {
      setState(() {
        _status = 'Ошибка: $e';
        _isLoading = false;
      });
    }
  }

  // Добавьте метод для закрытия iframe
  Future<void> _stopStream() async {
    try {
      await _webViewController.runJavaScript('closeVideo();');
    } catch (e) {
      print('Error stopping stream: $e');
    }
  }*/

  // Основной метод инициализации с каскадной загрузкой
  Future<void> _initializeStream() async {
    try {
      String? jwtToken = await AuthService.getJwt();
      if (jwtToken == null) {
        jwtToken = await AuthService.loginAndSaveJwt();
        if (jwtToken == null) {
          throw Exception('Не удалось получить JWT токен');
        }
      }

      // Запускаем основной метод с таймаутом
      await _loadPrimaryMethod(jwtToken);
    } catch (e) {
      _handleLoadError('Initialization Error: $e');
    }
  }

  // Основной метод загрузки
  Future<void> _loadPrimaryMethod(String jwtToken) async {
    final htmlContent = getVideoStreamHtml(
      jwtToken,
      '82dee2d3-0893-4a4d-b9bc-129179b692c2',
    );

    try {
      await _webViewController .loadHtmlString(htmlContent, baseUrl: 'https://live.teleslot.net');

      // Даем время на установку cookies и инициализацию
      await Future.delayed(Duration(seconds: 5));
    } catch (e) {
      _switchToFallback('Error load HTML: $e');
    }
  }

  // Fallback метод
  Future<void> _loadFallbackMethod() async {
    setState(() {
      _usingFallback = true;
      _isLoading = true;
      _status = 'Переключение на резервный вариант...';
    });

    try {
      const fallbackUrl =
          'https://live.teleslot.net/cd2ee7e59a33/static_folder/jitsi.html';
      await _webViewController.loadRequest(Uri.parse(fallbackUrl));
    } catch (e) {
      setState(() {
        _status = 'Ошибка резервного варианта: $e';
        _isLoading = false;
      });
    }
  }

  // Обработчик ошибок
  void _handleLoadError(String error) {
    logger.e('Load error: $error');

    if (!_usingFallback) {
      _switchToFallback(error);
    } else {
      setState(() {
        _status = 'Critical error: $error';
        _isLoading = false;
      });
    }
  }

  // Переключение на fallback
  void _switchToFallback(String reason) {
    logger.w('Switching to fallback: $reason');
    _loadTimeoutTimer?.cancel();
    _loadFallbackMethod();
  }

  // Добавьте метод для закрытия iframe
  Future<void> _stopStream() async {
    try {
      await _webViewController.runJavaScript('closeVideo();');
    } catch (e) {
      logger.e('Error stopping stream: $e');
    }
  }

  @override
  void dispose() {
    _stopStream();
    super.dispose();
  }
}*/
