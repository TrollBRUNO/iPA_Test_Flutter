// camera_widget.dart
import 'package:first_app_flutter/utils/adaptive_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/widgets/video_stream_html.dart';
import 'package:logger/logger.dart';

class CameraWidget extends StatefulWidget {
  final List<String> cameraIds;
  final List<String> cameraNames;

  const CameraWidget({
    super.key,
    required this.cameraIds,
    required this.cameraNames,
  });

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  int _currentIndex = 0;
  InAppWebViewController? _webViewController;
  String? _htmlContent;
  Logger logger = Logger();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLocalHtml();
  }

  Future<void> _loadLocalHtml() async {
    String? jwtToken = await AuthService.getJwt();
    if (jwtToken == null) {
      jwtToken = await AuthService.loginAndSaveJwt();
      if (jwtToken == null) {
        throw Exception('Не удалось получить JWT токен');
      }
    }
    if (!mounted) return;
    setState(() {
      _htmlContent = getVideoStreamHtml(
        jwtToken!,
        widget.cameraIds[_currentIndex],
      );
    });

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

  void _switchCamera(int direction) async {
    setState(() {
      _isLoading = true;
      _currentIndex = (_currentIndex + direction) % widget.cameraIds.length;
      if (_currentIndex < 0) _currentIndex = widget.cameraIds.length - 1;
    });

    await _loadLocalHtml();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: AdaptiveSizes.getCameraWidgetHeight(),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 255, 0, 0).withOpacity(0.6),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 0),
              ),
            ],
            color: Colors.red,
            border: Border.all(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: InAppWebView(
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
                ),
              ),
              if (_isLoading)
                Container(
                  color: Colors.black,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),

        SizedBox(height: AdaptiveSizes.h(0.00512)),

        // Переключатели камер
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left, size: 40, color: Colors.red),
              onPressed: () => _switchCamera(-1),
            ),
            Text(
              widget.cameraNames[_currentIndex],
              style: TextStyle(
                fontSize: AdaptiveSizes.getAddressSize(),
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_right, size: 40, color: Colors.red),
              onPressed: () => _switchCamera(1),
            ),
          ],
        ),
      ],
    );
  }
}
