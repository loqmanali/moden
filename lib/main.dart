import 'package:dynamic_path_url_strategy/dynamic_path_url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:modn/core/services/di.dart';
import 'package:modn/core/utils/app_system_ui.dart';
import 'package:modn/core/utils/state_management_observability.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app/app.dart';
import 'core/config/remote_config_service.dart';
import 'firebase_options.dart';

void main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://dd0b36efca3e4529f887869a888a5188@o374859.ingest.us.sentry.io/4510306900312064';
      // Adds request headers and IP for users, for more info visit:
      // https://docs.sentry.io/platforms/dart/guides/flutter/data-management/data-collected/
      options.sendDefaultPii = true;
      options.enableLogs = true;
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
      // Configure Session Replay
      options.replay.sessionSampleRate = 0.1;
      options.replay.onErrorSampleRate = 1.0;
    },
    appRunner: () async {
      // Initialize Flutter binding
      WidgetsFlutterBinding.ensureInitialized();
      // Initialize Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Initialize Remote Config before DI so services can read values
      await RemoteConfigService.initialize();

      // Initialize notification services
      // await notificationHandler.initialize();

      setPathUrlStrategy();

      // Initialize BLoC observer
      Bloc.observer = AppBlocObserver();

      // // Set system UI overlay style
      // SystemChrome.setSystemUIOverlayStyle(
      //   const SystemUiOverlayStyle(
      //     statusBarColor: Colors.transparent,
      //     statusBarIconBrightness: Brightness.dark,
      //     systemNavigationBarColor: Colors.white,
      //     systemNavigationBarIconBrightness: Brightness.dark,
      //   ),
      // );
      await setupDependencies();

      if (!kIsWeb) {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        AppSystemUi.setSystemUIWithoutContext(isDark: true);
      }

      runApp(SentryWidget(
        child: const App(),
      ));
    },
  );
}
