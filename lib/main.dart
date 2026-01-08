import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:collection';
import 'dart:math';
import 'dart:convert';

void main() {
  runApp(const BadukApp());
}

// AI 난이도 설정
enum AIDifficulty { beginner, intermediate, advanced, expert }

// 언어 설정
enum GameLanguage { korean, english, japanese, chinese }

class L10n {
  static final Map<GameLanguage, Map<String, String>> _strings = {
    GameLanguage.korean: {
      'appTitle': '바둑',
      'vsAI': '바둑 - vs AI',
      'twoPlayer': '바둑 - 2인 대국',
      'playAsBlack': '컴퓨터와 대국 (흑)',
      'playAsWhite': '컴퓨터와 대국 (백)',
      'twoPlayerMode': '2인 대국',
      'boardSize': '보드 크기',
      'newGame': '새 게임',
      'pass': '패스',
      'black': '흑',
      'white': '백',
      'blackTurn': '흑의 차례입니다',
      'whiteTurn': '백의 차례입니다',
      'yourTurn': '당신의 차례입니다',
      'aiThinking': 'AI가 생각 중...',
      'aiPass': 'AI 패스',
      'blackPass': '흑 패스',
      'whitePass': '백 패스',
      'congratsWin': '축하합니다! 승리!',
      'aiWin': 'AI 승리!',
      'blackWin': '흑 승리!',
      'whiteWin': '백 승리!',
      'draw': '무승부!',
      'me': '나',
      'ai': 'AI',
      'captures': '따낸 돌',
      'koViolation': '패 규칙 위반입니다!',
      'beginner': '입문',
      'intermediate': '중급',
      'expert': '정식',
      'language': '언어',
      'aiLevel': 'AI 레벨',
      'aiEasy': '쉬움',
      'aiNormal': '보통',
      'aiHard': '어려움',
      'aiExpert': '최강',
      'hint': '힌트',
      'hintMessage': '추천 위치가 표시되었습니다',
      'noHint': '추천할 수 없습니다',
      'continue': '이어하기',
      'save': '저장',
      'load': '불러오기',
      'noSavedGame': '저장된 게임이 없습니다',
      'gameSaved': '게임이 저장되었습니다',
      'gameLoaded': '게임을 불러왔습니다',
      'savedGameInfo': '저장된 게임',
      'saveDate': '저장 시간',
      'moveCount': '수',
    },
    GameLanguage.english: {
      'appTitle': 'Go',
      'vsAI': 'Go - vs AI',
      'twoPlayer': 'Go - 2 Players',
      'playAsBlack': 'Play as Black',
      'playAsWhite': 'Play as White',
      'twoPlayerMode': '2 Players',
      'boardSize': 'Board Size',
      'newGame': 'New Game',
      'pass': 'Pass',
      'black': 'Black',
      'white': 'White',
      'blackTurn': "Black's turn",
      'whiteTurn': "White's turn",
      'yourTurn': 'Your turn',
      'aiThinking': 'AI thinking...',
      'aiPass': 'AI passed',
      'blackPass': 'Black passed',
      'whitePass': 'White passed',
      'congratsWin': 'Congratulations! You win!',
      'aiWin': 'AI wins!',
      'blackWin': 'Black wins!',
      'whiteWin': 'White wins!',
      'draw': 'Draw!',
      'me': 'Me',
      'ai': 'AI',
      'captures': 'Captures',
      'koViolation': 'Ko rule violation!',
      'beginner': 'Beginner',
      'intermediate': 'Intermediate',
      'expert': 'Expert',
      'language': 'Language',
      'aiLevel': 'AI Level',
      'aiEasy': 'Easy',
      'aiNormal': 'Normal',
      'aiHard': 'Hard',
      'aiExpert': 'Expert',
      'hint': 'Hint',
      'hintMessage': 'Recommended move shown',
      'noHint': 'No suggestion available',
      'continue': 'Continue',
      'save': 'Save',
      'load': 'Load',
      'noSavedGame': 'No saved game',
      'gameSaved': 'Game saved',
      'gameLoaded': 'Game loaded',
      'savedGameInfo': 'Saved Game',
      'saveDate': 'Save Time',
      'moveCount': 'Moves',
    },
    GameLanguage.japanese: {
      'appTitle': '囲碁',
      'vsAI': '囲碁 - vs AI',
      'twoPlayer': '囲碁 - 対人戦',
      'playAsBlack': '黒で対局',
      'playAsWhite': '白で対局',
      'twoPlayerMode': '対人戦',
      'boardSize': '盤面サイズ',
      'newGame': '新規対局',
      'pass': 'パス',
      'black': '黒',
      'white': '白',
      'blackTurn': '黒の番です',
      'whiteTurn': '白の番です',
      'yourTurn': 'あなたの番です',
      'aiThinking': 'AI思考中...',
      'aiPass': 'AIパス',
      'blackPass': '黒パス',
      'whitePass': '白パス',
      'congratsWin': 'おめでとう！勝利！',
      'aiWin': 'AI勝利！',
      'blackWin': '黒勝利！',
      'whiteWin': '白勝利！',
      'draw': '引き分け！',
      'me': '自分',
      'ai': 'AI',
      'captures': 'アゲハマ',
      'koViolation': 'コウ違反です！',
      'beginner': '入門',
      'intermediate': '中級',
      'expert': '上級',
      'language': '言語',
      'aiLevel': 'AIレベル',
      'aiEasy': '簡単',
      'aiNormal': '普通',
      'aiHard': '難しい',
      'aiExpert': '最強',
      'hint': 'ヒント',
      'hintMessage': 'おすすめの手を表示しました',
      'noHint': '提案できません',
      'continue': '続きから',
      'save': '保存',
      'load': '読込',
      'noSavedGame': '保存されたゲームがありません',
      'gameSaved': 'ゲームを保存しました',
      'gameLoaded': 'ゲームを読み込みました',
      'savedGameInfo': '保存されたゲーム',
      'saveDate': '保存時間',
      'moveCount': '手数',
    },
    GameLanguage.chinese: {
      'appTitle': '围棋',
      'vsAI': '围棋 - vs AI',
      'twoPlayer': '围棋 - 双人对战',
      'playAsBlack': '执黑对局',
      'playAsWhite': '执白对局',
      'twoPlayerMode': '双人对战',
      'boardSize': '棋盘大小',
      'newGame': '新对局',
      'pass': '跳过',
      'black': '黑',
      'white': '白',
      'blackTurn': '黑方回合',
      'whiteTurn': '白方回合',
      'yourTurn': '你的回合',
      'aiThinking': 'AI思考中...',
      'aiPass': 'AI跳过',
      'blackPass': '黑方跳过',
      'whitePass': '白方跳过',
      'congratsWin': '恭喜！你赢了！',
      'aiWin': 'AI获胜！',
      'blackWin': '黑方获胜！',
      'whiteWin': '白方获胜！',
      'draw': '平局！',
      'me': '我',
      'ai': 'AI',
      'captures': '提子',
      'koViolation': '违反劫争规则！',
      'beginner': '入门',
      'intermediate': '中级',
      'expert': '高级',
      'language': '语言',
      'aiLevel': 'AI等级',
      'aiEasy': '简单',
      'aiNormal': '普通',
      'aiHard': '困难',
      'aiExpert': '最强',
      'hint': '提示',
      'hintMessage': '已显示推荐位置',
      'noHint': '无法提供建议',
      'continue': '继续游戏',
      'save': '保存',
      'load': '读取',
      'noSavedGame': '没有保存的游戏',
      'gameSaved': '游戏已保存',
      'gameLoaded': '游戏已读取',
      'savedGameInfo': '已保存的游戏',
      'saveDate': '保存时间',
      'moveCount': '手数',
    },
  };

  static String get(GameLanguage lang, String key) {
    return _strings[lang]?[key] ?? key;
  }

  static String getLanguageName(GameLanguage lang) {
    switch (lang) {
      case GameLanguage.korean:
        return '한국어';
      case GameLanguage.english:
        return 'English';
      case GameLanguage.japanese:
        return '日本語';
      case GameLanguage.chinese:
        return '中文';
    }
  }
}

class BadukApp extends StatefulWidget {
  const BadukApp({super.key});

  @override
  State<BadukApp> createState() => _BadukAppState();
}

class _BadukAppState extends State<BadukApp> {
  GameLanguage _language = GameLanguage.korean;

