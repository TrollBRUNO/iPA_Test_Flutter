// camera_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/widgets/video_stream_html.dart';
import 'package:logger/logger.dart';

class CameraWidget extends StatefulWidget {
  final String cameraId;
  final String cameraName;

  const CameraWidget({
    super.key,
    required this.cameraId,
    required this.cameraName,
  });

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  InAppWebViewController? _webViewController;
  String? _htmlContent;
  Logger logger = Logger();

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

    setState(() {
      _htmlContent = getVideoStreamHtml(jwtToken!, widget.cameraId);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: ClipRRect(
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
          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT,
            );
          },
        ),
      ),
    );
  }
}
