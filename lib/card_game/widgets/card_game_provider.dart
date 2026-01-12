import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_controller.dart';
import '../services/stats_service.dart';
import '../services/seven_card/seven_card_controller.dart';
import '../services/seven_card/seven_card_stats_service.dart';
import '../services/hi_lo/hi_lo_controller.dart';
import '../services/hi_lo/hi_lo_stats_service.dart';
import '../services/hula/hula_stats_service.dart';
import '../services/onecard/onecard_stats_service.dart';
import '../services/hearts/hearts_stats_service.dart';

/// 카드 게임에 필요한 Provider를 제공하는 래퍼
class CardGameProviderWrapper extends StatelessWidget {
  final Widget child;

  const CardGameProviderWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StatsService()..loadStats()),
        ChangeNotifierProvider(create: (_) => GameController()),
        ChangeNotifierProvider(create: (_) => SevenCardStatsService()..loadStats()),
        ChangeNotifierProvider(create: (_) => SevenCardController()),
        ChangeNotifierProvider(create: (_) => HiLoStatsService()..loadStats()),
        ChangeNotifierProvider(create: (_) => HiLoController()),
        ChangeNotifierProvider(create: (_) => HulaStatsService()..loadStats()),
        ChangeNotifierProvider(create: (_) => OneCardStatsService()..loadStats()),
        ChangeNotifierProvider(create: (_) => HeartsStatsService()..loadStats()),
      ],
      child: child,
    );
  }

  /// Provider가 이미 설정되어 있는지 확인
  static bool hasProviders(BuildContext context) {
    try {
      Provider.of<GameController>(context, listen: false);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// 필요한 경우에만 Provider로 감싸서 위젯 반환
  static Widget wrapIfNeeded(BuildContext context, Widget child) {
    if (hasProviders(context)) {
      return child;
    }
    return CardGameProviderWrapper(child: child);
  }
}
