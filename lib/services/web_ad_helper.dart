import 'package:flutter/foundation.dart';
import 'web_ad_helper_stub.dart'
    if (dart.library.js_interop) 'web_ad_helper_web.dart';

/// 웹 광고 표시/숨김 헬퍼
/// index.html의 JavaScript 함수를 호출하여 AdSense 광고 제어
/// 웹이 아닌 플랫폼에서는 아무 동작도 하지 않음
class WebAdHelper {
  static void showAd() {
    try {
      showAdImpl();
    } catch (e) {
      debugPrint('WebAdHelper: showAd error - $e');
    }
  }

  static void hideAd() {
    try {
      hideAdImpl();
    } catch (e) {
      debugPrint('WebAdHelper: hideAd error - $e');
    }
  }
}
