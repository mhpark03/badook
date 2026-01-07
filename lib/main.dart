import 'package:flutter/material.dart';
import 'dart:collection';
import 'dart:math';

void main() {
  runApp(const BadukApp());
}

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

class GameModeSelector extends StatelessWidget {
  final GameLanguage language;
  final Function(GameLanguage) onLanguageChanged;

  const GameModeSelector({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.get(language, 'appTitle')),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<GameLanguage>(
            icon: const Icon(Icons.language),
            tooltip: L10n.get(language, 'language'),
            onSelected: onLanguageChanged,
            itemBuilder: (context) => GameLanguage.values.map((lang) {
              return PopupMenuItem(
                value: lang,
                child: Row(
                  children: [
                    if (lang == language)
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
              L10n.get(language, 'appTitle'),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),
            // 컴퓨터와 대국 (흑)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BadukGame(
                      vsAI: true,
                      playerColor: Stone.black,
                      language: language,
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
                  Text(L10n.get(language, 'playAsBlack'), style: const TextStyle(fontSize: 18)),
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
                      language: language,
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
                  Text(L10n.get(language, 'playAsWhite'), style: const TextStyle(fontSize: 18)),
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
                      language: language,
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
                  Text(L10n.get(language, 'twoPlayerMode'), style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum Stone { none, black, white }

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

  const BadukGame({
    super.key,
    required this.vsAI,
    this.playerColor = Stone.black,
    required this.language,
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

  String tr(String key) => L10n.get(widget.language, key);

  Stone get aiColor => widget.playerColor.opponent;

  @override
  void initState() {
    super.initState();
    boardSize = 19;
    _initBoard();
    if (widget.vsAI && aiColor == Stone.black) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _aiMove();
      });
    }
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

    if (widget.vsAI && currentPlayer == aiColor && !gameOver) {
      _aiMove();
    }
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

  // ============ 강화된 AI ============

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

    List<int>? saveMove = _findSaveMove(validMoves);
    if (saveMove != null) return saveMove;

    List<int>? atariMove = _findAtariMove(validMoves);
    if (atariMove != null) return atariMove;

    if (captureMove != null) return captureMove;

    List<int>? blockMove = _findBlockMove(validMoves);
    if (blockMove != null) return blockMove;

    List<int>? pressureMove = _findPressureMove(validMoves);
    if (pressureMove != null) return pressureMove;

    return _findBestScoredMove(validMoves);
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

    score += _calculateInfluence(row, col) * 5;
    score += _calculateConnectivity(row, col, aiColor) * 8;
    score += _calculateAttackPotential(row, col) * 6;
    score += _calculateEyePotential(row, col) * 10;
    score += _calculateStrategicValue(row, col);

    board[row][col] = aiColor;
    var liberties = _getLiberties(_getGroup(row, col));
    board[row][col] = Stone.none;
    score += liberties.length * 4;

    score += _strengthenWeakGroups(row, col) * 7;
    score += _blockOpponentExpansion(row, col) * 5;
    score += _random.nextInt(3);

    return score;
  }

  int _calculateInfluence(int row, int col) {
    int influence = 0;

    for (int dr = -2; dr <= 2; dr++) {
      for (int dc = -2; dc <= 2; dc++) {
        int nr = row + dr;
        int nc = col + dc;
        if (_isValidPosition(nr, nc)) {
          if (board[nr][nc] == Stone.none) {
            int dist = dr.abs() + dc.abs();
            influence += (5 - dist);
          } else if (board[nr][nc] == aiColor) {
            influence += 2;
          }
        }
      }
    }

    return influence;
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
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _resetGame,
                  icon: const Icon(Icons.replay),
                  label: Text(tr('newGame')),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
