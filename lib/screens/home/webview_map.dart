import 'package:flutter/material.dart';
import 'package:tomato_record/utils/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewMap extends StatefulWidget {
  const WebviewMap({Key? key}) : super(key: key);

  @override
  State<WebviewMap> createState() => _WebviewMapState();
}

class _WebviewMapState extends State<WebviewMap> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('http://www.tamoimap.com/fm/index.php?flag=9'),
        // Uri.parse('https://www.tamoi.co.kr'),
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            logger.d('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            logger.d('Page started loading: $url');
          },
          onPageFinished: (String url) {
            logger.d('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            logger.d('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url.startsWith('https://www.youtube.com/')) {
            //   logger.d('blocking navigation to ${request.url}');
            //   return NavigationDecision.prevent;
            // }  // URL 제한을 걸 수 있음
            logger.d('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            logger.d('url change to ${change.url}');
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _controller,
    );
  }
}
