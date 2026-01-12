import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/board_game_strings.dart';
import '../models/samurai_game_state.dart';
import '../models/samurai_sudoku_generator.dart';
import '../services/game_storage.dart';
import '../widgets/samurai_board.dart';
import '../widgets/game_status_bar.dart';
import 'expanded_board_screen.dart';

class SamuraiGameScreen extends StatefulWidget {
  final SamuraiDifficulty? initialDifficulty;
  final SamuraiGameState? savedGameState;

  const SamuraiGameScreen({
    super.key,
    this.initialDifficulty,
    this.savedGameState,
  });

  @override
  State<SamuraiGameScreen> createState() => _SamuraiGameScreenState();
}

class _SamuraiGameScreenState extends State<SamuraiGameScreen>
    with WidgetsBindingObserver {
  late SamuraiGameState _gameState;
  late SamuraiDifficulty _selectedDifficulty;
  bool _isLoading = true;

  // 게임 타이머 및 통계
  Timer? _timer;
  int _elapsedSeconds = 0;
  int _failureCount = 0;
  bool _isPaused = false;
  bool _isBackgrounded = false; // 백그라운드 상태 (타이머만 멈춤, 화면 표시 안함)

  // 빠른 입력 모드 상태 (보드 간 이동 시 유지)
  bool _isQuickInputMode = false;
  int? _quickInputNumber;
  bool _isNoteMode = false;

  // 마지막으로 설정한 방향 (SystemChrome 중복 호출 방지)
  Orientation? _lastOrientation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.savedGameState != null) {
      // 저장된 게임 불러오기
      _gameState = widget.savedGameState!;
      _selectedDifficulty = _gameState.difficulty;
      // 저장된 게임 통계 복원
      _elapsedSeconds = _gameState.elapsedSeconds;
      _failureCount = _gameState.failureCount;
      _isLoading = false;
      _startTimer();
    } else {
      // 새 게임 시작
      _selectedDifficulty = widget.initialDifficulty ?? SamuraiDifficulty.medium;
      _startNewGame();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 앱이 백그라운드로 갈 때 타이머만 멈춤 (일시정지 화면 표시 안함)
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (!_isLoading && !_gameState.isCompleted) {
        setState(() {
          _isBackgrounded = true;
        });
      }
    } else if (state == AppLifecycleState.resumed) {
      // 앱이 포그라운드로 돌아오면 백그라운드 상태 해제
      setState(() {
        _isBackgrounded = false;
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && !_isBackgrounded && !_gameState.isCompleted) {
        setState(() {
          _elapsedSeconds++;
        });
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  Future<void> _startNewGame() async {
    // 새 게임 시작 시 모든 저장된 게임 삭제
    await GameStorage.deleteAllGames();

    setState(() {
      _isLoading = true;
    });

    // 별도 isolate에서 퍼즐 생성 (메인 스레드 블로킹 방지)
    final data = await compute(
      generateSamuraiPuzzleInIsolate,
      _selectedDifficulty,
    );

    if (mounted) {
      setState(() {
        _gameState = SamuraiGameState.fromGeneratedData(data);
        _isLoading = false;
        _elapsedSeconds = 0;
        _failureCount = 0;
        _isPaused = false;
      });
      _startTimer();
      _saveGame();
    }
  }

  /// 게임 상태 저장
  void _saveGame() {
    if (!_gameState.isCompleted) {
      // 현재 게임 통계를 게임 상태에 업데이트
      _gameState.elapsedSeconds = _elapsedSeconds;
      _gameState.failureCount = _failureCount;
      GameStorage.saveSamuraiGame(_gameState);
    } else {
      // 게임 완료 시 저장된 게임 삭제
      GameStorage.deleteSamuraiGame();
    }
  }

  void _onBoardSelect(int boardIndex) {
    setState(() {
      _gameState = _gameState.copyWith(
        selectedBoard: boardIndex,
        clearSelection: true,
      );
    });
  }

  void _onCellTap(int board, int row, int col) {
    // 셀 탭 시 확대 다이얼로그 표시
    _showExpandedBoard(board, row, col);
  }

  void _showExpandedBoard(int board, int? row, int? col) async {
    final result = await Navigator.push<ExpandedBoardResult>(
      context,
      MaterialPageRoute(
        builder: (context) => ExpandedBoardScreen(
          gameState: _gameState,
          boardIndex: board,
          initialRow: row,
          initialCol: col,
          elapsedSeconds: _elapsedSeconds,
          failureCount: _failureCount,
          isPaused: _isPaused,
          onPauseToggle: _togglePause,
          onFailure: () {
            setState(() {
              _failureCount++;
            });
          },
          onElapsedSecondsUpdate: (seconds) {
            _elapsedSeconds = seconds;
          },
          onValueChanged: (b, r, c, value) {
            _gameState.currentBoards[b][r][c] = value;
            _gameState.syncOverlapValue(b, r, c, value);
            // 값 입력 시 해당 셀의 메모 삭제 및 관련 셀의 메모에서 숫자 제거
            if (value != 0) {
              _gameState.clearNotes(b, r, c);
              _gameState.removeNumberFromAllRelatedNotes(b, r, c, value);
            }
          },
          onHint: (b, r, c) {
            int correctValue = _gameState.solutions[b][r][c];
            _gameState.currentBoards[b][r][c] = correctValue;
            _gameState.syncOverlapValue(b, r, c, correctValue);
            _gameState.clearNotes(b, r, c);
            _gameState.removeNumberFromAllRelatedNotes(b, r, c, correctValue);
          },
          onNoteToggle: (b, r, c, number) {
            _gameState.toggleNote(b, r, c, number);
          },
          onFillAllNotes: (b) {
            _gameState.fillAllNotes(b);
          },
          onComplete: () {
            _timer?.cancel();
            _gameState.isCompleted = true;
            _showCompletionDialog();
          },
          // 빠른 입력 모드 상태 전달
          initialQuickInputMode: _isQuickInputMode,
          initialQuickInputNumber: _quickInputNumber,
          initialNoteMode: _isNoteMode,
        ),
      ),
    );
    // ExpandedBoardScreen에서 돌아온 후 빠른 입력 모드 상태 저장
    if (result != null) {
      _isQuickInputMode = result.isQuickInputMode;
      _quickInputNumber = result.quickInputNumber;
      _isNoteMode = result.isNoteMode;
    }
    // 상태 갱신 및 저장
    setState(() {});
    _saveGame();
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showCompletionDialog() {
    // 완료된 게임 삭제
    GameStorage.deleteSamuraiGame();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('${'common.congratulations'.tr()} 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('games.sudoku.samuraiCompletedMessage'.tr()),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.timer, size: 20, color: Colors.blue),
                const SizedBox(width: 8),
                Text('common.elapsedTime'.tr(namedArgs: {'time': _formatTime(_elapsedSeconds)})),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.close, size: 20, color: Colors.red),
                const SizedBox(width: 8),
                Text('common.failureCount'.tr(namedArgs: {'count': '$_failureCount'})),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 팝업 닫기
              Navigator.pop(context); // 홈 화면으로 이동
            },
            child: Text('app.confirm'.tr()),
          ),
        ],
      ),
    );
  }

  void _showDifficultyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('dialog.selectDifficulty'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: SamuraiDifficulty.values.map((difficulty) {
            String label;
            switch (difficulty) {
              case SamuraiDifficulty.easy:
                label = 'common.easy'.tr();
                break;
              case SamuraiDifficulty.medium:
                label = 'common.normal'.tr();
                break;
              case SamuraiDifficulty.hard:
                label = 'common.hard'.tr();
                break;
            }
            return ListTile(
              title: Text(label),
              leading: Icon(
                _selectedDifficulty == difficulty
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: Colors.blue,
              ),
              onTap: () {
                setState(() {
                  _selectedDifficulty = difficulty;
                });
                Navigator.pop(context);
                _startNewGame();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getDifficultyText() {
    switch (_selectedDifficulty) {
      case SamuraiDifficulty.easy:
        return 'common.easy'.tr();
      case SamuraiDifficulty.medium:
        return 'common.normal'.tr();
      case SamuraiDifficulty.hard:
        return 'common.hard'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return _buildLandscapeLayout(context);
        } else {
          return _buildPortraitLayout(context);
        }
      },
    );
  }

  // 세로 모드 레이아웃
  Widget _buildPortraitLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('games.sudoku.samuraiName'.tr()),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _showRulesDialog,
            icon: const Icon(Icons.help_outline, color: Colors.white),
            tooltip: 'app.rules'.tr(),
          ),
          TextButton.icon(
            onPressed: _showDifficultyDialog,
            icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
            label: Text(
              'app.newGame'.tr(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text('common.generatingPuzzle'.tr()),
                ],
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // 게임 상태 표시 바
                    GameStatusBar(
                      elapsedSeconds: _elapsedSeconds,
                      failureCount: _failureCount,
                      isPaused: _isPaused,
                      onPauseToggle: _togglePause,
                      difficultyText: _getDifficultyText(),
                      themeColor: Colors.deepPurple,
                    ),
                    const SizedBox(height: 8),
                    // 안내 텍스트
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'games.sudoku.tapCellToEdit'.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    // 사무라이 보드 또는 일시정지 오버레이
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: _isPaused
                              ? _buildPausedOverlay()
                              : SamuraiBoard(
                                  gameState: _gameState,
                                  onCellTap: _onCellTap,
                                  onBoardSelect: _onBoardSelect,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  // 가로 모드 레이아웃 (오목 스타일)
  Widget _buildLandscapeLayout(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.deepPurple.shade900,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 16),
              Text('common.generatingPuzzle'.tr(), style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade700,
              Colors.deepPurple.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // 메인 영역: 보드 + 상태 정보
              Row(
                children: [
                  // 왼쪽: 게임 보드 (최대 크기)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(140, 8, 8, 8),
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: _isPaused
                              ? _buildPausedOverlay()
                              : SamuraiBoard(
                                  gameState: _gameState,
                                  onCellTap: _onCellTap,
                                  onBoardSelect: _onBoardSelect,
                                ),
                        ),
                      ),
                    ),
                  ),
                  // 오른쪽: 상태 정보
                  SizedBox(
                    width: 140,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40), // 상단 버튼 공간
                          _buildLandscapeStatusInfo(),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // 왼쪽 상단: 뒤로가기 + 제목 + 안내
              Positioned(
                top: 4,
                left: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildCircleButton(
                          icon: Icons.arrow_back,
                          onPressed: () => Navigator.pop(context),
                          tooltip: 'common.back'.tr(),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'games.sudoku.samuraiName'.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 52, top: 4),
                      child: Text(
                        'games.sudoku.tapCellToEdit'.tr(),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 오른쪽 상단: 새 게임 버튼
              Positioned(
                top: 4,
                right: 4,
                child: _buildCircleButton(
                  icon: Icons.refresh,
                  onPressed: _showDifficultyDialog,
                  tooltip: 'app.newGame'.tr(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 원형 버튼 위젯
  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
    final isEnabled = onPressed != null;
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.3,
      child: Material(
        color: Colors.black.withValues(alpha: 0.5),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Tooltip(
            message: tooltip,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Icon(
                icon,
                color: Colors.white70,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 가로 모드용 상태 정보
  Widget _buildLandscapeStatusInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          // 난이도
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getDifficultyText(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 시간 + 일시정지 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer, size: 18, color: Colors.white70),
              const SizedBox(width: 4),
              Text(
                _formatTime(_elapsedSeconds),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _togglePause,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                _isPaused ? Icons.play_arrow : Icons.pause,
                size: 24,
                color: Colors.white70,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 실패 횟수
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.close, size: 16, color: Colors.red.shade300),
              const SizedBox(width: 4),
              Text(
                '$_failureCount',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPausedOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pause_circle_outline,
              size: 64,
              color: Colors.grey.shade600,
            ),
            const SizedBox(height: 16),
            Text(
              'common.pause'.tr(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'common.resumeMessage'.tr(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
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
          'games.sudoku.rulesTitle'.tr(),
          style: const TextStyle(color: Colors.deepPurple),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'games.sudoku.rulesObjective'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'games.sudoku.samuraiRulesObjectiveDesc'.tr(),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Text(
                'games.sudoku.rulesBasic'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'games.sudoku.samuraiRulesBasicDesc'.tr(),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Text(
                'games.sudoku.samuraiRulesOverlap'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'games.sudoku.samuraiRulesOverlapDesc'.tr(),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Text(
                'games.sudoku.rulesTips'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'games.sudoku.samuraiRulesTipsDesc'.tr(),
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
