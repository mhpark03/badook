import 'package:flutter/foundation.dart';

/// 웹용 광고 서비스 (스텁)
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  bool get isAdLoaded => true;
  bool get isBannerLoaded => false;
  dynamic get bannerAd => null;

  static Future<void> initialize() async {
    debugPrint('AdService: Web platform - ads disabled');
  }

  void loadRewardedAd() {
    debugPrint('AdService: Web platform - ads disabled');
  }

  Future<bool> showRewardedAd({
    required Function(dynamic, dynamic) onUserEarnedReward,
    Function()? onAdDismissed,
    Function()? onAdNotAvailable,
  }) async {
    // 웹에서는 광고 없이 바로 보상 지급
    onUserEarnedReward(null, null);
    onAdDismissed?.call();
    return true;
  }

  Future<void> loadBannerAd({
    Function()? onLoaded,
    bool forceReload = false,
    double? screenWidth,
  }) async {
    // 웹에서는 배너 광고 로드하지 않음
  }

  void disposeBannerAd() {}

  void dispose() {}
}
