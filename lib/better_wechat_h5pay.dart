import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef LaunchWechatCallback(bool result);

class WechatPayWebView extends StatefulWidget {
  final WechatPayWebViewController controller;

  const WechatPayWebView({Key? key, required this.controller}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WechatPayWebViewState();
  }
}

class WechatPayWebViewState extends State<WechatPayWebView> {
  WebViewController? _webViewController;

  late _WechatPayListener _payListener;

  Completer<bool>? timeoutCompleter;

  @override
  void initState() {
    super.initState();

    _payListener = pay;
    widget.controller._payListener = _payListener;
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: true,
      child: Container(
        width: 100,
        height: 100,
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: _onWebViewCreated,
          navigationDelegate: _navigationDelegate,
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(WechatPayWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      widget.controller._payListener = _payListener;
    }
  }

  void _onWebViewCreated(WebViewController controller) {
    _webViewController = controller;
  }

  NavigationDecision _navigationDelegate(NavigationRequest request) {
    String url = request.url;

    // 跳转到微信应用
    if (url.startsWith("weixin://")) {
      if (Platform.isIOS) {
        launch(url).then((can) {
          if (timeoutCompleter?.isCompleted == false) {
            timeoutCompleter?.complete(can);
          }
        });
      } else if (Platform.isAndroid) {
        canLaunch(url).then((can) {
          if (can) {
            launch(url);
          }
          if (timeoutCompleter?.isCompleted == false) {
            timeoutCompleter?.complete(can);
          }
        });
      }
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  Future<bool> pay({required String url, required String referer}) async {
    if (timeoutCompleter?.isCompleted == false) {
      timeoutCompleter?.complete(false);
    }
    _webViewController?.loadUrl(url, headers: {
      "referer": referer,
    });

    // 3秒如果没有调起微信, 返回超时失败
    timeoutCompleter = Completer();
    Future.delayed(Duration(seconds: 3)).then((value) {
      if (timeoutCompleter?.isCompleted == false) {
        timeoutCompleter?.complete(false);
      }
    });
    return timeoutCompleter!.future;
  }
}

typedef Future<bool> _WechatPayListener({required String url, required String referer});

class WechatPayWebViewController {
  _WechatPayListener? _payListener;

  Future<bool> pay({required String url, required String referer}) async {
    if (_payListener != null) {
      return _payListener!(url: url, referer: referer);
    } else {
      return false;
    }
  }
}
