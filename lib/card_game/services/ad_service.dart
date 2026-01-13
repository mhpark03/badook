import 'package:flutter/foundation.dart';

/// 웹용 광고 서비스 (배너 광고만 지원)
/// 디버그 모드에서는 테스트 ID, 릴리즈 모드에서는 실제 광고 ID 사용
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  // 웹 배너 광고 ID (AdSense용)
  String get bannerAdUnitId {
    if (kDebugMode) {
      // 테스트 광고 ID
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    // 실제 광고 ID (웹 배포용)
    return 'ca-app-pub-8361977398389047/1127832458';
  }

  void dispose() {
    // 웹에서는 정리할 리소스 없음
  }
}
