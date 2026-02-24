import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/card_game_provider.dart';
import 'home_screen.dart';
import 'seven_card/seven_card_home_screen.dart';
import 'hi_lo/hi_lo_home_screen.dart';
import 'hula/hula_home_screen.dart';
import 'onecard/onecard_home_screen.dart';
import 'hearts/hearts_home_screen.dart';
import '../../main.dart';


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
    // Provider에서 언어 상태 읽기
    final languageProvider = context.watch<LanguageProvider>();
    final currentLanguage = languageProvider.language;

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
        title: L10n.get(currentLanguage, 'mighty'),
        subtitle: L10n.get(currentLanguage, 'mightyDesc'),
        icon: Icons.style,
        color: Colors.green[700]!,
        onTap: () => _startMightyGame(context),
      ),
      _GameInfo(
        title: L10n.get(currentLanguage, 'sevenpoker'),
        subtitle: L10n.get(currentLanguage, 'sevenpokerDesc'),
        icon: Icons.casino,
        color: Colors.blue[700]!,
        screen: const SevenCardHomeScreen(),
      ),
      _GameInfo(
        title: L10n.get(currentLanguage, 'highlow'),
        subtitle: L10n.get(currentLanguage, 'highlowDesc'),
        icon: Icons.swap_vert,
        color: Colors.purple[700]!,
        screen: const HiLoHomeScreen(),
      ),
      _GameInfo(
        title: L10n.get(currentLanguage, 'hula'),
        subtitle: L10n.get(currentLanguage, 'hulaDesc'),
        icon: Icons.style,
        color: Colors.teal[700]!,
        screen: const HulaHomeScreen(),
      ),
      _GameInfo(
        title: L10n.get(currentLanguage, 'onecard'),
        subtitle: L10n.get(currentLanguage, 'onecardDesc'),
        icon: Icons.filter_1,
        color: Colors.orange[700]!,
        screen: const OneCardHomeScreen(),
      ),
      _GameInfo(
        title: L10n.get(currentLanguage, 'hearts'),
        subtitle: L10n.get(currentLanguage, 'heartsDesc'),
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
        title: L10n.get(currentLanguage, 'cardGame'),
        language: currentLanguage,
        onLanguageChanged: languageProvider.setLanguage,
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

  void _startMightyGame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CardGameProviderWrapper(child: HomeScreen()),
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
        onTap: game.onTap ?? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CardGameProviderWrapper(child: game.screen!),
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
  final Widget? screen;
  final VoidCallback? onTap;

  const _GameInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.screen,
    this.onTap,
  });
}