  void _setLanguage(GameLanguage lang) {
    setState(() {
      _language = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: L10n.get(_language, 'appTitle'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: GameModeSelector(
        language: _language,
        onLanguageChanged: _setLanguage,
      ),
    );
  }
}

class GameModeSelector extends StatefulWidget {
  final GameLanguage language;
  final Function(GameLanguage) onLanguageChanged;

  const GameModeSelector({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  State<GameModeSelector> createState() => _GameModeSelectorState();
}

class _GameModeSelectorState extends State<GameModeSelector> {
  AIDifficulty _selectedDifficulty = AIDifficulty.intermediate;
  Map<String, dynamic>? _savedGameInfo;

  @override
  void initState() {
    super.initState();
    _checkSavedGame();
  }

  Future<void> _checkSavedGame() async {
    final info = await _BadukGameState.getSavedGameInfo();
    if (mounted) {
      setState(() {
        _savedGameInfo = info;
      });
    }
  }

  String _getDifficultyName(AIDifficulty difficulty) {
    switch (difficulty) {
      case AIDifficulty.beginner:
        return L10n.get(widget.language, 'aiEasy');
      case AIDifficulty.intermediate:
        return L10n.get(widget.language, 'aiNormal');
      case AIDifficulty.advanced:
        return L10n.get(widget.language, 'aiHard');
      case AIDifficulty.expert:
        return L10n.get(widget.language, 'aiExpert');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.get(widget.language, 'appTitle')),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<GameLanguage>(
            icon: const Icon(Icons.language),
            tooltip: L10n.get(widget.language, 'language'),
            onSelected: widget.onLanguageChanged,
            itemBuilder: (context) => GameLanguage.values.map((lang) {
              return PopupMenuItem(
                value: lang,
                child: Row(
                  children: [
                    if (lang == widget.language)
                      const Icon(Icons.check, size: 18)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    Text(L10n.getLanguageName(lang)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              L10n.get(widget.language, 'appTitle'),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            // AI 난이도 선택
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.brown.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.brown.shade300),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.psychology, color: Colors.brown),
                  const SizedBox(width: 8),
                  Text(
                    '${L10n.get(widget.language, 'aiLevel')}: ',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<AIDifficulty>(
                    value: _selectedDifficulty,
                    underline: const SizedBox(),
                    items: AIDifficulty.values.map((difficulty) {
                      return DropdownMenuItem(
                        value: difficulty,
                        child: Text(
                          _getDifficultyName(difficulty),
                          style: TextStyle(
                            fontWeight: difficulty == _selectedDifficulty
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedDifficulty = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // 컴퓨터와 대국 (흑)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BadukGame(
                      vsAI: true,
                      playerColor: Stone.black,
                      language: widget.language,
                      aiDifficulty: _selectedDifficulty,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(L10n.get(widget.language, 'playAsBlack'), style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 컴퓨터와 대국 (백)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BadukGame(
                      vsAI: true,
                      playerColor: Stone.white,
                      language: widget.language,
                      aiDifficulty: _selectedDifficulty,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(L10n.get(widget.language, 'playAsWhite'), style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 2인 대국
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BadukGame(
                      vsAI: false,
                      language: widget.language,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.people, size: 28),
                  const SizedBox(width: 12),
                  Text(L10n.get(widget.language, 'twoPlayerMode'), style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
            // 이어하기 버튼 (저장된 게임이 있을 때만 표시)
            if (_savedGameInfo != null) ...[
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              _buildContinueButton(),
            ],
          ],
        ),
      ),
    );
  }

  // 이어하기 버튼 위젯
  Widget _buildContinueButton() {
    if (_savedGameInfo == null) return const SizedBox();

    // 저장된 게임 정보 파싱
    final boardSize = _savedGameInfo!['boardSize'] ?? 19;
    final moveCount = (_savedGameInfo!['moveHistory'] as List?)?.length ?? 0;
    final vsAI = _savedGameInfo!['vsAI'] ?? true;
    final playerColorIndex = _savedGameInfo!['playerColor'] ?? 1;
    final aiDifficultyIndex = _savedGameInfo!['aiDifficulty'] ?? 1;
    final saveTimeStr = _savedGameInfo!['saveTime'] as String?;

    String saveTimeDisplay = '';
    if (saveTimeStr != null) {
      try {
        final saveTime = DateTime.parse(saveTimeStr);
        saveTimeDisplay = '${saveTime.month}/${saveTime.day} ${saveTime.hour}:${saveTime.minute.toString().padLeft(2, '0')}';
      } catch (e) {
        saveTimeDisplay = '';
      }
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.save, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    L10n.get(widget.language, 'savedGameInfo'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '$boardSize×$boardSize | ${L10n.get(widget.language, 'moveCount')}: $moveCount${saveTimeDisplay.isNotEmpty ? ' | $saveTimeDisplay' : ''}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () async {
            // 저장된 게임을 불러와서 시작
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BadukGame(
                  vsAI: vsAI,
                  playerColor: Stone.values[playerColorIndex],
                  language: widget.language,
                  aiDifficulty: AIDifficulty.values[aiDifficultyIndex],
                ),
              ),
            ).then((_) {
              // 화면 복귀 시 저장된 게임 정보 새로고침
              _checkSavedGame();
            });

            // 잠시 후 게임 불러오기 (Navigator 전환 후)
            Future.delayed(const Duration(milliseconds: 500), () async {
              final prefs = await SharedPreferences.getInstance();
              // 게임이 불러와질 것임을 표시 (BadukGame에서 처리)
            });
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.play_arrow, size: 28),
              const SizedBox(width: 12),
              Text(
                L10n.get(widget.language, 'continue'),
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum Stone { none, black, white }

// MCTS 노드 클래스
class MCTSNode {
  final List<int>? move;
  MCTSNode? parent;
  List<MCTSNode> children = [];
  int visits = 0;
  double wins = 0.0;
  List<List<int>> untriedMoves;
  final Stone player;

  MCTSNode({
    this.move,
    this.parent,
    required this.untriedMoves,
    required this.player,
  });

  // UCB1 값 계산
  double ucb1(double explorationConstant) {
    if (visits == 0) return double.infinity;
    return (wins / visits) +
        explorationConstant * sqrt(log(parent!.visits) / visits);
  }

  // 가장 좋은 자식 선택 (UCB1 기반)
  MCTSNode selectChild(double explorationConstant) {
    MCTSNode? best;
    double bestValue = double.negativeInfinity;
    for (var child in children) {
      double value = child.ucb1(explorationConstant);
      if (value > bestValue) {
        bestValue = value;
        best = child;
      }
    }
    return best!;
  }

  // 확장 가능한지 확인
  bool get isFullyExpanded => untriedMoves.isEmpty;

  // 터미널 노드인지 확인
  bool get isTerminal => children.isEmpty && untriedMoves.isEmpty;

  // 가장 많이 방문한 자식 반환 (최종 수 선택용)
  MCTSNode? getMostVisitedChild() {
    if (children.isEmpty) return null;
    return children.reduce((a, b) => a.visits > b.visits ? a : b);
  }
}

// AI 설정 클래스
class AISettings {
  final int mctsIterations;
  final int playoutDepth;
  final double explorationConstant;
  final bool useHeuristics;
  final double randomness;
  final int candidateCount;

  const AISettings({
    required this.mctsIterations,
    required this.playoutDepth,
    required this.explorationConstant,
    required this.useHeuristics,
    required this.randomness,
    required this.candidateCount,
  });

  static AISettings forDifficulty(AIDifficulty difficulty) {
    switch (difficulty) {
      case AIDifficulty.beginner:
        return const AISettings(
          mctsIterations: 50,
          playoutDepth: 30,
          explorationConstant: 1.414,
          useHeuristics: false,
          randomness: 0.4,
          candidateCount: 5,
        );
      case AIDifficulty.intermediate:
        return const AISettings(
          mctsIterations: 200,
          playoutDepth: 60,
          explorationConstant: 1.414,
          useHeuristics: true,
          randomness: 0.2,
          candidateCount: 10,
        );
      case AIDifficulty.advanced:
        return const AISettings(
          mctsIterations: 500,
          playoutDepth: 100,
          explorationConstant: 1.5,
          useHeuristics: true,
          randomness: 0.1,
          candidateCount: 15,
        );
      case AIDifficulty.expert:
        return const AISettings(
          mctsIterations: 1000,
          playoutDepth: 150,
          explorationConstant: 1.6,
          useHeuristics: true,
          randomness: 0.05,
          candidateCount: 20,
        );
    }
  }
}

extension StoneExtension on Stone {
  Stone get opponent {
    switch (this) {
      case Stone.black:
        return Stone.white;
      case Stone.white:
        return Stone.black;
      case Stone.none:
        return Stone.none;
    }
  }
}

class BadukGame extends StatefulWidget {
  final bool vsAI;
  final Stone playerColor;
  final GameLanguage language;
  final AIDifficulty aiDifficulty;

  const BadukGame({
    super.key,
    required this.vsAI,
    this.playerColor = Stone.black,
    required this.language,
    this.aiDifficulty = AIDifficulty.intermediate,
  });

  @override
  State<BadukGame> createState() => _BadukGameState();
}

class _BadukGameState extends State<BadukGame> {
  late int boardSize;
  late List<List<Stone>> board;
  Stone currentPlayer = Stone.black;
  bool gameOver = false;
  String gameMessage = '';
  int blackCaptures = 0;
  int whiteCaptures = 0;
  int consecutivePasses = 0;
  String? lastBoardState;
  List<List<int>>? lastMove;
  bool showTerritory = false;
  Map<String, int> territoryCount = {'black': 0, 'white': 0};
  bool isAIThinking = false;
  final Random _random = Random();
  late AISettings _aiSettings;

  // 힌트 관련 변수
  List<int>? hintMove;
  bool showHint = false;

  // 이어하기를 위한 수 기록
  List<Map<String, dynamic>> moveHistory = [];

  // 패턴 데이터베이스
  final Map<String, List<List<int>>> _josekiDatabase = {};

  // 트랜스포지션 테이블 (캐시)
  final Map<String, double> _transpositionTable = {};

  String tr(String key) => L10n.get(widget.language, key);

  Stone get aiColor => widget.playerColor.opponent;

  @override
  void initState() {
    super.initState();
    boardSize = 19;
    _aiSettings = AISettings.forDifficulty(widget.aiDifficulty);
    _initJosekiDatabase();
    _initBoard();
    if (widget.vsAI && aiColor == Stone.black) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _aiMove();
      });
    }
  }

  // 정석 데이터베이스 초기화
  void _initJosekiDatabase() {
    // 화점 정석
    _josekiDatabase['corner_33'] = [
      [3, 3], [15, 3], [3, 15], [15, 15]
    ];

    // 소목 정석
    _josekiDatabase['corner_34'] = [
      [3, 4], [4, 3], [15, 4], [16, 3],
      [3, 14], [4, 15], [15, 14], [16, 15]
    ];

    // 고목 정석
    _josekiDatabase['corner_35'] = [
      [3, 5], [5, 3], [15, 5], [16, 5],
      [3, 13], [5, 15], [15, 13], [16, 13]
    ];

    // 화점 협공
    _josekiDatabase['approach_33'] = [
      [5, 3], [3, 5], [5, 15], [3, 13],
      [13, 3], [15, 5], [13, 15], [15, 13]
    ];

    // 날일자 정석
    _josekiDatabase['knight_move'] = [
      [4, 6], [6, 4], [4, 12], [6, 14],
      [14, 6], [12, 4], [14, 12], [12, 14]
    ];

    // 두 칸 벌림
    _josekiDatabase['two_space_extension'] = [
      [3, 6], [6, 3], [3, 12], [6, 15],
      [15, 6], [12, 3], [15, 12], [12, 15]
    ];
  }

  void _initBoard() {
    board = List.generate(
      boardSize,
      (_) => List.generate(boardSize, (_) => Stone.none),
    );
    currentPlayer = Stone.black;
    gameOver = false;
    if (widget.vsAI) {
      String colorName = widget.playerColor == Stone.black ? tr('black') : tr('white');
      if (aiColor == Stone.black) {
        gameMessage = tr('aiThinking');
      } else {
        gameMessage = '${tr('yourTurn')} ($colorName)';
      }
    } else {
      gameMessage = tr('blackTurn');
    }
    blackCaptures = 0;
    whiteCaptures = 0;
    consecutivePasses = 0;
    lastBoardState = null;
    lastMove = null;
    showTerritory = false;
    territoryCount = {'black': 0, 'white': 0};
    isAIThinking = false;
    hintMove = null;
    showHint = false;
    moveHistory = [];
  }

  void _resetGame() {
    setState(() {
      _initBoard();
    });
    if (widget.vsAI && aiColor == Stone.black) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _aiMove();
      });
    }
  }

  void _changeBoardSize(int size) {
    setState(() {
      boardSize = size;
      _initBoard();
    });
  }

  String _boardToString() {
    return board.map((row) => row.map((s) => s.index).join()).join();
  }

  bool _tryPlaceStone(int row, int col, {bool isAI = false}) {
    if (gameOver || board[row][col] != Stone.none) return false;
    if (!isAI && isAIThinking) return false;

    board[row][col] = currentPlayer;

    List<List<int>> capturedStones = [];
    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == currentPlayer.opponent) {
        var group = _getGroup(nr, nc);
        if (_getLiberties(group).isEmpty) {
          capturedStones.addAll(group);
        }
      }
    }

    if (capturedStones.isEmpty) {
      var myGroup = _getGroup(row, col);
      if (_getLiberties(myGroup).isEmpty) {
        board[row][col] = Stone.none;
        return false;
      }
    }

    String beforeCapture = _boardToString();

    for (var stone in capturedStones) {
      board[stone[0]][stone[1]] = Stone.none;
    }

    String afterCapture = _boardToString();
    if (lastBoardState != null && afterCapture == lastBoardState) {
      board[row][col] = Stone.none;
      for (var stone in capturedStones) {
        board[stone[0]][stone[1]] = currentPlayer.opponent;
      }
      if (!isAI) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr('koViolation'))),
        );
      }
      return false;
    }

    setState(() {
      if (currentPlayer == Stone.black) {
        blackCaptures += capturedStones.length;
      } else {
        whiteCaptures += capturedStones.length;
      }

      // 수 기록 저장
      moveHistory.add({
        'row': row,
        'col': col,
        'player': currentPlayer.index,
        'captures': capturedStones.length,
        'isPass': false,
      });

      lastBoardState = beforeCapture;
      lastMove = [[row, col]];
      consecutivePasses = 0;

      currentPlayer = currentPlayer.opponent;
      _updateMessage();
    });

    return true;
  }

  void _placeStone(int row, int col) {
    if (!_tryPlaceStone(row, col)) return;

    // 힌트 숨기기
    setState(() {
      showHint = false;
      hintMove = null;
    });

    if (widget.vsAI && currentPlayer == aiColor && !gameOver) {
      _aiMove();
    }
  }

  // 힌트 기능: 플레이어에게 추천 수를 보여줌
  void _showHint() {
    if (gameOver || isAIThinking) return;

    // vs AI 모드에서만, 플레이어 차례일 때만
    if (widget.vsAI && currentPlayer != widget.playerColor) return;

    setState(() {
      isAIThinking = true;
      gameMessage = tr('aiThinking');
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      List<int>? hint = _findHintMove();

      setState(() {
        isAIThinking = false;
        if (hint != null) {
          hintMove = hint;
          showHint = true;
          gameMessage = tr('hintMessage');
        } else {
          hintMove = null;
          showHint = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr('noHint'))),
          );
          _updateMessage();
        }
      });
    });
  }

  // 힌트용 최적 수 찾기 (플레이어 관점)
  List<int>? _findHintMove() {
    Stone playerColor = widget.vsAI ? widget.playerColor : currentPlayer;

    List<List<int>> validMoves = [];
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] == Stone.none && _isValidMove(i, j, playerColor)) {
          validMoves.add([i, j]);
        }
      }
    }

