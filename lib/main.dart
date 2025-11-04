import 'package:dynamic_path_url_strategy/dynamic_path_url_strategy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:modn/core/services/di.dart';
import 'package:modn/core/utils/app_system_ui.dart';
import 'package:modn/core/utils/state_management_observability.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/config/remote_config_service.dart';

import 'app/app.dart';

void main() async {
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

  runApp(
    const App(),
  );
}
