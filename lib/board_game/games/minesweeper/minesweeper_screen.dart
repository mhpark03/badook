import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import '../../l10n/board_game_strings.dart';
import '../../services/game_save_service.dart';
import '../../../../services/web_ad_helper.dart';

enum CellState { hidden, revealed, flagged }

enum MinesweeperDifficulty {
  easy,   // 9x9, 10개 지뢰
  medium, // 16x16, 40개 지뢰
  hard,   // 24x16, 75개 지뢰
}

class MinesweeperCell {
  bool hasMine;
  CellState state;
  int adjacentMines;

  MinesweeperCell({
    this.hasMine = false,
    this.state = CellState.hidden,
    this.adjacentMines = 0,
  });

  MinesweeperCell copy() {
    return MinesweeperCell(
      hasMine: hasMine,
      state: state,
      adjacentMines: adjacentMines,
    );
  }
}

class MinesweeperScreen extends StatefulWidget {
  final MinesweeperDifficulty difficulty;
  final bool resumeGame;

  const MinesweeperScreen({
    super.key,
    this.difficulty = MinesweeperDifficulty.easy,
    this.resumeGame = false,
  });

  static Future<bool> hasSavedGame() async {
    return await GameSaveService.hasSavedGame('minesweeper');
  }

  static Future<MinesweeperDifficulty?> getSavedDifficulty() async {
    final gameState = await GameSaveService.loadGame('minesweeper');
    if (gameState == null) return null;
    final difficultyIndex = gameState['difficulty'] as int?;
    if (difficultyIndex == null) return null;
    return MinesweeperDifficulty.values[difficultyIndex];
  }

  static Future<void> clearSavedGame() async {
    await GameSaveService.clearSave();
  }

  @override
  State<MinesweeperScreen> createState() => _MinesweeperScreenState();
}

class _MinesweeperScreenState extends State<MinesweeperScreen> {
  late int rows;
  late int cols;
  late int totalMines;
  late List<List<MinesweeperCell>> board;

  bool gameOver = false;
  bool gameWon = false;
  bool firstClick = true;
  int flagCount = 0;
  int revealedCount = 0;

  // 타이머
  int elapsedSeconds = 0;
  DateTime? startTime;

