import 'package:flutter/widgets.dart';
import 'generated/app_localizations.dart';
import 'generated/app_localizations_ko.dart';
import '../models/seven_card/poker_hand.dart';

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
