import 'package:flutter/widgets.dart';

import '../generated/app_localizations.dart';
import '../localization.dart';

class L10nListener extends StatefulWidget {
  const L10nListener({super.key, required this.child});

  final Widget child;

  @override
  State<L10nListener> createState() => _L10nListenerState();
}

class _L10nListenerState extends State<L10nListener> {
  Locale? _cachedLocale;
  AppLocalizations? _cachedLocalization;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final localization = AppLocalizations.of(context);

    final shouldUpdate = _cachedLocale != locale ||
        (_cachedLocalization == null) ||
        (_cachedLocalization != null &&
            !_identicalLocalizations(_cachedLocalization!, localization));

    if (shouldUpdate) {
      _cachedLocale = locale;
      _cachedLocalization = localization;
    }

    L10n.init(context);
    return KeyedSubtree(
      key: ValueKey(locale.toLanguageTag()),
      child: widget.child,
    );
  }

  bool _identicalLocalizations(
    AppLocalizations previous,
    AppLocalizations current,
  ) {
    return identical(previous, current);
  }
}
