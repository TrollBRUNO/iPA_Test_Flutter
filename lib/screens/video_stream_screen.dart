// video_stream_screen.dart
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/widgets/inappwebview_widget.dart';
import 'package:first_app_flutter/widgets/video_stream_html.dart';
import 'package:first_app_flutter/widgets/video_stream_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:logger/logger.dart';

class VideoStreamScreen extends StatefulWidget {
  final String cameraId;
  final String cameraName;

  const VideoStreamScreen({
    super.key,
    required this.cameraId,
    required this.cameraName,
  });

  @override
  State<VideoStreamScreen> createState() => _VideoStreamScreenState();
}

class _VideoStreamScreenState extends State<VideoStreamScreen> {
  InAppWebViewController? _webViewController;
  String? _htmlContent;
  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _loadLocalHtml();
  }

  Future<void> _loadLocalHtml() async {
    // Получаем JWT токен
    String? jwtToken = await AuthService.getJwt();
    if (jwtToken == null) {
      jwtToken = await AuthService.loginAndSaveJwt();
      if (jwtToken == null) {
        throw Exception('Не удалось получить JWT токен');
      }
    }

    // Генерируем HTML
    setState(() {
      _htmlContent = getVideoStreamHtml(
        jwtToken!,
        '82dee2d3-0893-4a4d-b9bc-129179b692c2',
      );
    });

    /*final htmlContent = getVideoStreamHtml(
      jwtToken,
      '82dee2d3-0893-4a4d-b9bc-129179b692c2',
    );*/

    if (_webViewController != null && _htmlContent != null) {
      _webViewController!.loadData(
        data: _htmlContent!,
        baseUrl: WebUri('https://live.teleslot.net'),
        mimeType: 'text/html',
        encoding: 'utf-8',
        androidHistoryUrl: WebUri('https://live.teleslot.net'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Трансляция: ${widget.cameraName}')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: InAppWebView(
              /*initialUrlRequest: URLRequest(
                url: WebUri(
                  'https://live.teleslot.net/cd2ee7e59a33/static_folder/jitsi.html',
                ),
              ),*/
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                  useOnDownloadStart: true,
                  mediaPlaybackRequiresUserGesture: false,
                ),
                android: AndroidInAppWebViewOptions(
                  useHybridComposition: true,
                  builtInZoomControls: true,
                  displayZoomControls: false,
                  domStorageEnabled: true,
                  supportMultipleWindows: true,
                ),
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
                // Если HTML уже готов, загружаем его
                if (_htmlContent != null) {
                  controller.loadData(
                    data: _htmlContent!,
                    baseUrl: WebUri('https://live.teleslot.net'),
                    mimeType: 'text/html',
                    encoding: 'utf-8',
                    androidHistoryUrl: WebUri('https://live.teleslot.net'),
                  );
                }
              },
              androidOnPermissionRequest:
                  (controller, origin, resources) async {
                    return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT,
                    );
                  },
              onCreateWindow: (controller, createWindowRequest) async {
                // Открытие popup-окон в новом WebView внутри приложения
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: SizedBox(
                      width: 400,
                      height: 600,
                      child: InAppWebView(
                        windowId: createWindowRequest.windowId,
                        initialOptions: InAppWebViewGroupOptions(
                          crossPlatform: InAppWebViewOptions(
                            javaScriptEnabled: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
                return true;
              },
            ),
          ),
        ],
      ),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Трансляция: ${widget.cameraName}'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showCameraInfo,
            tooltip: 'Информация о камере',
          ),
          // Кнопка для переключения на вторую камеру
          IconButton(
            icon: const Icon(Icons.switch_video),
            onPressed: _switchCamera,
            tooltip: 'Переключить камеру',
          ),
        ],
      ),
      body: VideoStreamWidget(
        /*roomId: widget.cameraId,
        onClose: () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        },
        onStreamFinished: () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('30-секундная трансляция завершена'),
                duration: Duration(seconds: 3),
              ),
            );
          }
        },*/
      ),
    );
  }

  void _switchCamera() {
    // Переключаемся между двумя камерами
    final newCameraId =
        widget.cameraId == '82dee2d3-0893-4a4d-b9bc-129179b692c2'
        ? 'a1360da3-09ea-4dde-b0e7-1f23bcc592e1'
        : '82dee2d3-0893-4a4d-b9bc-129179b692c2';

    final newCameraName =
        widget.cameraId == '82dee2d3-0893-4a4d-b9bc-129179b692c2'
        ? 'Камера 2'
        : 'Камера 1';

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            VideoStreamScreen(cameraId: newCameraId, cameraName: newCameraName),
      ),
    );
  }

  void _showCameraInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Информация о камере'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Название: ${widget.cameraName}'),
            const SizedBox(height: 10),
            Text('ID: ${widget.cameraId}'),
            const SizedBox(height: 10),
            const Text('Технология: WebRTC через Jitsi Meet'),
            const SizedBox(height: 10),
            const Text('Длительность: 30 секунд (автостоп)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }*/
}
