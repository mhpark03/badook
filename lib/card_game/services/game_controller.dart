import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/card.dart';
import '../models/player.dart';
import '../models/game_state.dart';
import 'ai_player.dart';
import 'game_save_service.dart';
import 'mighty_tracking_service.dart';

class GameController extends ChangeNotifier {
  late GameState _state;
  final AIPlayer _aiPlayer = AIPlayer();
  bool _isProcessing = false;
  bool _waitingForTrickConfirm = false;
  Trick? _lastCompletedTrick;
  static const String _gameType = 'mighty';
  bool _isAutoPlayMode = false;
  bool _isAutoPlayPaused = false;
  BidExplanation? _lastBidExplanation;
  bool _showBidSummary = false;
  KittyExplanation? _kittyExplanation;
  bool _showKittySummary = false;
  FriendExplanation? _friendExplanation;
  bool _showFriendSummary = false;
  FriendDeclaration? _pendingDeclaration;

  // 트래킹용
  String _gameUuid = '';
  final List<BidEvaluationSnapshot> _bidSnapshots = [];
  bool _trackingSent = false;

  GameController() {
    _initializePlayers();
  }

  // 저장된 게임이 있는지 확인
  static Future<bool> hasSavedGame() async {
    return await GameSaveService.hasSavedGame(_gameType);
  }

  // 게임 저장
  Future<void> saveGame() async {
    // 진행 중인 게임만 저장
    if (_state.phase == GamePhase.waiting || _state.phase == GamePhase.gameEnd) {
      return;
    }
    await GameSaveService.saveGame(_gameType, _state.toJson());
  }

  // 저장된 게임 불러오기
  Future<bool> loadGame() async {
    final savedData = await GameSaveService.loadGame(_gameType);
    if (savedData == null) {
      return false;
    }
    try {
      _state = GameState.fromJson(savedData);
      notifyListeners();
      // AI 턴이면 자동 진행
      _resumeAIIfNeeded();
      return true;
    } catch (e) {
      return false;
    }
  }

  // 저장된 게임 삭제
  Future<void> clearSavedGame() async {
    await GameSaveService.clearSave();
  }

  // 게임 재개 시 AI 턴이면 자동 진행
  void _resumeAIIfNeeded() {
    if (_isAutoPlayMode) {
      if (_state.phase == GamePhase.bidding) {
        _processBiddingIfNeeded();
      } else if (_state.phase == GamePhase.selectingKitty) {
        _processAIKittySelection();
      } else if (_state.phase == GamePhase.declaringFriend) {
        _processAIFriendDeclaration();
      } else if (_state.phase == GamePhase.playing) {
        _processAIPlayIfNeeded();
      }
      return;
    }
    if (_state.phase == GamePhase.bidding && _state.currentBidder != 0) {
      _processBiddingIfNeeded();
    } else if (_state.phase == GamePhase.selectingKitty && _state.declarerId != 0) {
      _processAIKittySelection();
    } else if (_state.phase == GamePhase.declaringFriend && _state.declarerId != 0) {
      _processAIFriendDeclaration();
    } else if (_state.phase == GamePhase.playing && _state.currentPlayer != 0) {
      _processAIPlayIfNeeded();
    }
  }

  GameState get state => _state;
  bool get isProcessing => _isProcessing;
  bool get waitingForTrickConfirm => _waitingForTrickConfirm;
  Trick? get lastCompletedTrick => _lastCompletedTrick;
  bool get isAutoPlayMode => _isAutoPlayMode;
  bool get isAutoPlayPaused => _isAutoPlayPaused;
  BidExplanation? get lastBidExplanation => _lastBidExplanation;
  bool get showBidSummary => _showBidSummary;
  KittyExplanation? get kittyExplanation => _kittyExplanation;
  bool get showKittySummary => _showKittySummary;
  FriendExplanation? get friendExplanation => _friendExplanation;
  bool get showFriendSummary => _showFriendSummary;
  FriendDeclaration? get pendingDeclaration => _pendingDeclaration;

  String get gameUuid => _gameUuid;
  List<BidEvaluationSnapshot> get bidSnapshots => _bidSnapshots;

  Player get humanPlayer => _state.players[0];
  Player get currentPlayer => _state.players[_state.currentPlayer];
  bool get isHumanTurn =>
      _state.currentPlayer == 0 && !_isProcessing && !_waitingForTrickConfirm;

