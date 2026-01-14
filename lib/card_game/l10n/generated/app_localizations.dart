import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ko, this message translates to:
  /// **'마이티'**
  String get appTitle;

  /// No description provided for @gameSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'한국의 전통 트릭테이킹 카드 게임'**
  String get gameSubtitle;

  /// No description provided for @startGame.
  ///
  /// In ko, this message translates to:
  /// **'게임 시작하기'**
  String get startGame;

  /// No description provided for @newGame.
  ///
  /// In ko, this message translates to:
  /// **'새 게임'**
  String get newGame;

  /// No description provided for @biddingPhase.
  ///
  /// In ko, this message translates to:
  /// **'배팅 단계'**
  String get biddingPhase;

  /// No description provided for @currentBidder.
  ///
  /// In ko, this message translates to:
  /// **'현재 배팅: {name}'**
  String currentBidder(String name);

  /// No description provided for @noBidYet.
  ///
  /// In ko, this message translates to:
  /// **'아직 배팅 없음'**
  String get noBidYet;

  /// No description provided for @highestBid.
  ///
  /// In ko, this message translates to:
  /// **'최고 배팅: {bid}'**
  String highestBid(String bid);

  /// No description provided for @bid.
  ///
  /// In ko, this message translates to:
  /// **'배팅'**
  String get bid;

  /// No description provided for @bidButton.
  ///
  /// In ko, this message translates to:
  /// **'배팅하기'**
  String get bidButton;

  /// No description provided for @pass.
  ///
  /// In ko, this message translates to:
  /// **'패스'**
  String get pass;

  /// No description provided for @tricks.
  ///
  /// In ko, this message translates to:
  /// **'목표 점수'**
  String get tricks;

  /// No description provided for @giruda.
  ///
  /// In ko, this message translates to:
  /// **'기루다'**
  String get giruda;

  /// No description provided for @noGiruda.
  ///
  /// In ko, this message translates to:
  /// **'노기루다'**
  String get noGiruda;

  /// No description provided for @spade.
  ///
  /// In ko, this message translates to:
  /// **'스페이드'**
  String get spade;

  /// No description provided for @diamond.
  ///
  /// In ko, this message translates to:
  /// **'다이아몬드'**
  String get diamond;

  /// No description provided for @heart.
  ///
  /// In ko, this message translates to:
  /// **'하트'**
  String get heart;

  /// No description provided for @club.
  ///
  /// In ko, this message translates to:
  /// **'클럽'**
  String get club;

  /// No description provided for @spadeName.
  ///
  /// In ko, this message translates to:
  /// **'스페이드'**
  String get spadeName;

  /// No description provided for @diamondName.
  ///
  /// In ko, this message translates to:
  /// **'다이아'**
  String get diamondName;

  /// No description provided for @heartName.
  ///
  /// In ko, this message translates to:
  /// **'하트'**
  String get heartName;

  /// No description provided for @clubName.
  ///
  /// In ko, this message translates to:
  /// **'클로버'**
  String get clubName;

  /// No description provided for @selectKitty.
  ///
  /// In ko, this message translates to:
  /// **'키티 선택'**
  String get selectKitty;

  /// No description provided for @selectKittyDesc.
  ///
  /// In ko, this message translates to:
  /// **'버릴 카드 3장을 선택하세요 (선택됨: {count}/3)'**
  String selectKittyDesc(int count);

  /// No description provided for @receivedKitty.
  ///
  /// In ko, this message translates to:
  /// **'받은 키티:'**
  String get receivedKitty;

  /// No description provided for @myCards.
  ///
  /// In ko, this message translates to:
  /// **'내 카드:'**
  String get myCards;

  /// No description provided for @changeGiruda.
  ///
  /// In ko, this message translates to:
  /// **'기루다 변경 (선택사항):'**
  String get changeGiruda;

  /// No description provided for @confirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get confirm;

  /// No description provided for @declareFriend.
  ///
  /// In ko, this message translates to:
  /// **'프렌드 선언'**
  String get declareFriend;

  /// No description provided for @friendDeclarationType.
  ///
  /// In ko, this message translates to:
  /// **'프렌드 선언 방식:'**
  String get friendDeclarationType;

  /// No description provided for @byCard.
  ///
  /// In ko, this message translates to:
  /// **'카드로 지정'**
  String get byCard;

  /// No description provided for @firstTrickFriend.
  ///
  /// In ko, this message translates to:
  /// **'초구 프렌드'**
  String get firstTrickFriend;

  /// No description provided for @firstTrickFriendDesc.
  ///
  /// In ko, this message translates to:
  /// **'첫 트릭을 따는 사람'**
  String get firstTrickFriendDesc;

  /// No description provided for @nthTrickFriend.
  ///
  /// In ko, this message translates to:
  /// **'N번째 트릭 프렌드'**
  String get nthTrickFriend;

  /// No description provided for @noFriend.
  ///
  /// In ko, this message translates to:
  /// **'노프렌드'**
  String get noFriend;

  /// No description provided for @noFriendDesc.
  ///
  /// In ko, this message translates to:
  /// **'혼자 플레이'**
  String get noFriendDesc;

  /// No description provided for @declare.
  ///
  /// In ko, this message translates to:
  /// **'선언'**
  String get declare;

  /// No description provided for @suit.
  ///
  /// In ko, this message translates to:
  /// **'무늬:'**
  String get suit;

  /// No description provided for @rank.
  ///
  /// In ko, this message translates to:
  /// **'숫자:'**
  String get rank;

  /// No description provided for @selectedCard.
  ///
  /// In ko, this message translates to:
  /// **'선택한 카드: {card}'**
  String selectedCard(String card);

  /// No description provided for @trickNumber.
  ///
  /// In ko, this message translates to:
  /// **'트릭 번호:'**
  String get trickNumber;

  /// No description provided for @playCard.
  ///
  /// In ko, this message translates to:
  /// **'카드를 내세요'**
  String get playCard;

  /// No description provided for @yourTurn.
  ///
  /// In ko, this message translates to:
  /// **'당신의 차례입니다'**
  String get yourTurn;

  /// No description provided for @playerTurn.
  ///
  /// In ko, this message translates to:
  /// **'{name}의 차례'**
  String playerTurn(String name);

  /// No description provided for @contract.
  ///
  /// In ko, this message translates to:
  /// **'계약'**
  String get contract;

  /// No description provided for @trick.
  ///
  /// In ko, this message translates to:
  /// **'트릭'**
  String get trick;

  /// No description provided for @friend.
  ///
  /// In ko, this message translates to:
  /// **'프렌드'**
  String get friend;

  /// No description provided for @declarer.
  ///
  /// In ko, this message translates to:
  /// **'주공'**
  String get declarer;

  /// No description provided for @cards.
  ///
  /// In ko, this message translates to:
  /// **'카드: {count}'**
  String cards(int count);

  /// No description provided for @aiSelectingKitty.
  ///
  /// In ko, this message translates to:
  /// **'AI가 키티를 선택하고 있습니다...'**
  String get aiSelectingKitty;

  /// No description provided for @aiDeclaringFriend.
  ///
  /// In ko, this message translates to:
  /// **'AI가 프렌드를 선언하고 있습니다...'**
  String get aiDeclaringFriend;

  /// No description provided for @declarerTeamWins.
  ///
  /// In ko, this message translates to:
  /// **'주공 팀 승리!'**
  String get declarerTeamWins;

  /// No description provided for @defenderTeamWins.
  ///
  /// In ko, this message translates to:
  /// **'수비 팀 승리!'**
  String get defenderTeamWins;

  /// No description provided for @declarerTeam.
  ///
  /// In ko, this message translates to:
  /// **'주공 팀'**
  String get declarerTeam;

  /// No description provided for @defenderTeam.
  ///
  /// In ko, this message translates to:
  /// **'수비 팀'**
  String get defenderTeam;

  /// No description provided for @fullPoints.
  ///
  /// In ko, this message translates to:
  /// **'풀'**
  String get fullPoints;

  /// No description provided for @declarerTeamPoints.
  ///
  /// In ko, this message translates to:
  /// **'주공 팀: {points}점'**
  String declarerTeamPoints(int points);

  /// No description provided for @defenderTeamPoints.
  ///
  /// In ko, this message translates to:
  /// **'수비 팀: {points}점'**
  String defenderTeamPoints(int points);

  /// No description provided for @targetPoints.
  ///
  /// In ko, this message translates to:
  /// **'목표: {points}점'**
  String targetPoints(int points);

  /// No description provided for @score.
  ///
  /// In ko, this message translates to:
  /// **'점수'**
  String get score;

  /// No description provided for @points.
  ///
  /// In ko, this message translates to:
  /// **'{points}점'**
  String points(int points);

  /// No description provided for @player.
  ///
  /// In ko, this message translates to:
  /// **'플레이어'**
  String get player;

  /// No description provided for @you.
  ///
  /// In ko, this message translates to:
  /// **'당신'**
  String get you;

  /// No description provided for @bidding.
  ///
  /// In ko, this message translates to:
  /// **'배팅 중...'**
  String get bidding;

  /// No description provided for @waiting.
  ///
  /// In ko, this message translates to:
  /// **'대기'**
  String get waiting;

  /// No description provided for @otherPlayerTurn.
  ///
  /// In ko, this message translates to:
  /// **'다른 플레이어 차례입니다'**
  String get otherPlayerTurn;

  /// No description provided for @yourCards.
  ///
  /// In ko, this message translates to:
  /// **'당신의 카드'**
  String get yourCards;

  /// No description provided for @biddingTurn.
  ///
  /// In ko, this message translates to:
  /// **'배팅 차례'**
  String get biddingTurn;

  /// No description provided for @bidWithAmount.
  ///
  /// In ko, this message translates to:
  /// **'배팅 {amount}'**
  String bidWithAmount(int amount);

  /// No description provided for @trickComplete.
  ///
  /// In ko, this message translates to:
  /// **'트릭 {number} 완료'**
  String trickComplete(int number);

  /// No description provided for @winnerAnnouncement.
  ///
  /// In ko, this message translates to:
  /// **'{name} 승리! ({team})'**
  String winnerAnnouncement(String name, String team);

  /// No description provided for @attackTeam.
  ///
  /// In ko, this message translates to:
  /// **'공격팀'**
  String get attackTeam;

  /// No description provided for @defenseTeam.
  ///
  /// In ko, this message translates to:
  /// **'방어팀'**
  String get defenseTeam;

  /// No description provided for @nextTrick.
  ///
  /// In ko, this message translates to:
  /// **'다음 트릭'**
  String get nextTrick;

  /// No description provided for @friendNone.
  ///
  /// In ko, this message translates to:
  /// **'없음'**
  String get friendNone;

  /// No description provided for @firstTrick.
  ///
  /// In ko, this message translates to:
  /// **'첫트릭'**
  String get firstTrick;

  /// No description provided for @selectCardHint.
  ///
  /// In ko, this message translates to:
  /// **'카드를 선택하세요 ↓'**
  String get selectCardHint;

  /// No description provided for @previousTrick.
  ///
  /// In ko, this message translates to:
  /// **'이전 트릭'**
  String get previousTrick;

  /// No description provided for @winShort.
  ///
  /// In ko, this message translates to:
  /// **'승'**
  String get winShort;

  /// No description provided for @leadPlayer.
  ///
  /// In ko, this message translates to:
  /// **'선공'**
  String get leadPlayer;

  /// No description provided for @leadPlayerHint.
  ///
  /// In ko, this message translates to:
  /// **'👆 선공입니다!'**
  String get leadPlayerHint;

  /// No description provided for @selectCardBelow.
  ///
  /// In ko, this message translates to:
  /// **'아래에서 카드를 선택하세요'**
  String get selectCardBelow;

  /// No description provided for @leadPlayerSelectCard.
  ///
  /// In ko, this message translates to:
  /// **'👆 선공입니다! 카드를 선택하세요'**
  String get leadPlayerSelectCard;

  /// No description provided for @jokerCallAnnouncement.
  ///
  /// In ko, this message translates to:
  /// **'조커 콜! {suit}'**
  String jokerCallAnnouncement(String suit);

  /// No description provided for @wonCards.
  ///
  /// In ko, this message translates to:
  /// **'획득:'**
  String get wonCards;

  /// No description provided for @jokerCallTitle.
  ///
  /// In ko, this message translates to:
  /// **'조커 콜'**
  String get jokerCallTitle;

  /// No description provided for @jokerCallQuestion.
  ///
  /// In ko, this message translates to:
  /// **'{suit} 조커 콜을 선언하시겠습니까?'**
  String jokerCallQuestion(String suit);

  /// No description provided for @no.
  ///
  /// In ko, this message translates to:
  /// **'아니오'**
  String get no;

  /// No description provided for @jokerCallButton.
  ///
  /// In ko, this message translates to:
  /// **'{suit} 조커 콜!'**
  String jokerCallButton(String suit);

  /// No description provided for @jokerLeadSuitTitle.
  ///
  /// In ko, this message translates to:
  /// **'조커 선공'**
  String get jokerLeadSuitTitle;

  /// No description provided for @jokerLeadSuitQuestion.
  ///
  /// In ko, this message translates to:
  /// **'다른 플레이어가 따라야 할 무늬를 선택하세요'**
  String get jokerLeadSuitQuestion;

  /// No description provided for @allPassedTitle.
  ///
  /// In ko, this message translates to:
  /// **'모두 패스'**
  String get allPassedTitle;

  /// No description provided for @allPassedMessage.
  ///
  /// In ko, this message translates to:
  /// **'모든 플레이어가 패스했습니다.\n새 게임을 시작합니다.'**
  String get allPassedMessage;

  /// No description provided for @girudaChangeWarning.
  ///
  /// In ko, this message translates to:
  /// **'기루다 변경 시 목표 +2 증가'**
  String get girudaChangeWarning;

  /// No description provided for @keep.
  ///
  /// In ko, this message translates to:
  /// **'유지'**
  String get keep;

  /// No description provided for @aiRecommendation.
  ///
  /// In ko, this message translates to:
  /// **'AI 추천'**
  String get aiRecommendation;

  /// No description provided for @discardCards.
  ///
  /// In ko, this message translates to:
  /// **'버릴 카드:'**
  String get discardCards;

  /// No description provided for @goalPlus2.
  ///
  /// In ko, this message translates to:
  /// **'(목표 +2)'**
  String get goalPlus2;

  /// No description provided for @applyRecommendation.
  ///
  /// In ko, this message translates to:
  /// **'추천 적용'**
  String get applyRecommendation;

  /// No description provided for @nthTrickShort.
  ///
  /// In ko, this message translates to:
  /// **'{n}트릭'**
  String nthTrickShort(int n);

  /// No description provided for @recommendedFriend.
  ///
  /// In ko, this message translates to:
  /// **'추천 프렌드:'**
  String get recommendedFriend;

  /// No description provided for @joker.
  ///
  /// In ko, this message translates to:
  /// **'조커'**
  String get joker;

  /// No description provided for @mighty.
  ///
  /// In ko, this message translates to:
  /// **'마이티'**
  String get mighty;

  /// No description provided for @recommendNoFriend.
  ///
  /// In ko, this message translates to:
  /// **'노프렌드 추천'**
  String get recommendNoFriend;

  /// No description provided for @reasonHasMighty.
  ///
  /// In ko, this message translates to:
  /// **'마이티 보유'**
  String get reasonHasMighty;

  /// No description provided for @reasonHasJoker.
  ///
  /// In ko, this message translates to:
  /// **'조커 보유'**
  String get reasonHasJoker;

  /// No description provided for @reasonNeedMighty.
  ///
  /// In ko, this message translates to:
  /// **'마이티 필요'**
  String get reasonNeedMighty;

  /// No description provided for @reasonNeedJoker.
  ///
  /// In ko, this message translates to:
  /// **'조커 필요'**
  String get reasonNeedJoker;

  /// No description provided for @reasonNeedGirudaAce.
  ///
  /// In ko, this message translates to:
  /// **'기루다 A 필요'**
  String get reasonNeedGirudaAce;

  /// No description provided for @reasonNeedGirudaKing.
  ///
  /// In ko, this message translates to:
  /// **'기루다 K 필요'**
  String get reasonNeedGirudaKing;

  /// No description provided for @reasonStrongHand.
  ///
  /// In ko, this message translates to:
  /// **'강한 핸드'**
  String get reasonStrongHand;

  /// No description provided for @continueGame.
  ///
  /// In ko, this message translates to:
  /// **'이어하기'**
  String get continueGame;

  /// No description provided for @exitGame.
  ///
  /// In ko, this message translates to:
  /// **'나가기'**
  String get exitGame;

  /// No description provided for @exitGameConfirm.
  ///
  /// In ko, this message translates to:
  /// **'게임을 종료하시겠습니까?\n현재 게임은 자동 저장됩니다.'**
  String get exitGameConfirm;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @exit.
  ///
  /// In ko, this message translates to:
  /// **'종료'**
  String get exit;

  /// No description provided for @savedGame.
  ///
  /// In ko, this message translates to:
  /// **'저장된 게임'**
  String get savedGame;

  /// No description provided for @noSavedGame.
  ///
  /// In ko, this message translates to:
  /// **'저장된 게임이 없습니다'**
  String get noSavedGame;

  /// No description provided for @recommendedCard.
  ///
  /// In ko, this message translates to:
  /// **'추천 카드'**
  String get recommendedCard;

  /// No description provided for @showRecommendation.
  ///
  /// In ko, this message translates to:
  /// **'추천 보기'**
  String get showRecommendation;

  /// No description provided for @playerStats.
  ///
  /// In ko, this message translates to:
  /// **'플레이어 통계'**
  String get playerStats;

  /// No description provided for @winLoss.
  ///
  /// In ko, this message translates to:
  /// **'승/패'**
  String get winLoss;

  /// No description provided for @totalScore.
  ///
  /// In ko, this message translates to:
  /// **'총점'**
  String get totalScore;

  /// No description provided for @win.
  ///
  /// In ko, this message translates to:
  /// **'승'**
  String get win;

  /// No description provided for @loss.
  ///
  /// In ko, this message translates to:
  /// **'패'**
  String get loss;

  /// No description provided for @resetStats.
  ///
  /// In ko, this message translates to:
  /// **'초기화'**
  String get resetStats;

  /// No description provided for @resetStatsConfirm.
  ///
  /// In ko, this message translates to:
  /// **'광고를 시청하면 모든 통계가 초기화됩니다.\n계속하시겠습니까?'**
  String get resetStatsConfirm;

  /// No description provided for @exitApp.
  ///
  /// In ko, this message translates to:
  /// **'앱 종료'**
  String get exitApp;

  /// No description provided for @exitAppConfirm.
  ///
  /// In ko, this message translates to:
  /// **'앱을 종료하시겠습니까?'**
  String get exitAppConfirm;

  /// No description provided for @gameGuide.
  ///
  /// In ko, this message translates to:
  /// **'게임 방법'**
  String get gameGuide;

  /// No description provided for @guideOverview.
  ///
  /// In ko, this message translates to:
  /// **'게임 개요'**
  String get guideOverview;

  /// No description provided for @guideOverviewText.
  ///
  /// In ko, this message translates to:
  /// **'마이티는 5명이 즐기는 트릭테이킹 카드 게임입니다. 주공(1명)과 프렌드(1명)가 팀을 이루어 수비팀(3명)과 대결합니다.'**
  String get guideOverviewText;

  /// No description provided for @guideBidding.
  ///
  /// In ko, this message translates to:
  /// **'배팅'**
  String get guideBidding;

  /// No description provided for @guideBiddingText.
  ///
  /// In ko, this message translates to:
  /// **'• 각 플레이어는 자신이 획득할 점수 카드 수를 선언합니다\n• 가장 높은 배팅을 한 플레이어가 주공이 됩니다\n• 주공은 기루다(으뜸패)를 정합니다'**
  String get guideBiddingText;

  /// No description provided for @guideSpecialCards.
  ///
  /// In ko, this message translates to:
  /// **'특수 카드'**
  String get guideSpecialCards;

  /// No description provided for @guideSpecialCardsText.
  ///
  /// In ko, this message translates to:
  /// **'• 마이티: 스페이드 A (가장 강한 카드)\n• 조커: 두 번째로 강한 카드\n• 기루다: 주공이 정한 으뜸패 무늬'**
  String get guideSpecialCardsText;

  /// No description provided for @guideFriend.
  ///
  /// In ko, this message translates to:
  /// **'프렌드'**
  String get guideFriend;

  /// No description provided for @guideFriendText.
  ///
  /// In ko, this message translates to:
  /// **'• 주공은 특정 카드를 가진 사람을 프렌드로 지정합니다\n• 프렌드는 자신이 프렌드인지 숨길 수 있습니다\n• 조커콜: 특정 무늬의 3을 가진 사람을 프렌드로 지정'**
  String get guideFriendText;

  /// No description provided for @guideScoring.
  ///
  /// In ko, this message translates to:
  /// **'점수 계산'**
  String get guideScoring;

  /// No description provided for @guideScoringText.
  ///
  /// In ko, this message translates to:
  /// **'• 점수 카드: A, K, Q, J, 10 (각 1점, 총 20점)\n• 주공팀이 목표 점수 이상 획득하면 승리\n• 승리팀은 +점수, 패배팀은 -점수'**
  String get guideScoringText;

  /// No description provided for @guideTips.
  ///
  /// In ko, this message translates to:
  /// **'게임 팁'**
  String get guideTips;

  /// No description provided for @guideTipsText.
  ///
  /// In ko, this message translates to:
  /// **'• 마이티와 조커는 항상 강력합니다\n• 기루다 카드를 잘 활용하세요\n• 프렌드의 정체를 파악하는 것이 중요합니다'**
  String get guideTipsText;

  /// No description provided for @close.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get close;

  /// No description provided for @hint.
  ///
  /// In ko, this message translates to:
  /// **'힌트'**
  String get hint;

  /// No description provided for @enableHintQuestion.
  ///
  /// In ko, this message translates to:
  /// **'힌트를 활성화하시겠습니까?'**
  String get enableHintQuestion;

  /// No description provided for @newGameConfirm.
  ///
  /// In ko, this message translates to:
  /// **'새 게임을 시작하시겠습니까?'**
  String get newGameConfirm;

  /// No description provided for @dealMiss.
  ///
  /// In ko, this message translates to:
  /// **'딜 미스'**
  String get dealMiss;

  /// No description provided for @dealMissTitle.
  ///
  /// In ko, this message translates to:
  /// **'딜 미스 선언'**
  String get dealMissTitle;

  /// No description provided for @dealMissConfirm.
  ///
  /// In ko, this message translates to:
  /// **'딜 미스를 선언하시겠습니까?\n패를 공개하고 새로 시작합니다.'**
  String get dealMissConfirm;

  /// No description provided for @dealMissAnnouncement.
  ///
  /// In ko, this message translates to:
  /// **'{name} 딜 미스 선언!'**
  String dealMissAnnouncement(String name);

  /// No description provided for @dealMissNewGame.
  ///
  /// In ko, this message translates to:
  /// **'딜 미스로 게임을 다시 시작합니다.'**
  String get dealMissNewGame;

  /// No description provided for @aiPlayer1.
  ///
  /// In ko, this message translates to:
  /// **'민준'**
  String get aiPlayer1;

  /// No description provided for @aiPlayer2.
  ///
  /// In ko, this message translates to:
  /// **'서연'**
  String get aiPlayer2;

  /// No description provided for @aiPlayer3.
  ///
  /// In ko, this message translates to:
  /// **'지호'**
  String get aiPlayer3;

  /// No description provided for @aiPlayer4.
  ///
  /// In ko, this message translates to:
  /// **'수빈'**
  String get aiPlayer4;

  /// No description provided for @scoreCalcWin.
  ///
  /// In ko, this message translates to:
  /// **'점수 계산 (승리)'**
  String get scoreCalcWin;

  /// No description provided for @scoreCalcLose.
  ///
  /// In ko, this message translates to:
  /// **'점수 계산 (패배)'**
  String get scoreCalcLose;

  /// No description provided for @scoreFormula.
  ///
  /// In ko, this message translates to:
  /// **'(득점-공약+1) + (득점-최소)×2'**
  String get scoreFormula;

  /// No description provided for @scoreFormulaLose.
  ///
  /// In ko, this message translates to:
  /// **'-(공약 - 득점)'**
  String get scoreFormulaLose;

  /// No description provided for @scoreMultipliers.
  ///
  /// In ko, this message translates to:
  /// **'주공 ×2, 프렌드 ×1, 야당 ×(-1)'**
  String get scoreMultipliers;

  /// No description provided for @multiplierRun.
  ///
  /// In ko, this message translates to:
  /// **'런 ×2'**
  String get multiplierRun;

  /// No description provided for @multiplierNoGiruda.
  ///
  /// In ko, this message translates to:
  /// **'노기루다 ×2'**
  String get multiplierNoGiruda;

  /// No description provided for @multiplierNoFriend.
  ///
  /// In ko, this message translates to:
  /// **'노프렌드 ×2'**
  String get multiplierNoFriend;

  /// No description provided for @multiplierBackRun.
  ///
  /// In ko, this message translates to:
  /// **'백런 ×2'**
  String get multiplierBackRun;

  /// No description provided for @multiplierLabel.
  ///
  /// In ko, this message translates to:
  /// **'배수'**
  String get multiplierLabel;

  /// No description provided for @selectGame.
  ///
  /// In ko, this message translates to:
  /// **'게임 선택'**
  String get selectGame;

  /// No description provided for @sevenCardTitle.
  ///
  /// In ko, this message translates to:
  /// **'세븐 포커'**
  String get sevenCardTitle;

  /// No description provided for @sevenCardSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'7장 카드 포커 게임'**
  String get sevenCardSubtitle;

  /// No description provided for @sevenCardRules.
  ///
  /// In ko, this message translates to:
  /// **'게임 규칙'**
  String get sevenCardRules;

  /// No description provided for @sevenCardRulesText.
  ///
  /// In ko, this message translates to:
  /// **'• 각 플레이어는 7장의 카드를 받습니다\n• 처음 3장은 비공개, 나머지 4장은 공개\n• 베팅 라운드를 거쳐 최종 5장으로 족보를 만듭니다\n• 가장 높은 족보를 가진 플레이어가 승리'**
  String get sevenCardRulesText;

  /// No description provided for @pot.
  ///
  /// In ko, this message translates to:
  /// **'팟'**
  String get pot;

  /// No description provided for @currentBet.
  ///
  /// In ko, this message translates to:
  /// **'현재 베팅'**
  String get currentBet;

  /// No description provided for @betting.
  ///
  /// In ko, this message translates to:
  /// **'라운드'**
  String get betting;

  /// No description provided for @chips.
  ///
  /// In ko, this message translates to:
  /// **'칩'**
  String get chips;

  /// No description provided for @bet.
  ///
  /// In ko, this message translates to:
  /// **'베팅'**
  String get bet;

  /// No description provided for @fold.
  ///
  /// In ko, this message translates to:
  /// **'다이'**
  String get fold;

  /// No description provided for @call.
  ///
  /// In ko, this message translates to:
  /// **'콜'**
  String get call;

  /// No description provided for @raise.
  ///
  /// In ko, this message translates to:
  /// **'레이즈'**
  String get raise;

  /// No description provided for @check.
  ///
  /// In ko, this message translates to:
  /// **'체크'**
  String get check;

  /// No description provided for @allIn.
  ///
  /// In ko, this message translates to:
  /// **'올인'**
  String get allIn;

  /// No description provided for @folded.
  ///
  /// In ko, this message translates to:
  /// **'다이'**
  String get folded;

  /// No description provided for @wins.
  ///
  /// In ko, this message translates to:
  /// **'승리'**
  String get wins;

  /// No description provided for @betPing.
  ///
  /// In ko, this message translates to:
  /// **'삥'**
  String get betPing;

  /// No description provided for @betDdadang.
  ///
  /// In ko, this message translates to:
  /// **'따당'**
  String get betDdadang;

  /// No description provided for @betQuarter.
  ///
  /// In ko, this message translates to:
  /// **'쿼터'**
  String get betQuarter;

  /// No description provided for @betHalf.
  ///
  /// In ko, this message translates to:
  /// **'하프'**
  String get betHalf;

  /// No description provided for @betFull.
  ///
  /// In ko, this message translates to:
  /// **'풀'**
  String get betFull;

  /// No description provided for @betDie.
  ///
  /// In ko, this message translates to:
  /// **'다이'**
  String get betDie;

  /// No description provided for @selectCardToReveal.
  ///
  /// In ko, this message translates to:
  /// **'공개할 카드를 선택하세요'**
  String get selectCardToReveal;

  /// No description provided for @selectedCardWillBeRevealed.
  ///
  /// In ko, this message translates to:
  /// **'선택한 카드가 상대에게 공개됩니다'**
  String get selectedCardWillBeRevealed;

  /// No description provided for @totalBet.
  ///
  /// In ko, this message translates to:
  /// **'총'**
  String get totalBet;

  /// No description provided for @bonus.
  ///
  /// In ko, this message translates to:
  /// **'보너스'**
  String get bonus;

  /// No description provided for @finalResult.
  ///
  /// In ko, this message translates to:
  /// **'최종 결과'**
  String get finalResult;

  /// No description provided for @viewResultButton.
  ///
  /// In ko, this message translates to:
  /// **'결과 확인'**
  String get viewResultButton;

  /// No description provided for @hintOff.
  ///
  /// In ko, this message translates to:
  /// **'힌트 OFF'**
  String get hintOff;

  /// No description provided for @playerLabel.
  ///
  /// In ko, this message translates to:
  /// **'플레이어'**
  String get playerLabel;

  /// No description provided for @thisGame.
  ///
  /// In ko, this message translates to:
  /// **'이번 게임'**
  String get thisGame;

  /// No description provided for @cumulative.
  ///
  /// In ko, this message translates to:
  /// **'누적'**
  String get cumulative;

  /// No description provided for @bettingAmount.
  ///
  /// In ko, this message translates to:
  /// **'베팅'**
  String get bettingAmount;

  /// No description provided for @otherPlayersBonus.
  ///
  /// In ko, this message translates to:
  /// **'다른 플레이어'**
  String get otherPlayersBonus;

  /// No description provided for @gameEnd.
  ///
  /// In ko, this message translates to:
  /// **'게임 종료'**
  String get gameEnd;

  /// No description provided for @hiLoTitle.
  ///
  /// In ko, this message translates to:
  /// **'하이로우'**
  String get hiLoTitle;

  /// No description provided for @hiLoSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'하이/로우 스플릿 포커'**
  String get hiLoSubtitle;

  /// No description provided for @hi.
  ///
  /// In ko, this message translates to:
  /// **'하이'**
  String get hi;

  /// No description provided for @lo.
  ///
  /// In ko, this message translates to:
  /// **'로우'**
  String get lo;

  /// No description provided for @swing.
  ///
  /// In ko, this message translates to:
  /// **'스윙'**
  String get swing;

  /// No description provided for @selectHiLo.
  ///
  /// In ko, this message translates to:
  /// **'하이/로우 선택'**
  String get selectHiLo;

  /// No description provided for @selectHiLoDesc.
  ///
  /// In ko, this message translates to:
  /// **'하이, 로우, 또는 스윙을 선택하세요'**
  String get selectHiLoDesc;

  /// No description provided for @hiWinner.
  ///
  /// In ko, this message translates to:
  /// **'하이 승자'**
  String get hiWinner;

  /// No description provided for @loWinner.
  ///
  /// In ko, this message translates to:
  /// **'로우 승자'**
  String get loWinner;

  /// No description provided for @swingSuccess.
  ///
  /// In ko, this message translates to:
  /// **'스윙 성공!'**
  String get swingSuccess;

  /// No description provided for @swingFailed.
  ///
  /// In ko, this message translates to:
  /// **'스윙 실패'**
  String get swingFailed;

  /// No description provided for @hiPot.
  ///
  /// In ko, this message translates to:
  /// **'하이 팟'**
  String get hiPot;

  /// No description provided for @loPot.
  ///
  /// In ko, this message translates to:
  /// **'로우 팟'**
  String get loPot;

  /// No description provided for @noLowHand.
  ///
  /// In ko, this message translates to:
  /// **'로우 없음'**
  String get noLowHand;

  /// No description provided for @bestLow.
  ///
  /// In ko, this message translates to:
  /// **'베스트 로우'**
  String get bestLow;

  /// No description provided for @waitingForHiLo.
  ///
  /// In ko, this message translates to:
  /// **'선택 대기 중...'**
  String get waitingForHiLo;

  /// No description provided for @selectedHi.
  ///
  /// In ko, this message translates to:
  /// **'하이 선택'**
  String get selectedHi;

  /// No description provided for @selectedLo.
  ///
  /// In ko, this message translates to:
  /// **'로우 선택'**
  String get selectedLo;

  /// No description provided for @selectedSwing.
  ///
  /// In ko, this message translates to:
  /// **'스윙 선택'**
  String get selectedSwing;

  /// No description provided for @showdownTitle.
  ///
  /// In ko, this message translates to:
  /// **'선언 현황'**
  String get showdownTitle;

  /// No description provided for @showdownDesc.
  ///
  /// In ko, this message translates to:
  /// **'각 플레이어의 선택을 확인하세요'**
  String get showdownDesc;

  /// No description provided for @viewResults.
  ///
  /// In ko, this message translates to:
  /// **'결과 보기'**
  String get viewResults;

  /// No description provided for @finalResults.
  ///
  /// In ko, this message translates to:
  /// **'최종 결과'**
  String get finalResults;

  /// No description provided for @sevenCardGuideOverview.
  ///
  /// In ko, this message translates to:
  /// **'게임 개요'**
  String get sevenCardGuideOverview;

  /// No description provided for @sevenCardGuideOverviewText.
  ///
  /// In ko, this message translates to:
  /// **'세븐 포커는 5명이 즐기는 포커 게임입니다. 7장의 카드 중 5장으로 가장 높은 족보를 만들어 승리하세요.'**
  String get sevenCardGuideOverviewText;

  /// No description provided for @sevenCardGuideDealing.
  ///
  /// In ko, this message translates to:
  /// **'카드 배분'**
  String get sevenCardGuideDealing;

  /// No description provided for @sevenCardGuideDealingText.
  ///
  /// In ko, this message translates to:
  /// **'• 처음에 4장을 받습니다 (3장 비공개, 1장 공개)\n• 베팅 후 한 장씩 공개 카드를 받습니다\n• 최종 7장 중 5장으로 족보를 만듭니다'**
  String get sevenCardGuideDealingText;

  /// No description provided for @sevenCardGuideBetting.
  ///
  /// In ko, this message translates to:
  /// **'베팅 규칙'**
  String get sevenCardGuideBetting;

  /// No description provided for @sevenCardGuideBettingText.
  ///
  /// In ko, this message translates to:
  /// **'• 체크: 베팅 없이 넘기기\n• 콜: 현재 베팅에 맞추기\n• 레이즈: 베팅 금액 올리기\n• 다이: 게임 포기\n• 올인: 모든 칩 베팅'**
  String get sevenCardGuideBettingText;

  /// No description provided for @sevenCardGuideHands.
  ///
  /// In ko, this message translates to:
  /// **'족보 순위'**
  String get sevenCardGuideHands;

  /// No description provided for @sevenCardGuideHandsText.
  ///
  /// In ko, this message translates to:
  /// **'1. 로열 스트레이트 플러시\n2. 백 스트레이트 플러시\n3. 스트레이트 플러시\n4. 포카드\n5. 풀하우스\n6. 플러시\n7. 마운틴 (A-K-Q-J-10)\n8. 백스트레이트 (A-2-3-4-5)\n9. 스트레이트\n10. 트리플\n11. 투페어\n12. 원페어\n13. 하이카드'**
  String get sevenCardGuideHandsText;

  /// No description provided for @sevenCardGuideTips.
  ///
  /// In ko, this message translates to:
  /// **'게임 팁'**
  String get sevenCardGuideTips;

  /// No description provided for @sevenCardGuideTipsText.
  ///
  /// In ko, this message translates to:
  /// **'• 공개 카드로 상대방 족보를 예측하세요\n• 강한 핸드가 아니면 과도한 베팅을 피하세요\n• 블러핑도 전략입니다'**
  String get sevenCardGuideTipsText;

  /// No description provided for @sevenCardGuideBonus.
  ///
  /// In ko, this message translates to:
  /// **'보너스 핸드'**
  String get sevenCardGuideBonus;

  /// No description provided for @sevenCardGuideBonusText.
  ///
  /// In ko, this message translates to:
  /// **'• 로열 스트레이트 플러시: 500칩\n• 백 스트레이트 플러시: 300칩\n• 스트레이트 플러시: 200칩\n• 포카드: 100칩\n\n보너스 핸드 달성 시 다른 모든 플레이어에게 보너스를 받습니다!'**
  String get sevenCardGuideBonusText;

  /// No description provided for @hiLoGuideOverview.
  ///
  /// In ko, this message translates to:
  /// **'게임 개요'**
  String get hiLoGuideOverview;

  /// No description provided for @hiLoGuideOverviewText.
  ///
  /// In ko, this message translates to:
  /// **'하이로우는 세븐 포커의 변형으로, 팟이 하이(높은 족보)와 로우(낮은 족보) 승자에게 나뉩니다.'**
  String get hiLoGuideOverviewText;

  /// No description provided for @hiLoGuideDealing.
  ///
  /// In ko, this message translates to:
  /// **'카드 배분'**
  String get hiLoGuideDealing;

  /// No description provided for @hiLoGuideDealingText.
  ///
  /// In ko, this message translates to:
  /// **'• 세븐 포커와 동일한 방식으로 진행\n• 7장의 카드 중 5장으로 족보를 만듭니다\n• 마지막 베팅 후 하이/로우/스윙 선택'**
  String get hiLoGuideDealingText;

  /// No description provided for @hiLoGuideHiLo.
  ///
  /// In ko, this message translates to:
  /// **'하이/로우 선택'**
  String get hiLoGuideHiLo;

  /// No description provided for @hiLoGuideHiLoText.
  ///
  /// In ko, this message translates to:
  /// **'• 하이: 가장 높은 족보로 경쟁\n• 로우: 가장 낮은 족보로 경쟁\n• 스윙: 하이와 로우 모두 도전\n\n팟의 50%는 하이 승자, 50%는 로우 승자가 가져갑니다.'**
  String get hiLoGuideHiLoText;

  /// No description provided for @hiLoGuideLow.
  ///
  /// In ko, this message translates to:
  /// **'로우 족보'**
  String get hiLoGuideLow;

  /// No description provided for @hiLoGuideLowText.
  ///
  /// In ko, this message translates to:
  /// **'• 스트레이트/플러시 없는 핸드만 로우 자격\n• 낮을수록 좋음 (A가 가장 낮음)\n• 최강 로우: A-2-3-4-6\n• 페어가 없는 핸드가 유리'**
  String get hiLoGuideLowText;

  /// No description provided for @hiLoGuideSwing.
  ///
  /// In ko, this message translates to:
  /// **'스윙 규칙'**
  String get hiLoGuideSwing;

  /// No description provided for @hiLoGuideSwingText.
  ///
  /// In ko, this message translates to:
  /// **'• 7장을 두 개의 5장 핸드로 나눕니다\n• 하이와 로우 모두 1등해야 성공\n• 성공 시 전체 팟 획득\n• 실패 시 해당 부분은 다른 승자에게'**
  String get hiLoGuideSwingText;

  /// No description provided for @hiLoGuideTips.
  ///
  /// In ko, this message translates to:
  /// **'게임 팁'**
  String get hiLoGuideTips;

  /// No description provided for @hiLoGuideTipsText.
  ///
  /// In ko, this message translates to:
  /// **'• A-2-3-4 같은 낮은 카드는 로우에 유리\n• 스윙은 위험하지만 성공 시 큰 보상\n• 상대 카드를 보고 전략을 세우세요'**
  String get hiLoGuideTipsText;

  /// No description provided for @hiLoGuideBonus.
  ///
  /// In ko, this message translates to:
  /// **'보너스 핸드'**
  String get hiLoGuideBonus;

  /// No description provided for @hiLoGuideBonusText.
  ///
  /// In ko, this message translates to:
  /// **'• 로열 스트레이트 플러시: 500칩\n• 백 스트레이트 플러시: 300칩\n• 스트레이트 플러시: 200칩\n• 포카드: 100칩\n\n보너스 핸드 달성 시 자동으로 전체 팟을 획득합니다!'**
  String get hiLoGuideBonusText;

  /// No description provided for @hulaTitle.
  ///
  /// In ko, this message translates to:
  /// **'훌라'**
  String get hulaTitle;

  /// No description provided for @hulaSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'4인용 러미 카드 게임'**
  String get hulaSubtitle;

  /// No description provided for @heartsTitle.
  ///
  /// In ko, this message translates to:
  /// **'하트'**
  String get heartsTitle;

  /// No description provided for @heartsSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'4인 트릭 테이킹 게임'**
  String get heartsSubtitle;

  /// No description provided for @register.
  ///
  /// In ko, this message translates to:
  /// **'등록'**
  String get register;

  /// No description provided for @discardCard.
  ///
  /// In ko, this message translates to:
  /// **'버리기'**
  String get discardCard;

  /// No description provided for @stopGame.
  ///
  /// In ko, this message translates to:
  /// **'스톱'**
  String get stopGame;

  /// No description provided for @drawCard.
  ///
  /// In ko, this message translates to:
  /// **'카드를 뽑으세요'**
  String get drawCard;

  /// No description provided for @discardOrRegister.
  ///
  /// In ko, this message translates to:
  /// **'카드를 버리거나 등록하세요'**
  String get discardOrRegister;

  /// No description provided for @noCards.
  ///
  /// In ko, this message translates to:
  /// **'카드가 없습니다'**
  String get noCards;

  /// No description provided for @addedToMeld.
  ///
  /// In ko, this message translates to:
  /// **'멜드에 추가됨'**
  String get addedToMeld;

  /// No description provided for @noMeldToAttach.
  ///
  /// In ko, this message translates to:
  /// **'붙일 멜드가 없습니다'**
  String get noMeldToAttach;

  /// No description provided for @invalidCombination.
  ///
  /// In ko, this message translates to:
  /// **'유효하지 않은 조합입니다'**
  String get invalidCombination;

  /// No description provided for @drawFirst.
  ///
  /// In ko, this message translates to:
  /// **'먼저 카드를 뽑으세요'**
  String get drawFirst;

  /// No description provided for @selectCardToDiscard.
  ///
  /// In ko, this message translates to:
  /// **'버릴 카드를 선택하세요'**
  String get selectCardToDiscard;

  /// No description provided for @victory.
  ///
  /// In ko, this message translates to:
  /// **'승리!'**
  String get victory;

  /// No description provided for @defeat.
  ///
  /// In ko, this message translates to:
  /// **'패배'**
  String get defeat;

  /// No description provided for @hulaVictory.
  ///
  /// In ko, this message translates to:
  /// **'훌라로 승리! (x2)'**
  String get hulaVictory;

  /// No description provided for @handCards.
  ///
  /// In ko, this message translates to:
  /// **'손패'**
  String get handCards;

  /// No description provided for @myTurn.
  ///
  /// In ko, this message translates to:
  /// **'내 차례'**
  String get myTurn;

  /// No description provided for @start.
  ///
  /// In ko, this message translates to:
  /// **'시작'**
  String get start;

  /// No description provided for @discardedCards.
  ///
  /// In ko, this message translates to:
  /// **'버린 카드'**
  String get discardedCards;

  /// No description provided for @thankYou.
  ///
  /// In ko, this message translates to:
  /// **'땡큐'**
  String get thankYou;

  /// No description provided for @selectMethod.
  ///
  /// In ko, this message translates to:
  /// **'방법을 선택하세요'**
  String get selectMethod;

  /// No description provided for @register7Alone.
  ///
  /// In ko, this message translates to:
  /// **'7 단독 등록'**
  String get register7Alone;

  /// No description provided for @attachToMyMeld.
  ///
  /// In ko, this message translates to:
  /// **'내 멜드에 붙이기'**
  String get attachToMyMeld;

  /// No description provided for @attachToOtherMeld.
  ///
  /// In ko, this message translates to:
  /// **'멜드에 붙이기'**
  String get attachToOtherMeld;

  /// No description provided for @gameRules.
  ///
  /// In ko, this message translates to:
  /// **'게임 규칙'**
  String get gameRules;

  /// No description provided for @objective.
  ///
  /// In ko, this message translates to:
  /// **'목표'**
  String get objective;

  /// No description provided for @objectiveDesc.
  ///
  /// In ko, this message translates to:
  /// **'손패의 카드를 모두 등록하거나 버려서 가장 먼저 없애는 것이 목표입니다.'**
  String get objectiveDesc;

  /// No description provided for @howToPlay.
  ///
  /// In ko, this message translates to:
  /// **'진행 방법'**
  String get howToPlay;

  /// No description provided for @howToPlayDesc.
  ///
  /// In ko, this message translates to:
  /// **'매 턴마다 덱 또는 버린 더미에서 카드 1장을 뽑고, 등록 또는 버리기를 합니다.'**
  String get howToPlayDesc;

  /// No description provided for @meldTypes.
  ///
  /// In ko, this message translates to:
  /// **'멜드 종류'**
  String get meldTypes;

  /// No description provided for @thankYouMeld.
  ///
  /// In ko, this message translates to:
  /// **'땡큐 멜드'**
  String get thankYouMeld;

  /// No description provided for @thankYouMeldDesc.
  ///
  /// In ko, this message translates to:
  /// **'버린 더미에서 7을 뽑으면 \"땡큐\"를 외치고 특별한 등록을 할 수 있습니다.'**
  String get thankYouMeldDesc;

  /// No description provided for @stopRule.
  ///
  /// In ko, this message translates to:
  /// **'스톱'**
  String get stopRule;

  /// No description provided for @stopRuleDesc.
  ///
  /// In ko, this message translates to:
  /// **'언제든 스톱을 외쳐 게임을 끝낼 수 있습니다. 남은 카드 점수가 가장 적은 사람이 승리합니다.'**
  String get stopRuleDesc;

  /// No description provided for @scoring.
  ///
  /// In ko, this message translates to:
  /// **'점수 계산'**
  String get scoring;

  /// No description provided for @aiStartsFirst.
  ///
  /// In ko, this message translates to:
  /// **'{name}이 먼저 시작합니다'**
  String aiStartsFirst(Object name);

  /// No description provided for @xWins.
  ///
  /// In ko, this message translates to:
  /// **'{name} 승리!'**
  String xWins(Object name);

  /// No description provided for @nMelds.
  ///
  /// In ko, this message translates to:
  /// **'{count}개 멜드'**
  String nMelds(Object count);

  /// No description provided for @attachedToMeldSelf.
  ///
  /// In ko, this message translates to:
  /// **'{card} 멜드에 붙임'**
  String attachedToMeldSelf(Object card);

  /// No description provided for @attachedToMeldPlayer.
  ///
  /// In ko, this message translates to:
  /// **'{card} 플레이어 멜드에 붙임'**
  String attachedToMeldPlayer(Object card);

  /// No description provided for @attachedToMeldOther.
  ///
  /// In ko, this message translates to:
  /// **'{card} {name} 멜드에 붙임'**
  String attachedToMeldOther(Object card, Object name);

  /// No description provided for @drewCard.
  ///
  /// In ko, this message translates to:
  /// **'{name}이 카드를 뽑음'**
  String drewCard(Object name);

  /// No description provided for @thankYouAttachSelf.
  ///
  /// In ko, this message translates to:
  /// **'땡큐! {card} 내 멜드에 붙이기'**
  String thankYouAttachSelf(Object card);

  /// No description provided for @thankYouAttachOther.
  ///
  /// In ko, this message translates to:
  /// **'땡큐! {card} {name} 멜드에 붙이기'**
  String thankYouAttachOther(Object card, Object name);

  /// No description provided for @nPlayersHula.
  ///
  /// In ko, this message translates to:
  /// **'훌라 ({n}인)'**
  String nPlayersHula(Object n);

  /// No description provided for @nCards.
  ///
  /// In ko, this message translates to:
  /// **'{n}장'**
  String nCards(Object n);

  /// No description provided for @heartsBreaking.
  ///
  /// In ko, this message translates to:
  /// **'하트 브레이킹'**
  String get heartsBreaking;

  /// No description provided for @cardPass.
  ///
  /// In ko, this message translates to:
  /// **'카드 패스'**
  String get cardPass;

  /// No description provided for @trickNum.
  ///
  /// In ko, this message translates to:
  /// **'트릭 {n}/13'**
  String trickNum(Object n);

  /// No description provided for @passToLeft.
  ///
  /// In ko, this message translates to:
  /// **'왼쪽으로 패스 ({n}/3)'**
  String passToLeft(Object n);

  /// No description provided for @selectCardsToPass.
  ///
  /// In ko, this message translates to:
  /// **'왼쪽으로 보낼 카드 3장을 선택하세요'**
  String get selectCardsToPass;

  /// No description provided for @allPointsExhausted.
  ///
  /// In ko, this message translates to:
  /// **'모든 점수 카드 소진! 게임 종료'**
  String get allPointsExhausted;

  /// No description provided for @passRecommend.
  ///
  /// In ko, this message translates to:
  /// **'패스 추천'**
  String get passRecommend;

  /// No description provided for @recommend.
  ///
  /// In ko, this message translates to:
  /// **'추천'**
  String get recommend;

  /// No description provided for @hintEnabled.
  ///
  /// In ko, this message translates to:
  /// **'힌트가 활성화되었습니다!'**
  String get hintEnabled;

  /// No description provided for @oneCard.
  ///
  /// In ko, this message translates to:
  /// **'원카드'**
  String get oneCard;

  /// No description provided for @oneCardTitle.
  ///
  /// In ko, this message translates to:
  /// **'원카드 ({n}P)'**
  String oneCardTitle(Object n);

  /// No description provided for @oneCardCall.
  ///
  /// In ko, this message translates to:
  /// **'원카드!'**
  String get oneCardCall;

  /// No description provided for @oneCardCountdown.
  ///
  /// In ko, this message translates to:
  /// **'원카드 ({n}초)'**
  String oneCardCountdown(Object n);

  /// No description provided for @cannotPlayCard.
  ///
  /// In ko, this message translates to:
  /// **'이 카드는 낼 수 없습니다'**
  String get cannotPlayCard;

  /// No description provided for @attackReceived.
  ///
  /// In ko, this message translates to:
  /// **'공격으로 {n}장을 받았습니다'**
  String attackReceived(Object n);

  /// No description provided for @drewCardMsg.
  ///
  /// In ko, this message translates to:
  /// **'카드를 뽑았습니다'**
  String get drewCardMsg;

  /// No description provided for @bankruptcy.
  ///
  /// In ko, this message translates to:
  /// **'파산! ({n}장 보유)'**
  String bankruptcy(Object n);

  /// No description provided for @selectSuit.
  ///
  /// In ko, this message translates to:
  /// **'무늬를 선택하세요'**
  String get selectSuit;

  /// No description provided for @clockwise.
  ///
  /// In ko, this message translates to:
  /// **'시계'**
  String get clockwise;

  /// No description provided for @counterClockwise.
  ///
  /// In ko, this message translates to:
  /// **'반시계'**
  String get counterClockwise;

  /// No description provided for @blackJoker.
  ///
  /// In ko, this message translates to:
  /// **'흑백 조커'**
  String get blackJoker;

  /// No description provided for @colorJoker.
  ///
  /// In ko, this message translates to:
  /// **'컬러 조커'**
  String get colorJoker;

  /// No description provided for @winRate.
  ///
  /// In ko, this message translates to:
  /// **'승률'**
  String get winRate;

  /// No description provided for @rulesObjective.
  ///
  /// In ko, this message translates to:
  /// **'목표'**
  String get rulesObjective;

  /// No description provided for @rulesHowToPlay.
  ///
  /// In ko, this message translates to:
  /// **'진행 방법'**
  String get rulesHowToPlay;

  /// No description provided for @rulesScoring.
  ///
  /// In ko, this message translates to:
  /// **'점수 계산'**
  String get rulesScoring;

  /// No description provided for @rulesTips.
  ///
  /// In ko, this message translates to:
  /// **'게임 팁'**
  String get rulesTips;

  /// No description provided for @rulesAttackCards.
  ///
  /// In ko, this message translates to:
  /// **'공격 카드'**
  String get rulesAttackCards;

  /// No description provided for @rulesDefense.
  ///
  /// In ko, this message translates to:
  /// **'방어'**
  String get rulesDefense;

  /// No description provided for @rulesSpecialCards.
  ///
  /// In ko, this message translates to:
  /// **'특수 카드'**
  String get rulesSpecialCards;

  /// No description provided for @restart.
  ///
  /// In ko, this message translates to:
  /// **'다시 시작'**
  String get restart;

  /// No description provided for @totalAttack.
  ///
  /// In ko, this message translates to:
  /// **'총 {n}장 공격'**
  String totalAttack(int n);

  /// No description provided for @skipNextTurn.
  ///
  /// In ko, this message translates to:
  /// **'다음 턴 건너뛰기'**
  String get skipNextTurn;

  /// No description provided for @reverseDirection.
  ///
  /// In ko, this message translates to:
  /// **'방향 반대'**
  String get reverseDirection;

  /// No description provided for @skipTwoTurns.
  ///
  /// In ko, this message translates to:
  /// **'2턴 건너뛰기'**
  String get skipTwoTurns;

  /// No description provided for @changeSuit.
  ///
  /// In ko, this message translates to:
  /// **'무늬 변경'**
  String get changeSuit;

  /// No description provided for @playerPlayedCard.
  ///
  /// In ko, this message translates to:
  /// **'{name}이(가) 카드를 냈습니다'**
  String playerPlayedCard(String name);

  /// No description provided for @attackReceivedShort.
  ///
  /// In ko, this message translates to:
  /// **'공격으로 {n}장 받음'**
  String attackReceivedShort(int n);

  /// No description provided for @drewCardShort.
  ///
  /// In ko, this message translates to:
  /// **'카드 뽑음'**
  String get drewCardShort;

  /// No description provided for @bankruptcyShort.
  ///
  /// In ko, this message translates to:
  /// **'파산! ({n}장 보유)'**
  String bankruptcyShort(int n);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
