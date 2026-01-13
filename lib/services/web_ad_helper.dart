import 'package:flutter/foundation.dart';
import 'dart:js_interop';

/// 웹 광고 표시/숨김 헬퍼
/// index.html의 JavaScript 함수를 호출하여 AdSense 광고 제어
class WebAdHelper {
  static void showAd() {
    if (kIsWeb) {
      try {
        _jsShowAd();
      } catch (e) {
        debugPrint('WebAdHelper: showAd error - $e');
      }
    }
  }

  static void hideAd() {
    if (kIsWeb) {
      try {
        _jsHideAd();
      } catch (e) {
        debugPrint('WebAdHelper: hideAd error - $e');
      }
    }
  }
}

@JS('showAd')
external void _jsShowAd();

@JS('hideAd')
external void _jsHideAd();
