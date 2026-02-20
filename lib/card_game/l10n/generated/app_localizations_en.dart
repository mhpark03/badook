// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mighty';

  @override
  String get gameSubtitle => 'Korean Traditional Trick-Taking Card Game';

  @override
  String get startGame => 'Start Game';

  @override
  String get newGame => 'New Game';

  @override
  String get biddingPhase => 'Bidding Phase';

  @override
  String currentBidder(String name) {
    return 'Current Bidder: $name';
  }

  @override
  String get noBidYet => 'No bid yet';

  @override
  String highestBid(String bid) {
    return 'Highest Bid: $bid';
  }

  @override
  String get bid => 'Bid';

  @override
  String get bidButton => 'Place Bid';

  @override
  String get pass => 'Pass';

  @override
  String get tricks => 'Target Score';

  @override
  String get giruda => 'Trump';

  @override
  String get noGiruda => 'No Trump';

  @override
  String get spade => 'Spade';

  @override
  String get diamond => 'Diamond';

  @override
  String get heart => 'Heart';

  @override
  String get club => 'Club';

  @override
  String get spadeName => 'Spade';

  @override
  String get diamondName => 'Diamond';

  @override
  String get heartName => 'Heart';

  @override
  String get clubName => 'Club';

  @override
  String get selectKitty => 'Select Kitty';

  @override
  String selectKittyDesc(int count) {
    return 'Select 3 cards to discard (Selected: $count/3)';
  }

  @override
  String get receivedKitty => 'Received Kitty:';

  @override
  String get myCards => 'My Cards:';

  @override
  String get changeGiruda => 'Change Trump (Optional):';

  @override
  String get confirm => 'Confirm';

  @override
  String get declareFriend => 'Declare Friend';

  @override
  String get friendDeclarationType => 'Friend Declaration Type:';

  @override
  String get byCard => 'By Card';

  @override
  String get firstTrickFriend => 'First Trick Friend';

  @override
  String get firstTrickFriendDesc => 'Winner of the first trick';

  @override
  String get nthTrickFriend => 'Nth Trick Friend';

  @override
  String get noFriend => 'No Friend';

  @override
  String get noFriendDesc => 'Play alone';

  @override
  String get declare => 'Declare';

  @override
  String get suit => 'Suit:';

  @override
  String get rank => 'Rank:';

  @override
  String selectedCard(String card) {
    return 'Selected Card: $card';
  }

  @override
  String get trickNumber => 'Trick Number:';

  @override
  String get playCard => 'Play a card';

  @override
  String get yourTurn => 'Your turn';

  @override
  String playerTurn(String name) {
    return '$name\'s turn';
  }

  @override
  String get contract => 'Contract';

  @override
  String get trick => 'Trick';

  @override
  String get friend => 'Friend';

  @override
  String get declarer => 'Declarer';

  @override
  String cards(int count) {
    return 'Cards: $count';
  }

  @override
  String get aiSelectingKitty => 'AI is selecting kitty...';

  @override
  String get aiSelectingCard => 'AI is selecting card...';

  @override
  String get aiDeclaringFriend => 'AI is declaring friend...';

  @override
  String roundComplete(int round) {
    return 'Round $round Complete!';
  }

  @override
  String get cardDistribution5 => '5th card will be dealt.';

  @override
  String get cardDistribution6 => '6th card will be dealt.';

  @override
  String get cardDistribution7 => 'Final 7th card will be dealt.';

  @override
  String get goodLuck => 'GOOD LUCK!';

  @override
  String secondsRemaining(int seconds) {
    return '${seconds}s';
  }

  @override
  String get declarerTeamWins => 'Declarer Team Wins!';

  @override
  String get defenderTeamWins => 'Defender Team Wins!';

  @override
  String get declarerTeam => 'Declarer Team';

  @override
  String get defenderTeam => 'Defender Team';

  @override
  String get fullPoints => 'Full';

  @override
  String declarerTeamPoints(int points) {
    return 'Declarer Team: $points pts';
  }

  @override
  String defenderTeamPoints(int points) {
    return 'Defender Team: $points pts';
  }

  @override
  String targetPoints(int points) {
    return 'Target: $points pts';
  }

  @override
  String get score => 'Score';

  @override
  String points(int points) {
    return '$points pts';
  }

  @override
  String get player => 'Player';

  @override
  String get you => 'You';

  @override
  String get bidding => 'Bidding...';

  @override
  String get waiting => 'Waiting';

  @override
  String get otherPlayerTurn => 'Other player\'s turn';

  @override
  String get yourCards => 'Your Cards';

  @override
  String get biddingTurn => 'Your Bid';

  @override
  String bidWithAmount(int amount) {
    return 'Bid $amount';
  }

  @override
  String trickComplete(int number) {
    return 'Trick $number Complete';
  }

  @override
  String winnerAnnouncement(String name, String team) {
    return '$name Wins! ($team)';
  }

  @override
  String get attackTeam => 'Attack';

  @override
  String get defenseTeam => 'Defense';

  @override
  String get nextTrick => 'Next Trick';

  @override
  String get friendNone => 'None';

  @override
  String get firstTrick => '1st Trick';

  @override
  String get selectCardHint => 'Select a card ↓';

  @override
  String get previousTrick => 'Previous Trick';

  @override
  String get winShort => 'Win';

  @override
  String get leadPlayer => 'Lead';

  @override
  String get leadPlayerHint => '👆 You lead!';

  @override
  String get selectCardBelow => 'Select a card below';

  @override
  String get leadPlayerSelectCard => '👆 You lead! Select a card';

  @override
  String jokerCallAnnouncement(String suit) {
    return 'Joker Call! $suit';
  }

  @override
  String get wonCards => 'Won:';

  @override
  String get jokerCallTitle => 'Joker Call';

  @override
  String jokerCallQuestion(String suit) {
    return 'Declare $suit Joker Call?';
  }

  @override
  String get no => 'No';

  @override
  String jokerCallButton(String suit) {
    return '$suit Joker Call!';
  }

  @override
  String get jokerLeadSuitTitle => 'Joker Lead';

  @override
  String get jokerLeadSuitQuestion => 'Select the suit others must follow';

  @override
  String get allPassedTitle => 'All Passed';

  @override
  String get allPassedMessage => 'All players passed.\nStarting new game.';

  @override
  String get girudaChangeWarning => 'Changing trump: goal +2';

  @override
  String get keep => 'Keep';

  @override
  String get aiRecommendation => 'AI Recommendation';

  @override
  String get discardCards => 'Discard:';

  @override
  String get goalPlus2 => '(Goal +2)';

  @override
  String get applyRecommendation => 'Apply';

  @override
  String nthTrickShort(int n) {
    return 'Trick $n';
  }

  @override
  String get recommendedFriend => 'Recommended:';

  @override
  String get joker => 'Joker';

  @override
  String get mighty => 'Mighty';

  @override
  String get recommendNoFriend => 'No Friend recommended';

  @override
  String get reasonHasMighty => 'Has Mighty';

  @override
  String get reasonHasJoker => 'Has Joker';

  @override
  String get reasonNeedMighty => 'Need Mighty';

  @override
  String get reasonNeedJoker => 'Need Joker';

  @override
  String get reasonNeedGirudaAce => 'Need Trump Ace';

  @override
  String get reasonNeedGirudaKing => 'Need Trump King';

  @override
  String get reasonStrongHand => 'Strong hand';

  @override
  String get continueGame => 'Continue';

  @override
  String get exitGame => 'Exit';

  @override
  String get exitGameConfirm => 'Exit the game?\nCurrent game will be saved.';

  @override
  String get cancel => 'Cancel';

  @override
  String get exit => 'Exit';

  @override
  String get savedGame => 'Saved Game';

  @override
  String get noSavedGame => 'No saved game';

  @override
  String get recommendedCard => 'Recommended';

  @override
  String get showRecommendation => 'Show Hint';

  @override
  String get playerStats => 'Player Statistics';

  @override
  String get winLoss => 'W/L';

  @override
  String get totalScore => 'Score';

  @override
  String get win => 'W';

  @override
  String get loss => 'L';

  @override
  String get resetStats => 'Reset';

  @override
  String get resetStatsConfirm =>
      'Watch an ad to reset all statistics.\nContinue?';

  @override
  String get exitApp => 'Exit App';

  @override
  String get exitAppConfirm => 'Exit the app?';

  @override
  String get gameGuide => 'How to Play';

  @override
  String get guideOverview => 'Overview';

  @override
  String get guideOverviewText =>
      'Mighty is a trick-taking card game for 5 players. The Declarer (1) and Friend (1) team up against the Defenders (3).';

  @override
  String get guideBidding => 'Bidding';

  @override
  String get guideBiddingText =>
      '• Each player declares how many point cards they will win\n• The highest bidder becomes the Declarer\n• The Declarer chooses the trump suit (Giruda)';

  @override
  String get guideSpecialCards => 'Special Cards';

  @override
  String get guideSpecialCardsText =>
      '• Mighty: Ace of Spades (strongest card)\n• Joker: Second strongest card\n• Trump: The suit chosen by the Declarer';

  @override
  String get guideFriend => 'Friend';

  @override
  String get guideFriendText =>
      '• The Declarer designates someone with a specific card as Friend\n• The Friend can hide their identity\n• Joker Call: Designate the holder of a specific 3 as Friend';

  @override
  String get guideScoring => 'Scoring';

  @override
  String get guideScoringText =>
      '• Point cards: A, K, Q, J, 10 (1 point each, 20 total)\n• Declarer team wins if they reach the target score\n• Winners get + points, losers get - points';

  @override
  String get guideTips => 'Tips';

  @override
  String get guideTipsText =>
      '• Mighty and Joker are always powerful\n• Use trump cards wisely\n• Identifying the Friend is crucial';

  @override
  String get close => 'Close';

  @override
  String get hint => 'Hint';

  @override
  String get enableHintQuestion => 'Do you want to enable hints?';

  @override
  String get newGameConfirm => 'Do you want to start a new game?';

  @override
  String get dealMiss => 'Deal Miss';

  @override
  String get dealMissTitle => 'Declare Deal Miss';

  @override
  String get dealMissConfirm =>
      'Declare deal miss?\nYour hand will be revealed and a new game will start.';

  @override
  String dealMissAnnouncement(String name) {
    return '$name declared Deal Miss!';
  }

  @override
  String get dealMissNewGame => 'Restarting game due to deal miss.';

  @override
  String get aiPlayer1 => 'Alex';

  @override
  String get aiPlayer2 => 'Emma';

  @override
  String get aiPlayer3 => 'James';

  @override
  String get aiPlayer4 => 'Sophia';

  @override
  String get scoreCalcWin => 'Score Calculation (Win)';

  @override
  String get scoreCalcLose => 'Score Calculation (Lose)';

  @override
  String get scoreFormula => '(Points-Contract+1) + (Points-Min)×2';

  @override
  String get scoreFormulaLose => '-(Contract - Points)';

  @override
  String get scoreMultipliers => 'Declarer ×2, Friend ×1, Defense ×(-1)';

  @override
  String get multiplierRun => 'Run ×2';

  @override
  String get multiplierNoGiruda => 'No Trump ×2';

  @override
  String get multiplierNoFriend => 'No Friend ×2';

  @override
  String get multiplierBackRun => 'Back Run ×2';

  @override
  String get multiplierLabel => 'Multiplier';

  @override
  String get selectGame => 'Select Game';

  @override
  String get sevenCardTitle => 'Seven Poker';

  @override
  String get sevenCardSubtitle => '7-Card Poker Game';

  @override
  String get sevenCardRules => 'Game Rules';

  @override
  String get sevenCardRulesText =>
      '• Each player receives 7 cards\n• First 3 cards are hidden, remaining 4 are shown\n• Betting rounds determine the winner with best 5 cards\n• Player with the highest hand wins';

  @override
  String get pot => 'Pot';

  @override
  String get currentBet => 'Current Bet';

  @override
  String get betting => 'Round';

  @override
  String get chips => 'Chips';

  @override
  String get bet => 'Bet';

  @override
  String get fold => 'Die';

  @override
  String get call => 'Call';

  @override
  String get raise => 'Raise';

  @override
  String get check => 'Check';

  @override
  String get allIn => 'All In';

  @override
  String get folded => 'Die';

  @override
  String get wins => 'Wins';

  @override
  String get betPing => 'Ante';

  @override
  String get betDdadang => 'Raise';

  @override
  String get betQuarter => 'Quarter';

  @override
  String get betHalf => 'Half';

  @override
  String get betFull => 'Full';

  @override
  String get betDie => 'Fold';

  @override
  String get selectCardToReveal => 'Select a card to reveal';

  @override
  String get selectedCardWillBeRevealed =>
      'The selected card will be revealed to opponents';

  @override
  String get totalBet => 'Total';

  @override
  String get bonus => 'Bonus';

  @override
  String get finalResult => 'Final Result';

  @override
  String get viewResultButton => 'View Result';

  @override
  String get hintOff => 'Hint OFF';

  @override
  String get playerLabel => 'Player';

  @override
  String get thisGame => 'This Game';

  @override
  String get cumulative => 'Total';

  @override
  String get bettingAmount => 'Betting';

  @override
  String get otherPlayersBonus => 'Other players';

  @override
  String get gameEnd => 'Game End';

  @override
  String get hiLoTitle => 'Hi-Lo';

  @override
  String get hiLoSubtitle => 'Hi/Lo Split Poker';

  @override
  String get hi => 'Hi';

  @override
  String get lo => 'Lo';

  @override
  String get swing => 'Swing';

  @override
  String get selectHiLo => 'Select Hi/Lo';

  @override
  String get selectHiLoDesc => 'Choose Hi, Lo, or Swing';

  @override
  String get hiWinner => 'Hi Winner';

  @override
  String get loWinner => 'Lo Winner';

  @override
  String get swingSuccess => 'Swing Success!';

  @override
  String get swingFailed => 'Swing Failed';

  @override
  String get hiPot => 'Hi Pot';

  @override
  String get loPot => 'Lo Pot';

  @override
  String get noLowHand => 'No Low';

  @override
  String get bestLow => 'Best Low';

  @override
  String get waitingForHiLo => 'Waiting for selection...';

  @override
  String get selectedHi => 'Selected Hi';

  @override
  String get selectedLo => 'Selected Lo';

  @override
  String get selectedSwing => 'Selected Swing';

  @override
  String get showdownTitle => 'Declaration Status';

  @override
  String get showdownDesc => 'Check each player\'s choice';

  @override
  String get viewResults => 'View Results';

  @override
  String get finalResults => 'Final Results';

  @override
  String get sevenCardGuideOverview => 'Game Overview';

  @override
  String get sevenCardGuideOverviewText =>
      'Seven Card Poker is a poker game for 5 players. Create the best hand using 5 of your 7 cards to win.';

  @override
  String get sevenCardGuideDealing => 'Card Dealing';

  @override
  String get sevenCardGuideDealingText =>
      '• Initially receive 4 cards (3 hidden, 1 open)\n• Receive one open card after each betting round\n• Make a hand with 5 of your final 7 cards';

  @override
  String get sevenCardGuideBetting => 'Betting Rules';

  @override
  String get sevenCardGuideBettingText =>
      '• Check: Pass without betting\n• Call: Match current bet\n• Raise: Increase bet amount\n• Fold: Give up the hand\n• All In: Bet all chips';

  @override
  String get sevenCardGuideHands => 'Hand Rankings';

  @override
  String get sevenCardGuideHandsText =>
      '1. Royal Straight Flush\n2. Back Straight Flush\n3. Straight Flush\n4. Four of a Kind\n5. Full House\n6. Flush\n7. Mountain (A-K-Q-J-10)\n8. Back Straight (A-2-3-4-5)\n9. Straight\n10. Three of a Kind\n11. Two Pair\n12. One Pair\n13. High Card';

  @override
  String get sevenCardGuideTips => 'Game Tips';

  @override
  String get sevenCardGuideTipsText =>
      '• Predict opponent hands from open cards\n• Avoid excessive betting without strong hands\n• Bluffing is also a strategy';

  @override
  String get sevenCardGuideBonus => 'Bonus Hands';

  @override
  String get sevenCardGuideBonusText =>
      '• Royal Straight Flush: 500 chips\n• Back Straight Flush: 300 chips\n• Straight Flush: 200 chips\n• Four of a Kind: 100 chips\n\nBonus hands earn bonus from all other players!';

  @override
  String get hiLoGuideOverview => 'Game Overview';

  @override
  String get hiLoGuideOverviewText =>
      'Hi-Lo is a variation of Seven Card Poker where the pot is split between the highest and lowest hand.';

  @override
  String get hiLoGuideDealing => 'Card Dealing';

  @override
  String get hiLoGuideDealingText =>
      '• Same dealing as Seven Card Poker\n• Make a hand with 5 of your 7 cards\n• Choose Hi/Lo/Swing after final betting';

  @override
  String get hiLoGuideHiLo => 'Hi/Lo Selection';

  @override
  String get hiLoGuideHiLoText =>
      '• Hi: Compete with highest hand\n• Lo: Compete with lowest hand\n• Swing: Challenge both Hi and Lo\n\n50% of pot goes to Hi winner, 50% to Lo winner.';

  @override
  String get hiLoGuideLow => 'Low Hand Rules';

  @override
  String get hiLoGuideLowText =>
      '• Only hands without straights/flushes qualify\n• Lower is better (A is lowest)\n• Best low: A-2-3-4-6\n• No pair hands are advantageous';

  @override
  String get hiLoGuideSwing => 'Swing Rules';

  @override
  String get hiLoGuideSwingText =>
      '• Split 7 cards into two 5-card hands\n• Must win both Hi and Lo to succeed\n• Success: Win entire pot\n• Failure: That portion goes to other winner';

  @override
  String get hiLoGuideTips => 'Game Tips';

  @override
  String get hiLoGuideTipsText =>
      '• Low cards like A-2-3-4 favor Lo\n• Swing is risky but rewarding if successful\n• Observe opponent cards for strategy';

  @override
  String get hiLoGuideBonus => 'Bonus Hands';

  @override
  String get hiLoGuideBonusText =>
      '• Royal Straight Flush: 500 chips\n• Back Straight Flush: 300 chips\n• Straight Flush: 200 chips\n• Four of a Kind: 100 chips\n\nBonus hands automatically win the entire pot!';

  @override
  String get hulaTitle => 'Hula';

  @override
  String get hulaSubtitle => '4-Player Rummy Card Game';

  @override
  String get heartsTitle => 'Hearts';

  @override
  String get heartsSubtitle => '4-Player Trick-Taking Game';

  @override
  String get register => 'Meld';

  @override
  String get discardCard => 'Discard';

  @override
  String get stopGame => 'Stop';

  @override
  String get drawCard => 'Draw a card';

  @override
  String get discardOrRegister => 'Discard or meld a card';

  @override
  String get noCards => 'No cards';

  @override
  String get addedToMeld => 'Added to meld';

  @override
  String get noMeldToAttach => 'No meld to attach to';

  @override
  String get invalidCombination => 'Invalid combination';

  @override
  String get drawFirst => 'Draw a card first';

  @override
  String get selectCardToDiscard => 'Select a card to discard';

  @override
  String get victory => 'Victory!';

  @override
  String get defeat => 'Defeat';

  @override
  String get hulaVictory => 'Hula victory! (x2)';

  @override
  String get handCards => 'Hand';

  @override
  String get myTurn => 'My Turn';

  @override
  String get start => 'Start';

  @override
  String get discardedCards => 'Discarded';

  @override
  String get emptyDiscardPile => 'No\nDiscards';

  @override
  String get thankYou => 'Thank You';

  @override
  String get selectMethod => 'Select method';

  @override
  String get register7Alone => 'Register 7 alone';

  @override
  String attachToMyMeld(Object card) {
    return '$card attach to my meld';
  }

  @override
  String get attachToOtherMeld => 'Attach to meld';

  @override
  String get gameRules => 'Game Rules';

  @override
  String get objective => 'Objective';

  @override
  String get objectiveDesc =>
      'Be the first to discard all cards by melding or discarding them.';

  @override
  String get howToPlay => 'How to Play';

  @override
  String get howToPlayDesc =>
      'Each turn, draw a card from the deck or discard pile, then meld or discard.';

  @override
  String get meldTypes => 'Meld Types';

  @override
  String get thankYouMeld => 'Thank You Meld';

  @override
  String get thankYouMeldDesc =>
      'When you draw a 7 from the discard pile, you can call \"Thank You\" and make a special meld.';

  @override
  String get stopRule => 'Stop';

  @override
  String get stopRuleDesc =>
      'Call Stop anytime to end the game. Player with lowest card points wins.';

  @override
  String get scoring => 'Scoring';

  @override
  String aiStartsFirst(Object name) {
    return '$name starts first';
  }

  @override
  String xWins(Object name) {
    return '$name Wins!';
  }

  @override
  String nMelds(Object count) {
    return '$count melds';
  }

  @override
  String attachedToMeldSelf(Object card) {
    return '$card added to meld';
  }

  @override
  String attachedToMeldPlayer(Object card) {
    return '$card added to player\'s meld';
  }

  @override
  String attachedToMeldOther(Object card, Object name) {
    return '$card added to $name\'s meld';
  }

  @override
  String drewCard(Object name) {
    return '$name drew a card';
  }

  @override
  String thankYouAttachSelf(Object card) {
    return 'Thank You! $card to my meld';
  }

  @override
  String thankYouAttachOther(Object card, Object name) {
    return 'Thank You! $card to $name\'s meld';
  }

  @override
  String nPlayersHula(Object n) {
    return 'Hula (${n}P)';
  }

  @override
  String nCards(Object n) {
    return '$n cards';
  }

  @override
  String get soloSevenRegistered => '7 solo registered';

  @override
  String get sevenGroupRegistered => '7 group registered';

  @override
  String get runRegistered => 'Run registered';

  @override
  String get groupRegistered => 'Group registered';

  @override
  String meldRegisteredWithCards(Object cards, Object type) {
    return '$type registered $cards';
  }

  @override
  String drewCardWithCard(Object card) {
    return 'Drew $card';
  }

  @override
  String playerStopped(Object name) {
    return '$name stopped!';
  }

  @override
  String discardCardMsg(Object card) {
    return '$card discarded';
  }

  @override
  String thankYouDrawn(Object card, Object name) {
    return '$name Thank You! $card';
  }

  @override
  String get bonusHand => 'Bonus Hand!';

  @override
  String get inPossession => '(Owned)';

  @override
  String get fourPlayerGame => '4 Players';

  @override
  String get heartsBreaking => 'Hearts Breaking';

  @override
  String startsWithClub2(Object name) {
    return '$name starts with Club 2';
  }

  @override
  String get cardPass => 'Card Pass';

  @override
  String trickNum(Object n) {
    return 'Trick $n/13';
  }

  @override
  String passToLeft(Object n) {
    return 'Pass to Left ($n/3)';
  }

  @override
  String get selectCardsToPass => 'Select 3 cards to pass to the left';

  @override
  String get allPointsExhausted => 'All point cards exhausted! Game over';

  @override
  String winsTrick(Object name, Object points) {
    return '$name wins trick! (+${points}pts)';
  }

  @override
  String shootTheMoonSuccess(Object name) {
    return '$name shot the moon!';
  }

  @override
  String playerScore(Object name, Object score) {
    return '$name (${score}pts)';
  }

  @override
  String nPoints(Object n) {
    return '${n}pts';
  }

  @override
  String get passRecommend => 'Pass Recommend';

  @override
  String get recommend => 'Recommend';

  @override
  String get hintEnabled => 'Hint enabled!';

  @override
  String get oneCard => 'One Card';

  @override
  String oneCardTitle(Object n) {
    return 'One Card (${n}P)';
  }

  @override
  String get oneCardCall => 'One Card!';

  @override
  String oneCardCountdown(Object n) {
    return 'One Card (${n}s)';
  }

  @override
  String get cannotPlayCard => 'Cannot play this card';

  @override
  String attackReceived(Object n) {
    return 'Received $n cards from attack';
  }

  @override
  String get drewCardMsg => 'Drew a card';

  @override
  String bankruptcy(Object n) {
    return 'Bankrupt! ($n cards)';
  }

  @override
  String get selectSuit => 'Select a suit';

  @override
  String get clockwise => 'Clockwise';

  @override
  String get counterClockwise => 'Counter-clockwise';

  @override
  String get blackJoker => 'Black Joker';

  @override
  String get colorJoker => 'Color Joker';

  @override
  String get winRate => 'Win Rate';

  @override
  String get rulesObjective => 'Objective';

  @override
  String get rulesHowToPlay => 'How to Play';

  @override
  String get rulesScoring => 'Scoring';

  @override
  String get rulesTips => 'Tips';

  @override
  String get rulesAttackCards => 'Attack Cards';

  @override
  String get rulesDefense => 'Defense';

  @override
  String get rulesSpecialCards => 'Special Cards';

  @override
  String get restart => 'Restart';

  @override
  String totalAttack(int n) {
    return '$n cards attack';
  }

  @override
  String get skipNextTurn => 'Skip next turn';

  @override
  String get reverseDirection => 'Reverse direction';

  @override
  String get skipTwoTurns => 'Skip 2 turns';

  @override
  String get changeSuit => 'Change suit';

  @override
  String playerPlayedCard(String name) {
    return '$name played a card';
  }

  @override
  String attackReceivedShort(int n) {
    return 'Received $n cards';
  }

  @override
  String get drewCardShort => 'Drew card';

  @override
  String bankruptcyShort(int n) {
    return 'Bankrupt! ($n cards)';
  }

  @override
  String get heartsGuideObjectiveTitle => 'Objective';

  @override
  String get heartsGuideObjective =>
      'Avoid collecting Hearts and the Queen of Spades to get the lowest score.';

  @override
  String get heartsGuideHowToPlayTitle => 'How to Play';

  @override
  String get heartsGuideHowToPlay =>
      '• 4 players, 13 cards each\n• Pass 3 cards to the left at start\n• Player with 2 of Clubs leads first\n• Play 13 tricks avoiding point cards';

  @override
  String get heartsGuideScoringTitle => 'Scoring';

  @override
  String get heartsGuideScoring =>
      '• Hearts: 1 point each (13 total)\n• Queen of Spades (♠Q): 13 points\n• Total: 26 points\n• Lowest score wins!';

  @override
  String get heartsGuideBreakingTitle => 'Breaking Hearts';

  @override
  String get heartsGuideBreaking =>
      'Hearts cannot be played on the first trick.\nHearts can only lead after being played.';

  @override
  String get heartsGuideShootMoonTitle => 'Shoot the Moon';

  @override
  String get heartsGuideShootMoon =>
      'If one player takes all Hearts and the Queen of Spades:\n• That player: 0 points\n• Others: 26 points each';

  @override
  String get heartsGuideTipsTitle => 'Strategy Tips';

  @override
  String get heartsGuideTips =>
      '• Discard high cards early\n• Watch out for the Queen of Spades\n• Force opponents to take point cards';

  @override
  String get onecardGuideObjectiveTitle => 'Objective';

  @override
  String get onecardGuideObjective => 'Be the first to play all your cards.';

  @override
  String get onecardGuidePlayCardTitle => 'Playing Cards';

  @override
  String get onecardGuidePlayCard =>
      'Play a card matching the previous card\'s suit or rank.';

  @override
  String get onecardGuideAttackTitle => 'Attack Cards';

  @override
  String get onecardGuideAttack =>
      '• 2: +2 cards attack\n• A: +3 cards attack (♠A is +5)\n• Joker: +5 (B&W) / +7 (Color)';

  @override
  String get onecardGuideSpecialTitle => 'Special Cards';

  @override
  String get onecardGuideSpecial =>
      '• J: Skip next player\n• Q: Reverse direction\n• K: Skip 2 turns\n• 7: Change suit';

  @override
  String get onecardGuideJokerDefenseTitle => 'Joker Defense';

  @override
  String get onecardGuideJokerDefense =>
      'Joker attacks can only be blocked with another Joker.';

  @override
  String get onecardGuideOneCardTitle => 'One Card!';

  @override
  String get onecardGuideOneCard =>
      'Press \"One Card!\" when you have 1 card left.\nFailing to do so results in a 2-card penalty.';

  @override
  String get onecardGuideBankruptTitle => 'Bankruptcy';

  @override
  String get onecardGuideBankrupt =>
      'Having 20+ cards means bankruptcy! Player with fewest cards wins.';

  @override
  String get hulaGuideObjectiveTitle => 'Objective';

  @override
  String get hulaGuideObjective =>
      'Be the first to meld or discard all your cards.';

  @override
  String get hulaGuideHowToPlayTitle => 'How to Play';

  @override
  String get hulaGuideHowToPlay =>
      'Each turn, draw a card from deck or discard pile, then meld or discard.';

  @override
  String get hulaGuideMeldTypesTitle => 'Meld Types';

  @override
  String get hulaGuideMeldTypes =>
      '• Run: 3+ cards of same suit in sequence (e.g., ♠3-4-5)\n• Group: 3+ cards of same rank, different suits (e.g., ♠7-♥7-♦7)';

  @override
  String get hulaGuideSevenRuleTitle => 'Seven Rule';

  @override
  String get hulaGuideSevenRule => '7s can be melded alone.';

  @override
  String get hulaGuideThankYouTitle => 'Thank You';

  @override
  String get hulaGuideThankYou =>
      'Drawing a 7 from discard pile lets you say \"Thank You\" and make a special meld.';

  @override
  String get hulaGuideStopTitle => 'Stop';

  @override
  String get hulaGuideStop =>
      'Call Stop anytime to end the game.\nPlayer with lowest remaining card points wins.';

  @override
  String get hulaGuideCardPointsTitle => 'Card Points';

  @override
  String get hulaGuideCardPoints =>
      'A=1pt, 2~9=face value, J=10pt, Q=11pt, K=12pt';

  @override
  String get hulaGuideScoringTitle => 'Scoring';

  @override
  String get hulaGuideScoring =>
      '• Winner: Gets sum of differences from other hands\n• Losers: Lose points equal to difference from winner\n• Hula (win without melding): Double points';

  @override
  String get hulaGuideStopPenaltyTitle => 'Stop Failure Penalty';

  @override
  String get hulaGuideStopPenalty =>
      'If you call Stop but don\'t have the lowest:\n• You pay all points the winner would get\n• Other players don\'t lose points';

  @override
  String thankYouRegisterAlone(String card) {
    return 'Thank You! $card registered alone';
  }

  @override
  String thankYouAttachToMyMeld(String card) {
    return 'Thank You! $card attached to my meld';
  }

  @override
  String thankYouAttachToOtherMeld(String card, String playerName) {
    return 'Thank You! $card attached to $playerName\'s meld';
  }

  @override
  String thankYouNewMeld(String description) {
    return 'Thank You! $description';
  }

  @override
  String get onecardGuideInGameObjective =>
      'First player to play all cards wins.\nYou must call \"One Card\" before playing your last card.';

  @override
  String get onecardGuideHowToPlayInGame =>
      'Play a card matching the suit or rank.\nIf you can\'t play, draw from the deck.';

  @override
  String get onecardGuideDefenseTitle => 'Defense';

  @override
  String get onecardGuideDefense =>
      'Block attacks with matching attack cards.\nBlocked attacks stack to the next player.';

  @override
  String get onecardGuideTipsTitle => 'Game Tips';

  @override
  String get onecardGuideTips =>
      '• Save attack cards for defense\n• 2-card penalty for not calling One Card!\n• 20+ cards = bankruptcy loss';

  @override
  String get handRoyalStraightFlush => 'Royal Straight Flush';

  @override
  String get handBackStraightFlush => 'Back Straight Flush';

  @override
  String get handStraightFlush => 'Straight Flush';

  @override
  String get handFourOfAKind => 'Four of a Kind';

  @override
  String get handFullHouse => 'Full House';

  @override
  String get handFlush => 'Flush';

  @override
  String get handMountain => 'Mountain';

  @override
  String get handBackStraight => 'Back Straight';

  @override
  String get handStraight => 'Straight';

  @override
  String get handTriple => 'Triple';

  @override
  String get handTwoPair => 'Two Pair';

  @override
  String get handOnePair => 'One Pair';

  @override
  String get handHighCard => 'High Card';

  @override
  String highCardTop(String rank) {
    return '$rank High';
  }

  @override
  String get noLow => 'No Low';

  @override
  String nthCard(int n) {
    return 'Card #$n';
  }

  @override
  String get betCheck => 'Check';

  @override
  String get betCall => 'Call';

  @override
  String get cannotPlayFirstTrickDeclarerGiruda =>
      'Declarer cannot lead with trump on the first trick';

  @override
  String get cannotPlayFirstTrickJoker =>
      'Cannot play Joker on the first trick';

  @override
  String get cannotPlayLastTrickJoker => 'Cannot play Joker on the last trick';

  @override
  String get mustPlayJokerCall => 'Joker Call! You must play the Joker';

  @override
  String mustFollowSuit(String suit) {
    return 'You must follow $suit';
  }

  @override
  String get fullDeclarationWarning =>
      'Declaring Full raises the contract to 20';

  @override
  String get trickDetails => 'Trick Details';

  @override
  String get trickColumnGainLoss => 'Gain/\nLoss';

  @override
  String get trickColumnGiruda => 'Trump';

  @override
  String get trickColumnEvent => 'Event';

  @override
  String get trickLegendLead => 'Lead';

  @override
  String get trickLegendWinner => 'Winner';

  @override
  String get trickEventLastCard => 'Last card';

  @override
  String get trickEventJokerLead => 'Joker lead';

  @override
  String trickEventJokerLeadSuit(String suit) {
    return 'Joker lead ($suit)';
  }

  @override
  String get trickEventJokerGirudaExhaust => 'Forcing defenders to spend trump';

  @override
  String get trickEventMightyLead => 'Mighty lead';

  @override
  String get trickEventTopGirudaLead => 'Top trump lead';

  @override
  String get trickEventMidGirudaMightyBait => 'Mid trump to bait Mighty';

  @override
  String get trickEventMidGirudaPassLead => 'Mid trump to pass lead';

  @override
  String get trickEventDefenderGirudaWin => 'Defender trump win';

  @override
  String get trickEventMidGirudaLead => 'Mid trump lead';

  @override
  String get trickEventTopNonGirudaLead => 'Top non-trump lead';

  @override
  String get trickEventFirstTrickFriendBait =>
      'No lead in 1st trick / Friend bait';

  @override
  String get trickEventFirstTrickWaste => 'No lead in 1st trick / Waste';

  @override
  String get trickEventWaste => 'Waste play';

  @override
  String get trickEventAttackGirudaCut => 'Attack trump cut';

  @override
  String get trickEventDefenseGirudaCut => 'Defense trump cut';

  @override
  String get trickEventNonGirudaExhaust => 'Non-trump exhausted';

  @override
  String get demoMode => 'Demo Mode';

  @override
  String get stopDemo => 'Stop Demo';

  @override
  String get pauseDemo => 'Pause';

  @override
  String get resumeDemo => 'Resume';

  @override
  String get nextGame => 'Next Game';

  @override
  String get optimal => 'Optimal';

  @override
  String get currentBid => 'Current Bid';

  @override
  String get kittyExchange => 'Kitty Exchange';

  @override
  String get kittyReceived => 'Cards from Kitty';

  @override
  String get kittyDiscard => 'Discard Cards';

  @override
  String get discardCutSuit => 'Suit cleanup → cut possible';

  @override
  String get discardNonGirudaLow => 'Non-trump low card';

  @override
  String get discardLowValue => 'Low value card';

  @override
  String get discardLeastUseful => 'Least useful card';

  @override
  String get finalHand => 'Final Hand';

  @override
  String get girudaChange => 'Trump Change';

  @override
  String get friendDeclaration => 'Friend Declaration';

  @override
  String get fullDeclaration => 'Full (20) Declaration';

  @override
  String get reasonNoFriend => 'Strong hand, can win alone';

  @override
  String get reasonFirstTrick => 'First trick winner as friend';

  @override
  String get reasonNeedAce => 'Need non-trump Ace';

  @override
  String get firstTrickStrategy => 'First Trick Strategy';

  @override
  String get aceLead => 'Ace lead';

  @override
  String get kingLead => 'King lead';

  @override
  String get firstTrickGiveUp => 'No strong first trick card';

  @override
  String get bidSummary => 'Bid Summary';

  @override
  String get targetTricks => 'Target Points';

  @override
  String get cardFriend => 'Card Friend';

  @override
  String get firstTrickWinnerFriend => 'First Trick Friend';

  @override
  String get allPassed => 'All Passed';

  @override
  String get watchAiGame => 'Watch AI Game';
}
