import 'package:flutter/widgets.dart';
import 'generated/app_localizations.dart';
import 'generated/app_localizations_ko.dart';

// Re-export AppLocalizations for type usage
export 'generated/app_localizations.dart' show AppLocalizations;

/// AppLocalizations.of(context)가 null을 반환할 때 한국어 폴백을 제공하는 헬퍼
AppLocalizations getL10n(BuildContext context) {
  return AppLocalizations.of(context) ?? AppLocalizationsKo();
}
