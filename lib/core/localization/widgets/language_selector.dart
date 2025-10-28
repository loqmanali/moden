import 'package:flutter/material.dart';

import '../localization.dart';

/// A widget to select language in settings
class LanguageSelector extends StatelessWidget {
  /// Callback when language changes
  final Function(Locale) onChanged;

  const LanguageSelector({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            context.l10n.appTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 8),
        ...Localization.supportedLocales.map((locale) {
          final isSelected = currentLocale.languageCode == locale.languageCode;

          return ListTile(
            leading: Text(
              Localization.getLanguageFlag(locale.languageCode),
              style: const TextStyle(fontSize: 24),
            ),
            title: Text(Localization.getLanguageName(locale.languageCode)),
            trailing: isSelected
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () {
              if (!isSelected) {
                onChanged(locale);
              }
            },
          );
        }),
      ],
    );
  }
}

/// A simple language toggle for the app bar
class LanguageToggle extends StatelessWidget {
  /// Callback when language changes
  final Function(Locale) onChanged;

  const LanguageToggle({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);

    return IconButton(
      icon: Text(
        L10n.isArabic ? 'EN' : 'عربي',
        style: const TextStyle(fontSize: 24),
      ),
      tooltip: context.l10n.appTitle,
      onPressed: () {
        // Toggle between English and Spanish (or other available locales)
        final supportedLocales = Localization.supportedLocales;
        final currentIndex = supportedLocales.indexWhere(
            (locale) => locale.languageCode == currentLocale.languageCode);
        final nextIndex = (currentIndex + 1) % supportedLocales.length;
        onChanged(supportedLocales[nextIndex]);
      },
    );
  }
}
