import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../l10n/board_game_strings.dart';
import '../games/maze/maze_screen.dart';
import '../games/arrow_maze/arrow_maze_screen.dart';

class EscapeGameSelectionScreen extends StatelessWidget {
  final GameLanguage language;
  final Function(GameLanguage) onLanguageChanged;

  const EscapeGameSelectionScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Provider에서 언어 상태 읽기
    final languageProvider = context.watch<LanguageProvider>();
    final currentLanguage = languageProvider.language;

    // 현재 언어 설정
    BoardGameStrings.currentLanguage = currentLanguage;

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
        title: 'games.maze.name'.tr(),
        subtitle: 'games.maze.subtitle'.tr(),
        icon: Icons.grid_4x4,
        color: Colors.purple[700]!,
        onTap: (context) => _showMazeDialog(context),
      ),
      _GameInfo(
        title: 'games.arrowMaze.name'.tr(),
        subtitle: 'games.arrowMaze.subtitle'.tr(),
        icon: Icons.arrow_forward,
        color: Colors.teal[700]!,
        onTap: (context) => _showArrowMazeDialog(context),
      ),
    ];

    final double tileWidth;
    final double tileHeight;
    final double spacing = isSmallScreen ? 10 : 16;
    final double padding = isSmallScreen ? 12 : 16;
    if (screenWidth >= 900) {
      tileWidth = 175;
      tileHeight = 140;
    } else if (screenWidth >= 600) {
      tileWidth = 130;
      tileHeight = 110;
    } else {
      // 2열: (화면너비 - 좌우패딩*2 - 간격*1) / 2
      tileWidth = (screenWidth - padding * 2 - spacing) / 2;
      tileHeight = isSmallScreen ? 90 : 105;
    }

    return Scaffold(
      appBar: buildCommonAppBar(
        context: context,
        title: L10n.get(currentLanguage, 'escapeGame'),
        language: currentLanguage,
        onLanguageChanged: languageProvider.setLanguage,
      ),
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: Wrap(
                spacing: spacing,
                runSpacing: spacing,
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
    );
  }

  void _showMazeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'dialog.selectDifficulty'.tr(),
          style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDifficultyButton(
              context,
              title: 'common.easy'.tr(),
              subtitle: '10x10',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MazeScreen(
                      difficulty: MazeDifficulty.easy,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            _buildDifficultyButton(
              context,
              title: 'common.normal'.tr(),
              subtitle: '15x15',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MazeScreen(
                      difficulty: MazeDifficulty.medium,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            _buildDifficultyButton(
              context,
              title: 'common.hard'.tr(),
              subtitle: '20x20',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MazeScreen(
                      difficulty: MazeDifficulty.hard,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showArrowMazeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'dialog.selectDifficulty'.tr(),
          style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDifficultyButton(
              context,
              title: 'common.easy'.tr(),
              subtitle: '10x10',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ArrowMazeScreen(
                      difficulty: ArrowMazeDifficulty.easy,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            _buildDifficultyButton(
              context,
              title: 'common.normal'.tr(),
              subtitle: '30x30',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ArrowMazeScreen(
                      difficulty: ArrowMazeDifficulty.medium,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            _buildDifficultyButton(
              context,
              title: 'common.hard'.tr(),
              subtitle: '50x50',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ArrowMazeScreen(
                      difficulty: ArrowMazeDifficulty.hard,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.amber.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
              ),
            ),
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
          if (game.onTap != null) {
            game.onTap!(context);
          } else if (game.screen != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => game.screen!),
            );
          }
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
  final void Function(BuildContext)? onTap;

  const _GameInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.screen,
    this.onTap,
  });
}
