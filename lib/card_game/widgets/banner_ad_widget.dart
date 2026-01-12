import 'package:flutter/material.dart';

/// 웹용 배너 광고 위젯 (스텁)
class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 웹에서는 광고 표시하지 않음
    return const SizedBox.shrink();
  }
}
