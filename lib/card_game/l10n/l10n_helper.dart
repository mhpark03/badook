import 'package:flutter/widgets.dart';
import 'generated/app_localizations.dart';
import 'generated/app_localizations_ko.dart';
import '../models/seven_card/poker_hand.dart';
import '../models/hi_lo/hi_lo_state.dart';
import '../models/hi_lo/hi_lo_hand.dart';

// Re-export AppLocalizations for type usage
export 'generated/app_localizations.dart' show AppLocalizations;

/// AppLocalizations.of(context)가 null을 반환할 때 한국어 폴백을 제공하는 헬퍼
AppLocalizations getL10n(BuildContext context) {
  return AppLocalizations.of(context) ?? AppLocalizationsKo();
}

/// 포커 족보 이름 반환
String getHandRankName(BuildContext context, HandRank rank) {
  final l10n = getL10n(context);
  switch (rank) {
    case HandRank.royalStraightFlush:
      return l10n.handRoyalStraightFlush;
    case HandRank.backStraightFlush:
      return l10n.handBackStraightFlush;
    case HandRank.straightFlush:
      return l10n.handStraightFlush;
    case HandRank.fourOfAKind:
      return l10n.handFourOfAKind;
    case HandRank.fullHouse:
      return l10n.handFullHouse;
    case HandRank.flush:
      return l10n.handFlush;
    case HandRank.mountain:
      return l10n.handMountain;
    case HandRank.backStraight:
      return l10n.handBackStraight;
    case HandRank.straight:
      return l10n.handStraight;
    case HandRank.triple:
      return l10n.handTriple;
    case HandRank.twoPair:
      return l10n.handTwoPair;
    case HandRank.onePair:
      return l10n.handOnePair;
    case HandRank.highCard:
      return l10n.handHighCard;
  }
}

/// 포커 족보 표시 이름 반환 (하이카드는 X탑 형식)
String getHandRankDisplayName(BuildContext context, PokerHand? hand) {
  if (hand == null) return '';
  final l10n = getL10n(context);

  if (hand.rank == HandRank.highCard) {
    final highCard = hand.tiebreakers.isNotEmpty ? hand.tiebreakers.first : 0;
    return l10n.highCardTop(_getRankSymbol(highCard));
  }

  return getHandRankName(context, hand.rank);
}

String _getRankSymbol(int rankValue) {
  switch (rankValue) {
    case 14: return 'A';
    case 13: return 'K';
    case 12: return 'Q';
    case 11: return 'J';
    case 10: return '10';
    default: return '$rankValue';
  }
}

/// 라운드 전환 메시지 반환
String getRoundTransitionMessage(BuildContext context, int round) {
  final l10n = getL10n(context);
  final roundComplete = l10n.roundComplete(round);
  String cardDistribution;
  switch (round) {
    case 1:
      cardDistribution = l10n.cardDistribution5;
      break;
    case 2:
      cardDistribution = l10n.cardDistribution6;
      break;
    case 3:
      cardDistribution = l10n.cardDistribution7;
      break;
    default:
      cardDistribution = '';
  }
  return '$roundComplete\n$cardDistribution\n\n${l10n.goodLuck}';
}

/// 로우 핸드 표시 이름 반환
String getLowHandDisplayName(BuildContext context, LowHand? hand) {
  if (hand == null || !hand.isQualified) return getL10n(context).noLow;
  if (hand.cardRanks.isEmpty) return getL10n(context).noLow;

  final l10n = getL10n(context);
  final highCard = hand.cardRanks.last;

  String rankName;
  if (highCard == 1) {
    rankName = 'A';
  } else if (highCard == 11) {
    rankName = 'J';
  } else if (highCard == 12) {
    rankName = 'Q';
  } else if (highCard == 13) {
    rankName = 'K';
  } else {
    rankName = highCard.toString();
  }

  return l10n.highCardTop(rankName);
}

/// 하이/로우/스윙 선택 이름 반환
String getHiLoChoiceName(BuildContext context, HiLoChoice choice) {
  final l10n = getL10n(context);
  switch (choice) {
    case HiLoChoice.hi:
      return l10n.hi;
    case HiLoChoice.lo:
      return l10n.lo;
    case HiLoChoice.swing:
      return l10n.swing;
    case HiLoChoice.none:
      return '';
  }
}

/// 베팅 액션 이름 반환 (문자열 기반) - AI 추천용
String getBettingActionNameFromString(BuildContext context, String action) {
  final l10n = getL10n(context);
  switch (action) {
    case 'bing':
      return l10n.betPing;
    case 'check':
      return l10n.betCheck;
    case 'call':
      return l10n.betCall;
    case 'ddadang':
      return l10n.betDdadang;
    case 'quarter':
      return l10n.betQuarter;
    case 'half':
      return l10n.betHalf;
    case 'full':
      return l10n.betFull;
    case 'die':
      return l10n.betDie;
    default:
      return action;
  }
}
