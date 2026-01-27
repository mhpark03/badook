import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../services/game_save_service.dart';
import '../../services/hula/hula_stats_service.dart';
import '../../../services/web_ad_helper.dart';
import '../../l10n/l10n_helper.dart';

// 카드 무늬
enum Suit { spade, heart, diamond, club }

// 플레잉 카드
class PlayingCard {
  final Suit suit;
  final int rank; // 1-13 (A, 2-10, J, Q, K)

  PlayingCard({required this.suit, required this.rank});

  // 카드 점수 (A=1, 2-9=숫자, J=10, Q=11, K=12)
  int get point {
    if (rank == 1) return 1;
    if (rank == 11) return 10; // J
    if (rank == 12) return 11; // Q
    if (rank == 13) return 12; // K
    return rank;
  }

  String get rankString {
    switch (rank) {
      case 1:
        return 'A';
      case 11:
        return 'J';
      case 12:
        return 'Q';
      case 13:
        return 'K';
      default:
        return '$rank';
    }
  }

  String get suitSymbol {
    switch (suit) {
      case Suit.spade:
        return '♠';
      case Suit.heart:
        return '♥';
      case Suit.diamond:
        return '♦';
      case Suit.club:
        return '♣';
    }
  }

  Color get suitColor {
    if (suit == Suit.heart || suit == Suit.diamond) {
      return Colors.red;
    }
    return Colors.black;
  }

