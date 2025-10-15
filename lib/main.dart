import 'package:dynamic_path_url_strategy/dynamic_path_url_strategy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/theme.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:modn/app/app_wrapper.dart';
import 'package:modn/core/design_system/theme/moden_theme.dart';
import 'package:modn/core/routes/app_navigators.dart';
import 'package:modn/core/services/di.dart';
import 'package:modn/core/utils/app_system_ui.dart';
import 'package:modn/core/utils/state_management_observability.dart';

void main() async {
  // Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
//   await Firebase.initializeApp(
// // Uncomment the following line if you have a custom Firebase options file
//     // options: DefaultFirebaseOptions.currentPlatform,
//   );

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
  setupDependencies();

  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    AppSystemUi.setSystemUIWithoutContext(isDark: true);
  }

  runApp(
    const MyApp(),
  );
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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Moden',
        theme: ModenTheme.lightEx(),
        darkTheme: ModenTheme.darkEx(),
        themeMode: ThemeMode.light,
        scrollBehavior: NoStretchScrollBehavior(),
        builder: (context, child) {
          final brightness = MediaQuery.maybeOf(context)?.platformBrightness ??
              Brightness.light;
          final fTheme = brightness == Brightness.dark
              ? ModenTheme.dark
              : ModenTheme.light;
          final baseChild = FAnimatedTheme(data: fTheme, child: child!);

          if (kIsWeb) {
            return LayoutBuilder(
              builder: (context, constraints) {
                const double targetWidth = 430;
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
    );
  }
}