  void _initializePlayers() {
    final players = [
      Player(id: 0, name: '플레이어', type: PlayerType.human),
      Player(id: 1, name: '민준', type: PlayerType.ai),
      Player(id: 2, name: '서연', type: PlayerType.ai),
      Player(id: 3, name: '지호', type: PlayerType.ai),
      Player(id: 4, name: '수빈', type: PlayerType.ai),
    ];

    _state = GameState(players: players);
  }

  void startNewGame() {
    _lastBidExplanation = null;
    _showBidSummary = false;
    _kittyExplanation = null;
    _showKittySummary = false;
    _friendExplanation = null;
    _showFriendSummary = false;
    _gameUuid = MightyTrackingService.generateUuid();
    _bidSnapshots.clear();
    _trackingSent = false;
    _state.startNewGame();
    notifyListeners();
    if (!_isAutoPlayMode) saveGame(); // 자동 저장 (auto-play 시 스킵)
    _processBiddingIfNeeded();
  }

  void _processBiddingIfNeeded() async {
    if (_state.phase != GamePhase.bidding) return;
    if (!_isAutoPlayMode && _state.currentBidder == 0) return;

    _isProcessing = true;
    notifyListeners();

    if (_isAutoPlayMode) {
      // auto-play: 배팅 결정 + 설명 생성 후 표시
      await Future.delayed(const Duration(milliseconds: 500));
      if (_state.phase != GamePhase.bidding) return;
      if (_isAutoPlayPaused) { _isProcessing = false; notifyListeners(); return; }

      final currentPlayer = _state.players[_state.currentBidder];
      final (bid, evaluation) = _aiPlayer.decideBidWithEvaluation(currentPlayer, _state);

      _captureBidSnapshot(currentPlayer, bid);

      var effectiveSuit = evaluation.bestGiruda;
      if (effectiveSuit == null) {
        Suit? longestSuit;
        int longestCount = 0;
        for (final s in Suit.values) {
          final cnt = currentPlayer.hand.where((c) => !c.isJoker && c.suit == s).length;
          if (cnt > longestCount) { longestCount = cnt; longestSuit = s; }
        }
        if (longestCount >= 4) effectiveSuit = longestSuit;
      }

      String passReason = '';
      if (bid.passed) {
        passReason = evaluation.handStrength < 13 ? 'LOW_POINTS' : 'OUTBID';
      }

      _lastBidExplanation = BidExplanation(
        playerId: currentPlayer.id,
        playerName: currentPlayer.name,
        passed: bid.passed,
        suit: effectiveSuit,
        tricks: bid.tricks,
        minPoints: evaluation.minPoints,
        maxPoints: evaluation.maxPoints,
        optimalPoints: evaluation.optimalPoints,
        girudaCount: evaluation.girudaCount,
        passReason: passReason,
        handStrength: evaluation.handStrength,
        requiredBid: evaluation.requiredBid,
        scoreBreakdown: _aiPlayer.getPointBreakdownText(currentPlayer.hand, effectiveSuit),
      );

      _state.placeBid(bid);
      _isProcessing = false;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 3));
      if (_state.phase != GamePhase.bidding && !(_state.phase == GamePhase.waiting && _state.allPassed) && _state.phase != GamePhase.selectingKitty) return;
      if (_isAutoPlayPaused) return;