    if (validMoves.isEmpty) return null;

    // 영향력 맵 계산
    _calculateInfluenceMap();

    // 우선순위 기반 수 찾기 (플레이어 관점)
    Stone opponent = playerColor.opponent;

    // 1. 많은 돌 잡기
    int maxCaptures = 0;
    List<int>? captureMove;
    for (var move in validMoves) {
      int captures = _countCaptures(move[0], move[1], playerColor);
      if (captures > maxCaptures) {
        maxCaptures = captures;
        captureMove = move;
      }
    }
    if (maxCaptures >= 2) return captureMove;

    // 2. 위험한 그룹 구하기
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] == playerColor) {
          var group = _getGroup(i, j);
          var liberties = _getLiberties(group);
          if (liberties.length == 1) {
            // 단수 그룹 구하기
            for (var move in validMoves) {
              board[move[0]][move[1]] = playerColor;
              var newLiberties = _getLiberties(_getGroup(i, j));
              board[move[0]][move[1]] = Stone.none;
              if (newLiberties.length >= 2) {
                return move;
              }
            }
          }
        }
      }
    }

    // 3. 상대 위협 방어
    for (var move in validMoves) {
      int threat = _countCaptures(move[0], move[1], opponent);
      if (threat >= 2) {
        return move;
      }
    }

    // 4. 1개라도 잡기
    if (captureMove != null) return captureMove;

    // 5. 상대 단수 만들기
    for (var move in validMoves) {
      board[move[0]][move[1]] = playerColor;
      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = move[0] + dir[0];
        int nc = move[1] + dir[1];
        if (_isValidPosition(nr, nc) && board[nr][nc] == opponent) {
          var group = _getGroup(nr, nc);
          var liberties = _getLiberties(group);
          if (liberties.length == 1 && group.length >= 2) {
            board[move[0]][move[1]] = Stone.none;
            return move;
          }
        }
      }
      board[move[0]][move[1]] = Stone.none;
    }

    // 6. 전략적 평가 기반 최적 수
    int bestScore = -100000;
    List<int>? bestMove;
    for (var move in validMoves) {
      int score = _evaluateHintMove(move[0], move[1], playerColor);
      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    return bestMove;
  }

  // 힌트용 수 평가 (플레이어 관점)
  int _evaluateHintMove(int row, int col, Stone player) {
    int score = 0;

    // 영향력
    double influence = _influenceMap[row][col];
    if (player == aiColor) {
      score += (influence * 10).round();
    } else {
      score -= (influence * 10).round();
    }

    // 연결성
    int connections = 0;
    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == player) {
        connections++;
      }
    }
    score += connections * 8;

    // 활로 확보
    board[row][col] = player;
    var group = _getGroup(row, col);
    var liberties = _getLiberties(group);
    board[row][col] = Stone.none;
    score += liberties.length * 5;

    // 전략적 위치
    score += _calculateStrategicValue(row, col);

    // 공격 잠재력
    board[row][col] = player;
    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == player.opponent) {
        var oppGroup = _getGroup(nr, nc);
        var oppLiberties = _getLiberties(oppGroup);
        if (oppLiberties.length <= 2) {
          score += (4 - oppLiberties.length) * oppGroup.length * 3;
        }
      }
    }
    board[row][col] = Stone.none;

    return score;
  }

  void _updateMessage() {
    if (widget.vsAI) {
      String colorName = widget.playerColor == Stone.black ? tr('black') : tr('white');
      if (currentPlayer == widget.playerColor) {
        gameMessage = '${tr('yourTurn')} ($colorName)';
      } else {
        gameMessage = tr('aiThinking');
      }
    } else {
      gameMessage = currentPlayer == Stone.black ? tr('blackTurn') : tr('whiteTurn');
    }
  }

  // ============ 게임 저장/불러오기 ============

  // 게임 저장
  Future<void> _saveGame() async {
    final prefs = await SharedPreferences.getInstance();

    // 게임 상태를 JSON으로 변환
    Map<String, dynamic> gameState = {
      'boardSize': boardSize,
      'board': board.map((row) => row.map((s) => s.index).toList()).toList(),
      'currentPlayer': currentPlayer.index,
      'gameOver': gameOver,
      'blackCaptures': blackCaptures,
      'whiteCaptures': whiteCaptures,
      'consecutivePasses': consecutivePasses,
      'lastBoardState': lastBoardState,
      'lastMove': lastMove,
      'moveHistory': moveHistory,
      'vsAI': widget.vsAI,
      'playerColor': widget.playerColor.index,
      'aiDifficulty': widget.aiDifficulty.index,
      'saveTime': DateTime.now().toIso8601String(),
    };

    await prefs.setString('savedGame', jsonEncode(gameState));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('gameSaved'))),
      );
    }
  }

  // 저장된 게임이 있는지 확인
  static Future<Map<String, dynamic>?> getSavedGameInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('savedGame');

    if (savedData != null) {
      try {
        return jsonDecode(savedData) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // 게임 불러오기
  Future<void> _loadGame() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('savedGame');

    if (savedData == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr('noSavedGame'))),
        );
      }
      return;
    }

    try {
      Map<String, dynamic> gameState = jsonDecode(savedData);

      setState(() {
        boardSize = gameState['boardSize'];
        board = (gameState['board'] as List)
            .map((row) => (row as List).map((s) => Stone.values[s]).toList())
            .toList();
        currentPlayer = Stone.values[gameState['currentPlayer']];
        gameOver = gameState['gameOver'];
        blackCaptures = gameState['blackCaptures'];
        whiteCaptures = gameState['whiteCaptures'];
        consecutivePasses = gameState['consecutivePasses'];
        lastBoardState = gameState['lastBoardState'];

        if (gameState['lastMove'] != null) {
          lastMove = (gameState['lastMove'] as List)
              .map((m) => (m as List).cast<int>().toList())
              .toList();
        } else {
          lastMove = null;
        }

        if (gameState['moveHistory'] != null) {
          moveHistory = (gameState['moveHistory'] as List)
              .map((m) => Map<String, dynamic>.from(m))
              .toList();
        } else {
          moveHistory = [];
        }

        showTerritory = false;
        territoryCount = {'black': 0, 'white': 0};
        isAIThinking = false;
        hintMove = null;
        showHint = false;

        _updateMessage();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr('gameLoaded'))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  // 저장된 게임 삭제
  static Future<void> deleteSavedGame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedGame');
  }

  void _aiMove() {
    setState(() {
      isAIThinking = true;
      gameMessage = tr('aiThinking');
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (gameOver) return;

      List<int>? bestMove = _findBestMove();

      if (bestMove != null) {
        _tryPlaceStone(bestMove[0], bestMove[1], isAI: true);
      } else {
        _pass(isAI: true);
      }

      setState(() {
        isAIThinking = false;
        if (!gameOver) {
          String colorName = widget.playerColor == Stone.black ? tr('black') : tr('white');
          gameMessage = '${tr('yourTurn')} ($colorName)';
        }
      });
    });
  }

  // ============ 고급 AI ============

  // 영향력 맵 캐시
  late List<List<double>> _influenceMap;

  List<int>? _findBestMove() {
    List<List<int>> validMoves = [];

    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] == Stone.none && _isValidMove(i, j, aiColor)) {
          validMoves.add([i, j]);
        }
      }
    }

    if (validMoves.isEmpty) return null;

    // 난이도별 랜덤성 추가 (초급은 가끔 실수)
    if (_random.nextDouble() < _aiSettings.randomness) {
      // 좋은 수 중에서 랜덤 선택
      List<List<int>> reasonableMoves = _getReasonableMoves(validMoves);
      if (reasonableMoves.isNotEmpty) {
        return reasonableMoves[_random.nextInt(reasonableMoves.length)];
      }
    }

    // 영향력 맵 계산
    _calculateInfluenceMap();

    // 초반 정석 체크 (고급 난이도에서만 정석 사용)
    if (_aiSettings.useHeuristics) {
      int stoneCount = _countStones();
      if (stoneCount < 12) {
        List<int>? openingMove = _getOpeningMoveAdvanced(validMoves);
        if (openingMove != null) return openingMove;
      }
    }

    // 우선순위 1: 많은 돌을 잡을 수 있는 수 (2개 이상)
    int maxCaptures = 0;
    List<int>? captureMove;
    for (var move in validMoves) {
      int captures = _countCaptures(move[0], move[1], aiColor);
      if (captures > maxCaptures) {
        maxCaptures = captures;
        captureMove = move;
      }
    }
    if (maxCaptures >= 2) return captureMove;

    // 우선순위 2: 단수인 자기 그룹 구하기 (중요 그룹)
    List<int>? saveMove = _findSaveMove(validMoves);
    if (saveMove != null) return saveMove;

    // 우선순위 3: 사활 - 상대 그룹 죽이기
    List<int>? killMove = _findKillMoveAdvanced(validMoves);
    if (killMove != null) return killMove;

    // 우선순위 4: 사다리 공격 (고급 난이도에서만)
    if (_aiSettings.useHeuristics) {
      List<int>? ladderMove = _findLadderAttack(validMoves);
      if (ladderMove != null) return ladderMove;
    }

    // 우선순위 5: 상대 그룹을 단수로 만들기 (큰 그룹)
    List<int>? atariMove = _findAtariMove(validMoves);
    if (atariMove != null) return atariMove;

    // 우선순위 6: 1개라도 잡기
    if (captureMove != null) return captureMove;

    // 우선순위 7: 상대 공격 방어
    List<int>? blockMove = _findBlockMove(validMoves);
    if (blockMove != null) return blockMove;

    // 우선순위 8: 끊기 수 (상대 연결 차단)
    if (_aiSettings.useHeuristics) {
      List<int>? cutMove = _findCutMove(validMoves);
      if (cutMove != null) return cutMove;
    }

    // 우선순위 9: 압박 수
    List<int>? pressureMove = _findPressureMove(validMoves);
    if (pressureMove != null) return pressureMove;

    // 우선순위 10: 코시미/날일자 공격
    if (_aiSettings.useHeuristics) {
      List<int>? kosimiMove = _findKosimiMove(validMoves);
      if (kosimiMove != null) return kosimiMove;
    }

    // 우선순위 11: MCTS 또는 몬테카를로 시뮬레이션 기반 최적 수
    if (widget.aiDifficulty == AIDifficulty.expert) {
      return _findBestMoveWithMCTS(validMoves);
    } else {
      return _findBestMoveWithMonteCarlo(validMoves);
    }
  }

  // 합리적인 수 목록 (초급 AI용)
  List<List<int>> _getReasonableMoves(List<List<int>> validMoves) {
    List<List<int>> reasonable = [];
    for (var move in validMoves) {
      // 1선 피하기
      if (move[0] == 0 || move[0] == boardSize - 1 ||
          move[1] == 0 || move[1] == boardSize - 1) {
        continue;
      }
      // 자기 돌 근처 또는 상대 돌 근처
      bool nearStone = false;
      for (int dr = -2; dr <= 2; dr++) {
        for (int dc = -2; dc <= 2; dc++) {
          int nr = move[0] + dr;
          int nc = move[1] + dc;
          if (_isValidPosition(nr, nc) && board[nr][nc] != Stone.none) {
            nearStone = true;
            break;
          }
        }
        if (nearStone) break;
      }
      if (nearStone || _countStones() < 4) {
        reasonable.add(move);
      }
    }
    return reasonable.isEmpty ? validMoves : reasonable;
  }

  // 고급 정석 수
  List<int>? _getOpeningMoveAdvanced(List<List<int>> validMoves) {
    int stoneCount = _countStones();

    // 첫 수: 정석 데이터베이스에서 선택
    if (stoneCount == 0) {
      List<List<int>> openings = [
        ..._josekiDatabase['corner_33'] ?? [],
        ..._josekiDatabase['corner_34'] ?? [],
      ];
      openings.shuffle(_random);
      for (var move in openings) {
        if (validMoves.any((m) => m[0] == move[0] && m[1] == move[1])) {
          return move;
        }
      }
    }

    // 정석 응수
    if (stoneCount < 8) {
      List<int>? josekiResponse = _findJosekiResponse(validMoves);
      if (josekiResponse != null) return josekiResponse;
    }

    // 코너 접근
    if (stoneCount < 12) {
      List<int>? cornerApproach = _findCornerApproach(validMoves);
      if (cornerApproach != null) return cornerApproach;
    }

    return null;
  }

  // 정석 응수 찾기
  List<int>? _findJosekiResponse(List<List<int>> validMoves) {
    // 상대가 코너에 두었으면 협공 또는 협공
    for (var corner in _josekiDatabase['corner_33'] ?? []) {
      if (board[corner[0]][corner[1]] == widget.playerColor) {
        // 협공 수 찾기
        List<List<int>> approaches = _josekiDatabase['approach_33'] ?? [];
        for (var approach in approaches) {
          if (_isNearCorner(approach, corner) &&
              validMoves.any((m) => m[0] == approach[0] && m[1] == approach[1])) {
            return approach;
          }
        }
      }
    }

    // 날일자 확장
    for (var stone in _getAIStones()) {
      if (_isCornerStone(stone[0], stone[1])) {
        for (var knight in _josekiDatabase['knight_move'] ?? []) {
          if (_isNearCorner(knight, stone) &&
              validMoves.any((m) => m[0] == knight[0] && m[1] == knight[1])) {
            return knight;
          }
        }
      }
    }

    return null;
  }

  bool _isNearCorner(List<int> point, List<int> corner) {
    int dist = (point[0] - corner[0]).abs() + (point[1] - corner[1]).abs();
    return dist <= 6;
  }

  bool _isCornerStone(int row, int col) {
    int margin = boardSize == 19 ? 5 : (boardSize == 13 ? 4 : 3);
    return (row < margin || row >= boardSize - margin) &&
           (col < margin || col >= boardSize - margin);
  }

  List<List<int>> _getAIStones() {
    List<List<int>> stones = [];
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] == aiColor) {
          stones.add([i, j]);
        }
      }
    }
    return stones;
  }

  // 코시미 (붙여두기) 수 찾기
  List<int>? _findKosimiMove(List<List<int>> validMoves) {
    int bestScore = 0;
    List<int>? bestMove;

    for (var move in validMoves) {
      int score = 0;

      // 상대 돌에 대각선으로 붙이기 (코시미)
      for (var diag in [[-1, -1], [-1, 1], [1, -1], [1, 1]]) {
        int dr = move[0] + diag[0];
        int dc = move[1] + diag[1];
        if (_isValidPosition(dr, dc) && board[dr][dc] == widget.playerColor) {
          // 빈 점이 공유되는지 확인
          int sharedEmpty = 0;
          for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
            int nr = move[0] + dir[0];
            int nc = move[1] + dir[1];
            int or = dr + dir[0];
            int oc = dc + dir[1];
            if (_isValidPosition(nr, nc) && board[nr][nc] == Stone.none &&
                _isValidPosition(or, oc) && board[or][oc] == Stone.none) {
              sharedEmpty++;
            }
          }
          if (sharedEmpty >= 1) {
            var group = _getGroup(dr, dc);
            score += group.length * 5;
          }
        }
      }

      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    if (bestScore >= 10) return bestMove;
    return null;
  }

  // 고급 사활 분석
  List<int>? _findKillMoveAdvanced(List<List<int>> validMoves) {
    for (var move in validMoves) {
      board[move[0]][move[1]] = aiColor;

      // 인접한 상대 그룹 확인
      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = move[0] + dir[0];
        int nc = move[1] + dir[1];
        if (_isValidPosition(nr, nc) && board[nr][nc] == widget.playerColor) {
          var group = _getGroup(nr, nc);
          var liberties = _getLiberties(group);

          // 활로가 1-2개이고 눈이 없는 그룹
          if (liberties.length <= 2 && group.length >= 2) {
            // 진짜 눈 분석
            int realEyes = _countRealEyes(group);
            if (realEyes < 2) {
              board[move[0]][move[1]] = Stone.none;
              return move;
            }
          }

          // 큰 그룹이지만 눈이 부족한 경우
          if (liberties.length <= 3 && group.length >= 5) {
            int realEyes = _countRealEyes(group);
            if (realEyes == 0) {
              board[move[0]][move[1]] = Stone.none;
              return move;
            }
          }
        }
      }
      board[move[0]][move[1]] = Stone.none;
    }
    return null;
  }

  // 진짜 눈 개수 계산
  int _countRealEyes(List<List<int>> group) {
    Set<String> groupSet = {};
    for (var stone in group) {
      groupSet.add('${stone[0]},${stone[1]}');
    }

    int realEyes = 0;
    Set<String> checkedEmpty = {};

    for (var stone in group) {
      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = stone[0] + dir[0];
        int nc = stone[1] + dir[1];
        String key = '$nr,$nc';

        if (!checkedEmpty.contains(key) && _isValidPosition(nr, nc) && board[nr][nc] == Stone.none) {
          checkedEmpty.add(key);

          // 진짜 눈인지 확인: 4방향 모두 자기 돌 또는 가장자리
          int surrounded = 0;
          int diagonal = 0;
          int diagonalOpponent = 0;

          for (var d in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
            int nnr = nr + d[0];
            int nnc = nc + d[1];
            if (!_isValidPosition(nnr, nnc) || groupSet.contains('$nnr,$nnc')) {
              surrounded++;
            }
          }

          // 대각선 확인 (코너 안전성)
          for (var d in [[-1, -1], [-1, 1], [1, -1], [1, 1]]) {
            int nnr = nr + d[0];
            int nnc = nc + d[1];
            if (_isValidPosition(nnr, nnc)) {
              if (board[nnr][nnc] == widget.playerColor) {
                diagonalOpponent++;
              } else if (groupSet.contains('$nnr,$nnc') || !_isValidPosition(nnr, nnc)) {
                diagonal++;
              }
            } else {
              diagonal++;
            }
          }

          // 진짜 눈 조건: 4방향 둘러싸임 + 대각선 안전
          if (surrounded == 4 && diagonalOpponent <= 1) {
            realEyes++;
          }
        }
      }
    }

    return realEyes;
  }

  // MCTS (Monte Carlo Tree Search) 알고리즘
  List<int>? _findBestMoveWithMCTS(List<List<int>> validMoves) {
    if (validMoves.isEmpty) return null;

    // 보드 상태 저장
    List<List<Stone>> originalBoard = List.generate(
      boardSize, (i) => List.from(board[i])
    );

    // 후보 수 점수화 및 필터링
    List<MapEntry<List<int>, int>> scoredMoves = [];
    for (var move in validMoves) {
      int score = _evaluateMoveAdvanced(move[0], move[1]);
      scoredMoves.add(MapEntry(move, score));
    }
    scoredMoves.sort((a, b) => b.value.compareTo(a.value));

    // 상위 후보만 MCTS 수행
    int candidateCount = min(_aiSettings.candidateCount, scoredMoves.length);
    List<List<int>> candidates = scoredMoves.take(candidateCount).map((e) => e.key).toList();

    // 루트 노드 생성
    MCTSNode root = MCTSNode(
      untriedMoves: List.from(candidates),
      player: aiColor,
    );

    // MCTS 반복
    for (int i = 0; i < _aiSettings.mctsIterations; i++) {
      // 보드 복원
      _restoreBoard(originalBoard);

      // Selection & Expansion
      MCTSNode node = root;
      Stone currentMCTSPlayer = aiColor;

      // Selection: 트리를 따라 내려가기
      while (node.isFullyExpanded && node.children.isNotEmpty) {
        node = node.selectChild(_aiSettings.explorationConstant);
        if (node.move != null) {
          board[node.move![0]][node.move![1]] = currentMCTSPlayer;
          _removeCapturedStones(node.move![0], node.move![1], currentMCTSPlayer);
        }
        currentMCTSPlayer = currentMCTSPlayer.opponent;
      }

      // Expansion: 새 노드 추가
      if (node.untriedMoves.isNotEmpty) {
        var move = node.untriedMoves.removeAt(_random.nextInt(node.untriedMoves.length));
        if (_isValidMoveSimple(move[0], move[1], currentMCTSPlayer)) {
          board[move[0]][move[1]] = currentMCTSPlayer;
          _removeCapturedStones(move[0], move[1], currentMCTSPlayer);

          List<List<int>> nextMoves = _getValidMovesForPlayer(currentMCTSPlayer.opponent);
          MCTSNode child = MCTSNode(
            move: move,
            parent: node,
            untriedMoves: nextMoves.take(10).toList(),
            player: currentMCTSPlayer,
          );
          node.children.add(child);
          node = child;
          currentMCTSPlayer = currentMCTSPlayer.opponent;
        }
      }

      // Simulation: 랜덤 플레이아웃 (가중치 적용)
      double result = _weightedPlayout(currentMCTSPlayer);

      // Backpropagation: 결과 전파
      while (node.parent != null) {
        node.visits++;
        // AI 관점에서의 승률
        if (node.player == aiColor) {
          node.wins += result;
        } else {
          node.wins += 1.0 - result;
        }
        node = node.parent!;
      }
      root.visits++;
    }

    // 보드 복원
    _restoreBoard(originalBoard);

    // 가장 많이 방문한 수 선택
    MCTSNode? bestChild = root.getMostVisitedChild();
    if (bestChild != null && bestChild.move != null) {
      return bestChild.move;
    }

    // 폴백: 기존 몬테카를로
    return _findBestMoveWithMonteCarlo(validMoves);
  }

  void _restoreBoard(List<List<Stone>> originalBoard) {
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        board[i][j] = originalBoard[i][j];
      }
    }
  }

  List<List<int>> _getValidMovesForPlayer(Stone player) {
    List<List<int>> moves = [];
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] == Stone.none && _isValidMoveSimple(i, j, player)) {
          moves.add([i, j]);
        }
      }
    }
    return moves;
  }

  // 가중치 기반 플레이아웃
  double _weightedPlayout(Stone startPlayer) {
    Stone currentSim = startPlayer;
    int moves = 0;
    int maxMoves = _aiSettings.playoutDepth;
    int passes = 0;

    while (moves < maxMoves && passes < 2) {
      List<List<int>> simMoves = [];
      List<double> weights = [];

      for (int i = 0; i < boardSize; i++) {
        for (int j = 0; j < boardSize; j++) {
          if (board[i][j] == Stone.none && _isValidMoveSimple(i, j, currentSim)) {
            simMoves.add([i, j]);
            // 가중치 계산
            double weight = _calculateMoveWeight(i, j, currentSim);
            weights.add(weight);
          }
        }
      }

      if (simMoves.isEmpty) {
        passes++;
      } else {
        passes = 0;
        // 가중치 기반 선택
        List<int> selectedMove = _selectWeightedMove(simMoves, weights);
        board[selectedMove[0]][selectedMove[1]] = currentSim;
        _removeCapturedStones(selectedMove[0], selectedMove[1], currentSim);
      }

      currentSim = currentSim.opponent;
      moves++;
    }

    // 결과 평가
    int aiTerritory = _countTerritory(aiColor);
    int playerTerritory = _countTerritory(widget.playerColor);

    if (aiTerritory > playerTerritory) {
      return 1.0;
    } else if (aiTerritory < playerTerritory) {
      return 0.0;
    } else {
      return 0.5;
    }
  }

  double _calculateMoveWeight(int row, int col, Stone player) {
    double weight = 1.0;

    // 1선 페널티
    int edgeDist = _getEdgeDistance(row, col);
    if (edgeDist == 0) weight *= 0.1;
    else if (edgeDist == 1) weight *= 0.5;

    // 잡기 보너스
    int captures = _countCaptures(row, col, player);
    if (captures > 0) weight *= (1.0 + captures * 2.0);

    // 연결 보너스
    int connections = 0;
    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == player) {
        connections++;
      }
    }
    weight *= (1.0 + connections * 0.3);

    // 상대 근처 보너스
    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == player.opponent) {
        weight *= 1.5;
        break;
      }
    }

    return weight;
  }

  List<int> _selectWeightedMove(List<List<int>> moves, List<double> weights) {
    double totalWeight = weights.fold(0.0, (sum, w) => sum + w);
    if (totalWeight <= 0) {
      return moves[_random.nextInt(moves.length)];
    }

    double r = _random.nextDouble() * totalWeight;
    double cumulative = 0.0;
    for (int i = 0; i < moves.length; i++) {
      cumulative += weights[i];
      if (r <= cumulative) {
        return moves[i];
      }
    }
    return moves.last;
  }

  // 초반 정석 수
  List<int>? _getOpeningMove(List<List<int>> validMoves) {
    int stoneCount = _countStones();

    // 첫 수: 화점 또는 소목
    if (stoneCount == 0) {
      List<List<int>> goodOpenings = [];
      if (boardSize == 19) {
        goodOpenings = [[3, 3], [3, 15], [15, 3], [15, 15], [3, 4], [4, 3], [15, 4], [16, 3]];
      } else if (boardSize == 13) {
        goodOpenings = [[3, 3], [3, 9], [9, 3], [9, 9], [6, 6]];
      } else {
        goodOpenings = [[2, 2], [2, 6], [6, 2], [6, 6], [4, 4]];
      }
      for (var move in goodOpenings) {
        if (validMoves.any((m) => m[0] == move[0] && m[1] == move[1])) {
          return move;
        }
      }
    }

    // 코너 접근
    if (stoneCount < 8) {
      List<int>? cornerApproach = _findCornerApproach(validMoves);
      if (cornerApproach != null) return cornerApproach;
    }

    return null;
  }

  // 코너 접근 수
  List<int>? _findCornerApproach(List<List<int>> validMoves) {
    // 상대 코너 돌에 접근
    List<List<int>> corners = boardSize == 19
        ? [[3, 3], [3, 15], [15, 3], [15, 15]]
        : boardSize == 13
            ? [[3, 3], [3, 9], [9, 3], [9, 9]]
            : [[2, 2], [2, 6], [6, 2], [6, 6]];

    for (var corner in corners) {
      if (board[corner[0]][corner[1]] == widget.playerColor) {
        // 접근 수 찾기
        List<List<int>> approaches = _getApproachMoves(corner[0], corner[1]);
        for (var approach in approaches) {
          if (validMoves.any((m) => m[0] == approach[0] && m[1] == approach[1])) {
            return approach;
          }
        }
      }
    }
    return null;
  }

  List<List<int>> _getApproachMoves(int row, int col) {
    List<List<int>> approaches = [];
    int offset = boardSize == 19 ? 3 : 2;

    // 한 칸 날일자, 두 칸 벌림 등
    List<List<int>> offsets = [
      [-offset, 1], [-offset, -1], [offset, 1], [offset, -1],
      [1, -offset], [-1, -offset], [1, offset], [-1, offset],
      [-offset + 1, 0], [offset - 1, 0], [0, -offset + 1], [0, offset - 1],
    ];

    for (var off in offsets) {
      int nr = row + off[0];
      int nc = col + off[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == Stone.none) {
        approaches.add([nr, nc]);
      }
    }
    return approaches;
  }

  // 사활: 상대 그룹 죽이기
  List<int>? _findKillMove(List<List<int>> validMoves) {
    for (var move in validMoves) {
      board[move[0]][move[1]] = aiColor;

      // 인접한 상대 그룹 확인
      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = move[0] + dir[0];
        int nc = move[1] + dir[1];
        if (_isValidPosition(nr, nc) && board[nr][nc] == widget.playerColor) {
          var group = _getGroup(nr, nc);
          var liberties = _getLiberties(group);

          // 활로가 1-2개이고 눈이 없는 그룹
          if (liberties.length <= 2 && group.length >= 3 && !_hasEyeSpace(group)) {
            board[move[0]][move[1]] = Stone.none;
            return move;
          }
        }
      }
      board[move[0]][move[1]] = Stone.none;
    }
    return null;
  }

  // 눈 공간이 있는지 확인
  bool _hasEyeSpace(List<List<int>> group) {
    Set<String> groupSet = {};
    for (var stone in group) {
      groupSet.add('${stone[0]},${stone[1]}');
    }

    int potentialEyes = 0;
    Set<String> checkedEmpty = {};

    for (var stone in group) {
      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = stone[0] + dir[0];
        int nc = stone[1] + dir[1];
        String key = '$nr,$nc';

        if (!checkedEmpty.contains(key) && _isValidPosition(nr, nc) && board[nr][nc] == Stone.none) {
          checkedEmpty.add(key);

          // 이 빈 점이 눈이 될 수 있는지 확인
          int surroundingOwn = 0;
          int surroundingEdge = 0;
          for (var d in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
            int nnr = nr + d[0];
            int nnc = nc + d[1];
            if (!_isValidPosition(nnr, nnc)) {
              surroundingEdge++;
            } else if (groupSet.contains('$nnr,$nnc')) {
              surroundingOwn++;
            }
          }

          if (surroundingOwn + surroundingEdge >= 3) {
            potentialEyes++;
          }
        }
      }
    }

    return potentialEyes >= 2;
  }

  // 사다리 공격
  List<int>? _findLadderAttack(List<List<int>> validMoves) {
    for (var move in validMoves) {
      board[move[0]][move[1]] = aiColor;

      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = move[0] + dir[0];
        int nc = move[1] + dir[1];
        if (_isValidPosition(nr, nc) && board[nr][nc] == widget.playerColor) {
          var group = _getGroup(nr, nc);
          if (group.length <= 2) {
            var liberties = _getLiberties(group);
            if (liberties.length == 1) {
              // 사다리 성공 여부 확인
              if (_isLadderWorking(group, 0)) {
                board[move[0]][move[1]] = Stone.none;
                return move;
              }
            }
          }
        }
      }
      board[move[0]][move[1]] = Stone.none;
    }
    return null;
  }

  // 사다리가 성공하는지 확인 (재귀적)
  bool _isLadderWorking(List<List<int>> group, int depth) {
    if (depth > 15) return false; // 깊이 제한

    var liberties = _getLiberties(group);
    if (liberties.isEmpty) return true; // 잡힘
    if (liberties.length >= 2) return false; // 탈출

    // 상대가 도망가는 수
    String libKey = liberties.first;
    var parts = libKey.split(',');
    int escapeRow = int.parse(parts[0]);
    int escapeCol = int.parse(parts[1]);

    if (!_isValidMove(escapeRow, escapeCol, widget.playerColor)) {
      return true; // 도망갈 수 없음
    }

    board[escapeRow][escapeCol] = widget.playerColor;
    var newGroup = _getGroup(escapeRow, escapeCol);
    var newLiberties = _getLiberties(newGroup);

    if (newLiberties.length >= 3) {
      board[escapeRow][escapeCol] = Stone.none;
      return false; // 탈출 성공
    }

    // AI가 쫓는 수
    for (String lib in newLiberties) {
      var p = lib.split(',');
      int chaseRow = int.parse(p[0]);
      int chaseCol = int.parse(p[1]);

      if (_isValidMove(chaseRow, chaseCol, aiColor)) {
        board[chaseRow][chaseCol] = aiColor;
        bool works = _isLadderWorking(newGroup, depth + 1);
        board[chaseRow][chaseCol] = Stone.none;

        if (works) {
          board[escapeRow][escapeCol] = Stone.none;
          return true;
        }
      }
    }

    board[escapeRow][escapeCol] = Stone.none;
    return false;
  }

  // 끊기 수
  List<int>? _findCutMove(List<List<int>> validMoves) {
    int bestScore = 0;
    List<int>? bestMove;

    for (var move in validMoves) {
      int score = 0;

      // 대각선 방향으로 상대 돌이 있는지 확인
      List<List<int>> diagonals = [[-1, -1], [-1, 1], [1, -1], [1, 1]];
      int opponentDiagonals = 0;

      for (var diag in diagonals) {
        int dr = move[0] + diag[0];
        int dc = move[1] + diag[1];
        if (_isValidPosition(dr, dc) && board[dr][dc] == widget.playerColor) {
          opponentDiagonals++;
        }
      }

      // 직선 방향 빈 점 또는 자기 돌
      int emptyOrOwn = 0;
      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = move[0] + dir[0];
        int nc = move[1] + dir[1];
        if (_isValidPosition(nr, nc) && board[nr][nc] != widget.playerColor) {
          emptyOrOwn++;
        }
      }

      // 끊기가 효과적인 경우
      if (opponentDiagonals >= 2 && emptyOrOwn >= 2) {
        board[move[0]][move[1]] = aiColor;

        // 끊은 후 두 그룹의 크기 확인
        Set<String> counted = {};
        int minGroupSize = 100;

        for (var diag in diagonals) {
          int dr = move[0] + diag[0];
          int dc = move[1] + diag[1];
          String key = '$dr,$dc';
          if (_isValidPosition(dr, dc) && board[dr][dc] == widget.playerColor && !counted.contains(key)) {
            var group = _getGroup(dr, dc);
            for (var g in group) {
              counted.add('${g[0]},${g[1]}');
            }
            if (group.length < minGroupSize) {
              minGroupSize = group.length;
            }
          }
        }

        score = opponentDiagonals * 10 + minGroupSize * 5;
        board[move[0]][move[1]] = Stone.none;
      }

      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    if (bestScore >= 25) return bestMove;
    return null;
  }

  // 영향력 맵 계산
  void _calculateInfluenceMap() {
    _influenceMap = List.generate(boardSize, (_) => List.filled(boardSize, 0.0));

    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] != Stone.none) {
          double value = board[i][j] == aiColor ? 1.0 : -1.0;

          // 주변으로 영향력 전파
          for (int di = -4; di <= 4; di++) {
            for (int dj = -4; dj <= 4; dj++) {
              int ni = i + di;
              int nj = j + dj;
              if (_isValidPosition(ni, nj)) {
                double dist = sqrt(di * di + dj * dj);
                if (dist > 0) {
                  _influenceMap[ni][nj] += value / (dist * dist);
                }
              }
            }
          }
        }
      }
    }
  }

  // 몬테카를로 시뮬레이션 기반 최적 수
  List<int>? _findBestMoveWithMonteCarlo(List<List<int>> validMoves) {
    if (validMoves.isEmpty) return null;

    // 상위 후보만 시뮬레이션
    List<MapEntry<List<int>, int>> scored = [];
    for (var move in validMoves) {
      int score = _evaluateMoveAdvanced(move[0], move[1]);
      scored.add(MapEntry(move, score));
    }
    scored.sort((a, b) => b.value.compareTo(a.value));

    // 상위 10개만 몬테카를로
    int candidateCount = min(10, scored.length);
    List<int>? bestMove;
    double bestWinRate = -1;

    for (int i = 0; i < candidateCount; i++) {
      var move = scored[i].key;
      double winRate = _monteCarloSimulation(move[0], move[1], 30);

      // 기본 점수 + 승률 조합
      double combinedScore = scored[i].value * 0.3 + winRate * 100;

      if (combinedScore > bestWinRate) {
        bestWinRate = combinedScore;
        bestMove = move;
      }
    }

    return bestMove ?? scored.first.key;
  }

  // 몬테카를로 시뮬레이션
  double _monteCarloSimulation(int row, int col, int simulations) {
    int wins = 0;

    // 현재 보드 저장
    List<List<Stone>> originalBoard = List.generate(
      boardSize, (i) => List.from(board[i])
    );

    for (int sim = 0; sim < simulations; sim++) {
      // 보드 복원
      for (int i = 0; i < boardSize; i++) {
        for (int j = 0; j < boardSize; j++) {
          board[i][j] = originalBoard[i][j];
        }
      }

      // 첫 수 두기
      board[row][col] = aiColor;
      Stone currentSim = widget.playerColor;

      // 랜덤 플레이아웃
      int moves = 0;
      int maxMoves = boardSize * boardSize ~/ 2;
      int passes = 0;

      while (moves < maxMoves && passes < 2) {
        List<List<int>> simMoves = [];
        for (int i = 0; i < boardSize; i++) {
          for (int j = 0; j < boardSize; j++) {
            if (board[i][j] == Stone.none && _isValidMoveSimple(i, j, currentSim)) {
              simMoves.add([i, j]);
            }
          }
        }

        if (simMoves.isEmpty) {
          passes++;
        } else {
          passes = 0;
          var randomMove = simMoves[_random.nextInt(simMoves.length)];
          board[randomMove[0]][randomMove[1]] = currentSim;
          _removeCapturedStones(randomMove[0], randomMove[1], currentSim);
        }

        currentSim = currentSim.opponent;
        moves++;
      }

      // 결과 평가
      int aiTerritory = _countTerritory(aiColor);
      int playerTerritory = _countTerritory(widget.playerColor);

      if (aiTerritory > playerTerritory) wins++;
    }

    // 보드 복원
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        board[i][j] = originalBoard[i][j];
      }
    }

    return wins / simulations;
  }

  // 간단한 유효 수 확인 (시뮬레이션용)
  bool _isValidMoveSimple(int row, int col, Stone stone) {
    if (board[row][col] != Stone.none) return false;

    board[row][col] = stone;

    // 자충수 확인
    var group = _getGroup(row, col);
    var liberties = _getLiberties(group);

    if (liberties.isEmpty) {
      // 상대를 잡을 수 있는지 확인
      bool canCapture = false;
      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = row + dir[0];
        int nc = col + dir[1];
        if (_isValidPosition(nr, nc) && board[nr][nc] == stone.opponent) {
          var oppGroup = _getGroup(nr, nc);
          if (_getLiberties(oppGroup).isEmpty) {
            canCapture = true;
            break;
          }
        }
      }
      if (!canCapture) {
        board[row][col] = Stone.none;
        return false;
      }
    }

    board[row][col] = Stone.none;
    return true;
  }

  // 잡힌 돌 제거 (시뮬레이션용)
  void _removeCapturedStones(int row, int col, Stone stone) {
    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == stone.opponent) {
        var group = _getGroup(nr, nc);
        if (_getLiberties(group).isEmpty) {
          for (var s in group) {
            board[s[0]][s[1]] = Stone.none;
          }
        }
      }
    }
  }

  // 영역 계산 (시뮬레이션용)
  int _countTerritory(Stone stone) {
    int territory = 0;
    Set<String> visited = {};

    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] == stone) {
          territory++;
        } else if (board[i][j] == Stone.none && !visited.contains('$i,$j')) {
          var result = _floodFillTerritory(i, j, visited);
          if (result['owner'] == stone) {
            territory += result['count'] as int;
          }
        }
      }
    }
    return territory;
  }

  List<int>? _findSaveMove(List<List<int>> validMoves) {
    Set<String> groupsInAtari = {};
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] == aiColor) {
          String key = '$i,$j';
          if (!groupsInAtari.contains(key)) {
            var group = _getGroup(i, j);
            var liberties = _getLiberties(group);
            if (liberties.length == 1) {
              for (var stone in group) {
                groupsInAtari.add('${stone[0]},${stone[1]}');
              }

              for (var move in validMoves) {
                board[move[0]][move[1]] = aiColor;
                var newGroup = _getGroup(i, j);
                var newLiberties = _getLiberties(newGroup);
                board[move[0]][move[1]] = Stone.none;

                if (newLiberties.length >= 2) {
                  return move;
                }
              }

              for (var move in validMoves) {
                int captures = _countCaptures(move[0], move[1], aiColor);
                if (captures > 0) {
                  board[move[0]][move[1]] = aiColor;
                  List<List<int>> captured = [];
                  for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
                    int nr = move[0] + dir[0];
                    int nc = move[1] + dir[1];
                    if (_isValidPosition(nr, nc) && board[nr][nc] == widget.playerColor) {
                      var g = _getGroup(nr, nc);
                      if (_getLiberties(g).isEmpty) {
                        captured.addAll(g);
                      }
                    }
                  }
                  for (var c in captured) {
                    board[c[0]][c[1]] = Stone.none;
                  }

                  var newLiberties = _getLiberties(_getGroup(i, j));

                  for (var c in captured) {
                    board[c[0]][c[1]] = widget.playerColor;
                  }
                  board[move[0]][move[1]] = Stone.none;

                  if (newLiberties.length >= 2) {
                    return move;
                  }
                }
              }
            }
          }
        }
      }
    }
    return null;
  }

  List<int>? _findAtariMove(List<List<int>> validMoves) {
    int bestGroupSize = 0;
    List<int>? bestMove;

    for (var move in validMoves) {
      board[move[0]][move[1]] = aiColor;

      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = move[0] + dir[0];
        int nc = move[1] + dir[1];
        if (_isValidPosition(nr, nc) && board[nr][nc] == widget.playerColor) {
          var group = _getGroup(nr, nc);
          var liberties = _getLiberties(group);
          if (liberties.length == 1 && group.length > bestGroupSize) {
            bestGroupSize = group.length;
            bestMove = move;
          }
        }
      }

      board[move[0]][move[1]] = Stone.none;
    }

    if (bestGroupSize >= 2) return bestMove;
    return null;
  }

  List<int>? _findBlockMove(List<List<int>> validMoves) {
    int maxThreat = 0;
    List<int>? bestBlock;

    for (var move in validMoves) {
      int threat = _countCaptures(move[0], move[1], widget.playerColor);
      if (threat > maxThreat) {
        maxThreat = threat;
        bestBlock = move;
      }
    }

    if (maxThreat > 0) return bestBlock;
    return null;
  }

  List<int>? _findPressureMove(List<List<int>> validMoves) {
    int bestScore = 0;
    List<int>? bestMove;

    for (var move in validMoves) {
      board[move[0]][move[1]] = aiColor;

      int score = 0;
      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = move[0] + dir[0];
        int nc = move[1] + dir[1];
        if (_isValidPosition(nr, nc) && board[nr][nc] == widget.playerColor) {
          var group = _getGroup(nr, nc);
          var liberties = _getLiberties(group);
          if (liberties.length == 2) {
            score += group.length * 10;
          } else if (liberties.length == 3) {
            score += group.length * 3;
          }
        }
      }

      board[move[0]][move[1]] = Stone.none;

      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    if (bestScore >= 20) return bestMove;
    return null;
  }

  List<int>? _findBestScoredMove(List<List<int>> validMoves) {
    int bestScore = -100000;
    List<int>? bestMove;

    for (var move in validMoves) {
      int score = _evaluateMoveAdvanced(move[0], move[1]);
      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    return bestMove;
  }

  int _evaluateMoveAdvanced(int row, int col) {
    int score = 0;

    // 1. 영향력 맵 활용
    score += (_influenceMap[row][col] * 15).round();

    // 2. 연결성 평가
    score += _calculateConnectivity(row, col, aiColor) * 8;

    // 3. 공격 잠재력
    score += _calculateAttackPotential(row, col) * 6;

    // 4. 눈 형성 가능성
    score += _calculateEyePotential(row, col) * 12;

    // 5. 전략적 위치
    score += _calculateStrategicValue(row, col);

    // 6. 활로 확보
    board[row][col] = aiColor;
    var group = _getGroup(row, col);
    var liberties = _getLiberties(group);
    board[row][col] = Stone.none;
    score += liberties.length * 5;

    // 7. 약한 그룹 강화
    score += _strengthenWeakGroups(row, col) * 8;

    // 8. 상대 확장 차단
    score += _blockOpponentExpansion(row, col) * 6;

    // 9. 영역 확장 가치
    score += _calculateTerritoryValue(row, col) * 7;

    // 10. 모양 평가 (호구, 빈삼각형 등 나쁜 모양 피하기)
    score += _evaluateShape(row, col) * 10;

    // 11. 약간의 랜덤성
    score += _random.nextInt(3);

    return score;
  }

  // 영역 확장 가치 평가
  int _calculateTerritoryValue(int row, int col) {
    int value = 0;

    // 비어있는 영역에서의 가치
    int emptyNearby = 0;
    int ownNearby = 0;
    int oppNearby = 0;

    for (int dr = -2; dr <= 2; dr++) {
      for (int dc = -2; dc <= 2; dc++) {
        int nr = row + dr;
        int nc = col + dc;
        if (_isValidPosition(nr, nc)) {
          if (board[nr][nc] == Stone.none) {
            emptyNearby++;
          } else if (board[nr][nc] == aiColor) {
            ownNearby++;
          } else {
            oppNearby++;
          }
        }
      }
    }

    // 자기 돌 근처의 빈 공간 확장
    if (ownNearby > 0 && emptyNearby > oppNearby) {
      value += emptyNearby * 2;
    }

    // 경계 지역에서의 가치
    if (ownNearby > 0 && oppNearby > 0) {
      value += 5;
    }

    return value;
  }

  // 모양 평가
  int _evaluateShape(int row, int col) {
    int value = 0;

    board[row][col] = aiColor;

    // 빈삼각형 피하기 (나쁜 모양)
    List<List<List<int>>> trianglePatterns = [
      [[-1, 0], [0, -1], [-1, -1]],
      [[-1, 0], [0, 1], [-1, 1]],
      [[1, 0], [0, -1], [1, -1]],
      [[1, 0], [0, 1], [1, 1]],
    ];

    for (var pattern in trianglePatterns) {
      int ownCount = 0;
      int emptyCorner = 0;
      for (int i = 0; i < 3; i++) {
        int nr = row + pattern[i][0];
        int nc = col + pattern[i][1];
        if (_isValidPosition(nr, nc)) {
          if (board[nr][nc] == aiColor) {
            ownCount++;
          } else if (i == 2 && board[nr][nc] == Stone.none) {
            emptyCorner = 1;
          }
        }
      }
      // 빈삼각형: 2점이 자기 돌이고 대각선이 비어있음
      if (ownCount == 2 && emptyCorner == 1) {
        value -= 8; // 페널티
      }
    }

    // 호구 (좋은 모양)
    int directNeighbors = 0;
    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == aiColor) {
        directNeighbors++;
      }
    }

    // 한 점에 연결하면서 활로가 많으면 좋음
    if (directNeighbors == 1) {
      var group = _getGroup(row, col);
      var liberties = _getLiberties(group);
      if (liberties.length >= 4) {
        value += 5;
      }
    }

    board[row][col] = Stone.none;
    return value;
  }

  int _calculateInfluence(int row, int col) {
    // 영향력 맵 사용
    return (_influenceMap[row][col] * 10).round();
  }

  int _calculateConnectivity(int row, int col, Stone stone) {
    int connectivity = 0;

    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == stone) {
        connectivity += 5;
        var group = _getGroup(nr, nc);
        connectivity += group.length;
      }
    }

    for (var dir in [[-1, -1], [-1, 1], [1, -1], [1, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == stone) {
        connectivity += 2;
      }
    }

    for (var dir in [[-2, 0], [2, 0], [0, -2], [0, 2]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      int mr = row + dir[0] ~/ 2;
      int mc = col + dir[1] ~/ 2;
      if (_isValidPosition(nr, nc) && _isValidPosition(mr, mc)) {
        if (board[nr][nc] == stone && board[mr][mc] == Stone.none) {
          connectivity += 3;
        }
      }
    }

    return connectivity;
  }

  int _calculateAttackPotential(int row, int col) {
    int attack = 0;

    board[row][col] = aiColor;

    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == widget.playerColor) {
        var group = _getGroup(nr, nc);
        var liberties = _getLiberties(group);

        if (liberties.length <= 2) {
          attack += (4 - liberties.length) * group.length * 3;
        } else if (liberties.length <= 4) {
          attack += group.length;
        }
      }
    }

    board[row][col] = Stone.none;

    return attack;
  }

  int _calculateEyePotential(int row, int col) {
    int eyePotential = 0;

    int adjacentOwn = 0;
    int adjacentEmpty = 0;
    int adjacentEdge = 0;

    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (!_isValidPosition(nr, nc)) {
        adjacentEdge++;
      } else if (board[nr][nc] == aiColor) {
        adjacentOwn++;
      } else if (board[nr][nc] == Stone.none) {
        adjacentEmpty++;
      }
    }

    if (adjacentOwn >= 3 && adjacentEmpty == 1) {
      eyePotential += 15;
    }
    if (adjacentEdge >= 1 && adjacentOwn >= 2) {
      eyePotential += 10;
    }

    return eyePotential;
  }

  int _calculateStrategicValue(int row, int col) {
    int stoneCount = _countStones();
    int value = 0;

    if (_isStarPoint(row, col)) {
      value += 25;
    }

    if (stoneCount < boardSize) {
      int edgeDist = _getEdgeDistance(row, col);
      if (edgeDist >= 2 && edgeDist <= 4) {
        value += 20;
      }
      if (_isCornerApproach(row, col)) {
        value += 15;
      }
    } else if (stoneCount < boardSize * 3) {
      int centerDist = (row - boardSize ~/ 2).abs() + (col - boardSize ~/ 2).abs();
      value += (boardSize - centerDist) * 2;
    } else {
      value += _getBoundaryValue(row, col) * 3;
    }

    return value;
  }

  int _getEdgeDistance(int row, int col) {
    int rowDist = min(row, boardSize - 1 - row);
    int colDist = min(col, boardSize - 1 - col);
    return min(rowDist, colDist);
  }

  bool _isStarPoint(int row, int col) {
    var starPoints = _getStarPoints();
    for (var point in starPoints) {
      if (point[0] == row && point[1] == col) return true;
    }
    return false;
  }

  int _getBoundaryValue(int row, int col) {
    int value = 0;

    bool hasOwn = false;
    bool hasOpponent = false;

    for (int dr = -2; dr <= 2; dr++) {
      for (int dc = -2; dc <= 2; dc++) {
        int nr = row + dr;
        int nc = col + dc;
        if (_isValidPosition(nr, nc)) {
          if (board[nr][nc] == aiColor) hasOwn = true;
          if (board[nr][nc] == widget.playerColor) hasOpponent = true;
        }
      }
    }

    if (hasOwn && hasOpponent) {
      value += 10;
    }

    return value;
  }

  int _strengthenWeakGroups(int row, int col) {
    int value = 0;

    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == aiColor) {
        var group = _getGroup(nr, nc);
        var liberties = _getLiberties(group);
        if (liberties.length <= 3) {
          board[row][col] = aiColor;
          var newLiberties = _getLiberties(_getGroup(nr, nc));
          board[row][col] = Stone.none;

          if (newLiberties.length > liberties.length) {
            value += (4 - liberties.length) * group.length;
          }
        }
      }
    }

    return value;
  }

  int _blockOpponentExpansion(int row, int col) {
    int value = 0;

    for (int dr = -2; dr <= 2; dr++) {
      for (int dc = -2; dc <= 2; dc++) {
        int nr = row + dr;
        int nc = col + dc;
        if (_isValidPosition(nr, nc) && board[nr][nc] == widget.playerColor) {
          int dist = dr.abs() + dc.abs();
          value += (5 - dist);
        }
      }
    }

    return value;
  }

  // ============ 기존 유틸리티 함수들 ============

  bool _isValidMove(int row, int col, Stone stone) {
    if (board[row][col] != Stone.none) return false;

    board[row][col] = stone;

    List<List<int>> captures = [];
    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == stone.opponent) {
        var group = _getGroup(nr, nc);
        if (_getLiberties(group).isEmpty) {
          captures.addAll(group);
        }
      }
    }

    if (captures.isEmpty) {
      var myGroup = _getGroup(row, col);
      if (_getLiberties(myGroup).isEmpty) {
        board[row][col] = Stone.none;
        return false;
      }
    }

    for (var cap in captures) {
      board[cap[0]][cap[1]] = Stone.none;
    }
    String afterCapture = _boardToString();

    board[row][col] = Stone.none;
    for (var cap in captures) {
      board[cap[0]][cap[1]] = stone.opponent;
    }

    if (lastBoardState != null && afterCapture == lastBoardState) {
      return false;
    }

    return true;
  }

  int _countCaptures(int row, int col, Stone stone) {
    board[row][col] = stone;
    int captures = 0;

    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == stone.opponent) {
        var group = _getGroup(nr, nc);
        if (_getLiberties(group).isEmpty) {
          captures += group.length;
        }
      }
    }

    board[row][col] = Stone.none;
    return captures;
  }

  List<List<int>> _getStarPoints() {
    if (boardSize == 9) {
      return [[2, 2], [2, 6], [4, 4], [6, 2], [6, 6]];
    } else if (boardSize == 13) {
      return [[3, 3], [3, 9], [6, 6], [9, 3], [9, 9]];
    } else if (boardSize == 19) {
      return [[3, 3], [3, 9], [3, 15], [9, 3], [9, 9], [9, 15], [15, 3], [15, 9], [15, 15]];
    }
    return [];
  }

  bool _isCornerApproach(int row, int col) {
    int margin = boardSize <= 9 ? 2 : 3;
    return (row < margin || row >= boardSize - margin) &&
           (col < margin || col >= boardSize - margin);
  }

  int _countStones() {
    int count = 0;
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] != Stone.none) count++;
      }
    }
    return count;
  }

  void _pass({bool isAI = false}) {
    if (gameOver) return;
    if (!isAI && isAIThinking) return;

    setState(() {
      consecutivePasses++;
      lastMove = null;

      if (consecutivePasses >= 2) {
        gameOver = true;
        showTerritory = true;
        _calculateTerritory();
        int blackScore = territoryCount['black']! + blackCaptures;
        int whiteScore = territoryCount['white']! + whiteCaptures + 6;

        if (widget.vsAI) {
          int playerScore = widget.playerColor == Stone.black ? blackScore : whiteScore;
          int aiScore = widget.playerColor == Stone.black ? whiteScore : blackScore;
          if (playerScore > aiScore) {
            gameMessage = '${tr('congratsWin')} (${tr('black')}: $blackScore, ${tr('white')}: $whiteScore)';
          } else if (aiScore > playerScore) {
            gameMessage = '${tr('aiWin')} (${tr('black')}: $blackScore, ${tr('white')}: $whiteScore)';
          } else {
            gameMessage = '${tr('draw')} (${tr('black')}: $blackScore, ${tr('white')}: $whiteScore)';
          }
        } else {
          if (blackScore > whiteScore) {
            gameMessage = '${tr('blackWin')} (${tr('black')}: $blackScore, ${tr('white')}: $whiteScore)';
          } else if (whiteScore > blackScore) {
            gameMessage = '${tr('whiteWin')} (${tr('black')}: $blackScore, ${tr('white')}: $whiteScore)';
          } else {
            gameMessage = '${tr('draw')} (${tr('black')}: $blackScore, ${tr('white')}: $whiteScore)';
          }
        }
      } else {
        currentPlayer = currentPlayer.opponent;
        if (widget.vsAI) {
          String colorName = widget.playerColor == Stone.black ? tr('black') : tr('white');
          if (currentPlayer == widget.playerColor) {
            gameMessage = '${tr('yourTurn')} ($colorName) - ${tr('aiPass')}';
          } else {
            gameMessage = tr('aiThinking');
          }
        } else {
          gameMessage = currentPlayer == Stone.black
              ? '${tr('blackTurn')} (${tr('whitePass')})'
              : '${tr('whiteTurn')} (${tr('blackPass')})';
        }
      }
    });

    if (!isAI && widget.vsAI && currentPlayer == aiColor && !gameOver) {
      _aiMove();
    }
  }

  bool _isValidPosition(int row, int col) {
    return row >= 0 && row < boardSize && col >= 0 && col < boardSize;
  }

  List<List<int>> _getGroup(int row, int col) {
    Stone stone = board[row][col];
    if (stone == Stone.none) return [];

    List<List<int>> group = [];
    Set<String> visited = {};
    Queue<List<int>> queue = Queue();
    queue.add([row, col]);
    visited.add('$row,$col');

    while (queue.isNotEmpty) {
      var current = queue.removeFirst();
      group.add(current);

      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = current[0] + dir[0];
        int nc = current[1] + dir[1];
        String key = '$nr,$nc';

        if (_isValidPosition(nr, nc) && !visited.contains(key) && board[nr][nc] == stone) {
          visited.add(key);
          queue.add([nr, nc]);
        }
      }
    }

    return group;
  }

  Set<String> _getLiberties(List<List<int>> group) {
    Set<String> liberties = {};

    for (var stone in group) {
      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = stone[0] + dir[0];
        int nc = stone[1] + dir[1];

        if (_isValidPosition(nr, nc) && board[nr][nc] == Stone.none) {
          liberties.add('$nr,$nc');
        }
      }
    }

    return liberties;
  }

  void _calculateTerritory() {
    Set<String> visited = {};
    territoryCount = {'black': 0, 'white': 0};

    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] == Stone.none && !visited.contains('$i,$j')) {
          var result = _floodFillTerritory(i, j, visited);
          if (result['owner'] == Stone.black) {
            territoryCount['black'] = territoryCount['black']! + (result['count'] as int);
          } else if (result['owner'] == Stone.white) {
            territoryCount['white'] = territoryCount['white']! + (result['count'] as int);
          }
        }
      }
    }
  }

  Map<String, dynamic> _floodFillTerritory(int startRow, int startCol, Set<String> visited) {
    List<List<int>> territory = [];
    Set<Stone> borderingStones = {};
    Queue<List<int>> queue = Queue();
    queue.add([startRow, startCol]);
    visited.add('$startRow,$startCol');

    while (queue.isNotEmpty) {
      var current = queue.removeFirst();
      territory.add(current);

      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = current[0] + dir[0];
        int nc = current[1] + dir[1];
        String key = '$nr,$nc';

        if (_isValidPosition(nr, nc)) {
          if (board[nr][nc] == Stone.none && !visited.contains(key)) {
            visited.add(key);
            queue.add([nr, nc]);
          } else if (board[nr][nc] != Stone.none) {
            borderingStones.add(board[nr][nc]);
          }
        }
      }
    }

    Stone? owner;
    if (borderingStones.length == 1) {
      owner = borderingStones.first;
    }

    return {'owner': owner, 'count': territory.length, 'territory': territory};
  }

  Stone? _getTerritoryOwner(int row, int col) {
    if (board[row][col] != Stone.none) return null;

    Set<String> visited = {};
    var result = _floodFillTerritory(row, col, visited);
    return result['owner'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vsAI ? tr('vsAI') : tr('twoPlayer')),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (widget.vsAI)
            PopupMenuButton<int>(
              icon: const Icon(Icons.grid_on),
              tooltip: tr('boardSize'),
              onSelected: _changeBoardSize,
              itemBuilder: (context) => [
                PopupMenuItem(value: 9, child: Text('9x9 (${tr('beginner')})')),
                PopupMenuItem(value: 13, child: Text('13x13 (${tr('intermediate')})')),
                PopupMenuItem(value: 19, child: Text('19x19 (${tr('expert')})')),
              ],
            ),
          // 저장/불러오기 메뉴
          PopupMenuButton<String>(
            icon: const Icon(Icons.save),
            tooltip: tr('save'),
            onSelected: (value) {
              if (value == 'save') {
                _saveGame();
              } else if (value == 'load') {
                _loadGame();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'save',
                child: Row(
                  children: [
                    const Icon(Icons.save_alt, size: 20),
                    const SizedBox(width: 8),
                    Text(tr('save')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'load',
                child: Row(
                  children: [
                    const Icon(Icons.folder_open, size: 20),
                    const SizedBox(width: 8),
                    Text(tr('load')),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
            tooltip: tr('newGame'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              gameMessage,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: gameOver
                    ? (gameMessage.contains(tr('congratsWin')) ? Colors.green : Colors.blue)
                    : (isAIThinking ? Colors.orange : Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildScoreCard(
                  widget.vsAI
                    ? (widget.playerColor == Stone.black ? '${tr('me')} (${tr('black')})' : '${tr('ai')} (${tr('black')})')
                    : tr('black'),
                  blackCaptures,
                  Colors.black
                ),
                Text('$boardSize x $boardSize', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                _buildScoreCard(
                  widget.vsAI
                    ? (widget.playerColor == Stone.white ? '${tr('me')} (${tr('white')})' : '${tr('ai')} (${tr('white')})')
                    : tr('white'),
                  whiteCaptures,
                  Colors.white
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDEB887),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomPaint(
                      painter: BoardPainter(
                        boardSize: boardSize,
                        showTerritory: showTerritory,
                        getTerritoryOwner: _getTerritoryOwner,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double cellSize = constraints.maxWidth / boardSize;
                          return GestureDetector(
                            onTapUp: (details) {
                              if (isAIThinking) return;
                              double x = details.localPosition.dx;
                              double y = details.localPosition.dy;
                              int col = (x / cellSize).floor();
                              int row = (y / cellSize).floor();
                              if (row >= 0 && row < boardSize && col >= 0 && col < boardSize) {
                                _placeStone(row, col);
                              }
                            },
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: boardSize,
                              ),
                              itemCount: boardSize * boardSize,
                              itemBuilder: (context, index) {
                                int row = index ~/ boardSize;
                                int col = index % boardSize;
                                return Container(
                                  color: Colors.transparent,
                                  child: Center(
                                    child: _buildStone(row, col),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: (gameOver || isAIThinking) ? null : () => _pass(),
                  icon: const Icon(Icons.skip_next),
                  label: Text(tr('pass')),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: (gameOver || isAIThinking) ? null : _showHint,
                  icon: const Icon(Icons.lightbulb_outline),
                  label: Text(tr('hint')),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    backgroundColor: showHint ? Colors.amber.shade200 : null,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _resetGame,
                  icon: const Icon(Icons.replay),
                  label: Text(tr('newGame')),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String label, int captures, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color == Colors.black ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: color == Colors.black ? Colors.white : Colors.black,
            ),
          ),
          Text(
            '${tr('captures')}: $captures',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color == Colors.black ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStone(int row, int col) {
    if (board[row][col] == Stone.none) {
      // 힌트 위치 표시
      if (showHint && hintMove != null && hintMove![0] == row && hintMove![1] == col) {
        double hintSize = boardSize <= 9 ? 26 : (boardSize <= 13 ? 20 : 16);
        Stone hintColor = widget.vsAI ? widget.playerColor : currentPlayer;
        return Container(
          width: hintSize,
          height: hintSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hintColor == Stone.black
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.7),
            border: Border.all(
              color: Colors.amber,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withValues(alpha: 0.6),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.lightbulb,
              size: hintSize * 0.6,
              color: Colors.amber.shade700,
            ),
          ),
        );
      }

      if (showTerritory) {
        Stone? owner = _getTerritoryOwner(row, col);
        if (owner != null) {
          return Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: owner == Stone.black
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.5),
              border: Border.all(
                color: owner == Stone.black ? Colors.black : Colors.grey,
                width: 1,
              ),
            ),
          );
        }
      }
      return const SizedBox();
    }

    bool isLastMove = lastMove != null &&
                      lastMove!.isNotEmpty &&
                      lastMove![0][0] == row &&
                      lastMove![0][1] == col;

    double stoneSize = boardSize <= 9 ? 28 : (boardSize <= 13 ? 22 : 18);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: stoneSize,
          height: stoneSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: board[row][col] == Stone.white
                ? Border.all(color: Colors.grey, width: 1)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 3,
                offset: const Offset(2, 2),
              ),
            ],
            gradient: RadialGradient(
              colors: board[row][col] == Stone.black
                  ? [Colors.grey[600]!, Colors.black]
                  : [Colors.white, Colors.grey[300]!],
              center: const Alignment(-0.3, -0.3),
            ),
          ),
        ),
        if (isLastMove)
          Container(
            width: stoneSize * 0.4,
            height: stoneSize * 0.4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: board[row][col] == Stone.black ? Colors.white : Colors.black,
            ),
          ),
      ],
    );
  }
}

class BoardPainter extends CustomPainter {
  final int boardSize;
  final bool showTerritory;
  final Stone? Function(int, int) getTerritoryOwner;

  BoardPainter({
    required this.boardSize,
    required this.showTerritory,
    required this.getTerritoryOwner,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    double cellSize = size.width / boardSize;
    double padding = cellSize / 2;

    for (int i = 0; i < boardSize; i++) {
      canvas.drawLine(
        Offset(padding, padding + i * cellSize),
        Offset(size.width - padding, padding + i * cellSize),
        paint,
      );
      canvas.drawLine(
        Offset(padding + i * cellSize, padding),
        Offset(padding + i * cellSize, size.height - padding),
        paint,
      );
    }

    List<List<int>> starPoints = _getStarPoints();

    final starPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    double starSize = boardSize <= 9 ? 4 : (boardSize <= 13 ? 4 : 3);

    for (var point in starPoints) {
      canvas.drawCircle(
        Offset(padding + point[1] * cellSize, padding + point[0] * cellSize),
        starSize,
        starPaint,
      );
    }
  }

  List<List<int>> _getStarPoints() {
    if (boardSize == 9) {
      return [
        [2, 2], [2, 6],
        [4, 4],
        [6, 2], [6, 6],
      ];
    } else if (boardSize == 13) {
      return [
        [3, 3], [3, 9],
        [6, 6],
        [9, 3], [9, 9],
      ];
    } else if (boardSize == 19) {
      return [
        [3, 3], [3, 9], [3, 15],
        [9, 3], [9, 9], [9, 15],
        [15, 3], [15, 9], [15, 15],
      ];
    }
    return [];
  }

  @override
  bool shouldRepaint(covariant BoardPainter oldDelegate) {
    return oldDelegate.boardSize != boardSize ||
           oldDelegate.showTerritory != showTerritory;
  }
}
