# better_wechat_h5pay

A simple Wechat H5 payment for flutter.

## Install Started

1. Add this to your **pubspec.yaml** file:

```yaml
dependencies:
  better_wechat_h5pay: ^0.0.1
```

2. Install it

```bash
$ flutter packages get
```

## Normal usage

```dart
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


String url() {
  return "https://wx.tenpay.com/xxxxxx";
}

String referer() {
  return Platform.isIOS ? "yourserverhost://" : "https://yourserverhost";
}
```

## Feature
- [x] wechat h5 payment.