      if (_state.phase == GamePhase.bidding) {
        _processBiddingIfNeeded();
      } else if (_state.phase == GamePhase.selectingKitty) {
        if (_state.declarerId != 0 || _isAutoPlayMode) {
          _processAIKittySelection();
        }
      } else if (_state.phase == GamePhase.waiting && _state.allPassed) {
        _sendTrackingData();
        _lastBidExplanation = null;
        notifyListeners();
      }
    } else {
      // 일반 모드
      await Future.delayed(const Duration(milliseconds: 800));
      if (_state.phase != GamePhase.bidding) return;

      final currentPlayer = _state.players[_state.currentBidder];
      final (bid, evaluation) = _aiPlayer.decideBidWithEvaluation(currentPlayer, _state);
      _captureBidSnapshot(currentPlayer, bid);
      _state.placeBid(bid);

      _isProcessing = false;
      notifyListeners();
      saveGame();

      if (_state.phase == GamePhase.bidding) {
        _processBiddingIfNeeded();
      } else if (_state.phase == GamePhase.selectingKitty && _state.declarerId != 0) {
        _processAIKittySelection();
      }
    }
  }

  void humanBid(Bid bid) {
    if (_state.currentBidder != 0) return;

    _captureBidSnapshot(_state.players[0], bid);
    _state.placeBid(bid);
    notifyListeners();
    saveGame(); // 자동 저장

    if (_state.phase == GamePhase.bidding) {
      _processBiddingIfNeeded();
    } else if (_state.phase == GamePhase.selectingKitty &&
        _state.declarerId != 0) {
      _processAIKittySelection();
    }
  }

  void humanPass() {
    humanBid(Bid.pass(0));
  }

  // 딜 미스 선언 가능 여부
  bool get canHumanDeclareDealMiss {
    if (_state.phase != GamePhase.bidding) return false;
    if (_state.currentBidder != 0) return false;
    return humanPlayer.canDeclareDealMiss;
  }

  // 딜 미스 선언
  void humanDeclareDealMiss() {
    if (!canHumanDeclareDealMiss) return;

    _state.declareDealMiss(0);
    notifyListeners();

    // AI가 딜 미스 체크 후 배팅 진행
    _processAIDealMissCheck();
  }

  // AI 딜 미스 체크 후 배팅 진행
  void _processAIDealMissCheck() async {
    while (_state.phase == GamePhase.bidding && _state.currentBidder != 0) {
      final currentPlayer = _state.players[_state.currentBidder];

      // AI 딜 미스 체크
      if (currentPlayer.canDeclareDealMiss) {
        // AI는 점수 카드가 0개일 때만 딜 미스 선언 (조커+1개는 플레이 시도)
        final pointCards = currentPlayer.hand.where((c) => c.isPointCard).length;
        if (pointCards == 0) {
          _isProcessing = true;
          notifyListeners();

          await Future.delayed(const Duration(milliseconds: 800));

          _state.declareDealMiss(_state.currentBidder);

          _isProcessing = false;
          notifyListeners();

          // 딜 미스 후 다시 체크
          continue;
        }
      }

      // 딜 미스 안하면 배팅 진행
      break;
    }

    _processBiddingIfNeeded();
  }

  void _processAIKittySelection() async {
    _lastBidExplanation = null;
    _isProcessing = true;
    notifyListeners();

    await Future.delayed(Duration(milliseconds: _isAutoPlayMode ? 600 : 1000));
    if (_state.phase != GamePhase.selectingKitty || _state.declarerId == null) return;
    if (_isAutoPlayPaused) { _isProcessing = false; notifyListeners(); return; }

    final declarer = _state.players[_state.declarerId!];
    final originalGiruda = _state.giruda;
    final kittyCards = List<PlayingCard>.from(_state.kitty);

    // 1. 13장으로 기루다 변경 여부 결정
    final newGiruda = _aiPlayer.decideGirudaChange(declarer, _state, _state.kitty);

    // 2. 최종 기루다를 기준으로 버릴 카드 선택
    final discardCards = _aiPlayer.selectKittyCardsWithGiruda(declarer, _state, _state.kitty, newGiruda);

    final girudaChanged = newGiruda != originalGiruda;
    final allCards = [...declarer.hand, ...kittyCards];
    final finalHand = allCards.where((c) => !discardCards.contains(c)).toList();
    finalHand.sort((a, b) {
      if (a.isJoker) return -1;
      if (b.isJoker) return 1;
      if (a.suit != b.suit) return a.suit!.index.compareTo(b.suit!.index);
      return b.rankValue.compareTo(a.rankValue);
    });

    // Tracking: mark declarer in bid snapshots
    for (var snap in _bidSnapshots) {
      if (snap.playerId == _state.declarerId) snap.isDeclarer = true;
    }

    if (_isAutoPlayMode) {
      final reasons = _generateDiscardReasons(discardCards, newGiruda, declarer);

      // 교체 전 예상 점수 (배팅 시 10장 기준)
      final beforeEval = _aiPlayer.evaluateForBidding(declarer.hand);

      // 교체 후 예상 점수 (최종 핸드 10장 + 키티 점수 카드 기준)
      final (afterMin, afterMax) = _aiPlayer.estimatePointRange(finalHand, newGiruda);
      final kittyPointCards = discardCards.where((c) => c.isPointCard).length;
      final afterOptimal = (afterMin * 0.3 + (afterMax + kittyPointCards) * 0.7 + 1).round();

      _kittyExplanation = KittyExplanation(
        kittyCards: kittyCards,
        discardCards: discardCards,
        finalHand: finalHand,
        originalGiruda: originalGiruda,
        newGiruda: newGiruda,
        girudaChanged: girudaChanged,
        discardReasons: reasons,
        beforeMinPoints: beforeEval.minPoints,
        beforeMaxPoints: beforeEval.maxPoints,
        beforeOptimalPoints: beforeEval.optimalPoints,
        afterMinPoints: afterMin,
        afterMaxPoints: afterMax + kittyPointCards,
        afterOptimalPoints: afterOptimal,
      );

      _showKittySummary = true;
      _isProcessing = false;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 3));
      if (_isAutoPlayPaused) return;
      if (_state.phase != GamePhase.selectingKitty || _state.declarerId == null) return;

      _showKittySummary = false;
      _state.selectKitty(discardCards, newGiruda);
      _kittyExplanation = null;
      notifyListeners();

      _processAIFriendDeclaration();
    } else {
      _state.selectKitty(discardCards, newGiruda);
      _isProcessing = false;
      notifyListeners();
      saveGame();

      _processAIFriendDeclaration();
    }
  }

  void humanSelectKitty(List<PlayingCard> discardCards, Suit? newGiruda, {bool isFull = false}) {
    if (_state.declarerId != 0) return;
    if (discardCards.length != 3) return;

    _state.selectKitty(discardCards, newGiruda);
    if (isFull) {
      _state.declareFull();
    }
    notifyListeners();
    saveGame(); // 자동 저장
  }

  void _processAIFriendDeclaration() async {
    if (!_isAutoPlayMode && _state.declarerId == 0) return;

    _isProcessing = true;
    notifyListeners();

    await Future.delayed(Duration(milliseconds: _isAutoPlayMode ? 500 : 800));
    if (_isAutoPlayMode && _state.phase != GamePhase.declaringFriend) return;
    if (_isAutoPlayPaused) { _isProcessing = false; notifyListeners(); return; }

    final declarer = _state.players[_state.declarerId!];
    final declaration = _aiPlayer.declareFriend(declarer, _state);

    final isFull = _aiPlayer.shouldDeclareFull(declarer, _state, declaration);
    if (isFull) {
      _state.declareFull();
    }

    if (_isAutoPlayMode) {
      final reason = _generateFriendReason(declaration, declarer, _state);
      final firstTrickInfo = _analyzeFirstTrick(declarer, _state);

      _friendExplanation = FriendExplanation(
        declaration: declaration,
        reason: reason,
        isFull: isFull,
        firstTrickCard: firstTrickInfo.$1,
        firstTrickStrategy: firstTrickInfo.$2,
      );

      _showFriendSummary = true;
      _isProcessing = false;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 3));
      if (_isAutoPlayPaused) return;

      _showFriendSummary = false;
      _friendExplanation = null;
      notifyListeners();

      // 배팅 결과 요약 화면 표시
      _pendingDeclaration = declaration;
      _showBidSummary = true;
      _lastBidExplanation = null;
      notifyListeners();

      // auto-play: 3초 후 자동 진행
      await Future.delayed(const Duration(seconds: 3));
      if (_isAutoPlayPaused) return;
      if (_showBidSummary && _pendingDeclaration != null) {
        confirmBidSummary();
      }
    } else {
      _state.declareFriend(declaration);
      _isProcessing = false;
      notifyListeners();
      saveGame();
      _processAIPlayIfNeeded();
    }
  }

  void humanDeclareFriend(FriendDeclaration declaration) {
    if (_state.declarerId != 0) return;

    _state.declareFriend(declaration);
    notifyListeners();
    saveGame(); // 자동 저장

    _processAIPlayIfNeeded();
  }

  void _processAIPlayIfNeeded() async {
    if (_state.phase != GamePhase.playing) return;
    if (!_isAutoPlayMode && _state.currentPlayer == 0) return;
    if (_waitingForTrickConfirm) return;

    _isProcessing = true;
    notifyListeners();

    await Future.delayed(Duration(milliseconds: _isAutoPlayMode ? 300 : 600));
    if (!_isAutoPlayMode && _state.phase != GamePhase.playing) return;
    if (_isAutoPlayMode && _state.phase != GamePhase.playing) return;
    if (_isAutoPlayPaused) { _isProcessing = false; notifyListeners(); return; }

    final currentPlayer = _state.players[_state.currentPlayer];
    PlayingCard card;
    Suit? jokerLeadSuit;

    // AI 조커 콜 결정 (선공 시에만)
    if (_state.currentTrick != null && _state.currentTrick!.cards.isEmpty) {
      final jokerCallSuit = _aiPlayer.decideJokerCall(currentPlayer, _state);
      if (jokerCallSuit != null) {
        _state.declareJokerCall(jokerCallSuit);
        notifyListeners();
        await Future.delayed(Duration(milliseconds: _isAutoPlayMode ? 300 : 500));
        card = _state.jokerCall;
      } else {
        card = _aiPlayer.selectCard(currentPlayer, _state);
        if (card.isJoker) {
          jokerLeadSuit = _aiPlayer.selectJokerLeadSuit(currentPlayer, _state);
        }
        final jokerCallCard = _state.jokerCall;
        if (card.suit == jokerCallCard.suit && card.rank == jokerCallCard.rank) {
          bool hasJoker = currentPlayer.hand.any((c) => c.isJoker);
          final friendCard = _state.friendDeclaration?.card;
          bool isJokerFriend = friendCard != null && friendCard.isJoker;
          bool isAttackTeam = currentPlayer.isDeclarer || currentPlayer.isFriend;
          if (!hasJoker && !_state.isJokerPlayed && _state.currentTrickNumber > 1 &&
              !(isJokerFriend && isAttackTeam)) {
            _state.declareJokerCall(jokerCallCard.suit!);
            notifyListeners();
            await Future.delayed(Duration(milliseconds: _isAutoPlayMode ? 300 : 500));
          }
        }
      }
    } else {
      card = _aiPlayer.selectCard(currentPlayer, _state);
    }

    final trickCountBefore = _state.tricks.length;
    _state.playCard(card, currentPlayer.id, jokerLeadSuit: jokerLeadSuit);
    _isProcessing = false;

    // 트릭이 완료되었는지 확인
    if (_state.tricks.length > trickCountBefore && _state.phase == GamePhase.playing) {
      _lastCompletedTrick = _state.tricks.last;
      if (_isAutoPlayMode) {
        _waitingForTrickConfirm = true;
        notifyListeners();
        if (!_isAutoPlayPaused) {
          await Future.delayed(const Duration(seconds: 2));
          if (_isAutoPlayMode && _waitingForTrickConfirm && !_isAutoPlayPaused) {
            confirmTrick();
          }
        }
      } else {
        if (_state.currentPlayer == 0) {
          _waitingForTrickConfirm = false;
        } else {
          _waitingForTrickConfirm = true;
        }
        notifyListeners();
        saveGame();
      }
      return;
    }

    // 게임 종료
    if (_state.phase == GamePhase.gameEnd) {
      _sendTrackingData();
      if (_isAutoPlayMode) {
        notifyListeners();
        return;
      } else {
        clearSavedGame();
      }
    }

    notifyListeners();
    if (!_isAutoPlayMode) saveGame();

    if (_state.phase == GamePhase.playing) {
      _processAIPlayIfNeeded();
    }
  }

  void humanPlayCard(PlayingCard card, {Suit? jokerCallSuit, Suit? jokerLeadSuit}) {
    if (_state.currentPlayer != 0) return;
    if (!_state.canPlayCard(card, humanPlayer)) return;
    // 사용자가 선공일 때는 확인 대기 중이 아니므로 카드 낼 수 있음
    if (_waitingForTrickConfirm && _state.currentPlayer != 0) return;

    // 이전 트릭 표시 정리
    _lastCompletedTrick = null;

    // 조커 콜 선언 (선공 시에만)
    if (jokerCallSuit != null && isLeadingTrick) {
      _state.declareJokerCall(jokerCallSuit);
    }

    // 트릭 완료 여부 확인을 위해 현재 트릭 수 저장
    final trickCountBefore = _state.tricks.length;

    _state.playCard(card, 0, jokerLeadSuit: jokerLeadSuit);

    // 트릭이 완료되었는지 확인
    if (_state.tricks.length > trickCountBefore && _state.phase == GamePhase.playing) {
      _lastCompletedTrick = _state.tricks.last;
      // 사용자가 다음 선공이면 확인 없이 바로 카드 선택 가능
      if (_state.currentPlayer == 0) {
        _waitingForTrickConfirm = false;
      } else {
        _waitingForTrickConfirm = true;
      }
      notifyListeners();
      saveGame(); // 자동 저장
      return; // 사용자 확인 대기 또는 카드 선택 대기
    }

    // 게임 종료 시 저장 삭제
    if (_state.phase == GamePhase.gameEnd) {
      clearSavedGame();
    }

    notifyListeners();
    saveGame(); // 자동 저장

    if (_state.phase == GamePhase.playing) {
      _processAIPlayIfNeeded();
    }
  }

  // 사용자가 다음 선공인지 확인 (트릭 완료 후)
  bool get isHumanLeaderAfterTrick =>
      _lastCompletedTrick != null && _state.currentPlayer == 0 && !_waitingForTrickConfirm;

  // 트릭 확인 후 다음 단계 진행
  void confirmTrick() {
    if (!_waitingForTrickConfirm) return;

    _waitingForTrickConfirm = false;
    _lastCompletedTrick = null;
    notifyListeners();

    if (_state.phase == GamePhase.playing) {
      _processAIPlayIfNeeded();
    }
  }

  // 현재 트릭의 선공인지 확인
  bool get isLeadingTrick =>
      _state.currentTrick != null && _state.currentTrick!.cards.isEmpty;

  // 조커 콜이 가능한지 확인 (첫 트릭이 아니고, 선공이고, 조커가 아직 플레이되지 않은 경우)
  bool get canDeclareJokerCall =>
      _state.currentTrickNumber > 1 &&
      isLeadingTrick &&
      _state.currentPlayer == 0 &&
      !_state.isJokerPlayed;

  List<PlayingCard> getPlayableCards() {
    return humanPlayer.hand
        .where((card) => _state.canPlayCard(card, humanPlayer))
        .toList();
  }

  bool canPlayCard(PlayingCard card) {
    return _state.canPlayCard(card, humanPlayer);
  }

  String? getCannotPlayReason(PlayingCard card) {
    return _state.getCannotPlayReason(card, humanPlayer);
  }

  /// 사용자에게 추천할 카드를 반환
  /// AI 로직을 사용하여 최적의 카드를 선택
  PlayingCard? getRecommendedCard() {
    if (_state.phase != GamePhase.playing) return null;
    if (_state.currentPlayer != 0) return null;

    final playableCards = getPlayableCards();
    if (playableCards.isEmpty) return null;
    if (playableCards.length == 1) return playableCards.first;

    // AI 로직을 사용하여 추천 카드 선택
    return _aiPlayer.selectCard(humanPlayer, _state);
  }

  /// 사용자에게 추천할 배팅을 반환
  /// AI 로직을 사용하여 최적의 배팅을 선택
  Bid? getRecommendedBid() {
    if (_state.phase != GamePhase.bidding) return null;
    if (_state.currentBidder != 0) return null;
    if (_state.passedPlayers[0]) return null;

    // AI 로직을 사용하여 추천 배팅 선택
    return _aiPlayer.decideBid(humanPlayer, _state);
  }

  void _captureBidSnapshot(Player player, Bid bid) {
    final hand = player.hand;
    final eval = _aiPlayer.evaluateForBidding(hand);
    final bestSuit = eval.bestGiruda;
    final mightySuit = bestSuit == Suit.spade ? Suit.diamond : Suit.spade;

    _bidSnapshots.add(BidEvaluationSnapshot(
      playerId: player.id,
      hand: hand.map((c) => c.toJson()).toList(),
      bestGiruda: bestSuit?.name,
      girudaCount: eval.girudaCount,
      hasMighty: hand.any((c) =>
          !c.isJoker && c.suit == mightySuit && c.rank == Rank.ace),
      hasJoker: hand.any((c) => c.isJoker),
      hasGirudaAce: bestSuit != null &&
          hand.any((c) => !c.isJoker && c.suit == bestSuit && c.rank == Rank.ace),
      hasGirudaKing: bestSuit != null &&
          hand.any((c) => !c.isJoker && c.suit == bestSuit && c.rank == Rank.king),
      predictedMin: eval.minPoints,
      predictedMax: eval.maxPoints,
      predictedOptimal: eval.optimalPoints,
      bidAction: bid.passed ? 'PASS' : 'BID',
      bidAmount: bid.tricks,
    ));
  }

  void startAutoPlay() {
    _isAutoPlayMode = true;
    _isAutoPlayPaused = false;
    startNewGame();
  }

  void stopAutoPlay() {
    _isAutoPlayMode = false;
    _isAutoPlayPaused = false;
    _isProcessing = false;
    _waitingForTrickConfirm = false;
    _showBidSummary = false;
    _pendingDeclaration = null;
    _kittyExplanation = null;
    _showKittySummary = false;
    _friendExplanation = null;
    _showFriendSummary = false;
    _lastCompletedTrick = null;
    _initializePlayers();
    notifyListeners();
  }

  void pauseAutoPlay() {
    _isAutoPlayPaused = true;
    notifyListeners();
  }

  void resumeAutoPlay() {
    if (!_isAutoPlayMode || !_isAutoPlayPaused) return;
    _isAutoPlayPaused = false;
    notifyListeners();
    if (_waitingForTrickConfirm) {
      confirmTrick();
      return;
    }
    if (_showKittySummary && _kittyExplanation != null) {
      _showKittySummary = false;
      _state.selectKitty(_kittyExplanation!.discardCards, _kittyExplanation!.newGiruda);
      _kittyExplanation = null;
      notifyListeners();
      _processAIFriendDeclaration();
      return;
    }
    if (_showFriendSummary && _friendExplanation != null) {
      _showFriendSummary = false;
      final declaration = _friendExplanation!.declaration;
      _friendExplanation = null;
      _state.declareFriend(declaration);
      notifyListeners();
      _processAIPlayIfNeeded();
      return;
    }
    if (_showBidSummary && _pendingDeclaration != null) {
      return;
    }
    if (_state.phase == GamePhase.waiting && _state.allPassed) {
      _sendTrackingData();
      _lastBidExplanation = null;
      notifyListeners();
      return;
    }
    _resumeAIIfNeeded();
  }

  void startNextAutoGame() {
    if (!_isAutoPlayMode) return;
    _isAutoPlayPaused = false;
    startNewGame();
  }

  void confirmBidSummary() {
    if (!_showBidSummary || _pendingDeclaration == null) return;
    _showBidSummary = false;
    _state.declareFriend(_pendingDeclaration!);
    _pendingDeclaration = null;
    notifyListeners();
    _processAIPlayIfNeeded();
  }

  /// 버릴 카드의 이유 생성
  List<String> _generateDiscardReasons(List<PlayingCard> discardCards, Suit? finalGiruda, Player declarer) {
    final hand = [...declarer.hand, ..._state.kitty];
    final suitCounts = <Suit, int>{};
    for (final suit in Suit.values) {
      suitCounts[suit] = hand.where((c) => !c.isJoker && c.suit == suit).length;
    }
    return discardCards.map((card) {
      if (card.isJoker) return 'SPECIAL';
      final isGiruda = card.suit == finalGiruda;
      final suitCount = suitCounts[card.suit] ?? 0;
      final isPointCard = card.isPointCard;
      if (!isGiruda && suitCount <= 2) return 'CUT_SUIT';
      if (!isGiruda && !isPointCard) return 'NON_GIRUDA_LOW';
      if (!isPointCard) return 'LOW_VALUE';
      return 'LEAST_USEFUL';
    }).toList();
  }

  /// 프렌드 선택 이유 생성
  String _generateFriendReason(FriendDeclaration declaration, Player declarer, GameState state) {
    if (declaration.isNoFriend) return 'NO_FRIEND_STRONG';
    if (declaration.isFirstTrickWinner) return 'FIRST_TRICK';
    if (declaration.trickNumber != null) return 'NTH_TRICK';
    if (declaration.card != null) {
      final card = declaration.card!;
      final mighty = state.mighty;
      if (card.suit == mighty.suit && card.rank == mighty.rank) return 'NEED_MIGHTY';
      if (card.isJoker) return 'NEED_JOKER';
      if (state.giruda != null && card.suit == state.giruda) {
        if (card.rank == Rank.ace) return 'NEED_GIRUDA_ACE';
        if (card.rank == Rank.king) return 'NEED_GIRUDA_KING';
        return 'NEED_GIRUDA_MID';
      }
      if (card.rank == Rank.ace) return 'NEED_ACE';
      return 'NEED_STRONG_CARD';
    }
    return '';
  }

  /// 초구 분석: (추천 카드, 전략 코드)
  (PlayingCard?, String) _analyzeFirstTrick(Player declarer, GameState state) {
    final hand = declarer.hand;
    final giruda = state.giruda;
    PlayingCard? bestFirstCard;
    String strategy = '';
    for (final card in hand) {
      if (card.isJoker) continue;
      if (card.suit == giruda) continue;
      if (card.suit == state.mighty.suit && card.rank == state.mighty.rank) continue;
      if (card.rank == Rank.ace) { bestFirstCard = card; strategy = 'FIRST_ACE'; break; }
    }
    if (bestFirstCard == null) {
      for (final card in hand) {
        if (card.isJoker) continue;
        if (card.suit == giruda) continue;
        if (card.rank == Rank.king) { bestFirstCard = card; strategy = 'FIRST_KING'; break; }
      }
    }
    if (bestFirstCard == null) {
      final nonGirudaCards = hand.where((c) => !c.isJoker && c.suit != giruda).toList();
      if (nonGirudaCards.isNotEmpty) {
        nonGirudaCards.sort((a, b) => a.rankValue.compareTo(b.rankValue));
        bestFirstCard = nonGirudaCards.first;
        strategy = 'FIRST_GIVE_UP';
      }
    }
    return (bestFirstCard, strategy);
  }

  void _sendTrackingData() {
    if (_state.allPassed) return;
    if (_state.declarerId != null) {
      for (final snap in _bidSnapshots) {
        if (snap.playerId == _state.declarerId) snap.isDeclarer = true;
      }
    }
    MightyTrackingService.sendGameResult(
      gameUuid: _gameUuid,
      state: _state,
      bidSnapshots: _bidSnapshots,
    );
  }

  /// 게임 종료 시 서버로 트래킹 데이터 전송
  void sendTracking() {
    if (_trackingSent) return;
    _trackingSent = true;

    // 올패스 게임은 서버로 보내지 않음
    if (_state.allPassed) return;

    // 주공의 비딩 스냅샷에 isDeclarer 표시
    if (_state.declarerId != null) {
      for (final snap in _bidSnapshots) {
        if (snap.playerId == _state.declarerId) {
          snap.isDeclarer = true;
        }
      }
    }

    MightyTrackingService.sendGameResult(
      gameUuid: _gameUuid,
      state: _state,
      bidSnapshots: _bidSnapshots,
    );
  }

  void reset() {
    _initializePlayers();
    notifyListeners();
  }
}

