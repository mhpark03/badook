import 'package:flutter/material.dart';
import '../../main.dart';
import '../l10n/board_game_strings.dart';
import '../games/sudoku/screens/game_screen.dart';
import '../games/sudoku/screens/samurai_game_screen.dart';
import '../games/sudoku/screens/killer_game_screen.dart';
import '../games/sudoku/models/game_state.dart';
import '../games/sudoku/models/samurai_game_state.dart';
import '../games/sudoku/models/killer_sudoku_generator.dart';
import '../games/number_sums/screens/number_sums_game_screen.dart';
import '../games/number_sums/models/number_sums_generator.dart';

class SudokuSelectionScreen extends StatelessWidget {
  final GameLanguage language;
  final Function(GameLanguage) onLanguageChanged;

  const SudokuSelectionScreen({
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
        title: 'games.sudoku.classic'.tr(),
        subtitle: 'games.sudoku.classicDesc'.tr(),
        icon: Icons.grid_3x3,
        color: Colors.blue[700]!,
        onTap: (context) => _showClassicDifficultyDialog(context),
      ),
      _GameInfo(
        title: 'games.sudoku.samurai'.tr(),
        subtitle: 'games.sudoku.samuraiDesc'.tr(),
        icon: Icons.dashboard,
        color: Colors.purple[700]!,
        onTap: (context) => _showSamuraiDifficultyDialog(context),
      ),
      _GameInfo(
        title: 'games.sudoku.killer'.tr(),
        subtitle: 'games.sudoku.killerDesc'.tr(),
        icon: Icons.calculate,
        color: Colors.red[700]!,
        onTap: (context) => _showKillerDifficultyDialog(context),
      ),
      _GameInfo(
        title: 'games.numberSums.name'.tr(),
        subtitle: 'games.numberSums.description'.tr(),
        icon: Icons.add_box,
        color: Colors.teal[700]!,
        onTap: (context) => _showNumberSumsDifficultyDialog(context),
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
        title: L10n.get(language, 'sudoku'),
        language: language,
        onLanguageChanged: onLanguageChanged,
      ),
      backgroundColor: Colors.indigo[900],
      body: SafeArea(
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
    );
  }

  void _showClassicDifficultyDialog(BuildContext context) {
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
            _buildDifficultyButton(context, title: 'common.easy'.tr(), subtitle: '9x9', onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const GameScreen(initialDifficulty: Difficulty.easy),
              ));
            }),
            const SizedBox(height: 8),
            _buildDifficultyButton(context, title: 'common.normal'.tr(), subtitle: '9x9', onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const GameScreen(initialDifficulty: Difficulty.medium),
              ));
            }),
            const SizedBox(height: 8),
            _buildDifficultyButton(context, title: 'common.hard'.tr(), subtitle: '9x9', onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const GameScreen(initialDifficulty: Difficulty.hard),
              ));
            }),
            const SizedBox(height: 8),
            _buildDifficultyButton(context, title: 'common.expert'.tr(), subtitle: '9x9', onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const GameScreen(initialDifficulty: Difficulty.expert),
              ));
            }),
          ],
        ),
      ),
    );
  }

  void _showSamuraiDifficultyDialog(BuildContext context) {
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
            _buildDifficultyButton(context, title: 'common.easy'.tr(), subtitle: '5x 9x9', onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const SamuraiGameScreen(initialDifficulty: SamuraiDifficulty.easy),
              ));
            }),
            const SizedBox(height: 8),
            _buildDifficultyButton(context, title: 'common.normal'.tr(), subtitle: '5x 9x9', onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const SamuraiGameScreen(initialDifficulty: SamuraiDifficulty.medium),
              ));
            }),
            const SizedBox(height: 8),
            _buildDifficultyButton(context, title: 'common.hard'.tr(), subtitle: '5x 9x9', onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const SamuraiGameScreen(initialDifficulty: SamuraiDifficulty.hard),
              ));
            }),
          ],
        ),
      ),
    );
  }

  void _showKillerDifficultyDialog(BuildContext context) {
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
            _buildDifficultyButton(context, title: 'common.easy'.tr(), subtitle: '9x9', onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const KillerGameScreen(initialDifficulty: KillerDifficulty.easy),
              ));
            }),
            const SizedBox(height: 8),
            _buildDifficultyButton(context, title: 'common.normal'.tr(), subtitle: '9x9', onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const KillerGameScreen(initialDifficulty: KillerDifficulty.medium),
              ));
            }),
            const SizedBox(height: 8),
            _buildDifficultyButton(context, title: 'common.hard'.tr(), subtitle: '9x9', onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const KillerGameScreen(initialDifficulty: KillerDifficulty.hard),
              ));
            }),
          ],
        ),
      ),
    );
  }

  void _showNumberSumsDifficultyDialog(BuildContext context) {
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
            _buildDifficultyButton(context, title: 'common.easy'.tr(), subtitle: '6x6', onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const NumberSumsGameScreen(initialDifficulty: NumberSumsDifficulty.easy),
              ));
            }),
            const SizedBox(height: 8),
            _buildDifficultyButton(context, title: 'common.normal'.tr(), subtitle: '7x7', onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const NumberSumsGameScreen(initialDifficulty: NumberSumsDifficulty.medium),
              ));
            }),
            const SizedBox(height: 8),
            _buildDifficultyButton(context, title: 'common.hard'.tr(), subtitle: '8x8', onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const NumberSumsGameScreen(initialDifficulty: NumberSumsDifficulty.hard),
              ));
            }),
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
        onTap: () => game.onTap(context),
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
  final void Function(BuildContext) onTap;

  const _GameInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
