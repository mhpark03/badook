// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'マイティ';

  @override
  String get gameSubtitle => '韓国の伝統トリックテイキングカードゲーム';

  @override
  String get startGame => 'ゲーム開始';

  @override
  String get newGame => '新しいゲーム';

  @override
  String get biddingPhase => 'ビッディング段階';

  @override
  String currentBidder(String name) {
    return '現在のビッダー: $name';
  }

  @override
  String get noBidYet => 'まだビッドなし';

  @override
  String highestBid(String bid) {
    return '最高ビッド: $bid';
  }

  @override
  String get bid => 'ビッド';

  @override
  String get bidButton => 'ビッドする';

  @override
  String get pass => 'パス';

  @override
  String get tricks => '目標点数';

  @override
  String get giruda => '切り札';

  @override
  String get noGiruda => 'ノートランプ';

  @override
  String get spade => 'スペード';

  @override
  String get diamond => 'ダイヤ';

  @override
  String get heart => 'ハート';

  @override
  String get club => 'クラブ';

  @override
  String get spadeName => 'スペード';

  @override
  String get diamondName => 'ダイヤ';

  @override
  String get heartName => 'ハート';

  @override
  String get clubName => 'クラブ';

  @override
  String get selectKitty => 'キティ選択';

  @override
  String selectKittyDesc(int count) {
    return '捨てるカード3枚を選択 (選択済み: $count/3)';
  }

  @override
  String get receivedKitty => '受け取ったキティ:';

  @override
  String get myCards => '手札:';

  @override
  String get changeGiruda => '切り札変更 (任意):';

  @override
  String get confirm => '確認';

  @override
  String get declareFriend => 'フレンド宣言';

  @override
  String get friendDeclarationType => 'フレンド宣言方式:';

  @override
  String get byCard => 'カードで指定';

  @override
  String get firstTrickFriend => '初回トリックフレンド';

  @override
  String get firstTrickFriendDesc => '最初のトリックを取った人';

  @override
  String get nthTrickFriend => 'N回目トリックフレンド';

  @override
  String get noFriend => 'ノーフレンド';

  @override
  String get noFriendDesc => '一人でプレイ';

  @override
  String get declare => '宣言';

  @override
  String get suit => 'スート:';

  @override
  String get rank => 'ランク:';

  @override
  String selectedCard(String card) {
    return '選択したカード: $card';
  }

  @override
  String get trickNumber => 'トリック番号:';

  @override
  String get playCard => 'カードを出してください';

  @override
  String get yourTurn => 'あなたの番です';

  @override
  String playerTurn(String name) {
    return '$nameの番';
  }

  @override
  String get contract => '契約';

  @override
  String get trick => 'トリック';

  @override
  String get friend => 'フレンド';

  @override
  String get declarer => '宣言者';

  @override
  String cards(int count) {
    return 'カード: $count';
  }

  @override
  String get aiSelectingKitty => 'AIがキティを選択中...';

  @override
  String get aiSelectingCard => 'AIがカードを選択中...';

  @override
  String get aiDeclaringFriend => 'AIがフレンドを宣言中...';

  @override
  String get declarerTeamWins => '宣言者チームの勝利！';

  @override
  String get defenderTeamWins => '守備チームの勝利！';

  @override
  String get declarerTeam => '宣言者チーム';

  @override
  String get defenderTeam => '守備チーム';

  @override
  String get fullPoints => 'フル';

  @override
  String declarerTeamPoints(int points) {
    return '宣言者チーム: $points点';
  }

  @override
  String defenderTeamPoints(int points) {
    return '守備チーム: $points点';
  }

  @override
  String targetPoints(int points) {
    return '目標: $points点';
  }

  @override
  String get score => 'スコア';

  @override
  String points(int points) {
    return '$points点';
  }

  @override
  String get player => 'プレイヤー';

  @override
  String get you => 'あなた';

  @override
  String get bidding => 'ビッド中...';

  @override
  String get waiting => '待機';

  @override
  String get otherPlayerTurn => '他のプレイヤーの番です';

  @override
  String get yourCards => 'あなたのカード';

  @override
  String get biddingTurn => 'ビッドの番';

  @override
  String bidWithAmount(int amount) {
    return 'ビッド $amount';
  }

  @override
  String trickComplete(int number) {
    return 'トリック $number 完了';
  }

  @override
  String winnerAnnouncement(String name, String team) {
    return '$name 勝利! ($team)';
  }

  @override
  String get attackTeam => '攻撃';

  @override
  String get defenseTeam => '守備';

  @override
  String get nextTrick => '次のトリック';

  @override
  String get friendNone => 'なし';

  @override
  String get firstTrick => '初トリック';

  @override
  String get selectCardHint => 'カードを選んでください ↓';

  @override
  String get previousTrick => '前のトリック';

  @override
  String get winShort => '勝';

  @override
  String get leadPlayer => 'リード';

  @override
  String get leadPlayerHint => '👆 あなたがリードです!';

  @override
  String get selectCardBelow => '下からカードを選んでください';

  @override
  String get leadPlayerSelectCard => '👆 リードです! カードを選んでください';

  @override
  String jokerCallAnnouncement(String suit) {
    return 'ジョーカーコール! $suit';
  }

  @override
  String get wonCards => '獲得:';

  @override
  String get jokerCallTitle => 'ジョーカーコール';

  @override
  String jokerCallQuestion(String suit) {
    return '$suit ジョーカーコールを宣言しますか?';
  }

  @override
  String get no => 'いいえ';

  @override
  String jokerCallButton(String suit) {
    return '$suit ジョーカーコール!';
  }

  @override
  String get jokerLeadSuitTitle => 'ジョーカーリード';

  @override
  String get jokerLeadSuitQuestion => '他のプレイヤーが従うスートを選んでください';

  @override
  String get allPassedTitle => '全員パス';

  @override
  String get allPassedMessage => '全員がパスしました。\n新しいゲームを開始します。';

  @override
  String get girudaChangeWarning => '切り札変更時: 目標+2';

  @override
  String get keep => '維持';

  @override
  String get aiRecommendation => 'AIおすすめ';

  @override
  String get discardCards => '捨てるカード:';

  @override
  String get goalPlus2 => '(目標+2)';

  @override
  String get applyRecommendation => '適用';

  @override
  String nthTrickShort(int n) {
    return '$nトリック';
  }

  @override
  String get recommendedFriend => 'おすすめ:';

  @override
  String get joker => 'ジョーカー';

  @override
  String get mighty => 'マイティ';

  @override
  String get recommendNoFriend => 'ノーフレンドおすすめ';

  @override
  String get reasonHasMighty => 'マイティ所持';

  @override
  String get reasonHasJoker => 'ジョーカー所持';

  @override
  String get reasonNeedMighty => 'マイティ必要';

  @override
  String get reasonNeedJoker => 'ジョーカー必要';

  @override
  String get reasonNeedGirudaAce => '切り札A必要';

  @override
  String get reasonNeedGirudaKing => '切り札K必要';

  @override
  String get reasonStrongHand => '強い手札';

  @override
  String get continueGame => '続ける';

  @override
  String get exitGame => '終了';

  @override
  String get exitGameConfirm => 'ゲームを終了しますか?\n現在のゲームは保存されます。';

  @override
  String get cancel => 'キャンセル';

  @override
  String get exit => '終了';

  @override
  String get savedGame => '保存されたゲーム';

  @override
  String get noSavedGame => '保存されたゲームがありません';

  @override
  String get recommendedCard => 'おすすめ';

  @override
  String get showRecommendation => 'ヒント表示';

  @override
  String get playerStats => 'プレイヤー統計';

  @override
  String get winLoss => '勝/敗';

  @override
  String get totalScore => '合計';

  @override
  String get win => '勝';

  @override
  String get loss => '敗';

  @override
  String get resetStats => 'リセット';

  @override
  String get resetStatsConfirm => '広告を視聴すると、すべての統計がリセットされます。\n続行しますか?';

  @override
  String get exitApp => 'アプリ終了';

  @override
  String get exitAppConfirm => 'アプリを終了しますか?';

  @override
  String get gameGuide => '遊び方';

  @override
  String get guideOverview => 'ゲーム概要';

  @override
  String get guideOverviewText =>
      'マイティは5人で遊ぶトリックテイキングカードゲームです。宣言者(1人)とフレンド(1人)がチームを組み、守備チーム(3人)と対戦します。';

  @override
  String get guideBidding => 'ビッディング';

  @override
  String get guideBiddingText =>
      '• 各プレイヤーは獲得する得点カードの数を宣言します\n• 最高ビッドのプレイヤーが宣言者になります\n• 宣言者は切り札を決めます';

  @override
  String get guideSpecialCards => '特殊カード';

  @override
  String get guideSpecialCardsText =>
      '• マイティ: スペードのA (最強のカード)\n• ジョーカー: 2番目に強いカード\n• 切り札: 宣言者が選んだスート';

  @override
  String get guideFriend => 'フレンド';

  @override
  String get guideFriendText =>
      '• 宣言者は特定のカードを持つ人をフレンドに指定します\n• フレンドは正体を隠すことができます\n• ジョーカーコール: 特定の3を持つ人をフレンドに指定';

  @override
  String get guideScoring => 'スコア計算';

  @override
  String get guideScoringText =>
      '• 得点カード: A, K, Q, J, 10 (各1点、合計20点)\n• 宣言者チームが目標点数以上で勝利\n• 勝者は+点、敗者は-点';

  @override
  String get guideTips => 'ゲームのコツ';

  @override
  String get guideTipsText =>
      '• マイティとジョーカーは常に強力です\n• 切り札を上手く使いましょう\n• フレンドの正体を見抜くことが重要です';

  @override
  String get close => '閉じる';

  @override
  String get hint => 'ヒント';

  @override
  String get enableHintQuestion => 'ヒントを有効にしますか？';

  @override
  String get newGameConfirm => '新しいゲームを始めますか？';

  @override
  String get dealMiss => 'ディールミス';

  @override
  String get dealMissTitle => 'ディールミス宣言';

  @override
  String get dealMissConfirm => 'ディールミスを宣言しますか?\n手札を公開して新しく始めます。';

  @override
  String dealMissAnnouncement(String name) {
    return '$name ディールミス宣言!';
  }

  @override
  String get dealMissNewGame => 'ディールミスでゲームを再開します。';

  @override
  String get aiPlayer1 => '太郎';

  @override
  String get aiPlayer2 => '花子';

  @override
  String get aiPlayer3 => '健太';

  @override
  String get aiPlayer4 => '美咲';

  @override
  String get scoreCalcWin => 'スコア計算 (勝利)';

  @override
  String get scoreCalcLose => 'スコア計算 (敗北)';

  @override
  String get scoreFormula => '(得点-契約+1) + (得点-最小)×2';

  @override
  String get scoreFormulaLose => '-(契約 - 得点)';

  @override
  String get scoreMultipliers => '宣言者 ×2, フレンド ×1, 守備 ×(-1)';

  @override
  String get multiplierRun => 'ラン ×2';

  @override
  String get multiplierNoGiruda => 'ノートランプ ×2';

  @override
  String get multiplierNoFriend => 'ノーフレンド ×2';

  @override
  String get multiplierBackRun => 'バックラン ×2';

  @override
  String get multiplierLabel => '倍率';

  @override
  String get selectGame => 'ゲーム選択';

  @override
  String get sevenCardTitle => 'セブンポーカー';

  @override
  String get sevenCardSubtitle => '7枚カードポーカーゲーム';

  @override
  String get sevenCardRules => 'ゲームルール';

  @override
  String get sevenCardRulesText =>
      '• 各プレイヤーは7枚のカードを受け取ります\n• 最初の3枚は非公開、残り4枚は公開\n• ベッティングラウンドを経て最終5枚で役を作ります\n• 最も高い役を持つプレイヤーが勝利';

  @override
  String get pot => 'ポット';

  @override
  String get currentBet => '現在のベット';

  @override
  String get betting => 'ラウンド';

  @override
  String get chips => 'チップ';

  @override
  String get bet => 'ベット';

  @override
  String get fold => 'ダイ';

  @override
  String get call => 'コール';

  @override
  String get raise => 'レイズ';

  @override
  String get check => 'チェック';

  @override
  String get allIn => 'オールイン';

  @override
  String get folded => 'ダイ';

  @override
  String get wins => '勝利';

  @override
  String get betPing => 'ビン';

  @override
  String get betDdadang => 'タダン';

  @override
  String get betQuarter => 'クォーター';

  @override
  String get betHalf => 'ハーフ';

  @override
  String get betFull => 'フル';

  @override
  String get betDie => 'ダイ';

  @override
  String get selectCardToReveal => '公開するカードを選んでください';

  @override
  String get selectedCardWillBeRevealed => '選択したカードが相手に公開されます';

  @override
  String get totalBet => '合計';

  @override
  String get bonus => 'ボーナス';

  @override
  String get finalResult => '最終結果';

  @override
  String get viewResultButton => '結果を見る';

  @override
  String get hintOff => 'ヒント OFF';

  @override
  String get playerLabel => 'プレイヤー';

  @override
  String get thisGame => '今回';

  @override
  String get cumulative => '累計';

  @override
  String get bettingAmount => 'ベット';

  @override
  String get otherPlayersBonus => '他プレイヤー';

  @override
  String get gameEnd => 'ゲーム終了';

  @override
  String get hiLoTitle => 'ハイロー';

  @override
  String get hiLoSubtitle => 'ハイ/ロースプリットポーカー';

  @override
  String get hi => 'ハイ';

  @override
  String get lo => 'ロー';

  @override
  String get swing => 'スイング';

  @override
  String get selectHiLo => 'ハイ/ロー選択';

  @override
  String get selectHiLoDesc => 'ハイ、ロー、またはスイングを選択';

  @override
  String get hiWinner => 'ハイ勝者';

  @override
  String get loWinner => 'ロー勝者';

  @override
  String get swingSuccess => 'スイング成功！';

  @override
  String get swingFailed => 'スイング失敗';

  @override
  String get hiPot => 'ハイポット';

  @override
  String get loPot => 'ローポット';

  @override
  String get noLowHand => 'ローなし';

  @override
  String get bestLow => 'ベストロー';

  @override
  String get waitingForHiLo => '選択待ち...';

  @override
  String get selectedHi => 'ハイ選択';

  @override
  String get selectedLo => 'ロー選択';

  @override
  String get selectedSwing => 'スイング選択';

  @override
  String get showdownTitle => '宣言状況';

  @override
  String get showdownDesc => '各プレイヤーの選択を確認してください';

  @override
  String get viewResults => '結果を見る';

  @override
  String get finalResults => '最終結果';

  @override
  String get sevenCardGuideOverview => 'ゲーム概要';

  @override
  String get sevenCardGuideOverviewText =>
      'セブンカードポーカーは5人でプレイするポーカーゲームです。7枚のカードから5枚で最高の役を作って勝利しましょう。';

  @override
  String get sevenCardGuideDealing => 'カード配布';

  @override
  String get sevenCardGuideDealingText =>
      '• 最初に4枚を受け取ります（3枚伏せ、1枚オープン）\n• ベッティング後に1枚ずつオープンカードを受け取ります\n• 最終的に7枚から5枚で役を作ります';

  @override
  String get sevenCardGuideBetting => 'ベッティングルール';

  @override
  String get sevenCardGuideBettingText =>
      '• チェック: ベットなしでパス\n• コール: 現在のベットに合わせる\n• レイズ: ベット額を上げる\n• ダイ: ゲームを降りる\n• オールイン: 全チップをベット';

  @override
  String get sevenCardGuideHands => '役のランキング';

  @override
  String get sevenCardGuideHandsText =>
      '1. ロイヤルストレートフラッシュ\n2. バックストレートフラッシュ\n3. ストレートフラッシュ\n4. フォーカード\n5. フルハウス\n6. フラッシュ\n7. マウンテン (A-K-Q-J-10)\n8. バックストレート (A-2-3-4-5)\n9. ストレート\n10. スリーカード\n11. ツーペア\n12. ワンペア\n13. ハイカード';

  @override
  String get sevenCardGuideTips => 'ゲームのコツ';

  @override
  String get sevenCardGuideTipsText =>
      '• オープンカードから相手の役を予測しましょう\n• 強い手でなければ過度なベットを避けましょう\n• ブラフも戦略です';

  @override
  String get sevenCardGuideBonus => 'ボーナスハンド';

  @override
  String get sevenCardGuideBonusText =>
      '• ロイヤルストレートフラッシュ: 500チップ\n• バックストレートフラッシュ: 300チップ\n• ストレートフラッシュ: 200チップ\n• フォーカード: 100チップ\n\nボーナスハンド達成時、他の全プレイヤーからボーナスを獲得！';

  @override
  String get hiLoGuideOverview => 'ゲーム概要';

  @override
  String get hiLoGuideOverviewText =>
      'ハイローはセブンカードポーカーの変形で、ポットがハイ（高い役）とロー（低い役）の勝者に分けられます。';

  @override
  String get hiLoGuideDealing => 'カード配布';

  @override
  String get hiLoGuideDealingText =>
      '• セブンカードポーカーと同じ方式で進行\n• 7枚のカードから5枚で役を作ります\n• 最後のベット後にハイ/ロー/スイングを選択';

  @override
  String get hiLoGuideHiLo => 'ハイ/ロー選択';

  @override
  String get hiLoGuideHiLoText =>
      '• ハイ: 最高の役で競争\n• ロー: 最低の役で競争\n• スイング: ハイとロー両方に挑戦\n\nポットの50%はハイ勝者、50%はロー勝者が獲得。';

  @override
  String get hiLoGuideLow => 'ロー役のルール';

  @override
  String get hiLoGuideLowText =>
      '• ストレート/フラッシュのない手のみ資格あり\n• 低いほど良い（Aが最低）\n• 最強ロー: A-2-3-4-6\n• ペアなしの手が有利';

  @override
  String get hiLoGuideSwing => 'スイングルール';

  @override
  String get hiLoGuideSwingText =>
      '• 7枚を2つの5枚の手に分けます\n• ハイとロー両方で1位になる必要があります\n• 成功: ポット全体を獲得\n• 失敗: その部分は他の勝者へ';

  @override
  String get hiLoGuideTips => 'ゲームのコツ';

  @override
  String get hiLoGuideTipsText =>
      '• A-2-3-4のような低いカードはローに有利\n• スイングはリスクがありますが成功すれば大きな報酬\n• 相手のカードを見て戦略を立てましょう';

  @override
  String get hiLoGuideBonus => 'ボーナスハンド';

  @override
  String get hiLoGuideBonusText =>
      '• ロイヤルストレートフラッシュ: 500チップ\n• バックストレートフラッシュ: 300チップ\n• ストレートフラッシュ: 200チップ\n• フォーカード: 100チップ\n\nボーナスハンド達成時、自動的にポット全体を獲得！';

  @override
  String get hulaTitle => 'フラ';

  @override
  String get hulaSubtitle => '4人用ラミーカードゲーム';

  @override
  String get heartsTitle => 'ハーツ';

  @override
  String get heartsSubtitle => '4人トリックテイキングゲーム';

  @override
  String get register => '登録';

  @override
  String get discardCard => '捨てる';

  @override
  String get stopGame => 'ストップ';

  @override
  String get drawCard => 'カードを引いてください';

  @override
  String get discardOrRegister => 'カードを捨てるか登録してください';

  @override
  String get noCards => 'カードがありません';

  @override
  String get addedToMeld => 'メルドに追加しました';

  @override
  String get noMeldToAttach => '付けるメルドがありません';

  @override
  String get invalidCombination => '無効な組み合わせです';

  @override
  String get drawFirst => '先にカードを引いてください';

  @override
  String get selectCardToDiscard => '捨てるカードを選んでください';

  @override
  String get victory => '勝利！';

  @override
  String get defeat => '敗北';

  @override
  String get hulaVictory => 'フラで勝利！(x2)';

  @override
  String get handCards => '手札';

  @override
  String get myTurn => '自分の番';

  @override
  String get start => '開始';

  @override
  String get discardedCards => '捨てたカード';

  @override
  String get thankYou => 'タンキュー';

  @override
  String get selectMethod => '方法を選んでください';

  @override
  String get register7Alone => '7を単独登録';

  @override
  String get attachToMyMeld => '自分のメルドに付ける';

  @override
  String get attachToOtherMeld => 'メルドに付ける';

  @override
  String get gameRules => 'ゲームルール';

  @override
  String get objective => '目標';

  @override
  String get objectiveDesc => '手札のカードをすべて登録または捨てて最初になくすことが目標です。';

  @override
  String get howToPlay => '進め方';

  @override
  String get howToPlayDesc => '毎ターン、デッキまたは捨て札からカード1枚を引き、登録または捨てます。';

  @override
  String get meldTypes => 'メルドの種類';

  @override
  String get thankYouMeld => 'タンキューメルド';

  @override
  String get thankYouMeldDesc => '捨て札から7を引くと「タンキュー」を宣言して特別な登録ができます。';

  @override
  String get stopRule => 'ストップ';

  @override
  String get stopRuleDesc => 'いつでもストップを宣言してゲームを終了できます。残りカードの点数が最も少ない人が勝ちです。';

  @override
  String get scoring => '点数計算';

  @override
  String aiStartsFirst(Object name) {
    return '$nameが先に開始';
  }

  @override
  String xWins(Object name) {
    return '$nameの勝利！';
  }

  @override
  String nMelds(Object count) {
    return '$count個メルド';
  }

  @override
  String attachedToMeldSelf(Object card) {
    return '$cardをメルドに追加';
  }

  @override
  String attachedToMeldPlayer(Object card) {
    return '$cardをプレイヤーのメルドに追加';
  }

  @override
  String attachedToMeldOther(Object card, Object name) {
    return '$cardを$nameのメルドに追加';
  }

  @override
  String drewCard(Object name) {
    return '$nameがカードを引いた';
  }

  @override
  String thankYouAttachSelf(Object card) {
    return 'タンキュー！$cardを自分のメルドに';
  }

  @override
  String thankYouAttachOther(Object card, Object name) {
    return 'タンキュー！$cardを$nameのメルドに';
  }

  @override
  String nPlayersHula(Object n) {
    return 'フラ（$n人）';
  }

  @override
  String nCards(Object n) {
    return '$n枚';
  }

  @override
  String get heartsBreaking => 'ハートブレイキング';

  @override
  String get cardPass => 'カードパス';

  @override
  String trickNum(Object n) {
    return 'トリック$n/13';
  }

  @override
  String passToLeft(Object n) {
    return '左へパス ($n/3)';
  }

  @override
  String get selectCardsToPass => '左に渡すカード3枚を選んでください';

  @override
  String get allPointsExhausted => '得点カード終了！ゲーム終了';

  @override
  String get passRecommend => 'パス推奨';

  @override
  String get recommend => '推奨';

  @override
  String get hintEnabled => 'ヒントが有効になりました！';

  @override
  String get oneCard => 'ワンカード';

  @override
  String oneCardTitle(Object n) {
    return 'ワンカード（$n人）';
  }

  @override
  String get oneCardCall => 'ワンカード！';

  @override
  String oneCardCountdown(Object n) {
    return 'ワンカード（$n秒）';
  }

  @override
  String get cannotPlayCard => 'このカードは出せません';

  @override
  String attackReceived(Object n) {
    return '攻撃で$n枚を受けました';
  }

  @override
  String get drewCardMsg => 'カードを引きました';

  @override
  String bankruptcy(Object n) {
    return '破産！（$n枚所持）';
  }

  @override
  String get selectSuit => 'スートを選んでください';

  @override
  String get clockwise => '時計回り';

  @override
  String get counterClockwise => '反時計回り';

  @override
  String get blackJoker => '白黒ジョーカー';

  @override
  String get colorJoker => 'カラージョーカー';

  @override
  String get winRate => '勝率';

  @override
  String get rulesObjective => '目標';

  @override
  String get rulesHowToPlay => '遊び方';

  @override
  String get rulesScoring => '得点計算';

  @override
  String get rulesTips => 'ヒント';

  @override
  String get rulesAttackCards => '攻撃カード';

  @override
  String get rulesDefense => '防御';

  @override
  String get rulesSpecialCards => '特殊カード';

  @override
  String get restart => '再スタート';

  @override
  String totalAttack(int n) {
    return '$n枚攻撃';
  }

  @override
  String get skipNextTurn => '次のターンスキップ';

  @override
  String get reverseDirection => '方向反転';

  @override
  String get skipTwoTurns => '2ターンスキップ';

  @override
  String get changeSuit => 'スート変更';

  @override
  String playerPlayedCard(String name) {
    return '$nameがカードを出した';
  }

  @override
  String attackReceivedShort(int n) {
    return '攻撃で$n枚';
  }

  @override
  String get drewCardShort => 'カードを引いた';

  @override
  String bankruptcyShort(int n) {
    return '破産！（$n枚）';
  }

  @override
  String get heartsGuideObjectiveTitle => '目的';

  @override
  String get heartsGuideObjective => 'ハートとスペードのクイーンを避けて最低点を目指しましょう。';

  @override
  String get heartsGuideHowToPlayTitle => '遊び方';

  @override
  String get heartsGuideHowToPlay =>
      '• 4人で各13枚ずつ配ります\n• 開始時に左のプレイヤーに3枚渡します\n• クラブの2を持つ人が先攻\n• 13トリックで得点カードを避けます';

  @override
  String get heartsGuideScoringTitle => '得点計算';

  @override
  String get heartsGuideScoring =>
      '• ハート: 各1点（計13点）\n• スペードのクイーン (♠Q): 13点\n• 合計: 26点\n• 最低点が勝ち！';

  @override
  String get heartsGuideBreakingTitle => 'ハートブレイク';

  @override
  String get heartsGuideBreaking => '最初のトリックではハートを出せません。\nハートが一度出た後からリードできます。';

  @override
  String get heartsGuideShootMoonTitle => 'シュート・ザ・ムーン';

  @override
  String get heartsGuideShootMoon =>
      '1人が全てのハートとスペードのクイーンを取ると:\n• そのプレイヤー: 0点\n• 他のプレイヤー: 各26点';

  @override
  String get heartsGuideTipsTitle => '戦略のヒント';

  @override
  String get heartsGuideTips =>
      '• 高いカードは早めに捨てましょう\n• スペードのクイーンに注意\n• 相手に得点カードを取らせましょう';

  @override
  String get onecardGuideObjectiveTitle => '目的';

  @override
  String get onecardGuideObjective => '手札のカードを最初に全て出し切ることが目標です。';

  @override
  String get onecardGuidePlayCardTitle => 'カードの出し方';

  @override
  String get onecardGuidePlayCard => '前に出されたカードと同じスートか同じ数字のカードを出せます。';

  @override
  String get onecardGuideAttackTitle => '攻撃カード';

  @override
  String get onecardGuideAttack =>
      '• 2: +2枚攻撃\n• A: +3枚攻撃 (♠Aは+5枚)\n• ジョーカー: +5枚(白黒) / +7枚(カラー)';

  @override
  String get onecardGuideSpecialTitle => '特殊カード';

  @override
  String get onecardGuideSpecial =>
      '• J: 次の順番をスキップ\n• Q: 方向を反転\n• K: 2ターンスキップ\n• 7: スート変更';

  @override
  String get onecardGuideJokerDefenseTitle => 'ジョーカー防御';

  @override
  String get onecardGuideJokerDefense => 'ジョーカーで攻撃されたらジョーカーでしか防御できません。';

  @override
  String get onecardGuideOneCardTitle => 'ワンカード！';

  @override
  String get onecardGuideOneCard =>
      '手札が1枚になったら「ワンカード！」ボタンを押す必要があります。\n押さないとペナルティで2枚引きます。';

  @override
  String get onecardGuideBankruptTitle => '破産';

  @override
  String get onecardGuideBankrupt => '手札が20枚以上になると破産！カードが最も少ないプレイヤーが勝ちます。';

  @override
  String get hulaGuideObjectiveTitle => '目的';

  @override
  String get hulaGuideObjective => '手札のカードを全てメルドか捨てて最初になくすことが目標です。';

  @override
  String get hulaGuideHowToPlayTitle => '遊び方';

  @override
  String get hulaGuideHowToPlay => '毎ターン、デッキか捨て札から1枚引いて、メルドか捨てます。';

  @override
  String get hulaGuideMeldTypesTitle => 'メルドの種類';

  @override
  String get hulaGuideMeldTypes =>
      '• ラン: 同じスートの連続した数字3枚以上 (例: ♠3-4-5)\n• グループ: 同じ数字で異なるスート3枚以上 (例: ♠7-♥7-♦7)';

  @override
  String get hulaGuideSevenRuleTitle => '7の特別ルール';

  @override
  String get hulaGuideSevenRule => '7は単独でメルドできます。';

  @override
  String get hulaGuideThankYouTitle => 'サンキュー';

  @override
  String get hulaGuideThankYou => '捨て札から7を引くと「サンキュー」と言って特別なメルドができます。';

  @override
  String get hulaGuideStopTitle => 'ストップ';

  @override
  String get hulaGuideStop =>
      'いつでもストップを宣言してゲームを終了できます。\n残りカードのポイントが最も低い人が勝ちです。';

  @override
  String get hulaGuideCardPointsTitle => 'カードポイント';

  @override
  String get hulaGuideCardPoints => 'A=1点, 2~9=数字点, J=10点, Q=11点, K=12点';

  @override
  String get hulaGuideScoringTitle => '得点計算';

  @override
  String get hulaGuideScoring =>
      '• 勝者: 他プレイヤーとの差の合計を獲得\n• 敗者: 勝者との差分を減点\n• フーラ(メルドなしで勝利): ポイント2倍';

  @override
  String get hulaGuideStopPenaltyTitle => 'ストップ失敗ペナルティ';

  @override
  String get hulaGuideStopPenalty =>
      'ストップしたが最低点でない場合:\n• 勝者が得るポイント全てをストップした人が負担\n• 他のプレイヤーは減点なし';

  @override
  String thankYouRegisterAlone(String card) {
    return 'サンキュー！$card 単独登録';
  }

  @override
  String thankYouAttachToMyMeld(String card) {
    return 'サンキュー！$card 自分のメルドに追加';
  }

  @override
  String thankYouAttachToOtherMeld(String card, String playerName) {
    return 'サンキュー！$card $playerNameのメルドに追加';
  }

  @override
  String thankYouNewMeld(String description) {
    return 'サンキュー！$description';
  }

  @override
  String get onecardGuideInGameObjective =>
      '最初に全てのカードを出した人が勝ちです。\n最後の1枚を出す前に「ワンカード」と宣言してください。';

  @override
  String get onecardGuideHowToPlayInGame =>
      '同じスートか同じ数字のカードを出せます。\n出せない場合はデッキからカードを引きます。';

  @override
  String get onecardGuideDefenseTitle => '防御';

  @override
  String get onecardGuideDefense => '攻撃されたら同じ攻撃カードで防げます。\n防ぐと攻撃が累積して次の人に回ります。';

  @override
  String get onecardGuideTipsTitle => 'ゲームのコツ';

  @override
  String get onecardGuideTips =>
      '• 攻撃カードは防御用に取っておきましょう\n• ワンカードを言わないと2枚ペナルティ！\n• 20枚以上になると破産負け';

  @override
  String get handRoyalStraightFlush => 'ロイヤルストレートフラッシュ';

  @override
  String get handBackStraightFlush => 'バックストレートフラッシュ';

  @override
  String get handStraightFlush => 'ストレートフラッシュ';

  @override
  String get handFourOfAKind => 'フォーカード';

  @override
  String get handFullHouse => 'フルハウス';

  @override
  String get handFlush => 'フラッシュ';

  @override
  String get handMountain => 'マウンテン';

  @override
  String get handBackStraight => 'バックストレート';

  @override
  String get handStraight => 'ストレート';

  @override
  String get handTriple => 'スリーカード';

  @override
  String get handTwoPair => 'ツーペア';

  @override
  String get handOnePair => 'ワンペア';

  @override
  String get handHighCard => 'ハイカード';

  @override
  String highCardTop(String rank) {
    return '$rankトップ';
  }

  @override
  String get noLow => 'ロー無し';
}
