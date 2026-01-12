import 'package:flutter/foundation.dart';

/// 웹용 광고 서비스 (스텁)
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  bool get isRewardedAdReady => true;

  void loadRewardedAd() {
    // 웹에서는 광고 로드하지 않음
    debugPrint('AdService: Web platform - ads disabled');
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
