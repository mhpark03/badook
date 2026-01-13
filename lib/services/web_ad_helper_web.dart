import 'dart:js_interop';

/// 웹 플랫폼용 구현
void showAdImpl() {
  _jsShowAd();
}

void hideAdImpl() {
  _jsHideAd();
}

@JS('showAd')
external void _jsShowAd();

@JS('hideAd')
external void _jsHideAd();