class FriendExplanation {
  final FriendDeclaration declaration;
  final String reason;
  final bool isFull;
  final PlayingCard? firstTrickCard;
  final String firstTrickStrategy;

  FriendExplanation({
    required this.declaration,
    required this.reason,
    this.isFull = false,
    this.firstTrickCard,
    this.firstTrickStrategy = '',
  });
}

class KittyExplanation {
  final List<PlayingCard> kittyCards;
  final List<PlayingCard> discardCards;
  final List<PlayingCard> finalHand;
  final Suit? originalGiruda;
  final Suit? newGiruda;
  final bool girudaChanged;
  final List<String> discardReasons;
  final int beforeMinPoints;
  final int beforeMaxPoints;
  final int beforeOptimalPoints;
  final int afterMinPoints;
  final int afterMaxPoints;
  final int afterOptimalPoints;

  KittyExplanation({
    required this.kittyCards,
    required this.discardCards,
    required this.finalHand,
    required this.originalGiruda,
    required this.newGiruda,
    required this.girudaChanged,
    required this.discardReasons,
    this.beforeMinPoints = 0,
    this.beforeMaxPoints = 0,
    this.beforeOptimalPoints = 0,
    this.afterMinPoints = 0,
    this.afterMaxPoints = 0,
    this.afterOptimalPoints = 0,
  });
}

class BidExplanation {
  final int playerId;
  final String playerName;
  final bool passed;
  final Suit? suit;
  final int tricks;
  final int minPoints;
  final int maxPoints;
  final int optimalPoints;
  final int girudaCount;
  final String passReason;
  final int handStrength;
  final int requiredBid;
  final String scoreBreakdown;

  BidExplanation({
    required this.playerId,
    required this.playerName,
    required this.passed,
    this.suit,
    required this.tricks,
    required this.minPoints,
    required this.maxPoints,
    required this.optimalPoints,
    this.girudaCount = 0,
    this.passReason = '',
    this.handStrength = 0,
    this.requiredBid = 0,
    this.scoreBreakdown = '',
  });
}
