import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:modn/core/design_system/theme/moden_theme.dart';
import 'package:modn/core/localization/bloc/locale_bloc.dart';
import 'package:modn/core/routes/app_navigators.dart';

import '../core/localization/generated/app_localizations.dart';
import '../core/localization/widgets/l10n_listener.dart';
import 'app_wrapper.dart';

/// Main App widget that configures the application using BLoC pattern.
class App extends StatelessWidget {
  /// Creates a new App instance.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      child: BlocProvider(
        create: (context) => LocaleBloc(),
        child: Builder(
          builder: (context) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Moden',
            theme: ModenTheme.lightEx(),
            darkTheme: ModenTheme.darkEx(),
            themeMode: ThemeMode.light,
            scrollBehavior: NoStretchScrollBehavior(),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            locale: context.watch<LocaleBloc>().state.locale,
            builder: (context, child) {
              final brightness =
                  MediaQuery.maybeOf(context)?.platformBrightness ??
                      Brightness.light;
              final fTheme = brightness == Brightness.dark
                  ? ModenTheme.dark
                  : ModenTheme.light;
              final baseChild = L10nListener(
                child: FAnimatedTheme(
                  data: fTheme,
                  child: child!,
                ),
              );

              if (kIsWeb) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    const double targetWidth = 450;
                    return Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: targetWidth,
                        height: constraints.maxHeight,
                        child: baseChild,
                      ),
                    );
                  },
                );
              }

              return baseChild;
            },
            routerConfig: router,
          ),
        ),
      ),
    );
  }
}

class NoStretchScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