  int get suitIndex {
    switch (suit) {
      case Suit.spade:
        return 0;
      case Suit.heart:
        return 1;
      case Suit.diamond:
        return 2;
      case Suit.club:
        return 3;
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is PlayingCard) {
      return suit == other.suit && rank == other.rank;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(suit, rank);

  @override
  String toString() => '$suitSymbol$rankString';
}

// 멜드 (등록된 조합)
class Meld {
  final List<PlayingCard> cards;
  final bool isRun; // true = Run (시퀀스), false = Group (세트)

  Meld({required this.cards, required this.isRun});

  int get size => cards.length;
}

// 땡큐 옵션 타입
enum ThankYouType {
  seven,        // 7 단독 등록
  attachPlayer, // 플레이어 멜드에 붙이기
  attachComputer, // 컴퓨터 멜드에 붙이기
  newMeld,      // 새 멜드 생성
}

// 땡큐 옵션
class ThankYouOption {
  final ThankYouType type;
  final PlayingCard discardCard;
  final List<PlayingCard> handCards; // 손패에서 사용할 카드들
  final int? meldIndex; // 붙일 멜드 인덱스
  final int? computerIndex; // 컴퓨터 인덱스 (컴퓨터 멜드에 붙일 때)
  final bool isRun; // 새 멜드가 Run인지

  ThankYouOption({
    required this.type,
    required this.discardCard,
    this.handCards = const [],
    this.meldIndex,
    this.computerIndex,
    this.isRun = false,
  });

  // 옵션 설명 문자열
  String getDescription(BuildContext context) {
    final l10n = getL10n(context);
    switch (type) {
      case ThankYouType.seven:
        return l10n.soloSevenRegistered.replaceAll('7', '${discardCard.suitSymbol}7');
      case ThankYouType.attachPlayer:
        return l10n.attachToMyMeld('${discardCard.suitSymbol}${discardCard.rankString}');
      case ThankYouType.attachComputer:
        return l10n.attachedToMeldOther('${discardCard.suitSymbol}${discardCard.rankString}', _HulaScreenState.staticAiNames[computerIndex!]);
      case ThankYouType.newMeld:
        final allCards = [...handCards, discardCard];
        if (isRun) {
          allCards.sort((a, b) => a.rank.compareTo(b.rank));
        }
        final cardStr = allCards.map((c) => '${c.suitSymbol}${c.rankString}').join(' ');
        return isRun ? 'Run: $cardStr' : 'Group: $cardStr';
    }
  }
}

// 반응형 사이즈 헬퍼
class _HulaResponsiveSizes {
  final double screenHeight;
  final double screenWidth;

  late final double centerCardWidth;
  late final double centerCardHeight;
  late final double playerCardWidth;
  late final double playerCardHeight;
  late final double playerSymbolSize;
  late final double playerRankSize;
  late final double aiCardWidth;
  late final double aiCardHeight;
  late final double meldCardWidth;
  late final double meldCardHeight;

  _HulaResponsiveSizes(this.screenHeight, this.screenWidth) {
    // 화면 크기에 따른 스케일 팩터 계산
    // 넓은 화면(웹)에서는 더 큰 카드 사용
    final isWideScreen = screenWidth > 800;
    final isLargeScreen = screenHeight > 700;
    final scaleFactor = isWideScreen && isLargeScreen ? 1.5 : (isWideScreen ? 1.3 : 1.0);

    final baseUnit = screenHeight / 100;
    final widthUnit = screenWidth / 100;

    // 중앙 덱/버린카드 - 화면 비율로 계산
    centerCardWidth = (widthUnit * 8 * scaleFactor).clamp(50.0, 140.0);
    centerCardHeight = (baseUnit * 14 * scaleFactor).clamp(70.0, 200.0);

    // 플레이어 카드
    playerCardWidth = (widthUnit * 6 * scaleFactor).clamp(40.0, 100.0);
    playerCardHeight = (baseUnit * 12 * scaleFactor).clamp(55.0, 140.0);
    playerSymbolSize = (baseUnit * 3.5 * scaleFactor).clamp(14.0, 40.0);
    playerRankSize = (baseUnit * 3 * scaleFactor).clamp(12.0, 36.0);

    // AI 카드 (뒷면)
    aiCardWidth = (widthUnit * 4 * scaleFactor).clamp(20.0, 60.0);
    aiCardHeight = (baseUnit * 6 * scaleFactor).clamp(26.0, 80.0);

    // 멜드 영역 카드
    meldCardWidth = (widthUnit * 3 * scaleFactor).clamp(16.0, 45.0);
    meldCardHeight = (baseUnit * 5 * scaleFactor).clamp(22.0, 60.0);
  }
}

// 훌라 난이도
enum HulaDifficulty { easy, medium, hard }

// 52장 덱 생성
List<PlayingCard> createDeck() {
  final deck = <PlayingCard>[];
  for (final suit in Suit.values) {
    for (int rank = 1; rank <= 13; rank++) {
      deck.add(PlayingCard(suit: suit, rank: rank));
    }
  }
  return deck;
}

class HulaScreen extends StatefulWidget {
  final int playerCount;
  final bool resumeGame;
  final HulaDifficulty difficulty;

  const HulaScreen({
    super.key,
    this.playerCount = 2,
    this.resumeGame = false,
    this.difficulty = HulaDifficulty.medium,
  });

  static Future<bool> hasSavedGame() async {
    return await GameSaveService.hasSavedGame('hula');
  }

  static Future<int?> getSavedPlayerCount() async {
    final gameState = await GameSaveService.loadGame('hula');
    if (gameState == null) return null;
    return gameState['playerCount'] as int?;
  }

  static Future<HulaDifficulty?> getSavedDifficulty() async {
    final gameState = await GameSaveService.loadGame('hula');
    if (gameState == null) return null;
    final difficultyIndex = gameState['difficulty'] as int?;
    if (difficultyIndex == null) return null;
    return HulaDifficulty.values[difficultyIndex];
  }

  static Future<void> clearSavedGame() async {
    await GameSaveService.clearSave();
  }

  @override
  State<HulaScreen> createState() => _HulaScreenState();
}

class _HulaScreenState extends State<HulaScreen> with TickerProviderStateMixin {
  // AI 이름 (마이티와 동일)
  static const List<String> _defaultAiNames = ['AI 1', 'AI 2', 'AI 3'];

  // 로컬라이즈된 AI 이름 가져오기
  List<String> get aiNames {
    final l10n = getL10n(context);
    return [l10n.aiPlayer1, l10n.aiPlayer2, l10n.aiPlayer3];
  }

  // static 접근용 (toString 등에서 사용)
  static List<String> get staticAiNames => _defaultAiNames;

  // 카드 덱
  List<PlayingCard> deck = [];
  List<PlayingCard> discardPile = [];

  // 손패
  List<PlayingCard> playerHand = [];
  List<List<PlayingCard>> computerHands = [];

  // 등록된 멜드
  List<Meld> playerMelds = [];
  List<List<Meld>> computerMelds = [];

  // 게임 상태
  late int playerCount;
  int currentTurn = 0; // 0 = 플레이어
  bool gameOver = false;
  String? winner;
  int? winnerIndex;
  bool isHula = false; // 훌라 여부

  // 컴퓨터 난이도 (0=쉬움, 1=보통, 2=어려움)
  List<int> computerDifficulties = [];

  // 턴 단계
  bool hasDrawn = false; // 이번 턴에 드로우했는지
  List<int> selectedCardIndices = []; // 선택된 카드 인덱스들
  bool waitingForNextTurn = false; // 다음 턴 대기 중
  Timer? _nextTurnTimer; // 자동 진행 타이머
  int _autoPlayCountdown = 5; // 자동 진행 카운트다운
  int _lastDiscardTurn = 0; // 마지막으로 카드를 버린 플레이어 턴
  Timer? _computerActionTimer; // 컴퓨터 액션 딜레이 타이머
  static const int _computerActionDelay = 2000; // 컴퓨터 액션 딜레이 (밀리초)
  VoidCallback? _pendingComputerAction; // 대기 후 실행할 컴퓨터 동작

  // 땡큐 대기
  bool _thankYouWaiting = false; // 플레이어 땡큐 대기 중
  int _thankYouCountdown = 0; // 땡큐 대기 카운트다운
  Timer? _thankYouTimer; // 땡큐 대기 타이머
  static const int _thankYouWaitSeconds = 5; // 땡큐 대기 시간 (초)

  // 점수
  List<int> scores = [];      // 손패 점수 (남은 카드 합)
  List<int> roundScores = []; // 라운드 점수 (승자와의 차이)

  // 메시지
  String? gameMessage;
  Timer? _messageTimer;

  // 힌트
  bool _showHint = false;

  // 애니메이션
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    playerCount = widget.playerCount;

    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // ★ context 사용이 필요한 초기화는 첫 프레임 이후에 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.resumeGame) {
        _loadSavedGame();
      } else {
        _initGame();
      }
    });
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _nextTurnTimer?.cancel();
    _computerActionTimer?.cancel();
    _thankYouTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _showNewGameDialog() {
    final l10n = getL10n(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.newGame),
        content: Text(l10n.newGameConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _showHint = false;
              _initGame();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: Text(l10n.confirm, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _onHintButtonPressed() {
    if (_showHint) {
      setState(() {
        _showHint = false;
      });
    } else {
      _showHintDialog();
    }
  }

  void _showHintDialog() {
    final l10n = getL10n(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.hint),
        content: Text(l10n.enableHintQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              setState(() {
                _showHint = true;
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            child: Text(l10n.confirm, style: const TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _initGame() {
    // 타이머 모두 취소
    _cancelNextTurnTimer();
    _messageTimer?.cancel();
    _computerActionTimer?.cancel();
    _thankYouTimer?.cancel();
    _thankYouWaiting = false;
    _thankYouCountdown = 0;

    // 이전 게임 승자 저장 (새 게임 시작 플레이어로 사용)
    final previousWinner = winnerIndex;

    deck = createDeck();
    deck.shuffle(Random());

    discardPile = [];
    playerHand = [];
    computerHands = List.generate(playerCount - 1, (_) => []);
    playerMelds = [];
    computerMelds = List.generate(playerCount - 1, (_) => []);
    scores = List.generate(playerCount, (_) => 0);
    roundScores = List.generate(playerCount, (_) => 0);

    // 컴퓨터 난이도 설정 (선택된 난이도 적용)
    final difficultyValue = widget.difficulty.index; // 0=쉬움, 1=보통, 2=어려움
    computerDifficulties = List.generate(playerCount - 1, (_) => difficultyValue);

    final random = Random();

    // 각 플레이어에게 7장씩 배분
    for (int i = 0; i < 7; i++) {
      playerHand.add(deck.removeLast());
      for (int c = 0; c < playerCount - 1; c++) {
        computerHands[c].add(deck.removeLast());
      }
    }

    // 버린 더미에 1장 공개
    discardPile.add(deck.removeLast());

    // 손패 정렬
    _sortHand(playerHand);
    for (var hand in computerHands) {
      _sortHand(hand);
    }

    // 시작 플레이어 선택 (이전 게임 승자가 먼저, 첫 게임은 랜덤)
    currentTurn = previousWinner ?? random.nextInt(playerCount);
    gameOver = false;
    winner = null;
    winnerIndex = null;
    isHula = false;
    hasDrawn = false;
    selectedCardIndices = [];
    waitingForNextTurn = false;
    gameMessage = null;
    _lastDiscardTurn = 0;
    _pendingComputerAction = null;

    setState(() {});
    _saveGame();

    // 컴퓨터가 먼저 시작하면 대기 상태로 전환
    final l10n = getL10n(context);
    if (currentTurn != 0) {
      final startingComputer = currentTurn;
      _showMessage(l10n.aiStartsFirst(aiNames[startingComputer - 1]));
      setState(() {
        waitingForNextTurn = true;
      });
      _startNextTurnTimer();
    } else {
      // 플레이어가 먼저 시작
      _showMessage(l10n.drawCard);
    }
  }

  // 다음 턴 자동 진행 타이머 시작
  void _startNextTurnTimer({int seconds = 5}) {
    _cancelNextTurnTimer();
    _autoPlayCountdown = seconds;

    // 메시지 타이머 취소 (타이머 동안 메시지 유지)
    _messageTimer?.cancel();

    _nextTurnTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || gameOver) {
        timer.cancel();
        return;
      }

      setState(() {
        _autoPlayCountdown--;
      });

      if (_autoPlayCountdown <= 0) {
        timer.cancel();
        _onNextTurn();
      }
    });
  }

  // 다음 턴 타이머 취소
  void _cancelNextTurnTimer() {
    _nextTurnTimer?.cancel();
    _nextTurnTimer = null;
  }

  // 컴퓨터 동작 후 대기 상태로 전환 (다음 동작을 콜백으로 저장)
  void _startWaitWithAction(VoidCallback nextAction, {int seconds = 5}) {
    setState(() {
      waitingForNextTurn = true;
      _pendingComputerAction = nextAction;
    });
    _startNextTurnTimer(seconds: seconds);
  }

  // 다음 턴 버튼 클릭
  void _onNextTurn() {
    _cancelNextTurnTimer();
    final pendingAction = _pendingComputerAction;
    setState(() {
      waitingForNextTurn = false;
      _pendingComputerAction = null;
    });
    _messageTimer?.cancel();

    if (gameOver) return;

    // 대기 중인 컴퓨터 동작이 있으면 실행
    if (pendingAction != null) {
      Timer(const Duration(milliseconds: 300), () {
        if (mounted && !gameOver) {
          pendingAction();
        }
      });
      return;
    }

    // 플레이어 후 순서 컴퓨터 땡큐 확인
    final afterResult = _checkComputerThankYouAfterPlayer(_lastDiscardTurn);
    if (afterResult != null) {
      Timer(const Duration(milliseconds: 300), () {
        if (mounted && !gameOver) {
          _executeComputerThankYou(afterResult);
        }
      });
      return;
    }

    // 땡큐 없으면 다음 턴 진행
    if (currentTurn != 0) {
      Timer(const Duration(milliseconds: 300), () {
        if (mounted && !gameOver) {
          _computerTurn();
        }
      });
    }
  }

  void _sortHand(List<PlayingCard> hand) {
    hand.sort((a, b) {
      if (a.suit != b.suit) {
        return a.suitIndex.compareTo(b.suitIndex);
      }
      return a.rank.compareTo(b.rank);
    });
  }

  // 카드를 Map으로 변환
  Map<String, dynamic> _cardToMap(PlayingCard card) {
    return {
      'suit': card.suit.index,
      'rank': card.rank,
    };
  }

  // Map에서 카드 복원
  PlayingCard _mapToCard(Map<String, dynamic> map) {
    return PlayingCard(
      suit: Suit.values[map['suit'] as int],
      rank: map['rank'] as int,
    );
  }

  // 멜드를 Map으로 변환
  Map<String, dynamic> _meldToMap(Meld meld) {
    return {
      'cards': meld.cards.map(_cardToMap).toList(),
      'isRun': meld.isRun,
    };
  }

  // Map에서 멜드 복원
  Meld _mapToMeld(Map<String, dynamic> map) {
    final cardsList = (map['cards'] as List)
        .map((c) => _mapToCard(c as Map<String, dynamic>))
        .toList();
    return Meld(
      cards: cardsList,
      isRun: map['isRun'] as bool,
    );
  }

  // 게임 상태 저장
  Future<void> _saveGame() async {
    if (gameOver) {
      await HulaScreen.clearSavedGame();
      return;
    }

    final gameState = {
      'playerCount': playerCount,
      'difficulty': widget.difficulty.index,
      'deck': deck.map(_cardToMap).toList(),
      'discardPile': discardPile.map(_cardToMap).toList(),
      'playerHand': playerHand.map(_cardToMap).toList(),
      'computerHands': computerHands
          .map((hand) => hand.map(_cardToMap).toList())
          .toList(),
      'playerMelds': playerMelds.map(_meldToMap).toList(),
      'computerMelds': computerMelds
          .map((melds) => melds.map(_meldToMap).toList())
          .toList(),
      'currentTurn': currentTurn,
      'hasDrawn': hasDrawn,
      'scores': scores,
      'computerDifficulties': computerDifficulties,
      'waitingForNextTurn': waitingForNextTurn,
      'lastDiscardTurn': _lastDiscardTurn,
    };

    await GameSaveService.saveGame('hula', gameState);
  }

  // 저장된 게임 불러오기
  Future<void> _loadSavedGame() async {
    final gameState = await GameSaveService.loadGame('hula');

    if (gameState == null) {
      _initGame();
      return;
    }

    setState(() {
      playerCount = gameState['playerCount'] as int;

      // 덱 복원
      deck = (gameState['deck'] as List)
          .map((c) => _mapToCard(c as Map<String, dynamic>))
          .toList();

      // 버린 더미 복원
      discardPile = (gameState['discardPile'] as List)
          .map((c) => _mapToCard(c as Map<String, dynamic>))
          .toList();

      // 플레이어 손패 복원
      playerHand = (gameState['playerHand'] as List)
          .map((c) => _mapToCard(c as Map<String, dynamic>))
          .toList();

      // 컴퓨터 손패 복원
      computerHands = (gameState['computerHands'] as List)
          .map((hand) => (hand as List)
              .map((c) => _mapToCard(c as Map<String, dynamic>))
              .toList())
          .toList();

      // 플레이어 멜드 복원
      playerMelds = (gameState['playerMelds'] as List)
          .map((m) => _mapToMeld(m as Map<String, dynamic>))
          .toList();

      // 컴퓨터 멜드 복원
      computerMelds = (gameState['computerMelds'] as List)
          .map((melds) => (melds as List)
              .map((m) => _mapToMeld(m as Map<String, dynamic>))
              .toList())
          .toList();

      currentTurn = gameState['currentTurn'] as int;
      hasDrawn = gameState['hasDrawn'] as bool;
      scores = List<int>.from(gameState['scores'] as List);

      // 난이도 복원 (저장된 게임에 없으면 선택된 난이도 사용)
      if (gameState.containsKey('computerDifficulties')) {
        computerDifficulties = List<int>.from(gameState['computerDifficulties'] as List);
      } else {
        final difficultyValue = widget.difficulty.index;
        computerDifficulties = List.generate(playerCount - 1, (_) => difficultyValue);
      }

      gameOver = false;
      winner = null;
      winnerIndex = null;
      isHula = false;
      selectedCardIndices = [];

      // 대기 상태 복원
      waitingForNextTurn = gameState['waitingForNextTurn'] as bool? ?? false;
      _lastDiscardTurn = gameState['lastDiscardTurn'] as int? ?? 0;

      // 내 차례에서는 대기 상태 불필요 (타이머/시작버튼 없음)
      if (currentTurn == 0) {
        waitingForNextTurn = false;
      }
    });
    _cancelNextTurnTimer();

    // 내 차례면 메시지만 표시
    final l10n = getL10n(context);
    if (currentTurn == 0) {
      _showMessage(hasDrawn ? l10n.discardOrRegister : l10n.drawCard);
    }
    // 컴퓨터 턴이고 대기 상태면 타이머 시작
    else if (waitingForNextTurn) {
      _startNextTurnTimer();
    }
    // 컴퓨터 턴이고 드로우 전이면 대기 상태로 만들고 타이머 시작
    else if (!hasDrawn) {
      setState(() {
        waitingForNextTurn = true;
      });
      _startNextTurnTimer();
    }
    // 컴퓨터 턴이고 드로우 후면 버리기 단계로 진행
    else {
      final computerIndex = currentTurn - 1;
      _computerActionTimer = Timer(const Duration(milliseconds: 500), () {
        if (mounted && !gameOver) {
          _computerTurnDiscard(computerIndex);
        }
      });
    }
  }

  void _showMessage(String message, {int seconds = 2, bool keepDuringWait = false}) {
    setState(() {
      gameMessage = message;
    });
    _messageTimer?.cancel();
    // 메시지는 다음 동작까지 항상 유지 (타이머로 지우지 않음)
  }

  // 덱에서 카드 드로우
  void _drawFromDeck() {
    if (hasDrawn || gameOver || currentTurn != 0) return;
    final l10n = getL10n(context);

    // 대기 상태면 타이머 취소
    if (waitingForNextTurn) {
      _cancelNextTurnTimer();
    }

    if (deck.isEmpty) {
      // 덱이 비면 버린 더미 섞기
      if (discardPile.length <= 1) {
        _showMessage(l10n.noCards);
        return;
      }
      final topCard = discardPile.removeLast();
      deck = List.from(discardPile);
      deck.shuffle(Random());
      discardPile = [topCard];
    }

    final card = deck.removeLast();
    playerHand.add(card);
    _sortHand(playerHand);

    setState(() {
      hasDrawn = true;
      selectedCardIndices = [];
      waitingForNextTurn = false;
    });
    _showMessage(getL10n(context).drewCardWithCard('${card.suitSymbol}${card.rankString}'));
    _saveGame();
  }

  // 버린 더미에서 카드 가져오기 (땡큐)
  void _drawFromDiscard() {
    if (gameOver) return;
    if (discardPile.isEmpty) return;

    // 플레이어 턴이거나, 대기 중일 때 (땡큐)
    if (currentTurn == 0 && hasDrawn) return;
    if (currentTurn != 0 && !waitingForNextTurn && !_thankYouWaiting) return;

    // 땡큐 가능 여부 확인 (등록 가능한 경우에만)
    if (!_canThankYou()) return;

    // 땡큐 대기 중이면 타이머 취소하고 플레이어 턴으로 변경
    if (_thankYouWaiting) {
      _thankYouTimer?.cancel();
      setState(() {
        currentTurn = 0;  // ★ 플레이어 턴으로 변경
        _thankYouWaiting = false;
        _thankYouCountdown = 0;
      });
    }

    // 모든 가능한 옵션 찾기
    final options = _findAllThankYouOptions();
    if (options.isEmpty) return;

    // 옵션이 1개면 바로 실행, 2개 이상이면 선택 다이얼로그
    if (options.length == 1) {
      _executeThankYouOption(options.first);
    } else {
      _showThankYouOptionsDialog(options);
    }
  }

  // 땡큐 옵션 선택 다이얼로그 표시
  void _showThankYouOptionsDialog(List<ThankYouOption> options) {
    // ★ 다이얼로그가 열려있는 동안 타이머로 인한 상태 변경 방지
    _cancelNextTurnTimer();
    _thankYouTimer?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(
              '${options.first.discardCard.suitSymbol}${options.first.discardCard.rankString}',
              style: TextStyle(
                color: options.first.discardCard.suitColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text('${getL10n(context).thankYou} ${getL10n(context).selectMethod}'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: _buildOptionIcon(option),
                  title: Text(
                    option.getDescription(context),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _executeThankYouOption(option);
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // ★ 취소 시 대기 상태였다면 타이머 재시작
              if (waitingForNextTurn) {
                _startNextTurnTimer();
              } else if (currentTurn != 0) {
                // 땡큐 대기에서 취소하면 다음 턴 진행
                _endThankYouWait();
              }
            },
            child: Text(getL10n(context).cancel),
          ),
        ],
      ),
    );
  }

  // 옵션 아이콘 빌드
  Widget _buildOptionIcon(ThankYouOption option) {
    IconData icon;
    Color color;
    switch (option.type) {
      case ThankYouType.seven:
        icon = Icons.looks_one;
        color = Colors.purple;
      case ThankYouType.attachPlayer:
        icon = Icons.add_circle;
        color = Colors.green;
      case ThankYouType.attachComputer:
        icon = Icons.add_circle_outline;
        color = Colors.orange;
      case ThankYouType.newMeld:
        icon = option.isRun ? Icons.linear_scale : Icons.grid_view;
        color = Colors.blue;
    }
    return Icon(icon, color: color, size: 32);
  }

  // 땡큐 옵션 실행
  void _executeThankYouOption(ThankYouOption option) {
    // 땡큐 상황: 대기 중에 가져가기
    if (waitingForNextTurn) {
      _cancelNextTurnTimer();
      setState(() {
        currentTurn = 0;
        waitingForNextTurn = false;
      });
    }

    // ★ 땡큐 대기 중에 가져가기 - 플레이어 턴으로 변경
    if (_thankYouWaiting) {
      _thankYouTimer?.cancel();
      setState(() {
        currentTurn = 0;
        _thankYouWaiting = false;
        _thankYouCountdown = 0;
      });
    }

    // ★ option.discardCard를 사용하여 정확한 카드 제거 (타이머로 인한 상태 변경 방지)
    final card = option.discardCard;
    // discardPile에서 해당 카드가 마지막에 있는지 확인 후 제거
    if (discardPile.isNotEmpty && discardPile.last == card) {
      discardPile.removeLast();
    } else {
      // 카드가 없거나 다른 카드면 무시 (이미 다른 처리로 제거됨)
      return;
    }
    String meldMessage = '';

    final l10n = getL10n(context);
    switch (option.type) {
      case ThankYouType.seven:
        playerMelds.add(Meld(cards: [card], isRun: false));
        _mergeConsecutiveRuns(playerMelds);
        meldMessage = l10n.thankYouRegisterAlone('${card.suitSymbol}7');

      case ThankYouType.attachPlayer:
        _attachToMeld(option.meldIndex!, card);
        meldMessage = l10n.thankYouAttachToMyMeld('${card.suitSymbol}${card.rankString}');

      case ThankYouType.attachComputer:
        _attachToMeldList(option.meldIndex!, card, computerMelds[option.computerIndex!]);
        meldMessage = l10n.thankYouAttachToOtherMeld('${card.suitSymbol}${card.rankString}', aiNames[option.computerIndex!]);

      case ThankYouType.newMeld:
        final newMeldCards = [...option.handCards, card];
        // 손패에서 제거
        for (final c in option.handCards) {
          playerHand.remove(c);
        }
        if (option.isRun) {
          newMeldCards.sort((a, b) => a.rank.compareTo(b.rank));
        }
        playerMelds.add(Meld(cards: newMeldCards, isRun: option.isRun));
        _mergeConsecutiveRuns(playerMelds);
        meldMessage = l10n.thankYouNewMeld(option.getDescription(context));
    }

    setState(() {
      hasDrawn = true;
      selectedCardIndices = [];
    });
    _showMessage(meldMessage);
    _saveGame();

    // 손패가 비었으면 승리
    if (playerHand.isEmpty) {
      _playerWins();
    }
  }

  // 카드 선택/해제
  void _toggleCardSelection(int index) {
    if (gameOver || currentTurn != 0) return;

    setState(() {
      if (selectedCardIndices.contains(index)) {
        selectedCardIndices.remove(index);
      } else {
        selectedCardIndices.add(index);
      }
      selectedCardIndices.sort();
    });
  }

  // 선택된 카드들이 유효한 멜드인지 확인
  bool _isValidMeld(List<PlayingCard> cards) {
    if (cards.length < 3) return false;

    // Group (같은 숫자) 체크
    if (_isValidGroup(cards)) return true;

    // Run (같은 무늬 연속) 체크
    if (_isValidRun(cards)) return true;

    return false;
  }

  bool _isValidGroup(List<PlayingCard> cards) {
    if (cards.length < 3 || cards.length > 4) return false;
    final rank = cards.first.rank;
    return cards.every((c) => c.rank == rank);
  }

  bool _isValidRun(List<PlayingCard> cards) {
    if (cards.length < 3) return false;

    final suit = cards.first.suit;
    if (!cards.every((c) => c.suit == suit)) return false;

    // 랭크 정렬
    final ranks = cards.map((c) => c.rank).toList()..sort();

    // A-2-3 또는 Q-K-A 처리
    // A를 1 또는 14로 취급
    bool isSequential = true;
    for (int i = 1; i < ranks.length; i++) {
      if (ranks[i] != ranks[i - 1] + 1) {
        isSequential = false;
        break;
      }
    }
    if (isSequential) return true;

    // A를 14로 취급해서 다시 체크 (Q-K-A)
    if (ranks.contains(1)) {
      final highRanks = ranks.map((r) => r == 1 ? 14 : r).toList()..sort();
      isSequential = true;
      for (int i = 1; i < highRanks.length; i++) {
        if (highRanks[i] != highRanks[i - 1] + 1) {
          isSequential = false;
          break;
        }
      }
      if (isSequential) return true;
    }

    return false;
  }

  // 기존 멜드에 카드 붙이기 가능 여부 확인
  int _canAttachToMeld(PlayingCard card) {
    for (int i = 0; i < playerMelds.length; i++) {
      final meld = playerMelds[i];

      // 단독 7 카드 특별 처리: Run으로만 확장 가능 (Group 불가)
      if (meld.cards.length == 1 && meld.cards.first.rank == 7) {
        final seven = meld.cards.first;
        // 같은 무늬의 6 또는 8이면 Run으로 확장
        if (card.suit == seven.suit && (card.rank == 6 || card.rank == 8)) {
          return i;
        }
        continue;
      }

      if (meld.isRun) {
        // Run: 같은 무늬이고 앞이나 뒤에 연속되는 카드
        if (card.suit == meld.cards.first.suit) {
          final ranks = meld.cards.map((c) => c.rank).toList()..sort();
          final minRank = ranks.first;
          final maxRank = ranks.last;

          // 앞에 붙이기 (A-2-3에 K 붙이기는 제외, 단 A가 14로 사용된 경우 제외)
          if (card.rank == minRank - 1) return i;
          // 뒤에 붙이기
          if (card.rank == maxRank + 1) return i;
          // A를 14로 취급 (Q-K-A 케이스)
          if (maxRank == 13 && card.rank == 1) return i;
          // A-2-3에서 A 앞에 K는 안됨 (A가 1로 사용된 경우)
        }
      } else {
        // Group: 같은 숫자 (최대 4장까지)
        if (meld.cards.length < 4 && card.rank == meld.cards.first.rank) {
          // 이미 같은 무늬가 있는지 확인
          if (!meld.cards.any((c) => c.suit == card.suit)) {
            return i;
          }
        }
      }
    }
    return -1;
  }

  // 멜드에 카드 붙이기
  void _attachToMeld(int meldIndex, PlayingCard card) {
    final meld = playerMelds[meldIndex];
    final newCards = [...meld.cards, card];
    bool newIsRun = meld.isRun;

    // 단독 7 카드에 붙이는 경우: Run 또는 Group 결정
    if (meld.cards.length == 1 && meld.cards.first.rank == 7) {
      final seven = meld.cards.first;
      if (card.suit == seven.suit && (card.rank == 6 || card.rank == 8)) {
        // 같은 무늬의 6 또는 8 → Run으로 변환
        newIsRun = true;
      } else {
        // 다른 7 → Group 유지
        newIsRun = false;
      }
    }

    if (newIsRun) {
      // Run은 정렬
      newCards.sort((a, b) => a.rank.compareTo(b.rank));
    }

    playerMelds[meldIndex] = Meld(cards: newCards, isRun: newIsRun);
    _mergeConsecutiveRuns(playerMelds);
  }

  // ★ 연속된 Run 멜드 병합
  void _mergeConsecutiveRuns(List<Meld> melds) {
    bool merged = true;
    while (merged) {
      merged = false;
      for (int i = 0; i < melds.length; i++) {
        final meld1 = melds[i];
        if (!meld1.isRun || meld1.cards.isEmpty) continue;
        final suit1 = meld1.cards.first.suit;
        final ranks1 = meld1.cards.map((c) => c.rank).toList()..sort();
        final min1 = ranks1.first;
        final max1 = ranks1.last;

        for (int j = i + 1; j < melds.length; j++) {
          final meld2 = melds[j];
          if (!meld2.isRun || meld2.cards.isEmpty) continue;
          if (meld2.cards.first.suit != suit1) continue;

          final ranks2 = meld2.cards.map((c) => c.rank).toList()..sort();
          final min2 = ranks2.first;
          final max2 = ranks2.last;

          // 연속인지 확인 (max1+1 == min2 또는 max2+1 == min1)
          if (max1 + 1 == min2 || max2 + 1 == min1) {
            final combinedCards = [...meld1.cards, ...meld2.cards];
            combinedCards.sort((a, b) => a.rank.compareTo(b.rank));
            melds[i] = Meld(cards: combinedCards, isRun: true);
            melds.removeAt(j);
            merged = true;
            break;
          }
        }
        if (merged) break;
      }
    }
  }

  // 7 카드인지 확인
  bool _isSeven(PlayingCard card) => card.rank == 7;

  // 땡큐 가능 여부 확인 (버린 카드를 가져와서 바로 등록 가능한지)
  // 주의: 새로운 멜드 등록이 가능할 때만 가져올 수 있음 (붙이기만 가능하면 안됨)
  // ★ 7 단독 땡큐 제거 - 3장 이상의 멜드로만 등록 가능
  bool _canThankYou() {
    if (discardPile.isEmpty) return false;
    final card = discardPile.last;

    // ★ 땡큐는 손패 + 버린카드로 새 멜드(3장 이상)를 만들 수 있을 때만 가능
    // 기존 멜드에 붙이기는 땡큐 조건이 아님
    final thankYouCards = _findThankYouMeldCards(card);
    return thankYouCards != null;
  }

  // 땡큐 카드와 손패로 만들 수 있는 멜드 카드 찾기 (첫 번째만)
  List<PlayingCard>? _findThankYouMeldCards(PlayingCard discardCard) {
    final options = _findAllNewMeldOptions(discardCard);
    if (options.isNotEmpty) {
      return options.first.handCards;
    }
    return null;
  }

  // 모든 가능한 새 멜드 옵션 찾기 (손패와 합쳐서)
  List<ThankYouOption> _findAllNewMeldOptions(PlayingCard discardCard) {
    final options = <ThankYouOption>[];

    // Group 체크: 같은 숫자 2장 이상 있는지
    final sameRank = playerHand.where((c) => c.rank == discardCard.rank).toList();
    if (sameRank.length >= 2) {
      // 3장 Group
      options.add(ThankYouOption(
        type: ThankYouType.newMeld,
        discardCard: discardCard,
        handCards: sameRank.take(2).toList(),
        isRun: false,
      ));
    }

    // Run 체크: 같은 무늬의 연속 숫자
    final sameSuit = playerHand.where((c) => c.suit == discardCard.suit).toList();
    if (sameSuit.length >= 2) {
      sameSuit.sort((a, b) => a.rank.compareTo(b.rank));

      // 모든 2장 조합 체크
      for (int i = 0; i < sameSuit.length; i++) {
        for (int j = i + 1; j < sameSuit.length; j++) {
          final c1 = sameSuit[i];
          final c2 = sameSuit[j];

          // c1, c2, discardCard가 연속인지 확인
          final ranks = [c1.rank, c2.rank, discardCard.rank]..sort();
          bool isSequential = ranks[1] == ranks[0] + 1 && ranks[2] == ranks[1] + 1;

          // A-2-3 또는 Q-K-A 특수 케이스
          if (!isSequential && ranks.contains(1)) {
            final highRanks = ranks.map((r) => r == 1 ? 14 : r).toList()..sort();
            isSequential = highRanks[1] == highRanks[0] + 1 && highRanks[2] == highRanks[1] + 1;
          }

          if (isSequential) {
            options.add(ThankYouOption(
              type: ThankYouType.newMeld,
              discardCard: discardCard,
              handCards: [c1, c2],
              isRun: true,
            ));
          }
        }
      }
    }

    return options;
  }

  // 모든 땡큐 옵션 찾기
  // ★ 땡큐는 손패 + 버린카드로 새 멜드(3장 이상)를 만드는 경우에만 가능
  // 기존 멜드에 붙이기는 땡큐 옵션이 아님
  List<ThankYouOption> _findAllThankYouOptions() {
    if (discardPile.isEmpty) return [];
    final card = discardPile.last;

    // 손패와 합쳐서 새 멜드 생성 옵션만 반환
    return _findAllNewMeldOptions(card);
  }

  // 특정 인덱스의 멜드에 카드를 붙일 수 있는지 확인
  bool _canAttachToMeldAtIndex(PlayingCard card, List<Meld> melds, int index) {
    if (index < 0 || index >= melds.length) return false;
    final meld = melds[index];

    // 단독 7 카드 특별 처리: Run으로만 확장 가능 (Group 불가)
    if (meld.cards.length == 1 && meld.cards.first.rank == 7) {
      final seven = meld.cards.first;
      if (card.suit == seven.suit && (card.rank == 6 || card.rank == 8)) {
        return true;
      }
      return false;
    }

    if (meld.isRun) {
      if (card.suit == meld.cards.first.suit) {
        final ranks = meld.cards.map((c) => c.rank).toList()..sort();
        final minRank = ranks.first;
        final maxRank = ranks.last;
        if (card.rank == minRank - 1) return true;
        if (card.rank == maxRank + 1) return true;
        if (maxRank == 13 && card.rank == 1) return true;
      }
    } else {
      if (meld.cards.length < 4 && card.rank == meld.cards.first.rank) {
        if (!meld.cards.any((c) => c.suit == card.suit)) {
          return true;
        }
      }
    }
    return false;
  }

  // 범용: 특정 멜드 목록에 카드를 붙일 수 있는지 확인
  int _canAttachToMeldList(PlayingCard card, List<Meld> melds) {
    for (int i = 0; i < melds.length; i++) {
      final meld = melds[i];

      // 단독 7 카드 특별 처리: Run으로만 확장 가능 (Group 불가)
      if (meld.cards.length == 1 && meld.cards.first.rank == 7) {
        final seven = meld.cards.first;
        if (card.suit == seven.suit && (card.rank == 6 || card.rank == 8)) {
          return i;
        }
        continue;
      }

      if (meld.isRun) {
        if (card.suit == meld.cards.first.suit) {
          final ranks = meld.cards.map((c) => c.rank).toList()..sort();
          final minRank = ranks.first;
          final maxRank = ranks.last;
          if (card.rank == minRank - 1) return i;
          if (card.rank == maxRank + 1) return i;
          if (maxRank == 13 && card.rank == 1) return i;
        }
      } else {
        if (meld.cards.length < 4 && card.rank == meld.cards.first.rank) {
          if (!meld.cards.any((c) => c.suit == card.suit)) {
            return i;
          }
        }
      }
    }
    return -1;
  }

  // 범용: 특정 멜드 목록에 카드 붙이기
  void _attachToMeldList(int meldIndex, PlayingCard card, List<Meld> melds) {
    final meld = melds[meldIndex];
    final newCards = [...meld.cards, card];
    bool newIsRun = meld.isRun;

    if (meld.cards.length == 1 && meld.cards.first.rank == 7) {
      final seven = meld.cards.first;
      if (card.suit == seven.suit && (card.rank == 6 || card.rank == 8)) {
        newIsRun = true;
      } else {
        newIsRun = false;
      }
    }

    if (newIsRun) {
      newCards.sort((a, b) => a.rank.compareTo(b.rank));
    }

    melds[meldIndex] = Meld(cards: newCards, isRun: newIsRun);
    _mergeConsecutiveRuns(melds);
  }

  // AI 추천 버릴 카드 인덱스 (플레이어용)
  int? _getRecommendedDiscardCardIndex() {
    if (playerHand.isEmpty) return null;
    if (currentTurn != 0 || !hasDrawn) return null; // 버리기 단계가 아님

    final recommendedCard = _selectCardToDiscard(playerHand);
    return playerHand.indexOf(recommendedCard);
  }

  // 스마트 카드 버리기: 버릴 카드 선택
  PlayingCard _selectCardToDiscard(List<PlayingCard> hand, {int? computerIndex}) {
    if (hand.length == 1) return hand.first;

    // 난이도에 따른 랜덤 선택 확률 (쉬움: 40%, 보통: 15%, 어려움: 0%)
    if (computerIndex != null && computerIndex < computerDifficulties.length) {
      final difficulty = computerDifficulties[computerIndex];
      final randomChance = difficulty == 0 ? 40 : (difficulty == 1 ? 15 : 0);
      if (Random().nextInt(100) < randomChance) {
        // 랜덤하게 카드 선택 (단, 7은 제외)
        final nonSevenCards = hand.where((c) => !_isSeven(c)).toList();
        if (nonSevenCards.isNotEmpty) {
          return nonSevenCards[Random().nextInt(nonSevenCards.length)];
        }
      }
    }

    // 스톱 위험도 계산 (컴퓨터의 경우)
    double stopRisk = 0.0;
    if (computerIndex != null) {
      stopRisk = _estimateStopRisk(computerIndex + 1);
    }

    // ★ 자신의 손패가 적으면 스톱 고려 (자신이 스톱할 가능성)
    // 손패 5장 이하면 낮은 점수 카드 유지가 중요
    double selfStopBonus = 0.0;
    if (hand.length <= 3) {
      selfStopBonus = 1.0; // 3장 이하: 최대 보너스
    } else if (hand.length <= 4) {
      selfStopBonus = 0.8; // 4장: 높은 보너스
    } else if (hand.length <= 5) {
      selfStopBonus = 0.5; // 5장: 중간 보너스
    }

    // 각 카드의 "유지 가치" 점수 계산 (높을수록 유지해야 함)
    final scores = <PlayingCard, double>{};

    for (final card in hand) {
      double keepScore = 0;

      // ★ 자신의 손패가 적을 때 낮은 점수 카드 유지 보너스
      if (selfStopBonus > 0) {
        if (card.point <= 3) {
          keepScore += (4 - card.point) * 40 * selfStopBonus; // A: 120, 2: 80, 3: 40 (at 100%)
        } else if (card.point >= 10) {
          keepScore -= 50 * selfStopBonus; // K/Q/J/10 유지 가치 낮춤
        }
      }

      // 스톱 위험도가 높을 때 낮은 점수 카드 유지 보너스
      if (stopRisk >= 40.0) {
        // 낮은 점수 카드 (A=1, 2=2, 3=3)는 유지 가치 높임
        // 높은 점수 카드 (K/Q/J/10=10)는 유지 가치 낮춤
        final riskMultiplier = stopRisk / 100.0; // 0.4 ~ 1.0
        if (card.point <= 3) {
          keepScore += (4 - card.point) * 30 * riskMultiplier; // A: 90, 2: 60, 3: 30 (at 100% risk)
        } else if (card.point >= 10) {
          keepScore -= 40 * riskMultiplier; // K/Q/J/10 유지 가치 낮춤
        }
      }

      // 1. 7 카드는 절대 버리면 안 됨 (단독 등록 가능)
      if (_isSeven(card)) {
        keepScore += 1000;
      }

      // 2. 같은 숫자 카드 개수 (Group 가능성)
      final sameRankCount = hand.where((c) => c.rank == card.rank).length;
      if (sameRankCount >= 2) {
        keepScore += sameRankCount * 30; // 2장: 60, 3장: 90
      }

      // 3. 같은 무늬 연속 카드 (Run 가능성)
      final sameSuitCards = hand.where((c) => c.suit == card.suit).toList();
      if (sameSuitCards.length >= 2) {
        sameSuitCards.sort((a, b) => a.rank.compareTo(b.rank));
        int consecutiveCount = 1;
        for (int i = 0; i < sameSuitCards.length - 1; i++) {
          // 연속이거나 1칸 건너뛴 경우 (2,4 같은 경우 3이 오면 Run 가능)
          final diff = sameSuitCards[i + 1].rank - sameSuitCards[i].rank;
          if (diff == 1 || diff == 2) {
            if (sameSuitCards[i].rank == card.rank ||
                sameSuitCards[i + 1].rank == card.rank) {
              consecutiveCount++;
            }
          }
        }
        if (consecutiveCount >= 2) {
          keepScore += consecutiveCount * 25; // 2장 연속: 50, 3장: 75
        }
      }

      // 4. 등록된 멜드에 바로 붙일 수 있는지 확인 (7 단독 포함)
      bool canAttachNow = false;
      if (_canAttachToMeldList(card, playerMelds) >= 0) {
        canAttachNow = true;
      }
      if (!canAttachNow) {
        for (final melds in computerMelds) {
          if (_canAttachToMeldList(card, melds) >= 0) {
            canAttachNow = true;
            break;
          }
        }
      }
      if (canAttachNow) {
        keepScore += 100; // ★ 바로 붙일 수 있는 카드는 높은 유지 가치
      }

      // 5. 버린 더미에서 같은 카드 확인 (확률 계산)
      // 같은 숫자가 이미 많이 버려졌으면 Group 확률 낮음
      final discardedSameRank =
          discardPile.where((c) => c.rank == card.rank).length;
      if (discardedSameRank >= 2) {
        keepScore -= 20; // Group 가능성 낮음
      }

      // 같은 무늬의 필요한 카드가 버려졌으면 Run 확률 낮음
      final neededForRun = [card.rank - 1, card.rank + 1];
      final discardedNeeded = discardPile
          .where((c) => c.suit == card.suit && neededForRun.contains(c.rank))
          .length;
      if (discardedNeeded >= 1) {
        keepScore -= 15 * discardedNeeded;
      }

      // 5. 카드 점수 (낮은 점수 카드 유지 선호)
      keepScore -= card.point * 2;

      scores[card] = keepScore;
    }

    // 가장 낮은 유지 가치를 가진 카드 버리기
    final sortedCards = hand.toList()
      ..sort((a, b) => scores[a]!.compareTo(scores[b]!));

    // 최종 안전장치: 7은 절대 버리지 않음 (다른 카드가 있는 경우)
    final selectedCard = sortedCards.first;
    if (_isSeven(selectedCard)) {
      final nonSeven = sortedCards.firstWhere((c) => !_isSeven(c), orElse: () => selectedCard);
      return nonSeven;
    }

    return selectedCard;
  }

  // 훌라 가능성 분석 (모든 카드를 한 번에 낼 수 있는지)
  // 반환: { 'canHula': bool, 'playableCount': int, 'probability': double }
  Map<String, dynamic> _analyzeHulaPotential(List<PlayingCard> hand, List<Meld> melds) {
    // 이미 멜드가 등록되어 있으면 훌라 불가능
    if (melds.isNotEmpty) {
      return {'canHula': false, 'playableCount': 0, 'probability': 0.0};
    }

    if (hand.isEmpty) {
      return {'canHula': true, 'playableCount': 0, 'probability': 100.0};
    }

    // 시뮬레이션: 모든 카드를 낼 수 있는지 계산
    final testHand = List<PlayingCard>.from(hand);
    final testMelds = <Meld>[];
    int playableCount = 0;

    // 1. 모든 가능한 멜드 찾기 (3장 이상)
    List<PlayingCard>? meld;
    while ((meld = _findBestMeld(testHand)) != null) {
      for (final card in meld!) {
        testHand.remove(card);
        playableCount++;
      }
      final isRun = _isValidRun(meld);
      testMelds.add(Meld(cards: meld, isRun: isRun));
    }

    // 2. 7 카드 단독 등록
    final sevens = testHand.where((c) => _isSeven(c)).toList();
    for (final seven in sevens) {
      testHand.remove(seven);
      testMelds.add(Meld(cards: [seven], isRun: false));
      playableCount++;
    }

    // 3. 자신의 멜드에 붙일 수 있는 카드
    bool attached = true;
    while (attached && testMelds.isNotEmpty) {
      attached = false;
      for (int i = testHand.length - 1; i >= 0; i--) {
        final card = testHand[i];
        final meldIndex = _canAttachToMeldList(card, testMelds);
        if (meldIndex >= 0) {
          _attachToMeldList(meldIndex, card, testMelds);
          testHand.removeAt(i);
          playableCount++;
          attached = true;
        }
      }
    }

    // 4. 다른 플레이어 멜드에 붙일 수 있는 카드 (자신의 멜드가 생긴 후에만)
    if (testMelds.isNotEmpty) {
      attached = true;
      while (attached && testHand.isNotEmpty) {
        attached = false;
        for (int i = testHand.length - 1; i >= 0; i--) {
          final card = testHand[i];

          // 플레이어 멜드에 붙이기
          if (playerMelds.isNotEmpty) {
            final idx = _canAttachToMeldList(card, playerMelds);
            if (idx >= 0) {
              testHand.removeAt(i);
              playableCount++;
              attached = true;
              continue;
            }
          }

          // 컴퓨터 멜드에 붙이기
          for (int c = 0; c < computerMelds.length; c++) {
            if (computerMelds[c].isNotEmpty) {
              final idx = _canAttachToMeldList(card, computerMelds[c]);
              if (idx >= 0) {
                testHand.removeAt(i);
                playableCount++;
                attached = true;
                break;
              }
            }
          }
        }
      }
    }

    // 남은 카드 확인
    final remainingCount = testHand.length;
    final canHula = remainingCount == 0;

    // 확률 계산
    double probability = 0.0;
    if (canHula) {
      probability = 100.0;
    } else {
      // 남은 카드가 적을수록 확률 높음
      // 남은 카드로 멜드를 만들 수 있는 가능성 계산
      probability = _calculateRemainingProbability(testHand, hand.length);
    }

    return {
      'canHula': canHula,
      'playableCount': playableCount,
      'remainingCount': remainingCount,
      'probability': probability,
    };
  }

  // 남은 카드로 멜드를 만들 확률 계산
  double _calculateRemainingProbability(List<PlayingCard> remaining, int originalHandSize) {
    if (remaining.isEmpty) return 100.0;

    double probability = 0.0;
    final checked = <PlayingCard>{};

    // 1. 기존 멜드에 붙일 수 있는 카드 확인 (확률 높음)
    int attachableCount = 0;
    for (final card in remaining) {
      bool canAttach = false;
      // 플레이어 멜드
      if (playerMelds.isNotEmpty && _canAttachToMeldList(card, playerMelds) >= 0) {
        canAttach = true;
      }
      // 컴퓨터 멜드
      if (!canAttach) {
        for (final cMelds in computerMelds) {
          if (cMelds.isNotEmpty && _canAttachToMeldList(card, cMelds) >= 0) {
            canAttach = true;
            break;
          }
        }
      }
      if (canAttach) {
        attachableCount++;
        probability += 25.0; // 붙일 수 있는 카드는 확률 높음
      }
    }

    // 2. 붙일 수 없는 카드들의 Group/Run 가능성
    for (final card in remaining) {
      if (checked.contains(card)) continue;
      checked.add(card);

      // 같은 숫자 카드 확인 (Group 가능성)
      final sameRank = remaining.where((c) => c.rank == card.rank).length;
      final discardedSameRank = discardPile.where((c) => c.rank == card.rank).length;
      final totalSameRank = sameRank + discardedSameRank;

      // 4장 중 남은 장수로 Group 확률 계산
      if (sameRank >= 2) {
        final neededForGroup = 3 - sameRank;
        final availableInDeck = 4 - totalSameRank;
        if (availableInDeck >= neededForGroup) {
          probability += 20.0 * (availableInDeck / 4.0);
        }
      }

      // 같은 무늬 연속 카드 확인 (Run 가능성)
      final sameSuit = remaining.where((c) => c.suit == card.suit).toList();
      if (sameSuit.length >= 2) {
        sameSuit.sort((a, b) => a.rank.compareTo(b.rank));
        // 연속 카드 확인
        bool hasConsecutive = false;
        for (int i = 0; i < sameSuit.length - 1; i++) {
          if (sameSuit[i + 1].rank - sameSuit[i].rank <= 2) {
            hasConsecutive = true;
            break;
          }
        }
        if (hasConsecutive) {
          // 필요한 카드가 버려졌는지 확인
          final neededRanks = <int>[];
          for (final c in sameSuit) {
            neededRanks.addAll([c.rank - 1, c.rank + 1]);
          }
          final discardedNeeded = discardPile
              .where((c) => c.suit == card.suit && neededRanks.contains(c.rank))
              .length;
          probability += 15.0 * (1 - discardedNeeded / neededRanks.length);
        }
      }
    }

    // 남은 카드 수에 따른 페널티 (붙일 수 있는 카드 제외)
    final nonAttachable = remaining.length - attachableCount;
    final remainingPenalty = nonAttachable * 10.0;
    probability = (probability - remainingPenalty).clamp(0.0, 100.0);

    return probability;
  }

  // 다른 플레이어의 스톱 위험도 계산
  // 반환: 0.0 ~ 100.0 (높을수록 스톱 가능성 높음)
  double _estimateStopRisk(int myIndex) {
    double maxRisk = 0.0;

    // 플레이어(0) 체크
    if (myIndex != 0) {
      final playerRisk = _calculatePlayerStopRisk(playerHand, playerMelds);
      maxRisk = maxRisk > playerRisk ? maxRisk : playerRisk;
    }

    // 다른 컴퓨터들 체크
    for (int i = 0; i < computerHands.length; i++) {
      if (i + 1 == myIndex) continue; // 자신 제외

      final risk = _calculatePlayerStopRisk(computerHands[i], computerMelds[i]);
      maxRisk = maxRisk > risk ? maxRisk : risk;
    }

    return maxRisk;
  }

  // 특정 플레이어의 스톱 가능성 계산
  double _calculatePlayerStopRisk(List<PlayingCard> hand, List<Meld> melds) {
    double risk = 0.0;

    // 1. 손패 수에 따른 위험도 (적을수록 위험)
    // 3장 이하: 매우 위험, 5장 이하: 위험, 7장 이하: 주의
    if (hand.length <= 2) {
      risk += 80.0;
    } else if (hand.length <= 3) {
      risk += 60.0;
    } else if (hand.length <= 4) {
      risk += 40.0;
    } else if (hand.length <= 5) {
      risk += 25.0;
    } else if (hand.length <= 7) {
      risk += 10.0;
    }

    // 2. 등록된 멜드 수에 따른 위험도
    // 멜드가 많을수록 카드 정리가 잘 되어 있음
    if (melds.length >= 4) {
      risk += 30.0;
    } else if (melds.length >= 3) {
      risk += 20.0;
    } else if (melds.length >= 2) {
      risk += 10.0;
    }

    // 3. 손패 점수 추정 (낮을수록 스톱 가능성 높음)
    final handScore = _calculateHandScore(hand);
    if (handScore <= 5) {
      risk += 25.0;
    } else if (handScore <= 10) {
      risk += 15.0;
    } else if (handScore <= 20) {
      risk += 5.0;
    }

    // 4. 기존 멜드에 붙일 수 있는 카드 수 (멜드가 있을 때만)
    if (melds.isNotEmpty) {
      int attachableCount = 0;
      for (final card in hand) {
        // 자신의 멜드에 붙이기
        if (_canAttachToMeldList(card, melds) >= 0) {
          attachableCount++;
          continue;
        }
        // 플레이어 멜드에 붙이기
        if (playerMelds.isNotEmpty && _canAttachToMeldList(card, playerMelds) >= 0) {
          attachableCount++;
          continue;
        }
        // 컴퓨터 멜드에 붙이기
        for (final cMelds in computerMelds) {
          if (cMelds.isNotEmpty && _canAttachToMeldList(card, cMelds) >= 0) {
            attachableCount++;
            break;
          }
        }
      }
      // 붙일 수 있는 카드가 많을수록 위험도 증가
      if (attachableCount >= 3) {
        risk += 20.0;
      } else if (attachableCount >= 2) {
        risk += 12.0;
      } else if (attachableCount >= 1) {
        risk += 5.0;
      }
    }

    return risk.clamp(0.0, 100.0);
  }

  // 컴퓨터가 스톱을 외칠지 결정
  bool _shouldComputerCallStop(int computerIndex) {
    // 난이도에 따른 스톱 확률 (쉬움: 0%, 보통: 50%, 어려움: 100%)
    final difficulty = computerDifficulties.length > computerIndex
        ? computerDifficulties[computerIndex]
        : 2;
    if (difficulty == 0) return false; // 쉬운 난이도는 스톱 안 함

    final myHand = computerHands[computerIndex];
    final myScore = _calculateHandScore(myHand);

    // 1. 손패가 너무 많으면 스톱 안 함 (불리할 가능성)
    if (myHand.length > 5) return false;

    // 2. 내 점수가 너무 높으면 스톱 안 함
    if (myScore > 15) return false;

    // 3. 다른 플레이어 점수 추정 및 비교
    int betterCount = 0; // 나보다 점수가 낮을 것 같은 플레이어 수
    int totalPlayers = playerCount - 1; // 자신 제외
    bool someoneAboutToWin = false;

    // 플레이어 확인
    final playerScore = _calculateHandScore(playerHand);
    if (playerScore < myScore) {
      betterCount++;
    }
    if (playerHand.length <= 2) {
      someoneAboutToWin = true;
    }

    // 다른 컴퓨터 확인
    for (int i = 0; i < computerHands.length; i++) {
      if (i == computerIndex) continue;

      final otherHand = computerHands[i];
      final otherScore = _calculateHandScore(otherHand);

      if (otherScore < myScore) {
        betterCount++;
      }
      if (otherHand.length <= 2) {
        someoneAboutToWin = true;
      }
    }

    // 4. 스톱 결정 조건

    // 4-1. 내 점수가 0이면 무조건 스톱 (완벽)
    if (myScore == 0) return true;

    // 4-2. 상대가 곧 이길 것 같고 내 점수가 낮으면 선제 스톱
    if (someoneAboutToWin && myScore <= 5 && betterCount == 0) {
      return true;
    }

    // 4-3. 손패 2장 이하 & 점수 5점 이하 & 모든 상대보다 유리
    if (myHand.length <= 2 && myScore <= 5 && betterCount == 0) {
      return true;
    }

    // 4-4. 손패 3장 이하 & 점수 3점 이하 & 절반 이상 상대보다 유리
    if (myHand.length <= 3 && myScore <= 3 && betterCount <= totalPlayers / 2) {
      return true;
    }

    // 4-5. 손패 1장 & 점수 10점 이하 (거의 확실히 유리)
    if (myHand.length == 1 && myScore <= 10 && betterCount == 0) {
      // 보통 난이도는 50% 확률
      if (difficulty == 1 && Random().nextInt(100) >= 50) return false;
      return true;
    }

    return false;
  }

  // 컴퓨터가 스톱 선언
  void _computerCallStop(int computerIndex) {
    _showMessage(getL10n(context).playerStopped(aiNames[computerIndex]));
    _calculateScoresAndEnd(stopperIndex: computerIndex + 1); // 컴퓨터 인덱스 + 1
  }

  // 멜드 등록 여부 결정 (훌라 가능성 + 스톱 위험도 고려)
  bool _shouldRegisterMelds(List<PlayingCard> hand, List<Meld> melds, {int? computerIndex}) {
    // 이미 멜드가 있으면 훌라 불가능 → 등록해도 됨
    if (melds.isNotEmpty) return true;

    final analysis = _analyzeHulaPotential(hand, melds);

    // 훌라 가능하면 즉시 등록 (승리)
    if (analysis['canHula'] == true) return true;

    final probability = analysis['probability'] as double;
    final remainingCount = analysis['remainingCount'] as int;

    // 스톱 위험도 계산
    final myIndex = computerIndex ?? 0;
    final stopRisk = _estimateStopRisk(myIndex);
    final nextTurnStopRisk = _estimateNextTurnStopRisk(myIndex);
    final myHandScore = _calculateHandScore(hand);

    // ★ 7 카드 보유 시 스톱 위험에 더 민감하게 반응
    final hasSevens = hand.any((c) => _isSeven(c));
    final sevensCount = hand.where((c) => _isSeven(c)).length;

    // ★ 다음 턴에 스톱 가능성이 높으면 즉시 등록 (눈치 게임)
    if (nextTurnStopRisk >= 80.0) {
      return true; // 다음 턴에 스톱 확실시, 즉시 등록
    }

    // ★ 7을 가지고 있고 스톱 위험이 높으면 즉시 등록
    if (hasSevens && stopRisk >= 50.0) {
      return true; // 7이 있으면 더 빨리 등록
    }

    // ★ 7이 여러 장 있고 스톱 위험이 있으면 등록
    if (sevensCount >= 2 && stopRisk >= 35.0) {
      return true; // 7이 2장 이상이면 더 빨리 등록
    }

    // 스톱 위험도가 높으면 등록하여 벌점 최소화
    // 위험도 70% 이상이고 내 손패 점수가 높으면 즉시 등록
    if (stopRisk >= 70.0 && myHandScore >= 15) {
      return true; // 방어적 등록
    }

    // 위험도 50% 이상이고 내 손패 점수가 매우 높으면 등록
    if (stopRisk >= 50.0 && myHandScore >= 25) {
      return true;
    }

    // 훌라 확률 vs 스톱 위험도 비교
    // 스톱 위험도가 훌라 확률보다 높으면 등록 고려
    if (stopRisk > probability && stopRisk >= 40.0) {
      // 단, 훌라가 거의 완성 상태면 (남은 카드 1장) 계속 시도
      if (remainingCount <= 1 && probability >= 50.0) {
        // ★ 그래도 7이 있고 스톱 위험이 높으면 등록
        if (hasSevens && stopRisk >= 60.0) {
          return true;
        }
        return false; // 훌라 시도 계속
      }
      return true; // 방어적 등록
    }

    // 훌라 확률이 높으면 대기
    // 60% 이상이고 남은 카드가 3장 이하면 훌라 시도
    if (probability >= 60.0 && remainingCount <= 3) {
      // 단, 스톱 위험도가 매우 높으면 등록
      if (stopRisk >= 60.0) {
        return true;
      }
      // ★ 7이 있고 다음 턴 스톱 위험이 높으면 등록
      if (hasSevens && nextTurnStopRisk >= 60.0) {
        return true;
      }
      return false; // 등록 대기
    }

    // 손패가 많으면 일단 등록 (방어적)
    if (hand.length >= 10) return true;

    // 확률이 40% 이상이고 남은 카드가 2장 이하면 대기
    if (probability >= 40.0 && remainingCount <= 2) {
      // 단, 스톱 위험도가 높으면 등록
      if (stopRisk >= 50.0) {
        return true;
      }
      // ★ 7이 있고 다음 턴 스톱 위험이 높으면 등록
      if (hasSevens && nextTurnStopRisk >= 50.0) {
        return true;
      }
      return false;
    }

    // 그 외에는 등록
    return true;
  }

  // ★ 다음 턴에 스톱될 가능성 계산 (더 공격적인 예측)
  double _estimateNextTurnStopRisk(int myIndex) {
    double maxRisk = 0.0;

    // 플레이어(0) 체크
    if (myIndex != 0) {
      final risk = _calculateNextTurnStopProbability(playerHand, playerMelds);
      maxRisk = maxRisk > risk ? maxRisk : risk;
    }

    // 다른 컴퓨터들 체크
    for (int i = 0; i < computerHands.length; i++) {
      if (i + 1 == myIndex) continue; // 자신 제외

      final risk = _calculateNextTurnStopProbability(computerHands[i], computerMelds[i]);
      maxRisk = maxRisk > risk ? maxRisk : risk;
    }

    return maxRisk;
  }

  // 특정 플레이어가 다음 턴에 스톱할 확률 계산
  double _calculateNextTurnStopProbability(List<PlayingCard> hand, List<Meld> melds) {
    // 등록이 없으면 스톱 불가 (2배 패널티 감수해야 함)
    if (melds.isEmpty) return 0.0;

    final handScore = _calculateHandScore(hand);

    // 손패가 2장 이하이고 점수가 5 이하면 거의 확실히 스톱
    if (hand.length <= 2 && handScore <= 5) {
      return 95.0;
    }

    // 손패가 3장 이하이고 점수가 8 이하면 높은 확률
    if (hand.length <= 3 && handScore <= 8) {
      return 80.0;
    }

    // 손패가 4장 이하이고 점수가 10 이하면 중간 확률
    if (hand.length <= 4 && handScore <= 10) {
      return 60.0;
    }

    // 손패가 5장 이하이고 점수가 15 이하면 낮은 확률
    if (hand.length <= 5 && handScore <= 15) {
      return 40.0;
    }

    // 멜드가 많고 손패가 적으면 스톱 가능성
    if (melds.length >= 3 && hand.length <= 5) {
      return 35.0 + (5 - hand.length) * 10;
    }

    return 0.0;
  }

  // 7 카드 3장 이상일 때 Group vs Run 전략 결정
  String _decideSevensStrategy(List<PlayingCard> sevens, List<PlayingCard> hand) {
    // Run 가능성 점수 계산
    double runPotential = 0;
    // Group 점수 (기본값: 3장 즉시 제거)
    double groupScore = 30;

    for (final seven in sevens) {
      final suit = seven.suit;

      // 손에 있는 6, 8 확인
      final hasSix = hand.any((c) => c.suit == suit && c.rank == 6);
      final hasEight = hand.any((c) => c.suit == suit && c.rank == 8);

      // 손에 있는 5, 9 확인 (더 긴 Run 가능성)
      final hasFive = hand.any((c) => c.suit == suit && c.rank == 5);
      final hasNine = hand.any((c) => c.suit == suit && c.rank == 9);

      // 버린 더미에서 6, 8 확인
      final discardedSix = discardPile.where((c) => c.suit == suit && c.rank == 6).length;
      final discardedEight = discardPile.where((c) => c.suit == suit && c.rank == 8).length;

      // Run 가능성 계산
      double sevenRunScore = 0;

      // 이미 6 또는 8을 가지고 있으면 Run 유리
      if (hasSix) sevenRunScore += 25;
      if (hasEight) sevenRunScore += 25;

      // 5 또는 9도 있으면 긴 Run 가능
      if (hasSix && hasFive) sevenRunScore += 15;
      if (hasEight && hasNine) sevenRunScore += 15;

      // 6, 8이 버려졌으면 Run 확률 낮음
      // 같은 숫자는 4장뿐이므로 2장 이상 버려지면 확률 낮음
      if (discardedSix >= 2) sevenRunScore -= 20;
      if (discardedEight >= 2) sevenRunScore -= 20;
      if (discardedSix == 1) sevenRunScore -= 5;
      if (discardedEight == 1) sevenRunScore -= 5;

      // 6, 8 모두 없고 버려진 것도 많으면 Run 불가능에 가까움
      if (!hasSix && !hasEight && discardedSix + discardedEight >= 2) {
        sevenRunScore -= 30;
      }

      runPotential += sevenRunScore;
    }

    // 평균 Run 가능성
    runPotential /= sevens.length;

    // Group 점수 조정
    // 4번째 7이 손에 있으면 Group 유리
    if (sevens.length >= 4) {
      groupScore += 20;
    }

    // 방어적 관점: 손패가 많으면 빨리 줄이는 Group 선호
    if (hand.length > 10) {
      groupScore += 15;
    }

    // 공격적 관점: 손패가 적으면 Run으로 더 많이 붙이기 선호
    if (hand.length <= 5) {
      runPotential += 10;
    }

    // 결정
    if (runPotential > groupScore) {
      return 'run';
    } else {
      return 'group';
    }
  }

  // 멜드 등록
  void _registerMeld() {
    final l10n = getL10n(context);
    final selectedCards =
        selectedCardIndices.map((i) => playerHand[i]).toList();

    // 7 카드 단독 등록 (훌라 특별 규칙)
    if (selectedCardIndices.length == 1 && _isSeven(selectedCards.first)) {
      final card = selectedCards.first;
      playerHand.remove(card);
      playerMelds.add(Meld(cards: [card], isRun: false));
      _mergeConsecutiveRuns(playerMelds);

      setState(() {
        selectedCardIndices = [];
      });
      _showMessage(l10n.register7Alone);
      _saveGame();

      if (playerHand.isEmpty) {
        _playerWins();
      }
      return;
    }

    // 1~2장 선택: 기존 멜드에 붙이기 시도 (플레이어 + 컴퓨터 멜드)
    if (selectedCardIndices.length < 3) {
      // 각 카드에 대해 붙이기 가능 여부 확인
      bool attached = false;
      for (final card in selectedCards) {
        // 1. 플레이어 멜드에 붙이기 시도
        final playerMeldIndex = _canAttachToMeld(card);
        if (playerMeldIndex >= 0) {
          _attachToMeld(playerMeldIndex, card);
          playerHand.remove(card);
          attached = true;
          continue;
        }

        // 2. 컴퓨터 멜드에 붙이기 시도
        for (int c = 0; c < computerMelds.length; c++) {
          final compMeldIndex = _canAttachToMeldList(card, computerMelds[c]);
          if (compMeldIndex >= 0) {
            _attachToMeldList(compMeldIndex, card, computerMelds[c]);
            playerHand.remove(card);
            attached = true;
            break;
          }
        }
      }

      if (attached) {
        setState(() {
          selectedCardIndices = [];
        });
        _showMessage(l10n.addedToMeld);
        _saveGame();

        if (playerHand.isEmpty) {
          _playerWins();
        }
        return;
      }

      _showMessage(l10n.noMeldToAttach);
      return;
    }

    // 3장 이상: 새 멜드 등록
    if (!_isValidMeld(selectedCards)) {
      _showMessage(l10n.invalidCombination);
      return;
    }

    final isRun = _isValidRun(selectedCards);

    // 카드 제거 (역순으로)
    for (int i = selectedCardIndices.length - 1; i >= 0; i--) {
      playerHand.removeAt(selectedCardIndices[i]);
    }

    playerMelds.add(Meld(cards: selectedCards, isRun: isRun));
    _mergeConsecutiveRuns(playerMelds);

    setState(() {
      selectedCardIndices = [];
    });

    _showMessage(isRun ? getL10n(context).runRegistered : getL10n(context).groupRegistered);
    _saveGame();

    // 손패가 비었으면 승리
    if (playerHand.isEmpty) {
      _playerWins();
    }
  }

  // 카드 버리기
  void _discardCard() {
    final l10n = getL10n(context);
    if (!hasDrawn) {
      _showMessage(l10n.drawFirst);
      return;
    }
    if (selectedCardIndices.length != 1) {
      _showMessage(l10n.selectCardToDiscard);
      return;
    }

    final cardIndex = selectedCardIndices.first;
    final card = playerHand.removeAt(cardIndex);
    discardPile.add(card);

    setState(() {
      selectedCardIndices = [];
      hasDrawn = false;
    });

    _showMessage(getL10n(context).discardCardMsg('${card.suitSymbol}${card.rankString}'));
    _saveGame();

    // 손패가 비었으면 승리
    if (playerHand.isEmpty) {
      _playerWins();
      return;
    }

    // 땡큐 확인: 플레이어 전 순서 컴퓨터는 즉시, 후 순서는 10초 후
    _lastDiscardTurn = 0;
    Timer(const Duration(milliseconds: 300), () {
      if (mounted && !gameOver) {
        // 1. 플레이어 전 순서 컴퓨터 땡큐 확인 (즉시)
        final beforeResult = _checkComputerThankYouBeforePlayer(0);
        if (beforeResult != null) {
          _executeComputerThankYou(beforeResult);
        } else {
          // 2. 플레이어 후 순서 컴퓨터가 있으면 10초 대기
          _startThankYouWait();
        }
      }
    });
  }

  // 땡큐 대기 시작 (플레이어에게 기회 부여)
  void _startThankYouWait() {
    // 플레이어가 땡큐 가능한지 확인
    final canPlayerThankYou = _canThankYou();

    setState(() {
      currentTurn = (currentTurn + 1) % playerCount;
      hasDrawn = false;
      selectedCardIndices = [];
      waitingForNextTurn = currentTurn == 0; // 플레이어 턴일 때만 대기 상태
    });
    _saveGame();

    if (currentTurn != 0) {
      // 다음이 컴퓨터 턴인데 플레이어가 땡큐 가능하면 대기 시간 부여
      if (canPlayerThankYou) {
        _startThankYouCountdown();
      } else {
        // 땡큐 불가능하면 바로 진행
        Timer(const Duration(milliseconds: 300), () {
          if (mounted && !gameOver) {
            _onNextTurn();
          }
        });
      }
    } else {
      // 플레이어 턴: 메시지 타이머만 취소 (메시지 유지)
      _messageTimer?.cancel();
    }
  }

  // 땡큐 대기 카운트다운 시작
  void _startThankYouCountdown() {
    _thankYouTimer?.cancel();
    setState(() {
      _thankYouWaiting = true;
      _thankYouCountdown = _thankYouWaitSeconds;
    });

    _thankYouTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || gameOver) {
        timer.cancel();
        return;
      }

      setState(() {
        _thankYouCountdown--;
      });

      if (_thankYouCountdown <= 0) {
        timer.cancel();
        _endThankYouWait();
      }
    });
  }

  // 땡큐 대기 종료 (시간 초과 또는 플레이어가 땡큐/패스)
  void _endThankYouWait() {
    _thankYouTimer?.cancel();
    setState(() {
      _thankYouWaiting = false;
      _thankYouCountdown = 0;
    });

    if (mounted && !gameOver && currentTurn != 0) {
      // 플레이어 후 순서 컴퓨터 땡큐 확인
      final afterResult = _checkComputerThankYouAfterPlayer(_lastDiscardTurn);
      if (afterResult != null) {
        _executeComputerThankYou(afterResult);
      } else {
        _onNextTurn();
      }
    }
  }

  void _playerWins() {
    // 등록 없이 한 번에 다 냈으면 훌라
    isHula = playerMelds.isEmpty && playerHand.isEmpty;
    _endGame(0);
  }

  void _endTurn() {
    if (gameOver) return;

    setState(() {
      currentTurn = (currentTurn + 1) % playerCount;
      hasDrawn = false;
      selectedCardIndices = [];
      waitingForNextTurn = currentTurn == 0; // 플레이어 턴일 때만 대기 상태
    });
    _saveGame();

    if (currentTurn != 0) {
      // 컴퓨터 턴: 타이머 없이 바로 진행 (드로우 후 타이머가 동작함)
      Timer(const Duration(milliseconds: 300), () {
        if (mounted && !gameOver) {
          _computerTurn();
        }
      });
    } else {
      // 플레이어 턴: 타이머 없이 대기 (동작할 때까지 유지)
      _messageTimer?.cancel();
    }
  }

  void _computerTurn() {
    if (gameOver) return;
    _computerActionTimer?.cancel();

    final computerIndex = currentTurn - 1;
    final hand = computerHands[computerIndex];
    final melds = computerMelds[computerIndex];

    // ★ 스톱 호출 여부 확인 (카드 뽑기 전에만 가능)
    if (_shouldComputerCallStop(computerIndex)) {
      _computerCallStop(computerIndex);
      return;
    }

    // 난이도에 따른 땡큐(드로우) 확률 (쉬움: 50%, 보통: 80%, 어려움: 100%)
    final difficulty = computerDifficulties.length > computerIndex
        ? computerDifficulties[computerIndex]
        : 2;
    final drawDiscardChance = difficulty == 0 ? 50 : (difficulty == 1 ? 80 : 100);

    // 1. 드로우 (버린 더미 or 덱)
    PlayingCard drawnCard;
    final topDiscard = discardPile.isNotEmpty ? discardPile.last : null;

    // 버린 카드가 멜드에 도움이 되면 가져오기 (난이도 적용)
    // ★ 바닥 카드는 손패와 합쳐서 3장 이상의 멜드를 만들 수 있을 때만 가져올 수 있음
    // 7 카드도 예외 없음 (단독 등록은 자신의 손패에서만 가능)
    bool takeDiscard = false;
    if (topDiscard != null && Random().nextInt(100) < drawDiscardChance) {
      final testHand = [...hand, topDiscard];
      if (_findBestMeld(testHand) != null) {
        takeDiscard = true;
      }
    }

    if (takeDiscard && discardPile.isNotEmpty) {
      drawnCard = discardPile.removeLast();
      _showMessage(getL10n(context).thankYouDrawn(aiNames[computerIndex], '${drawnCard.suitSymbol}${drawnCard.rankString}'));
    } else {
      if (deck.isEmpty && discardPile.length > 1) {
        final topCard = discardPile.removeLast();
        deck = List.from(discardPile);
        deck.shuffle(Random());
        discardPile = [topCard];
      }
      if (deck.isEmpty) {
        _endTurn();
        return;
      }
      drawnCard = deck.removeLast();
      _showMessage(getL10n(context).drewCard(aiNames[computerIndex]));
    }

    hand.add(drawnCard);
    _sortHand(hand);
    setState(() {});
    _saveGame();

    // 드로우 후 대기 상태로 전환 (1초 타이머)
    _startWaitWithAction(() => _computerTurnRegister(computerIndex), seconds: 1);
  }

  // 컴퓨터 턴 - 멜드 등록 단계
  void _computerTurnRegister(int computerIndex) {
    if (gameOver) return;

    final hand = computerHands[computerIndex];
    final melds = computerMelds[computerIndex];

    // 훌라 가능성 확인 후 등록 여부 결정 (스톱 위험도 포함)
    // 훌라 시도 중이면 7도 등록하지 않음 (0점이므로 손해 없음)
    final shouldRegister = _shouldRegisterMelds(hand, melds, computerIndex: computerIndex + 1);

    if (!shouldRegister) {
      _computerTurnDiscard(computerIndex);
      return;
    }

    // 등록할 멜드 수집
    final meldsToRegister = <Map<String, dynamic>>[];

    // 7 카드 먼저 등록 (가장 우선순위)
    final testHand = List<PlayingCard>.from(hand);
    final sevens = testHand.where((c) => _isSeven(c)).toList();
    if (sevens.isNotEmpty) {
      if (sevens.length >= 3) {
        final decision = _decideSevensStrategy(sevens, testHand);
        if (decision == 'group') {
          meldsToRegister.add({'cards': sevens.take(3).toList(), 'isRun': false, 'type': '7group'});
          for (final seven in sevens.skip(3)) {
            meldsToRegister.add({'cards': [seven], 'isRun': false, 'type': '7'});
          }
        } else {
          for (final seven in sevens) {
            meldsToRegister.add({'cards': [seven], 'isRun': false, 'type': '7'});
          }
        }
      } else {
        for (final seven in sevens) {
          meldsToRegister.add({'cards': [seven], 'isRun': false, 'type': '7'});
        }
      }
      // testHand에서 7 제거
      for (final seven in sevens) {
        testHand.remove(seven);
      }
    }

    // 일반 멜드 찾기 (7 카드 제외된 상태)
    List<PlayingCard>? bestMeld;
    while ((bestMeld = _findBestMeld(testHand)) != null) {
      final isRun = _isValidRun(bestMeld!);
      meldsToRegister.add({'cards': List<PlayingCard>.from(bestMeld), 'isRun': isRun, 'type': 'meld'});
      for (final card in bestMeld) {
        testHand.remove(card);
      }
    }

    // 순차적으로 등록 실행
    _computerRegisterMeldsSequentially(computerIndex, meldsToRegister, 0);
  }

  // 멜드를 순차적으로 등록 (대기 상태 포함)
  void _computerRegisterMeldsSequentially(int computerIndex, List<Map<String, dynamic>> meldsToRegister, int index) {
    if (gameOver) return;
    if (index >= meldsToRegister.length) {
      // 모든 등록 완료, 붙여놓기 단계로 (타이머 없이 바로 진행)
      _computerTurnAttach(computerIndex);
      return;
    }

    final hand = computerHands[computerIndex];
    final melds = computerMelds[computerIndex];
    final meldData = meldsToRegister[index];
    final cards = meldData['cards'] as List<PlayingCard>;
    final isRun = meldData['isRun'] as bool;
    final type = meldData['type'] as String;

    // 카드가 손에 있는지 확인
    bool allCardsInHand = cards.every((c) => hand.contains(c));
    if (!allCardsInHand) {
      // 이미 처리된 카드, 다음으로
      _computerRegisterMeldsSequentially(computerIndex, meldsToRegister, index + 1);
      return;
    }

    // 멜드 등록
    for (final card in cards) {
      hand.remove(card);
    }
    melds.add(Meld(cards: cards, isRun: isRun));
    _mergeConsecutiveRuns(melds);

    // 메시지 표시
    if (type == '7group') {
      _showMessage('${aiNames[computerIndex]}: ${getL10n(context).sevenGroupRegistered}');
    } else if (type == '7') {
      _showMessage('${aiNames[computerIndex]}: ${getL10n(context).soloSevenRegistered}');
    } else {
      final cardStr = cards.map((c) => '${c.suitSymbol}${c.rankString}').join(' ');
      _showMessage('${aiNames[computerIndex]}: ${getL10n(context).meldRegisteredWithCards(isRun ? 'Run' : 'Group', cardStr)}');
    }

    setState(() {});
    _saveGame();

    if (hand.isEmpty) {
      _endGame(currentTurn);
      return;
    }

    // 등록 후 대기 상태로 전환 (다음 등록 또는 붙여놓기 단계)
    _startWaitWithAction(() => _computerRegisterMeldsSequentially(computerIndex, meldsToRegister, index + 1));
  }

  // 컴퓨터 턴 - 붙여놓기 단계
  void _computerTurnAttach(int computerIndex) {
    if (gameOver) return;

    final hand = computerHands[computerIndex];
    final melds = computerMelds[computerIndex];

    // 자신의 멜드가 없으면 붙여놓기 불가 (훌라 규칙)
    if (melds.isEmpty) {
      _computerTurnDiscard(computerIndex);
      return;
    }

    // 난이도에 따른 붙여놓기 확률 (쉬움: 50%, 보통: 80%, 어려움: 100%)
    final difficulty = computerDifficulties.length > computerIndex
        ? computerDifficulties[computerIndex]
        : 2;
    final attachChance = difficulty == 0 ? 50 : (difficulty == 1 ? 80 : 100);

    // 붙일 수 있는 카드 찾기
    for (int i = hand.length - 1; i >= 0; i--) {
      final card = hand[i];

      // 자신의 멜드에 붙이기
      final ownMeldIndex = _canAttachToMeldList(card, melds);
      if (ownMeldIndex >= 0 && Random().nextInt(100) < attachChance) {
        _attachToMeldList(ownMeldIndex, card, melds);
        hand.removeAt(i);
        _showMessage('${aiNames[computerIndex]}: ${getL10n(context).attachedToMeldSelf('${card.suitSymbol}${card.rankString}')}');
        setState(() {});
        _saveGame();

        if (hand.isEmpty) {
          _endGame(currentTurn);
          return;
        }

        // 붙이기 후 대기 상태로 전환
        _startWaitWithAction(() => _computerTurnAttach(computerIndex));
        return;
      }

      // 플레이어 멜드에 붙이기
      final playerMeldIndex = _canAttachToMeldList(card, playerMelds);
      if (playerMeldIndex >= 0 && Random().nextInt(100) < attachChance) {
        _attachToMeldList(playerMeldIndex, card, playerMelds);
        hand.removeAt(i);
        _showMessage('${aiNames[computerIndex]}: ${getL10n(context).attachedToMeldPlayer('${card.suitSymbol}${card.rankString}')}');
        setState(() {});
        _saveGame();

        if (hand.isEmpty) {
          _endGame(currentTurn);
          return;
        }

        // 붙이기 후 대기 상태로 전환
        _startWaitWithAction(() => _computerTurnAttach(computerIndex));
        return;
      }

      // 다른 컴퓨터 멜드에 붙이기
      for (int c = 0; c < computerMelds.length; c++) {
        if (c == computerIndex) continue;
        final otherMeldIndex = _canAttachToMeldList(card, computerMelds[c]);
        if (otherMeldIndex >= 0 && Random().nextInt(100) < attachChance) {
          _attachToMeldList(otherMeldIndex, card, computerMelds[c]);
          hand.removeAt(i);
          _showMessage('${aiNames[computerIndex]}: ${getL10n(context).attachedToMeldOther('${card.suitSymbol}${card.rankString}', aiNames[c])}');
          setState(() {});
          _saveGame();

          if (hand.isEmpty) {
            _endGame(currentTurn);
            return;
          }

          // 붙이기 후 대기 상태로 전환
          _startWaitWithAction(() => _computerTurnAttach(computerIndex));
          return;
        }
      }
    }

    // 붙일 카드 없음, 버리기 단계로
    _computerTurnDiscard(computerIndex);
  }

  // 컴퓨터 턴 - 버리기 단계
  void _computerTurnDiscard(int computerIndex) {
    if (gameOver) return;

    final hand = computerHands[computerIndex];
    final melds = computerMelds[computerIndex];

    // 손에 7이 있고, 이미 멜드가 있으면 (훌라 불가능) 7 등록
    // 훌라 시도 중(melds.isEmpty)이면 7을 손에 보유 (0점이므로 손해 없음)
    final sevens = hand.where((c) => _isSeven(c)).toList();
    if (sevens.isNotEmpty && melds.isNotEmpty) {
      final seven = sevens.first;
      hand.remove(seven);
      melds.add(Meld(cards: [seven], isRun: false));
      _mergeConsecutiveRuns(melds);
      _showMessage('${aiNames[computerIndex]}: ${getL10n(context).soloSevenRegistered}');
      setState(() {});
      _saveGame();

      if (hand.isEmpty) {
        _endGame(currentTurn);
        return;
      }

      // 딜레이 후 다시 버리기 단계
      _computerActionTimer = Timer(Duration(milliseconds: _computerActionDelay), () {
        if (mounted && !gameOver) {
          _computerTurnDiscard(computerIndex);
        }
      });
      return;
    }

    // 스마트 카드 버리기 (난이도 적용)
    final discardCard = _selectCardToDiscard(hand, computerIndex: computerIndex);
    hand.remove(discardCard);
    discardPile.add(discardCard);
    _sortHand(hand);

    _showMessage('${aiNames[computerIndex]}: ${getL10n(context).discardCardMsg('${discardCard.suitSymbol}${discardCard.rankString}')}');
    setState(() {});
    _saveGame();

    if (hand.isEmpty) {
      _endGame(currentTurn);
      return;
    }

    // 땡큐 확인: 플레이어 전 순서 컴퓨터는 즉시, 후 순서는 10초 후
    _lastDiscardTurn = currentTurn;
    _computerActionTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted && !gameOver) {
        // 1. 플레이어 전 순서 컴퓨터 땡큐 확인 (즉시)
        final beforeResult = _checkComputerThankYouBeforePlayer(currentTurn);
        if (beforeResult != null) {
          _executeComputerThankYou(beforeResult);
        } else {
          // 2. 플레이어에게 10초 기회 부여 후 플레이어 후 순서 컴퓨터 확인
          _startThankYouWait();
        }
      }
    });
  }

  // 컴퓨터가 땡큐할 수 있는지 확인
  // beforePlayer: true면 플레이어 전 순서만, false면 플레이어 후 순서만
  int? _checkComputerThankYou(int fromTurn, {bool? beforePlayer}) {
    if (discardPile.isEmpty) return null;
    final topCard = discardPile.last;
    final random = Random();

    // fromTurn 다음 순서부터 확인
    bool passedPlayer = false;
    for (int i = 1; i < playerCount; i++) {
      final checkTurn = (fromTurn + i) % playerCount;

      if (checkTurn == 0) {
        passedPlayer = true;
        continue; // 플레이어는 건너뜀 (플레이어는 버튼으로 땡큐)
      }

      // beforePlayer 필터링
      if (beforePlayer == true && passedPlayer) continue; // 플레이어 전만 확인
      if (beforePlayer == false && !passedPlayer) continue; // 플레이어 후만 확인

      final computerIndex = checkTurn - 1;
      if (computerIndex < 0 || computerIndex >= computerHands.length) continue;
      final hand = computerHands[computerIndex];

      // 난이도에 따른 땡큐 확률 (쉬움: 50%, 보통: 80%, 어려움: 100%)
      final difficulty = computerDifficulties.length > computerIndex
          ? computerDifficulties[computerIndex]
          : 2;
      final thankYouChance = difficulty == 0 ? 50 : (difficulty == 1 ? 80 : 100);

      // ★ 땡큐는 손패 + 버린카드로 새 멜드(3장 이상)를 만들 수 있을 때만 가능
      // 기존 멜드에 붙이기는 땡큐 조건이 아님
      final testHand = [...hand, topCard];
      final canMakeMeld = _findBestMeld(testHand) != null;

      if (canMakeMeld) {
        // 난이도에 따른 확률 체크
        if (random.nextInt(100) < thankYouChance) {
          return computerIndex;
        }
      }
    }
    return null;
  }

  // 플레이어 전 순서 컴퓨터만 땡큐 확인 (즉시 실행)
  int? _checkComputerThankYouBeforePlayer(int fromTurn) {
    return _checkComputerThankYou(fromTurn, beforePlayer: true);
  }

  // 플레이어 후 순서 컴퓨터만 땡큐 확인 (10초 후 실행)
  int? _checkComputerThankYouAfterPlayer(int fromTurn) {
    return _checkComputerThankYou(fromTurn, beforePlayer: false);
  }

  // 컴퓨터 땡큐 실행
  void _executeComputerThankYou(int computerIndex) {
    if (discardPile.isEmpty) return;
    _computerActionTimer?.cancel();

    // ★ 플레이어 땡큐 대기 상태 해제 (AI가 먼저 땡큐함)
    _thankYouTimer?.cancel();

    final card = discardPile.removeLast();
    final hand = computerHands[computerIndex];

    hand.add(card);
    _sortHand(hand);
    _showMessage(getL10n(context).thankYouDrawn(aiNames[computerIndex], '${card.suitSymbol}${card.rankString}'));

    // ★ 모든 상태 변경을 setState 안에서 수행 (race condition 방지)
    setState(() {
      _thankYouWaiting = false;
      _thankYouCountdown = 0;
      currentTurn = computerIndex + 1;
    });
    _saveGame();

    // 땡큐 후 바로 등록 단계로 진행 (등록 후 타이머가 동작함)
    Timer(const Duration(milliseconds: 300), () {
      if (mounted && !gameOver) {
        _executeComputerThankYouRegister(computerIndex);
      }
    });
  }

  // 컴퓨터 땡큐 후 - 멜드 등록 단계
  void _executeComputerThankYouRegister(int computerIndex) {
    if (gameOver) return;

    final hand = computerHands[computerIndex];
    final melds = computerMelds[computerIndex];

    // 훌라 가능성 확인 후 등록 여부 결정 (스톱 위험도 포함)
    final shouldRegister = _shouldRegisterMelds(hand, melds, computerIndex: computerIndex + 1);

    if (!shouldRegister) {
      _computerDiscardAfterThankYou(computerIndex);
      return;
    }

    // 등록할 멜드 수집
    final meldsToRegister = <Map<String, dynamic>>[];

    // 일반 멜드 찾기
    final testHand = List<PlayingCard>.from(hand);
    List<PlayingCard>? bestMeld;
    while ((bestMeld = _findBestMeld(testHand)) != null) {
      final isRun = _isValidRun(bestMeld!);
      meldsToRegister.add({'cards': List<PlayingCard>.from(bestMeld), 'isRun': isRun, 'type': 'meld'});
      for (final card in bestMeld) {
        testHand.remove(card);
      }
    }

    // 7 카드 찾기
    final sevens = testHand.where((c) => _isSeven(c)).toList();
    if (sevens.length >= 3) {
      final decision = _decideSevensStrategy(sevens, testHand);
      if (decision == 'group') {
        meldsToRegister.add({'cards': sevens.take(3).toList(), 'isRun': false, 'type': '7group'});
        for (final seven in sevens.skip(3)) {
          meldsToRegister.add({'cards': [seven], 'isRun': false, 'type': '7'});
        }
      } else {
        for (final seven in sevens) {
          meldsToRegister.add({'cards': [seven], 'isRun': false, 'type': '7'});
        }
      }
    } else {
      // ★ 7 카드가 3장 미만일 때 - 기존 멜드에 붙일 수 있는 경우만 등록
      for (final seven in sevens) {
        // 자신의 멜드 또는 다른 플레이어 멜드에 붙일 수 있는지 확인
        bool canAttach = false;
        // 자신의 멜드 확인
        if (_canAttachToMeldList(seven, melds) >= 0) {
          canAttach = true;
        }
        // 다른 플레이어 멜드 확인
        if (!canAttach) {
          for (final otherMelds in computerMelds) {
            if (_canAttachToMeldList(seven, otherMelds) >= 0) {
              canAttach = true;
              break;
            }
          }
        }
        if (!canAttach && _canAttachToMeldList(seven, playerMelds) >= 0) {
          canAttach = true;
        }
        if (canAttach) {
          meldsToRegister.add({'cards': [seven], 'isRun': false, 'type': '7'});
        }
      }
    }

    // 순차적으로 등록 실행
    _executeComputerThankYouRegisterSequentially(computerIndex, meldsToRegister, 0);
  }

  // 땡큐 후 멜드를 순차적으로 등록 (대기 상태 포함)
  void _executeComputerThankYouRegisterSequentially(int computerIndex, List<Map<String, dynamic>> meldsToRegister, int index) {
    if (gameOver) return;
    if (index >= meldsToRegister.length) {
      // 모든 등록 완료, 붙여놓기 단계로 (타이머 없이 바로 진행)
      _executeComputerThankYouAttach(computerIndex);
      return;
    }

    final hand = computerHands[computerIndex];
    final melds = computerMelds[computerIndex];
    final meldData = meldsToRegister[index];
    final cards = meldData['cards'] as List<PlayingCard>;
    final isRun = meldData['isRun'] as bool;
    final type = meldData['type'] as String;

    // 카드가 손에 있는지 확인
    bool allCardsInHand = cards.every((c) => hand.contains(c));
    if (!allCardsInHand) {
      // 이미 처리된 카드, 다음으로
      _executeComputerThankYouRegisterSequentially(computerIndex, meldsToRegister, index + 1);
      return;
    }

    // 멜드 등록
    for (final card in cards) {
      hand.remove(card);
    }
    melds.add(Meld(cards: cards, isRun: isRun));
    _mergeConsecutiveRuns(melds);

    // 메시지 표시
    if (type == '7group') {
      _showMessage('${aiNames[computerIndex]}: ${getL10n(context).sevenGroupRegistered}');
    } else if (type == '7') {
      _showMessage('${aiNames[computerIndex]}: ${getL10n(context).soloSevenRegistered}');
    } else {
      final cardStr = cards.map((c) => '${c.suitSymbol}${c.rankString}').join(' ');
      _showMessage('${aiNames[computerIndex]}: ${getL10n(context).meldRegisteredWithCards(isRun ? 'Run' : 'Group', cardStr)}');
    }

    setState(() {});
    _saveGame();

    if (hand.isEmpty) {
      _endGame(computerIndex + 1);
      return;
    }

    // 등록 후 대기 상태로 전환
    _startWaitWithAction(() => _executeComputerThankYouRegisterSequentially(computerIndex, meldsToRegister, index + 1));
  }

  // 컴퓨터 땡큐 후 - 붙여놓기 단계
  void _executeComputerThankYouAttach(int computerIndex) {
    if (gameOver) return;

    final hand = computerHands[computerIndex];
    final melds = computerMelds[computerIndex];

    // 자신의 멜드가 없으면 붙여놓기 불가 (훌라 규칙)
    if (melds.isEmpty) {
      _computerDiscardAfterThankYou(computerIndex);
      return;
    }

    // 난이도에 따른 붙여놓기 확률 (쉬움: 50%, 보통: 80%, 어려움: 100%)
    final difficulty = computerDifficulties.length > computerIndex
        ? computerDifficulties[computerIndex]
        : 2;
    final attachChance = difficulty == 0 ? 50 : (difficulty == 1 ? 80 : 100);

    // 붙일 수 있는 카드 찾기
    for (int i = hand.length - 1; i >= 0; i--) {
      final card = hand[i];

      // 자신의 멜드에 붙이기
      final ownMeldIndex = _canAttachToMeldList(card, melds);
      if (ownMeldIndex >= 0 && Random().nextInt(100) < attachChance) {
        _attachToMeldList(ownMeldIndex, card, melds);
        hand.removeAt(i);
        _showMessage('${aiNames[computerIndex]}: ${getL10n(context).attachedToMeldSelf('${card.suitSymbol}${card.rankString}')}');
        setState(() {});
        _saveGame();

        if (hand.isEmpty) {
          _endGame(computerIndex + 1);
          return;
        }

        // 붙이기 후 대기 상태로 전환
        _startWaitWithAction(() => _executeComputerThankYouAttach(computerIndex));
        return;
      }

      // 플레이어 멜드에 붙이기
      final playerMeldIndex = _canAttachToMeldList(card, playerMelds);
      if (playerMeldIndex >= 0 && Random().nextInt(100) < attachChance) {
        _attachToMeldList(playerMeldIndex, card, playerMelds);
        hand.removeAt(i);
        _showMessage('${aiNames[computerIndex]}: ${getL10n(context).attachedToMeldPlayer('${card.suitSymbol}${card.rankString}')}');
        setState(() {});
        _saveGame();

        if (hand.isEmpty) {
          _endGame(computerIndex + 1);
          return;
        }

        // 붙이기 후 대기 상태로 전환
        _startWaitWithAction(() => _executeComputerThankYouAttach(computerIndex));
        return;
      }

      // 다른 컴퓨터 멜드에 붙이기
      for (int c = 0; c < computerMelds.length; c++) {
        if (c == computerIndex) continue;
        final otherMeldIndex = _canAttachToMeldList(card, computerMelds[c]);
        if (otherMeldIndex >= 0 && Random().nextInt(100) < attachChance) {
          _attachToMeldList(otherMeldIndex, card, computerMelds[c]);
          hand.removeAt(i);
          _showMessage('${aiNames[computerIndex]}: ${getL10n(context).attachedToMeldOther('${card.suitSymbol}${card.rankString}', aiNames[c])}');
          setState(() {});
          _saveGame();

          if (hand.isEmpty) {
            _endGame(computerIndex + 1);
            return;
          }

          // 붙이기 후 대기 상태로 전환
          _startWaitWithAction(() => _executeComputerThankYouAttach(computerIndex));
          return;
        }
      }
    }

    // 붙일 카드 없음, 버리기 단계로
    _computerDiscardAfterThankYou(computerIndex);
  }

  // 땡큐 후 컴퓨터가 카드 버리기
  void _computerDiscardAfterThankYou(int computerIndex) {
    final hand = computerHands[computerIndex];
    final melds = computerMelds[computerIndex];

    // 손에 7이 있으면 먼저 등록
    final sevens = hand.where((c) => _isSeven(c)).toList();
    if (sevens.isNotEmpty) {
      final seven = sevens.first;
      hand.remove(seven);
      melds.add(Meld(cards: [seven], isRun: false));
      _mergeConsecutiveRuns(melds);
      _showMessage('${aiNames[computerIndex]}: ${getL10n(context).soloSevenRegistered}');
      setState(() {});
      _saveGame();

      if (hand.isEmpty) {
        _endGame(computerIndex + 1);
        return;
      }

      // 딜레이 후 다시 버리기 단계
      _computerActionTimer = Timer(Duration(milliseconds: _computerActionDelay), () {
        if (mounted && !gameOver) {
          _computerDiscardAfterThankYou(computerIndex);
        }
      });
      return;
    }

    // 스마트 카드 버리기 (난이도 적용)
    final discardCard = _selectCardToDiscard(hand, computerIndex: computerIndex);
    hand.remove(discardCard);
    discardPile.add(discardCard);
    _sortHand(hand);

    _showMessage('${aiNames[computerIndex]}: ${getL10n(context).discardCardMsg('${discardCard.suitSymbol}${discardCard.rankString}')}');
    setState(() {});
    _saveGame();

    if (hand.isEmpty) {
      _endGame(computerIndex + 1);
      return;
    }

    // 땡큐 확인: 플레이어 전 순서 컴퓨터는 즉시, 후 순서는 10초 후
    final discardTurn = computerIndex + 1;
    _lastDiscardTurn = discardTurn;
    Timer(const Duration(milliseconds: 500), () {
      if (mounted && !gameOver) {
        // 1. 플레이어 전 순서 컴퓨터 땡큐 확인 (즉시)
        final beforeResult = _checkComputerThankYouBeforePlayer(discardTurn);
        if (beforeResult != null) {
          _executeComputerThankYou(beforeResult);
        } else {
          // 2. 플레이어에게 10초 기회 부여 후 플레이어 후 순서 컴퓨터 확인
          _startThankYouWait();
        }
      }
    });
  }

  List<PlayingCard>? _findBestMeld(List<PlayingCard> hand) {
    if (hand.length < 3) return null;

    // Group 찾기
    final rankGroups = <int, List<PlayingCard>>{};
    for (final card in hand) {
      rankGroups.putIfAbsent(card.rank, () => []).add(card);
    }
    for (final group in rankGroups.values) {
      if (group.length >= 3) {
        return group.take(3).toList();
      }
    }

    // Run 찾기
    final suitGroups = <Suit, List<PlayingCard>>{};
    for (final card in hand) {
      suitGroups.putIfAbsent(card.suit, () => []).add(card);
    }
    for (final cards in suitGroups.values) {
      if (cards.length >= 3) {
        cards.sort((a, b) => a.rank.compareTo(b.rank));
        for (int i = 0; i <= cards.length - 3; i++) {
          final run = <PlayingCard>[cards[i]];
          for (int j = i + 1; j < cards.length && run.length < 3; j++) {
            if (cards[j].rank == run.last.rank + 1) {
              run.add(cards[j]);
            }
          }
          if (run.length >= 3) {
            return run;
          }
        }
      }
    }

    return null;
  }

  // 스톱 선언 (플레이어)
  void _callStop() {
    if (gameOver) return;
    final l10n = getL10n(context);
    _showMessage('${l10n.player} ${l10n.stopGame}!');
    _calculateScoresAndEnd(stopperIndex: 0); // 플레이어가 스톱
  }

  void _calculateScoresAndEnd({required int stopperIndex}) {
    // 모든 플레이어 점수 계산 (등록하지 못했거나 7을 가지고 있으면 2배 패널티)
    // ★ 실제 등록된 카드 수로 확인 (빈 멜드 방지)
    final playerRegisteredCards = playerMelds.fold<int>(0, (sum, meld) => sum + meld.cards.length);
    final playerRegistered = playerRegisteredCards > 0;
    final playerHasSeven = playerHand.any((c) => _isSeven(c));
    scores[0] = _calculateHandScore(playerHand) * ((!playerRegistered || playerHasSeven) ? 2 : 1);
    for (int i = 0; i < computerHands.length; i++) {
      final computerRegisteredCards = computerMelds[i].fold<int>(0, (sum, meld) => sum + meld.cards.length);
      final computerRegistered = computerRegisteredCards > 0;
      final computerHasSeven = computerHands[i].any((c) => _isSeven(c));
      scores[i + 1] = _calculateHandScore(computerHands[i]) * ((!computerRegistered || computerHasSeven) ? 2 : 1);
    }

    // 최저 점수 찾기
    int minScore = scores[0];
    List<int> minIndices = [0]; // 최저 점수를 가진 모든 플레이어 인덱스

    for (int i = 1; i < scores.length; i++) {
      if (scores[i] < minScore) {
        minScore = scores[i];
        minIndices = [i];
      } else if (scores[i] == minScore) {
        minIndices.add(i);
      }
    }

    int winnerIdx;
    // 동점자가 여러 명인 경우
    if (minIndices.length > 1) {
      // 스톱한 사람이 동점자에 포함되어 있으면 스톱한 사람은 패배
      if (minIndices.contains(stopperIndex)) {
        // 스톱한 사람을 제외한 동점자 중 첫 번째가 승리
        minIndices.remove(stopperIndex);
        winnerIdx = minIndices.first;
      } else {
        // 스톱한 사람이 동점자가 아니면 첫 번째 동점자가 승리
        winnerIdx = minIndices.first;
      }
    } else {
      // 단독 최저 점수면 그 사람이 승리
      winnerIdx = minIndices.first;
    }

    // 스톱 실패 여부 확인 후 게임 종료
    final stopFailed = stopperIndex != winnerIdx;
    _endGame(winnerIdx, stopperIndex: stopFailed ? stopperIndex : null);
  }

  int _calculateHandScore(List<PlayingCard> hand) {
    return hand.fold(0, (sum, card) => sum + card.point);
  }

  // stopperIndex: 스톱 실패한 플레이어 인덱스 (null이면 일반 종료)
  void _endGame(int winnerIdx, {int? stopperIndex}) {
    // 손패 점수 계산 (순수 손패 점수, 2배 패널티는 차이 계산 후 적용)
    scores[0] = _calculateHandScore(playerHand);
    for (int i = 0; i < computerHands.length; i++) {
      scores[i + 1] = _calculateHandScore(computerHands[i]);
    }

    // 패널티 여부 계산 (등록하지 않았거나 7을 가지고 있으면 차이의 2배 패널티)
    final List<bool> hasPenalty = List.generate(playerCount, (i) {
      if (i == 0) {
        final registeredCards = playerMelds.fold<int>(0, (sum, meld) => sum + meld.cards.length);
        final hasSeven = playerHand.any((c) => _isSeven(c));
        return registeredCards == 0 || hasSeven;
      } else {
        final registeredCards = computerMelds[i - 1].fold<int>(0, (sum, meld) => sum + meld.cards.length);
        final hasSeven = computerHands[i - 1].any((c) => _isSeven(c));
        return registeredCards == 0 || hasSeven;
      }
    });

    // 라운드 점수 계산
    final hulaMultiplier = (isHula && winnerIdx == 0) ? 2 : 1;
    final winnerHandScore = scores[winnerIdx];
    int winnerGain = 0;

    roundScores = List.generate(playerCount, (_) => 0);

    // 승자가 얻을 총 점수 계산 (차이 계산 후 2배 패널티 적용)
    for (int i = 0; i < playerCount; i++) {
      if (i == winnerIdx) continue;
      final diff = scores[i] - winnerHandScore;
      // 패널티 대상 플레이어는 차이의 2배
      final penaltyMultiplier = hasPenalty[i] ? 2 : 1;
      final finalDiff = diff * penaltyMultiplier * hulaMultiplier;
      winnerGain += finalDiff;
    }

    if (stopperIndex != null) {
      // 스톱 실패: 승자가 얻은 점수를 스톱한 플레이어가 모두 부담
      // 다른 플레이어는 감점 없음
      roundScores[winnerIdx] = winnerGain;
      roundScores[stopperIndex] = -winnerGain;
      // 나머지 플레이어는 0 (이미 초기화됨)
    } else {
      // 일반 종료: 각자 승자와의 차이만큼 감점 (패널티 대상은 2배)
      for (int i = 0; i < playerCount; i++) {
        if (i == winnerIdx) continue;
        final diff = scores[i] - winnerHandScore;
        final penaltyMultiplier = hasPenalty[i] ? 2 : 1;
        final finalDiff = diff * penaltyMultiplier * hulaMultiplier;
        roundScores[i] = -finalDiff;
      }
      roundScores[winnerIdx] = winnerGain;
    }

    setState(() {
      gameOver = true;
      winnerIndex = winnerIdx;
      if (winnerIdx == 0) {
        winner = getL10n(context).player;
      } else {
        winner = aiNames[winnerIdx - 1];
      }
    });

    // 통계 저장 (스톱 실패 시 특별 처리)
    final statsService = Provider.of<HulaStatsService>(context, listen: false);
    statsService.recordGameResultWithRoundScores(
      winnerId: winnerIdx,
      roundScores: roundScores,
    );

    // 게임 종료 시 저장된 게임 삭제
    _saveGame();

    _showGameOverDialog();
  }

  void _showGameOverDialog() {
    // 광고 표시
    WebAdHelper.showAd();

    final l10n = getL10n(context);
    final statsService = Provider.of<HulaStatsService>(context, listen: false);
    final playerNames = [l10n.you, ...aiNames];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: winnerIndex == 0 ? Colors.amber : Colors.red.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        title: Column(
          children: [
            Text(
              winnerIndex == 0 ? l10n.victory : l10n.defeat,
              style: TextStyle(
                color: winnerIndex == 0 ? Colors.amber : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            if (isHula && winnerIndex == 0)
              Text(
                l10n.hulaVictory,
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.xWins(winner ?? ''),
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 16),
            // 점수 테이블 헤더
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Expanded(flex: 2, child: Text('', style: TextStyle(color: Colors.white70, fontSize: 12))),
                  Expanded(child: Text(l10n.handCards, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                  Expanded(child: Text(l10n.score, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                  Expanded(child: Text(l10n.cumulative, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                ],
              ),
            ),
            const SizedBox(height: 4),
            // 각 플레이어 점수
            ...List.generate(
              playerCount,
              (i) {
                final isWinner = winnerIndex == i;
                final stats = statsService.getPlayerStats(i);
                final roundScore = roundScores[i];
                final roundScoreStr = roundScore >= 0 ? '+$roundScore' : '$roundScore';
                final totalScore = stats?.totalScore ?? 0;
                final totalScoreStr = totalScore >= 0 ? '+$totalScore' : '$totalScore';

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.white12)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            if (isWinner)
                              const Icon(Icons.emoji_events, color: Colors.amber, size: 16),
                            if (isWinner) const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                playerNames[i],
                                style: TextStyle(
                                  color: isWinner ? Colors.amber : Colors.white,
                                  fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${scores[i]}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          roundScoreStr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: roundScore >= 0 ? Colors.lightGreenAccent : Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          totalScoreStr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: totalScore >= 0 ? Colors.lightGreenAccent : Colors.redAccent,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initGame();
            },
            child: Text(getL10n(context).newGame),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(getL10n(context).close),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D5C2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(getL10n(context).nPlayersHula(playerCount),
            style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.lightbulb, color: _showHint ? Colors.yellow : Colors.white),
            tooltip: _showHint ? getL10n(context).hintOff : getL10n(context).hint,
            onPressed: _onHintButtonPressed,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _showNewGameDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: _buildGameContent(),
      ),
    );
  }

  Widget _buildGameContent() {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height - mediaQuery.padding.top - mediaQuery.padding.bottom;
    final screenWidth = mediaQuery.size.width;
    final sizes = _HulaResponsiveSizes(screenHeight, screenWidth);

    return Column(
      children: [
        // 상단 컴퓨터: 2인은 COM1, 3인은 COM2, 4인은 COM2
        if (computerHands.isNotEmpty)
          _buildTopComputerHand(computerHands.length == 1 ? 0 : 1, sizes),

        // 중앙 영역 (좌우 컴퓨터 + 덱/버린더미)
        Expanded(
          child: computerHands.length >= 2
              ? Row(
                  children: [
                    // 왼쪽 컴퓨터 (COM3) - 4인 게임만
                    if (computerHands.length >= 3)
                      _buildSideComputerHand(2, sizes),
                    // 중앙 카드 영역
                    Expanded(child: _buildCenterArea(sizes)),
                    // 오른쪽 컴퓨터 (COM1) - 3인 이상
                    _buildSideComputerHand(0, sizes),
                  ],
                )
              : _buildCenterArea(sizes),
        ),

        // 하단 영역 (메시지, 멜드, 손패, 버튼)
        _buildBottomSection(sizes),
      ],
    );
  }

  // 하단 영역 (스크롤 가능)
  Widget _buildBottomSection(_HulaResponsiveSizes sizes) {
    return Flexible(
      flex: 0,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 현재 차례 표시 + 메시지 (위아래로 표시)
            if (!gameOver)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 상단: 현재 순서 표시 + 시작 버튼
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: currentTurn == 0 ? Colors.green : Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            currentTurn == 0
                                ? getL10n(context).myTurn
                                : (waitingForNextTurn ? '${aiNames[currentTurn - 1]} ($_autoPlayCountdown)' : getL10n(context).playerTurn(aiNames[currentTurn - 1])),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // 시작하기 버튼 (컴퓨터 차례 대기 중일 때만 표시)
                        if (waitingForNextTurn && currentTurn != 0) ...[
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _onNextTurn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              getL10n(context).start,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    // 하단: 메시지
                    if (gameMessage != null) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          gameMessage!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

            // 등록된 멜드
            if (playerMelds.isNotEmpty) _buildPlayerMelds(sizes),

            // 플레이어 손패
            _buildPlayerHand(sizes),

            // 액션 버튼
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  // 상단 컴퓨터 (가로 배치)
  Widget _buildTopComputerHand(int computerIndex, _HulaResponsiveSizes sizes) {
    if (computerIndex >= computerHands.length) return const SizedBox();
    final l10n = getL10n(context);

    final hand = computerHands[computerIndex];
    final melds = computerMelds[computerIndex];
    final isCurrentTurn = currentTurn == computerIndex + 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCurrentTurn ? Colors.amber.shade700 : Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.computer, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      aiNames[computerIndex],
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.nCards(hand.length),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    if (melds.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        '(${l10n.nMelds(melds.length)})',
                        style: const TextStyle(color: Colors.green, fontSize: 11),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // 카드 뒷면 표시
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              min(hand.length, 8),
              (j) => Container(
                width: sizes.aiCardWidth,
                height: sizes.aiCardHeight,
                margin: const EdgeInsets.only(left: 2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade800, Colors.blue.shade900],
                  ),
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: Colors.white24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 좌/우측 컴퓨터 (세로 배치)
  Widget _buildSideComputerHand(int computerIndex, _HulaResponsiveSizes sizes) {
    if (computerIndex >= computerHands.length) return const SizedBox();
    final l10n = getL10n(context);

    final hand = computerHands[computerIndex];
    final melds = computerMelds[computerIndex];
    final isCurrentTurn = currentTurn == computerIndex + 1;

    return Container(
      width: 55,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 컴퓨터 이름
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: isCurrentTurn ? Colors.amber.shade700 : Colors.grey.shade800,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              aiNames[computerIndex],
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          // 카드 수
          Text(
            l10n.nCards(hand.length),
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
          if (melds.isNotEmpty)
            Text(
              l10n.nMelds(melds.length),
              style: const TextStyle(color: Colors.green, fontSize: 9),
            ),
          const SizedBox(height: 8),
          // 세로 카드 스택
          Expanded(
            child: _buildVerticalCardStack(hand.length, sizes),
          ),
        ],
      ),
    );
  }

  // 세로 카드 스택
  Widget _buildVerticalCardStack(int cardCount, _HulaResponsiveSizes sizes) {
    final overlap = sizes.aiCardHeight * 0.3;
    final cardHeight = sizes.aiCardHeight;
    final cardWidth = sizes.aiCardWidth;
    const maxVisible = 7;
    final visibleCount = cardCount > maxVisible ? maxVisible : cardCount;
    final totalHeight = cardHeight + (visibleCount - 1) * overlap;

    return Center(
      child: SizedBox(
        width: cardWidth,
        height: totalHeight,
        child: Stack(
          children: List.generate(visibleCount, (index) {
            return Positioned(
              top: index * overlap,
              child: Container(
                width: cardWidth,
                height: cardHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade800, Colors.blue.shade900],
                  ),
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: Colors.white24, width: 0.5),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCenterArea(_HulaResponsiveSizes sizes) {
    final cardWidth = sizes.centerCardWidth;
    final cardHeight = sizes.centerCardHeight;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 덱 - 내 차례이고 드로우 전이면 탭 가능 (waitingForNextTurn 상태에서도)
              GestureDetector(
                onTap: currentTurn == 0 && !hasDrawn
                    ? _drawFromDeck
                    : null,
                child: Container(
                  width: cardWidth,
                  height: cardHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade700, Colors.blue.shade900],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: currentTurn == 0 && !hasDrawn
                          ? Colors.yellow
                          : Colors.white24,
                      width: currentTurn == 0 && !hasDrawn
                          ? 3
                          : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🂠', style: TextStyle(fontSize: 28)),
                      Text(
                        '${deck.length}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // 버린 더미
              Builder(
                builder: (context) {
                  // 땡큐 가능: 대기 중이거나 플레이어 턴에서 드로우 안했을 때, 그리고 등록 가능할 때만
                  final canTakeDiscard = discardPile.isNotEmpty &&
                      ((currentTurn == 0 && !hasDrawn) || waitingForNextTurn || _thankYouWaiting) &&
                      _canThankYou();
                  // 땡큐 대기 상태면 주황색, 일반 드로우면 녹색
                  final borderColor =
                      (_thankYouWaiting || waitingForNextTurn) && canTakeDiscard
                          ? Colors.orange
                          : (canTakeDiscard ? Colors.green : Colors.grey);

                  return GestureDetector(
                    onTap: canTakeDiscard ? _drawFromDiscard : null,
                    child: SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: Stack(
                        children: [
                          Container(
                            width: cardWidth,
                            height: cardHeight,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: borderColor,
                                width: canTakeDiscard ? 3 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: discardPile.isEmpty
                                ? Center(
                                    child: Text(
                                      getL10n(context).emptyDiscardPile,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  )
                                : _buildCardFace(discardPile.last, small: true),
                          ),
                          // 땡큐 대기 카운트다운 표시
                          if (_thankYouWaiting && canTakeDiscard)
                            Positioned.fill(
                              child: GestureDetector(
                                onTap: _drawFromDiscard,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        getL10n(context).thankYou,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '$_thankYouCountdown',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          // 모든 등록된 멜드 표시
          _buildAllMeldsArea(),
        ],
      ),
    );
  }

  Widget _buildCardFace(PlayingCard card, {bool small = false}) {
    final fontSize = small ? 14.0 : 18.0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(small ? 6 : 8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            card.suitSymbol,
            style: TextStyle(
              fontSize: fontSize + 4,
              color: card.suitColor,
            ),
          ),
          Text(
            card.rankString,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: card.suitColor,
            ),
          ),
        ],
      ),
    );
  }

  // 모든 플레이어의 멜드를 표시 (붙여놓기 가능)
  Widget _buildAllMeldsArea() {
    // 모든 멜드 수집
    final List<Map<String, dynamic>> allMelds = [];

    // 플레이어 멜드
    for (int i = 0; i < playerMelds.length; i++) {
      allMelds.add({
        'meldIndex': i,
        'meld': playerMelds[i],
        'melds': playerMelds,
      });
    }

    // 컴퓨터 멜드
    for (int c = 0; c < computerMelds.length; c++) {
      for (int i = 0; i < computerMelds[c].length; i++) {
        allMelds.add({
          'meldIndex': i,
          'meld': computerMelds[c][i],
          'melds': computerMelds[c],
        });
      }
    }

    // 반응형 크기 계산
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isWideScreen = screenWidth > 800;
    final scaleFactor = isWideScreen ? 1.5 : 1.0;

    final fixedHeight = 70.0 * scaleFactor;
    final cardHeight = 28.0 * scaleFactor;
    final cardWidth = 20.0 * scaleFactor;
    final overlap = 12.0 * scaleFactor;

    return Container(
      height: fixedHeight,
      margin: const EdgeInsets.only(top: 8),
      child: allMelds.isEmpty
          ? const SizedBox()
          : SingleChildScrollView(
              child: Wrap(
                spacing: 12,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: allMelds.map((meldInfo) {
                  final meld = meldInfo['meld'] as Meld;
                  final melds = meldInfo['melds'] as List<Meld>;
                  final meldIndex = meldInfo['meldIndex'] as int;

                  // 선택된 카드가 이 멜드에 붙일 수 있는지 확인
                  bool canAttach = false;
                  if (selectedCardIndices.length == 1 &&
                      currentTurn == 0 &&
                      hasDrawn &&
                      playerMelds.isNotEmpty) {
                    final card = playerHand[selectedCardIndices.first];
                    canAttach = _canAttachToMeldList(card, melds) == meldIndex;
                  }

                  // 겹치는 카드 스택 너비 계산
                  final stackWidth = cardWidth + (meld.cards.length - 1) * overlap;

                  return GestureDetector(
                    onTap: canAttach
                        ? () {
                            final card = playerHand[selectedCardIndices.first];
                            _attachToMeldList(meldIndex, card, melds);
                            playerHand.remove(card);
                            selectedCardIndices.clear();

                            if (playerHand.isEmpty) {
                              _endGame(0);
                            } else {
                              setState(() {});
                              _saveGame();
                            }
                          }
                        : null,
                    child: Container(
                      width: stackWidth,
                      height: cardHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        border: canAttach
                            ? Border.all(color: Colors.yellow, width: 2)
                            : null,
                      ),
                      child: Stack(
                        children: List.generate(meld.cards.length, (i) {
                          final card = meld.cards[i];
                          return Positioned(
                            left: i * overlap,
                            child: Container(
                              width: cardWidth,
                              height: cardHeight,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(color: Colors.grey.shade400, width: 0.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 1,
                                    offset: const Offset(0.5, 0.5),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    card.suitSymbol,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: card.suitColor,
                                      height: 1,
                                    ),
                                  ),
                                  Text(
                                    card.rankString,
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: card.suitColor,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }

  Widget _buildPlayerMelds(_HulaResponsiveSizes sizes) {
    return Container(
      height: sizes.meldCardHeight * 1.6,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: playerMelds.length,
        itemBuilder: (context, meldIndex) {
          final meld = playerMelds[meldIndex];
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  meld.isRun ? 'Run: ' : 'Set: ',
                  style: const TextStyle(color: Colors.green, fontSize: 10),
                ),
                ...meld.cards.map((card) => Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Text(
                        '${card.suitSymbol}${card.rankString}',
                        style: TextStyle(
                          color: card.suitColor == Colors.red
                              ? Colors.red.shade300
                              : Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayerHand(_HulaResponsiveSizes sizes) {
    final cardWidth = sizes.playerCardWidth;
    final cardHeight = sizes.playerCardHeight;
    final symbolSize = sizes.playerSymbolSize;
    final rankSize = sizes.playerRankSize;

    // AI 추천 카드 인덱스
    final recommendedIndex = _showHint ? _getRecommendedDiscardCardIndex() : null;

    // 세로 모드: 2줄
    final int cardsPerRow = (playerHand.length / 2).ceil();

    final List<int> row1 = List.generate(
      cardsPerRow > playerHand.length ? playerHand.length : cardsPerRow,
      (i) => i,
    );
    final List<int> row2 = List.generate(
      playerHand.length - cardsPerRow > 0
          ? playerHand.length - cardsPerRow
          : 0,
      (i) => cardsPerRow + i,
    );

    Widget buildCard(int index) {
      final card = playerHand[index];
      final isSelected = selectedCardIndices.contains(index);
      final isRecommended = _showHint && recommendedIndex == index;

      return GestureDetector(
        onTap: () => _toggleCardSelection(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.translationValues(0, isSelected ? -10 : 0, 0),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            color: isRecommended ? Colors.lightBlueAccent.withValues(alpha: 0.2) : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isRecommended ? Colors.lightBlueAccent : (isSelected ? Colors.amber : Colors.grey.shade400),
              width: isRecommended ? 3 : (isSelected ? 3 : 1),
            ),
            boxShadow: [
              BoxShadow(
                color: isRecommended
                    ? Colors.lightBlueAccent.withValues(alpha: 0.5)
                    : (isSelected
                        ? Colors.amber.withValues(alpha: 0.5)
                        : Colors.black.withValues(alpha: 0.2)),
                blurRadius: isRecommended ? 10 : (isSelected ? 8 : 4),
                offset: const Offset(1, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isRecommended)
                const Icon(Icons.lightbulb, color: Colors.lightBlueAccent, size: 12),
              Text(
                card.suitSymbol,
                style: TextStyle(
                  fontSize: symbolSize,
                  color: card.suitColor,
                ),
              ),
              Text(
                card.rankString,
                style: TextStyle(
                  fontSize: rankSize,
                  fontWeight: FontWeight.bold,
                  color: card.suitColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildCardRow(List<int> indices) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: indices.map((index) => buildCard(index)).toList(),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildCardRow(row1),
            if (row2.isNotEmpty) ...[
              const SizedBox(height: 4),
              buildCardRow(row2),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    // 7 단독: 특별 규칙, 1~2장: 붙이기 가능 여부, 3장+: 새 멜드 가능 여부
    bool canMeld = false;
    if (selectedCardIndices.length >= 3) {
      final cards = selectedCardIndices.map((i) => playerHand[i]).toList();
      canMeld = _isValidMeld(cards);
    } else if (selectedCardIndices.length == 1 && _isSeven(playerHand[selectedCardIndices.first])) {
      // 7 카드 단독 등록 가능 (훌라 특별 규칙)
      canMeld = true;
    } else if (selectedCardIndices.isNotEmpty && playerMelds.isNotEmpty) {
      // 1~2장 선택 시 붙이기 가능 여부 확인 (자신의 멜드가 있어야만 붙이기 가능 - 훌라 규칙)
      for (final idx in selectedCardIndices) {
        final card = playerHand[idx];
        // 플레이어 멜드 확인
        if (_canAttachToMeld(card) >= 0) {
          canMeld = true;
          break;
        }
        // 컴퓨터 멜드 확인
        for (final compMelds in computerMelds) {
          if (_canAttachToMeldList(card, compMelds) >= 0) {
            canMeld = true;
            break;
          }
        }
        if (canMeld) break;
      }
    }
    final canDiscard = hasDrawn && selectedCardIndices.length == 1;

    final l10n = getL10n(context);
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.black38,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 멜드 등록 (드로우 후에만 가능)
          _buildActionButton(
            label: l10n.register,
            color: Colors.green,
            onPressed: currentTurn == 0 && hasDrawn && canMeld ? _registerMeld : null,
          ),
          // 버리기
          _buildActionButton(
            label: l10n.discardCard,
            color: Colors.orange,
            onPressed: currentTurn == 0 && canDiscard ? _discardCard : null,
          ),
          // 스톱 (카드 뽑기 전, 등록된 멜드가 있을 때만 선언 가능)
          _buildActionButton(
            label: l10n.stopGame,
            color: Colors.red,
            onPressed: currentTurn == 0 && !gameOver && !hasDrawn && playerMelds.isNotEmpty ? _callStop : null,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: onPressed != null ? color : Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _showRulesDialog() {
    final l10n = getL10n(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          l10n.gameRules,
          style: const TextStyle(color: Colors.amber),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.objective,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.objectiveDesc,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.howToPlay,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.howToPlayDesc,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.meldTypes,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '• Run: ♠3-4-5\n• Group: ♠7-♥7-♦7',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.register7Alone,
                style: const TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '7 ✓',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.thankYouMeld,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.thankYouMeldDesc,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.stopRule,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.stopRuleDesc,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.scoring,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'A=1, 2~9, J=10, Q=11, K=12',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }
}