  // 롱프레스 상태 추적 (탭과 롱프레스 구분)
  Timer? _longPressTimer;
  bool _longPressTriggered = false;
  static const _longPressDuration = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    _setupDifficulty();
    if (widget.resumeGame) {
      _loadGame();
    } else {
      _initBoard();
    }
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    super.dispose();
  }

  void _setupDifficulty() {
    switch (widget.difficulty) {
      case MinesweeperDifficulty.easy:
        rows = 9;
        cols = 9;
        totalMines = 10;
        break;
      case MinesweeperDifficulty.medium:
        rows = 16;
        cols = 16;
        totalMines = 40;
        break;
      case MinesweeperDifficulty.hard:
        rows = 24;
        cols = 16;
        totalMines = 75;
        break;
    }
  }

  void _initBoard() {
    board = List.generate(
      rows,
      (_) => List.generate(cols, (_) => MinesweeperCell()),
    );
    gameOver = false;
    gameWon = false;
    firstClick = true;
    flagCount = 0;
    revealedCount = 0;
    elapsedSeconds = 0;
    startTime = null;
  }

  // 부활 다이얼로그 (폭탄 터트렸을 때)
  void _showReviveAdDialog(int row, int col) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Row(
          children: [
            const Icon(Icons.warning_amber, color: Colors.redAccent, size: 28),
            const SizedBox(width: 8),
            Text('games.minesweeper.mineExploded'.tr(), style: const TextStyle(color: Colors.redAccent)),
          ],
        ),
        content: Text(
          'dialog.continueMessage'.tr(),
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // 게임 오버 처리
              setState(() {
                gameOver = true;
                _revealAllMines();
              });
              _saveGame();
            },
            child: Text('common.giveUp'.tr(), style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // 부활: 해당 셀을 깃발로 표시
              setState(() {
                board[row][col].state = CellState.flagged;
                flagCount++;
              });
              _saveGame();
            },
            child: Text('common.continue'.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }

  // 힌트
  void _showHintAdDialog() {
    if (gameOver || gameWon || firstClick) return;
    _useHint();
  }

  // 힌트 사용: 안전한 셀 하나를 자동으로 열기
  void _useHint() {
    if (gameOver || gameWon || firstClick) return;

    // 안전한 숨겨진 셀 찾기
    List<List<int>> safeCells = [];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (board[r][c].state == CellState.hidden && !board[r][c].hasMine) {
          safeCells.add([r, c]);
        }
      }
    }

    if (safeCells.isEmpty) return;

    // 랜덤으로 하나 선택하여 열기
    final random = Random();
    final selected = safeCells[random.nextInt(safeCells.length)];

    _revealCell(selected[0], selected[1]);
    _saveGame();
    HapticFeedback.mediumImpact();
  }

  void _placeMines(int excludeRow, int excludeCol) {
    final random = Random();
    int placedMines = 0;

    while (placedMines < totalMines) {
      int r = random.nextInt(rows);
      int c = random.nextInt(cols);

      // 첫 클릭 위치와 주변 8칸은 지뢰 배치 제외
      if ((r - excludeRow).abs() <= 1 && (c - excludeCol).abs() <= 1) {
        continue;
      }

      if (!board[r][c].hasMine) {
        board[r][c].hasMine = true;
        placedMines++;
      }
    }

    // 인접 지뢰 수 계산
    _calculateAdjacentMines();
  }

  void _calculateAdjacentMines() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (!board[r][c].hasMine) {
          int count = 0;
          for (int dr = -1; dr <= 1; dr++) {
            for (int dc = -1; dc <= 1; dc++) {
              int nr = r + dr;
              int nc = c + dc;
              if (nr >= 0 && nr < rows && nc >= 0 && nc < cols) {
                if (board[nr][nc].hasMine) count++;
              }
            }
          }
          board[r][c].adjacentMines = count;
        }
      }
    }
  }

  void _onCellTap(int row, int col) {
    if (gameOver || gameWon) return;
    if (board[row][col].state != CellState.hidden) return;

    if (firstClick) {
      firstClick = false;
      startTime = DateTime.now();
      _placeMines(row, col);
    }

    _revealCell(row, col);
    _saveGame();
  }

  void _revealCell(int row, int col) {
    if (row < 0 || row >= rows || col < 0 || col >= cols) return;
    if (board[row][col].state != CellState.hidden) return;

    setState(() {
      board[row][col].state = CellState.revealed;
      revealedCount++;

      if (board[row][col].hasMine) {
        HapticFeedback.heavyImpact();
        // 부활 기회 제공
        board[row][col].state = CellState.hidden;
        revealedCount--;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showReviveAdDialog(row, col);
        });
        return;
      }

      // 주변 지뢰가 없으면 주변 셀도 열기
      if (board[row][col].adjacentMines == 0) {
        for (int dr = -1; dr <= 1; dr++) {
          for (int dc = -1; dc <= 1; dc++) {
            if (dr == 0 && dc == 0) continue;
            _revealCell(row + dr, col + dc);
          }
        }
      }

      // 승리 체크
      _checkWin();
    });
  }

  void _onCellLongPress(int row, int col) {
    if (gameOver || gameWon) return;
    if (board[row][col].state == CellState.revealed) return;

    setState(() {
      if (board[row][col].state == CellState.hidden) {
        board[row][col].state = CellState.flagged;
        flagCount++;
      } else {
        board[row][col].state = CellState.hidden;
        flagCount--;
      }
    });
    HapticFeedback.lightImpact();
    _saveGame();
  }

  void _revealAllMines() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (board[r][c].hasMine) {
          board[r][c].state = CellState.revealed;
        }
      }
    }
  }

  void _checkWin() {
    int totalCells = rows * cols;
    int safeCells = totalCells - totalMines;
    if (revealedCount == safeCells) {
      gameWon = true;
      WebAdHelper.showAd();
      HapticFeedback.heavyImpact();
      MinesweeperScreen.clearSavedGame();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showVictoryDialog();
      });
    }
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 32),
            const SizedBox(width: 8),
            Text('common.win'.tr(), style: const TextStyle(color: Colors.green)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'games.minesweeper.victoryMessage'.tr(),
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.flag, color: Colors.red, size: 20),
                const SizedBox(width: 4),
                Text(
                  '$totalMines ${'games.minesweeper.mines'.tr()}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.grid_on, color: Colors.blueGrey, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${rows}x$cols',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('common.exit'.tr(), style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _restartGame();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: Text('app.restart'.tr()),
          ),
        ],
      ),
    );
  }

  Future<void> _saveGame() async {
    if (gameOver || gameWon || firstClick) {
      await MinesweeperScreen.clearSavedGame();
      return;
    }

    final boardData = board.map((row) => row.map((cell) {
      return {
        'hasMine': cell.hasMine,
        'state': cell.state.index,
        'adjacentMines': cell.adjacentMines,
      };
    }).toList()).toList();

    final gameState = {
      'board': boardData,
      'difficulty': widget.difficulty.index,
      'flagCount': flagCount,
      'revealedCount': revealedCount,
      'elapsedSeconds': elapsedSeconds,
    };

    await GameSaveService.saveGame('minesweeper', gameState);
  }

  Future<void> _loadGame() async {
    final gameState = await GameSaveService.loadGame('minesweeper');

    if (gameState == null) {
      _initBoard();
      return;
    }

    final boardData = gameState['board'] as List;
    board = boardData.map<List<MinesweeperCell>>((row) {
      return (row as List).map<MinesweeperCell>((cellData) {
        final cell = cellData as Map<String, dynamic>;
        return MinesweeperCell(
          hasMine: cell['hasMine'] as bool,
          state: CellState.values[cell['state'] as int],
          adjacentMines: cell['adjacentMines'] as int,
        );
      }).toList();
    }).toList();

    setState(() {
      flagCount = gameState['flagCount'] as int? ?? 0;
      revealedCount = gameState['revealedCount'] as int? ?? 0;
      elapsedSeconds = gameState['elapsedSeconds'] as int? ?? 0;
      firstClick = false;
      gameOver = false;
      gameWon = false;
    });
  }

  void _restartGame() {
    setState(() {
      _initBoard();
    });
    MinesweeperScreen.clearSavedGame();
  }

  Color _getNumberColor(int number) {
    switch (number) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      case 4:
        return Colors.purple;
      case 5:
        return Colors.brown;
      case 6:
        return Colors.cyan;
      case 7:
        return Colors.black;
      case 8:
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return _buildLandscapeLayout();
        } else {
          return _buildPortraitLayout();
        }
      },
    );
  }

  Widget _buildPortraitLayout() {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade800,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.terrain, color: Colors.blueGrey),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'games.minesweeper.name'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blueGrey.shade100,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showRulesDialog,
            tooltip: 'app.rules'.tr(),
          ),
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            onPressed: (!firstClick && !gameOver && !gameWon) ? _showHintAdDialog : null,
            tooltip: 'common.hint'.tr(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _restartGame,
            tooltip: 'app.restart'.tr(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildInfoPanel(isLandscape: false),
            Expanded(
              child: _buildGameBoard(isLandscape: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout() {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade900,
        child: SafeArea(
          child: Row(
            children: [
              // 왼쪽 패널: 뒤로가기, 제목, 게임 결과
              SizedBox(
                width: 140,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white70),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Icon(Icons.terrain, color: Colors.blueGrey, size: 32),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        'games.minesweeper.name'.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blueGrey.shade100,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    if (gameOver || gameWon) ...[
                      _buildCompactResultMessage(),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
              // 중앙: 게임 보드 (가로 모드에서 회전)
              Expanded(
                child: Center(
                  child: _buildGameBoard(isLandscape: true),
                ),
              ),
              // 오른쪽 패널: 정보, 새로고침
              SizedBox(
                width: 140,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildHintButton(),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.white70),
                          onPressed: _restartGame,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildVerticalInfo(),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHintButton() {
    final isEnabled = !firstClick && !gameOver && !gameWon;
    return IconButton(
      icon: Icon(
        Icons.lightbulb_outline,
        color: isEnabled ? Colors.amber : Colors.white30,
      ),
      onPressed: isEnabled ? _showHintAdDialog : null,
    );
  }

  Widget _buildCompactResultMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: gameWon
            ? Colors.green.withValues(alpha: 0.2)
            : Colors.red.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: gameWon ? Colors.green : Colors.red,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            gameWon ? Icons.emoji_events : Icons.sentiment_very_dissatisfied,
            color: gameWon ? Colors.amber : Colors.red,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            gameWon ? 'common.win'.tr() : 'common.lose'.tr(),
            style: TextStyle(
              color: gameWon ? Colors.green : Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.flag, color: Colors.red, size: 24),
          const SizedBox(height: 4),
          Text(
            '${totalMines - flagCount}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            'games.minesweeper.mines'.tr(),
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 16),
          const Icon(Icons.check_circle, color: Colors.green, size: 24),
          const SizedBox(height: 4),
          Text(
            '$revealedCount',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            '/ ${rows * cols - totalMines}',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.flag, color: Colors.red, size: 18),
          const SizedBox(width: 4),
          Text(
            '${totalMines - flagCount}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.check_circle, color: Colors.green, size: 18),
          const SizedBox(width: 4),
          Text(
            '$revealedCount/${rows * cols - totalMines}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPanel({required bool isLandscape}) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: isLandscape
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatusCard(),
                const SizedBox(height: 16),
                if (gameOver || gameWon) _buildResultMessage(),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildInfoItem(
                      icon: Icons.flag,
                      iconColor: Colors.red,
                      value: '${totalMines - flagCount}',
                      label: 'games.minesweeper.mines'.tr(),
                    ),
                    _buildInfoItem(
                      icon: Icons.check_circle,
                      iconColor: Colors.green,
                      value: '$revealedCount/${rows * cols - totalMines}',
                      label: 'games.minesweeper.progress'.tr(),
                    ),
                  ],
                ),
                if (gameOver || gameWon) ...[
                  const SizedBox(height: 12),
                  _buildResultMessage(),
                ],
              ],
            ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blueGrey.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          _buildInfoItem(
            icon: Icons.flag,
            iconColor: Colors.red,
            value: '${totalMines - flagCount}',
            label: 'games.minesweeper.mines'.tr(),
          ),
          const SizedBox(height: 12),
          _buildInfoItem(
            icon: Icons.check_circle,
            iconColor: Colors.green,
            value: '$revealedCount/${rows * cols - totalMines}',
            label: 'games.minesweeper.progress'.tr(),
          ),
        ],
      ),
    );
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

  Widget _buildResultMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: gameWon
            ? Colors.green.withValues(alpha: 0.2)
            : Colors.red.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: gameWon ? Colors.green : Colors.red,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            gameWon ? Icons.emoji_events : Icons.sentiment_very_dissatisfied,
            color: gameWon ? Colors.amber : Colors.red,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            gameWon ? 'common.win'.tr() : 'common.lose'.tr(),
            style: TextStyle(
              color: gameWon ? Colors.green : Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameBoard({required bool isLandscape}) {
    // 가로 모드에서는 행/열을 바꿔서 표시 (90도 회전 효과)
    final displayRows = isLandscape ? cols : rows;
    final displayCols = isLandscape ? rows : cols;

    return Center(
      child: AspectRatio(
        aspectRatio: displayCols / displayRows,
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.blueGrey.shade600,
              width: 3,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: displayCols,
              ),
              itemCount: rows * cols,
              itemBuilder: (context, index) {
                final displayRow = index ~/ displayCols;
                final displayCol = index % displayCols;

                // 가로 모드에서 좌표 변환 (90도 시계방향 회전)
                int dataRow, dataCol;
                if (isLandscape) {
                  dataRow = displayCol;
                  dataCol = cols - 1 - displayRow;
                } else {
                  dataRow = displayRow;
                  dataCol = displayCol;
                }

                return _buildCell(dataRow, dataCol);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCell(int row, int col) {
    final cell = board[row][col];

    return Listener(
      onPointerDown: (event) {
        // 마우스 오른쪽 버튼 클릭 시 즉시 깃발 처리
        if (event.kind == PointerDeviceKind.mouse &&
            event.buttons == kSecondaryMouseButton) {
          _onCellLongPress(row, col);
          return;
        }

        // 왼쪽 버튼 또는 터치: 롱프레스 타이머 시작
        _longPressTriggered = false;
        _longPressTimer?.cancel();
        _longPressTimer = Timer(_longPressDuration, () {
          _longPressTriggered = true;
          _onCellLongPress(row, col);
        });
      },
      onPointerUp: (event) {
        _longPressTimer?.cancel();
        _longPressTimer = null;

        // 오른쪽 버튼은 이미 처리됨
        if (event.kind == PointerDeviceKind.mouse &&
            (event.buttons == kSecondaryMouseButton ||
             event.pointer == 0)) {
          // 오른쪽 버튼 up은 무시 (이미 down에서 처리)
        }

        // 롱프레스가 이미 트리거되지 않았으면 일반 탭 처리
        if (!_longPressTriggered) {
          _onCellTap(row, col);
        }
        _longPressTriggered = false;
      },
      onPointerCancel: (_) {
        _longPressTimer?.cancel();
        _longPressTimer = null;
        _longPressTriggered = false;
      },
      child: Container(
        decoration: BoxDecoration(
          color: _getCellColor(cell),
          border: Border.all(
            color: Colors.grey.shade800,
            width: 1,
          ),
        ),
        child: Center(
          child: _getCellContent(cell),
        ),
      ),
    );
  }

  Color _getCellColor(MinesweeperCell cell) {
    if (cell.state == CellState.hidden || cell.state == CellState.flagged) {
      return Colors.blueGrey.shade500;
    }
    if (cell.hasMine) {
      return Colors.red.shade400;
    }
    return Colors.grey.shade300;
  }

  Widget? _getCellContent(MinesweeperCell cell) {
    if (cell.state == CellState.flagged) {
      return const Icon(
        Icons.flag,
        color: Colors.red,
        size: 18,
      );
    }

    if (cell.state == CellState.hidden) {
      return null;
    }

    if (cell.hasMine) {
      return Icon(
        Icons.brightness_7,
        color: Colors.black,
        size: 18,
      );
    }

    if (cell.adjacentMines > 0) {
      return Text(
        '${cell.adjacentMines}',
        style: TextStyle(
          color: _getNumberColor(cell.adjacentMines),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );
    }

    return null;
  }

  void _showRulesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'games.minesweeper.rulesTitle'.tr(),
          style: const TextStyle(color: Colors.blueGrey),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🎯 ${'games.minesweeper.rulesObjective'.tr()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'games.minesweeper.rulesObjectiveDesc'.tr(),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Text(
                '🎮 ${'games.minesweeper.rulesControls'.tr()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'games.minesweeper.rulesControlsDesc'.tr(),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Text(
                '🔢 ${'games.minesweeper.rulesNumbers'.tr()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'games.minesweeper.rulesNumbersDesc'.tr(),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Text(
                '💡 ${'games.minesweeper.rulesTips'.tr()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'games.minesweeper.rulesTipsDesc'.tr(),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('app.confirm'.tr()),
          ),
        ],
      ),
    );
  }
}
