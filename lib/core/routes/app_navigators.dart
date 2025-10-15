import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modn/features/events/screen/events_screen.dart';
import 'package:modn/features/qr/screen/accepted_screen.dart';
import 'package:modn/features/qr/screen/qr_screen.dart';
import 'package:modn/features/qr/screen/rejected_screen.dart';
import 'package:modn/features/splash/splash_screen.dart';

import '../../features/authentication/views/login_screen.dart';

class AppNavigations {
  static const String root = '/';
  static const String splash = '/splash';
  static const String login = '/login';

  /// Event routes
  static const String event = '/event';

  /// QR routes
  static const String qr = '/qr';

  /// QR accepted routes
  static const String qrAccepted = '/qr/accepted';

  /// QR rejected routes
  static const String qrRejected = '/qr/rejected';
}

final rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: AppNavigations.splash,
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: false,
  routes: [
    /// Root route - redirects to home
    GoRoute(
      name: AppNavigations.root,
      path: AppNavigations.root,
      redirect: (context, state) => AppNavigations.splash,
    ),

    /// Splash routes
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      name: AppNavigations.splash,
      path: AppNavigations.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    /// Auth routes
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      name: AppNavigations.login,
      path: AppNavigations.login,
      builder: (context, state) {
        return const LoginScreen();
      },
    ),

    /// Event routes
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      name: AppNavigations.event,
      path: AppNavigations.event,
      builder: (context, state) {
        return const EventsScreen();
      },
    ),

    /// QR routes
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      name: AppNavigations.qr,
      path: AppNavigations.qr,
      builder: (context, state) {
        return const QrScreen();
      },
    ),

    /// QR accepted routes
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      name: AppNavigations.qrAccepted,
      path: AppNavigations.qrAccepted,
      builder: (context, state) {
        return const AcceptedScreen();
      },
    ),

    /// QR rejected routes
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      name: AppNavigations.qrRejected,
      path: AppNavigations.qrRejected,
      builder: (context, state) {
        return const RejectedScreen();
      },
    ),
  ],
);
