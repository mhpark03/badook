import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../board_game/l10n/board_game_strings.dart';
import 'janggi_screen.dart';

class JanggiSelectionScreen extends StatefulWidget {
  final GameLanguage language;
  final Function(GameLanguage) onLanguageChanged;

  const JanggiSelectionScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  State<JanggiSelectionScreen> createState() => _JanggiSelectionScreenState();
}

class _JanggiSelectionScreenState extends State<JanggiSelectionScreen> {
  bool _hasSavedGame = false;
  JanggiGameMode? _savedGameMode;
  JanggiDifficulty? _savedDifficulty;

  @override
  void initState() {
    super.initState();
    _checkSavedGame();
  }

  Future<void> _checkSavedGame() async {
    final hasSaved = await JanggiScreen.hasSavedGame();
    final savedMode = await JanggiScreen.getSavedGameMode();
    final savedDifficulty = await JanggiScreen.getSavedDifficulty();
    if (mounted) {
      setState(() {
        _hasSavedGame = hasSaved;
        _savedGameMode = savedMode;
        _savedDifficulty = savedDifficulty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provider에서 언어 상태 읽기
    final languageProvider = context.watch<LanguageProvider>();
    final language = languageProvider.language;

    // 현재 언어 설정
    BoardGameStrings.currentLanguage = language;

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
        title: 'games.janggi.name'.tr(),
        language: language,
        onLanguageChanged: languageProvider.setLanguage,
      ),
      backgroundColor: const Color(0xFF8B4513), // 장기판 색상
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: Column(
                children: [
                  Wrap(
                    spacing: isSmallScreen ? 10 : 16,
                    runSpacing: isSmallScreen ? 10 : 16,
                    alignment: WrapAlignment.center,
                    children: [
                      // AI 대전
                      SizedBox(
                        width: tileWidth,
                        height: tileHeight,
                        child: _buildGameTile(
                          context: context,
                          title: 'games.janggi.vsAI'.tr(),
                          subtitle: 'games.janggi.vsAIDesc'.tr(),
                          icon: Icons.smart_toy,
                          color: const Color(0xFFCD853F),
                          iconSize: iconSize,
                          titleSize: titleSize,
                          subtitleSize: subtitleSize,
                          onTap: () => _showAIDifficultyDialog(context),
                        ),
                      ),
                      // 2인 대전
                      SizedBox(
                        width: tileWidth,
                        height: tileHeight,
                        child: _buildGameTile(
                          context: context,
                          title: 'games.janggi.vsHuman'.tr(),
                          subtitle: 'games.janggi.vsHumanDesc'.tr(),
                          icon: Icons.people,
                          color: const Color(0xFFDEB887),
                          iconSize: iconSize,
                          titleSize: titleSize,
                          subtitleSize: subtitleSize,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const JanggiScreen(
                                  gameMode: JanggiGameMode.vsHuman,
                                ),
                              ),
                            ).then((_) => _checkSavedGame());
                          },
                        ),
                      ),
                      // 이어하기 (저장된 게임이 있을 때만)
                      if (_hasSavedGame)
                        SizedBox(
                          width: tileWidth,
                          height: tileHeight,
                          child: _buildContinueTile(
                            context: context,
                            iconSize: iconSize,
                            titleSize: titleSize,
                            subtitleSize: subtitleSize,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAIDifficultyDialog(BuildContext context) {
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
              subtitle: 'games.janggi.playAsCho'.tr(),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JanggiScreen(
                      gameMode: JanggiGameMode.vsHan,
                      difficulty: JanggiDifficulty.easy,
                    ),
                  ),
                ).then((_) => _checkSavedGame());
              },
            ),
            const SizedBox(height: 8),
            _buildDifficultyButton(
              context,
              title: 'common.normal'.tr(),
              subtitle: 'games.janggi.playAsCho'.tr(),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JanggiScreen(
                      gameMode: JanggiGameMode.vsHan,
                      difficulty: JanggiDifficulty.normal,
                    ),
                  ),
                ).then((_) => _checkSavedGame());
              },
            ),
            const SizedBox(height: 8),
            _buildDifficultyButton(
              context,
              title: 'common.hard'.tr(),
              subtitle: 'games.janggi.playAsCho'.tr(),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JanggiScreen(
                      gameMode: JanggiGameMode.vsHan,
                      difficulty: JanggiDifficulty.hard,
                    ),
                  ),
                ).then((_) => _checkSavedGame());
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

  Widget _buildContinueTile({
    required BuildContext context,
    required double iconSize,
    required double titleSize,
    required double subtitleSize,
  }) {
    return _buildGameTile(
      context: context,
      title: 'games.janggi.continueGame'.tr(),
      subtitle: 'games.janggi.continueGameDesc'.tr(),
      icon: Icons.play_arrow,
      color: Colors.green[700]!,
      iconSize: iconSize,
      titleSize: titleSize,
      subtitleSize: subtitleSize,
      onTap: () {
        if (_savedGameMode != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JanggiScreen(
                gameMode: _savedGameMode!,
                resumeGame: true,
                difficulty: _savedDifficulty ?? JanggiDifficulty.normal,
              ),
            ),
          ).then((_) => _checkSavedGame());
        }
      },
    );
  }

  Widget _buildGameTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required double iconSize,
    required double titleSize,
    required double subtitleSize,
    required VoidCallback onTap,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;
        final availableWidth = constraints.maxWidth;
        final padding = availableHeight * 0.06;
        final dynamicIconSize = (availableHeight * 0.28).clamp(18.0, iconSize);
        final iconPadding = dynamicIconSize * 0.25;
        final dynamicTitleSize = (availableHeight * 0.11).clamp(11.0, titleSize);
        final dynamicSubtitleSize = (availableHeight * 0.08).clamp(8.0, subtitleSize);
        final spacing = availableHeight * 0.04;

        return Material(
          color: color,
          borderRadius: BorderRadius.circular(16),
          elevation: 4,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
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
                          icon,
                          color: Colors.white,
                          size: dynamicIconSize,
                        ),
                      ),
                      SizedBox(height: spacing),
                      Text(
                        title,
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
                        subtitle,
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
            ),
          ),
        );
      },
    );
  }
}
