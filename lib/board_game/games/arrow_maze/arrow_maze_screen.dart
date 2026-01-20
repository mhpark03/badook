import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/board_game_strings.dart';
import 'models/game_state.dart';
import 'widgets/game_board.dart';

enum ArrowMazeDifficulty { easy, medium, hard }

class ArrowMazeScreen extends StatefulWidget {
  final ArrowMazeDifficulty difficulty;

  const ArrowMazeScreen({
    super.key,
    this.difficulty = ArrowMazeDifficulty.easy,
  });

  @override
  State<ArrowMazeScreen> createState() => _ArrowMazeScreenState();
}

class _ArrowMazeScreenState extends State<ArrowMazeScreen> {
  late ArrowMazeGameState _gameState;

  @override
  void initState() {
    super.initState();
    _gameState = ArrowMazeGameState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _gameState.startGame(widget.difficulty.index);
    });
  }

  @override
  void dispose() {
    _gameState.dispose();
    super.dispose();
  }

  void _showHint() {
    _gameState.showHint();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _gameState,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        appBar: AppBar(
          backgroundColor: const Color(0xFF2D2D44),
          foregroundColor: Colors.white,
          title: Text(
            'games.arrowMaze.name'.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () => _showHelpDialog(),
              tooltip: 'app.rules'.tr(),
            ),
            IconButton(
              icon: const Icon(Icons.lightbulb_outline),
              onPressed: _showHint,
              tooltip: 'common.hint'.tr(),
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: () => _gameState.resetLevel(),
              tooltip: 'app.newGame'.tr(),
            ),
          ],
        ),
        body: SafeArea(
          child: Consumer<ArrowMazeGameState>(
            builder: (context, gameState, child) {
              return Stack(
                children: [
                  Column(
                    children: [
                      _buildInfoPanel(gameState),
                      _buildInstructions(gameState),
                      const Expanded(child: ArrowMazeGameBoard()),
                    ],
                  ),
                  if (gameState.isLoading) _buildLoadingOverlay(),
                  if (gameState.isLevelComplete) _buildLevelCompleteOverlay(gameState),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPanel(ArrowMazeGameState gameState) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildInfoItem(
            icon: Icons.timer_outlined,
            iconColor: const Color(0xFFFFD93D),
            value: gameState.elapsedTimeString,
            label: 'games.arrowMaze.time'.tr(),
          ),
          _buildInfoItem(
            icon: Icons.close,
            iconColor: const Color(0xFFE74C3C),
            value: gameState.errorCount.toString(),
            label: 'games.arrowMaze.errors'.tr(),
          ),
          _buildInfoItem(
            icon: Icons.grid_view,
            iconColor: const Color(0xFF4ECDC4),
            value: '${ArrowMazeGameState.gridSizes[gameState.currentDifficulty]}x${ArrowMazeGameState.gridSizes[gameState.currentDifficulty]}',
            label: _getDifficultyName(gameState.currentDifficulty),
          ),
        ],
      ),
    );
  }

  String _getDifficultyName(int difficulty) {
    switch (difficulty) {
      case 0:
        return 'common.easy'.tr();
      case 1:
        return 'common.normal'.tr();
      case 2:
        return 'common.hard'.tr();
      default:
        return '';
    }
  }

  Widget _buildInfoItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions(ArrowMazeGameState gameState) {
    String statusText;
    Color statusColor;

    int flyingCount = gameState.flyingArrows.length;
    bool hasCollided = gameState.flyingArrows.any((a) => a.collided);

    if (gameState.isAnimating) {
      if (hasCollided) {
        statusText = 'games.arrowMaze.collision'.tr();
        statusColor = Colors.red;
      } else if (flyingCount > 1) {
        statusText = '${'games.arrowMaze.flying'.tr()} ($flyingCount)';
        statusColor = Colors.white70;
      } else {
        statusText = 'games.arrowMaze.flying'.tr();
        statusColor = gameState.flyingArrow?.color ?? Colors.white70;
      }
    } else {
      int remaining = gameState.level?.remainingPaths ?? 0;
      statusText = 'games.arrowMaze.tapArrow'.tr().replaceAll('{count}', remaining.toString());
      statusColor = Colors.white70;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: const Color(0xFF1A1A2E).withValues(alpha: 0.9),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: Color(0xFF4ECDC4),
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              'games.arrowMaze.loading'.tr(),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCompleteOverlay(ArrowMazeGameState gameState) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D44),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.celebration,
                color: Color(0xFFFFD93D),
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'games.arrowMaze.cleared'.tr().replaceAll('{difficulty}', _getDifficultyName(gameState.currentDifficulty)),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStatItem(Icons.timer_outlined, gameState.elapsedTimeString, const Color(0xFFFFD93D)),
                  const SizedBox(width: 24),
                  _buildStatItem(Icons.close, gameState.errorCount.toString(), const Color(0xFFE74C3C)),
                  const SizedBox(width: 24),
                  _buildStatItem(Icons.lightbulb_outline, gameState.hintCount.toString(), const Color(0xFF4ECDC4)),
                ],
              ),
              if (gameState.errorCount == 0 && gameState.hintCount == 0)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    'games.arrowMaze.perfect'.tr(),
                    style: const TextStyle(
                      color: Color(0xFFFFD93D),
                      fontSize: 16,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                    onPressed: () => gameState.resetLevel(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D2D44),
                      foregroundColor: Colors.white70,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'app.newGame'.tr(),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text('app.rules'.tr(), style: const TextStyle(color: Color(0xFF4ECDC4))),
        content: Text(
          '${'games.arrowMaze.help1'.tr()}\n\n'
          '${'games.arrowMaze.help2'.tr()}\n\n'
          '${'games.arrowMaze.help3'.tr()}\n\n'
          '${'games.arrowMaze.help4'.tr()}\n\n'
          '${'games.arrowMaze.help5'.tr()}',
          style: const TextStyle(color: Colors.white70, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.confirm'.tr(), style: const TextStyle(color: Color(0xFF4ECDC4))),
          ),
        ],
      ),
    );
  }
}
