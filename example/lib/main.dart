import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:better_wechat_h5pay/better_wechat_h5pay.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  WechatPayWebViewController _payWebViewController = WechatPayWebViewController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            WechatPayWebView(controller: _payWebViewController),
            Expanded(
              child: Center(
                child: CupertinoButton(
                  child: Text("支付"),
                  onPressed: () {
                    _payWebViewController.pay(url: url(), referer: referer());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String url() {
    return "https://wx.tenpay.com/xxxxxx";
  }

  String referer() {
    return Platform.isIOS ? "yourserverhost://" : "https://yourserverhost";
  }
}
