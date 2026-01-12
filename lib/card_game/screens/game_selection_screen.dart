import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/banner_ad_widget.dart';
import '../services/game_controller.dart';
import '../services/stats_service.dart';
import '../services/seven_card/seven_card_controller.dart';
import '../services/seven_card/seven_card_stats_service.dart';
import '../services/hi_lo/hi_lo_controller.dart';
import '../services/hi_lo/hi_lo_stats_service.dart';
import '../services/hula/hula_stats_service.dart';
import '../services/onecard/onecard_stats_service.dart';
import '../services/hearts/hearts_stats_service.dart';
import 'home_screen.dart';
import 'seven_card/seven_card_home_screen.dart';
import 'hi_lo/hi_lo_home_screen.dart';
import 'hula/hula_home_screen.dart';
import 'onecard/onecard_home_screen.dart';
import 'hearts/hearts_home_screen.dart';
import '../../main.dart';

/// 카드 게임에 필요한 Provider를 제공하는 래퍼
class _CardGameProviderWrapper extends StatelessWidget {
  final Widget child;

  const _CardGameProviderWrapper({required this.child});

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
}

// 기본 문자열
class _DefaultStrings {
  static const selectGame = '게임 선택';
  static const appTitle = '마이티';
  static const gameSubtitle = '5인 트럼프';
  static const sevenCardTitle = '세븐카드';
  static const sevenCardSubtitle = '포커 게임';
  static const hiLoTitle = '하이로우';
  static const hiLoSubtitle = '숫자 맞추기';
  static const hulaTitle = '훌라';
  static const hulaSubtitle = '3장 카드';
  static const heartsTitle = '하트';
  static const heartsSubtitle = '패스 게임';
}

class GameSelectionScreen extends StatelessWidget {
  final GameLanguage language;
  final Function(GameLanguage) onLanguageChanged;

  const GameSelectionScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height - mediaQuery.padding.top - mediaQuery.padding.bottom;
    final isSmallScreen = screenHeight < 600;

    // 반응형: 화면 너비에 따라 최대 너비와 폰트 크기 결정
    final double maxContentWidth;
    final double iconSize;
    final double titleSize;
    final double subtitleSize;

    if (screenWidth >= 900) {
      maxContentWidth = 800;
      iconSize = 48;
      titleSize = 20;
      subtitleSize = 14;
    } else if (screenWidth >= 600) {
      maxContentWidth = 600;
      iconSize = 40;
      titleSize = 18;
      subtitleSize = 13;
    } else {
      maxContentWidth = double.infinity;
      iconSize = isSmallScreen ? 28 : 36;
      titleSize = isSmallScreen ? 14.0 : 17.0;
      subtitleSize = isSmallScreen ? 10.0 : 12.0;
    }

    final games = [
      _GameInfo(
        title: _DefaultStrings.appTitle,
        subtitle: _DefaultStrings.gameSubtitle,
        icon: Icons.style,
        color: Colors.green[700]!,
        screen: const HomeScreen(),
      ),
      _GameInfo(
        title: _DefaultStrings.sevenCardTitle,
        subtitle: _DefaultStrings.sevenCardSubtitle,
        icon: Icons.casino,
        color: Colors.blue[700]!,
        screen: const SevenCardHomeScreen(),
      ),
      _GameInfo(
        title: _DefaultStrings.hiLoTitle,
        subtitle: _DefaultStrings.hiLoSubtitle,
        icon: Icons.swap_vert,
        color: Colors.purple[700]!,
        screen: const HiLoHomeScreen(),
      ),
      _GameInfo(
        title: _DefaultStrings.hulaTitle,
        subtitle: _DefaultStrings.hulaSubtitle,
        icon: Icons.style,
        color: Colors.teal[700]!,
        screen: const HulaHomeScreen(),
      ),
      _GameInfo(
        title: '원카드',
        subtitle: '4인 대전',
        icon: Icons.filter_1,
        color: Colors.orange[700]!,
        screen: const OneCardHomeScreen(),
      ),
      _GameInfo(
        title: _DefaultStrings.heartsTitle,
        subtitle: _DefaultStrings.heartsSubtitle,
        icon: Icons.favorite,
        color: Colors.red[700]!,
        screen: const HeartsHomeScreen(),
      ),
    ];

    final double tileWidth;
    final double tileHeight;
    if (screenWidth >= 900) {
      tileWidth = 200;
      tileHeight = 160;
    } else if (screenWidth >= 600) {
      tileWidth = 160;
      tileHeight = 130;
    } else {
      tileWidth = (screenWidth - 48) / 2;
      tileHeight = isSmallScreen ? 100 : 120;
    }

    return Scaffold(
      appBar: buildCommonAppBar(
        context: context,
        title: L10n.get(language, 'cardGame'),
        language: language,
        onLanguageChanged: onLanguageChanged,
      ),
      backgroundColor: Colors.green[900],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: maxContentWidth),
                    child: Wrap(
                      spacing: isSmallScreen ? 10 : 16,
                      runSpacing: isSmallScreen ? 10 : 16,
                      alignment: WrapAlignment.center,
                      children: games.map((game) => SizedBox(
                        width: tileWidth,
                        height: tileHeight,
                        child: _buildGameTile(
                          context: context,
                          game: game,
                          iconSize: iconSize,
                          titleSize: titleSize,
                          subtitleSize: subtitleSize,
                        ),
                      )).toList(),
                    ),
                  ),
                ),
              ),
            ),
            const BannerAdWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildGameTile({
    required BuildContext context,
    required _GameInfo game,
    required double iconSize,
    required double titleSize,
    required double subtitleSize,
  }) {
    return Material(
      color: game.color,
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => _CardGameProviderWrapper(child: game.screen),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight;
            final availableWidth = constraints.maxWidth;
            final padding = availableHeight * 0.06;
            final dynamicIconSize = (availableHeight * 0.28).clamp(18.0, iconSize);
            final iconPadding = dynamicIconSize * 0.25;
            final dynamicTitleSize = (availableHeight * 0.11).clamp(11.0, titleSize);
            final dynamicSubtitleSize = (availableHeight * 0.08).clamp(8.0, subtitleSize);
            final spacing = availableHeight * 0.04;

            return Container(
              padding: EdgeInsets.all(padding),
              width: availableWidth,
              height: availableHeight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  width: availableWidth - padding * 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(iconPadding),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          game.icon,
                          color: Colors.white,
                          size: dynamicIconSize,
                        ),
                      ),
                      SizedBox(height: spacing),
                      Text(
                        game.title,
                        style: TextStyle(
                          fontSize: dynamicTitleSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: spacing * 0.3),
                      Text(
                        game.subtitle,
                        style: TextStyle(
                          fontSize: dynamicSubtitleSize,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GameInfo {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget screen;

  const _GameInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.screen,
  });
}
