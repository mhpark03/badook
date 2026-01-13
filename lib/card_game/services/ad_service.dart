import 'package:flutter/foundation.dart';

/// 웹용 광고 서비스
/// 디버그 모드에서는 테스트 ID, 릴리즈 모드에서는 실제 광고 ID 사용
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  // 광고 단위 ID (디버그 모드에서는 테스트 ID 사용)
  // 웹 배너 광고 ID (AdSense 등 웹 광고 플랫폼용)
  String get bannerAdUnitId {
    if (kDebugMode) {
      // 테스트 광고 ID
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    // 실제 광고 ID (웹 배포용)
    return 'ca-app-pub-8361977398389047/1127832458';
  }

  // 보상형 광고 ID
  String get rewardedAdUnitId {
    if (kDebugMode) {
      // 테스트 광고 ID
      return 'ca-app-pub-3940256099942544/5224354917';
    }
    // 실제 광고 ID (웹 배포용)
    return 'ca-app-pub-8361977398389047/3216947358';
  }

  bool get isRewardedAdReady => true;

  void loadRewardedAd() {
    debugPrint('AdService: Web platform - loadRewardedAd (ID: $rewardedAdUnitId)');
  }

  Future<bool> showRewardedAd({
    required Function() onRewarded,
    Function()? onAdDismissed,
    Function()? onAdNotAvailable,
  }) async {
    // 웹에서는 광고 없이 바로 보상 지급
    onRewarded();
    onAdDismissed?.call();
    return true;
  }

  void dispose() {
    // 웹에서는 정리할 리소스 없음
  }
}
