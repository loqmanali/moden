import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modn/core/services/di.dart';
import 'package:modn/features/authentication/cubit/login_cubit.dart';
import 'package:modn/features/events/models/active_event_model.dart';
import 'package:modn/features/events/screen/events_screen.dart';
import 'package:modn/features/events/screen/workshops_screen.dart';
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

  /// Workshops routes
  static const String workshops = '/workshops';

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
        return BlocProvider(
          create: (context) => di<LoginCubit>(),
          child: const LoginScreen(),
        );
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

    /// Event routes
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      name: AppNavigations.workshops,
      path: AppNavigations.workshops,
      builder: (context, state) {
        final extra = state.extra;
        EventDetails? event;
        if (extra is EventDetails) {
          event = extra;
        } else if (extra is Map<String, dynamic>) {
          event = EventDetails.fromJson(extra);
        } else if (extra is Map) {
          event = EventDetails.fromJson(Map<String, dynamic>.from(extra));
        }
        if (event == null) {
          return const EventsScreen();
        }
        // final List<EventWorkshop> workshops;
        // if (extra is List<EventWorkshop>) {
        //   workshops = extra;
        // } else if (extra is List) {
        //   workshops = extra
        //       .map((e) {
        //         if (e is EventWorkshop) return e;
        //         if (e is Map<String, dynamic>) {
        //           return EventWorkshop.fromJson(e);
        //         }
        //         return null;
        //       })
        //       .whereType<EventWorkshop>()
        //       .toList(growable: false);
        // } else {
        //   workshops = const <EventWorkshop>[];
        // }
        return WorkshopsScreen(event: event);
      },
    ),

    /// QR routes
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      name: AppNavigations.qr,
      path: AppNavigations.qr,
      builder: (context, state) {
        final type = state.queryParameters['type'] ?? 'event';
        final workshopId = state.queryParameters['workshopId'];
        return QrScreen(
          type: type,
          workshopId: workshopId,
        );
      },
    ),

    /// QR accepted routes
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      name: AppNavigations.qrAccepted,
      path: AppNavigations.qrAccepted,
      builder: (context, state) {
        final type = state.queryParameters['type'] ?? 'event';
        final workshopId = state.queryParameters['workshopId'];
        return AcceptedScreen(
          type: type,
          workshopId: workshopId,
        );
      },
    ),

    /// QR rejected routes
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      name: AppNavigations.qrRejected,
      path: AppNavigations.qrRejected,
      builder: (context, state) {
        final type = state.queryParameters['type'] ?? 'event';
        final workshopId = state.queryParameters['workshopId'];
        return RejectedScreen(
          type: type,
          workshopId: workshopId,
        );
      },
    ),
  ],
);
