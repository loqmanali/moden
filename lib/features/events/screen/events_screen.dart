import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:modn/core/localization/localization.dart';
import 'package:modn/core/routes/app_navigators.dart';
import 'package:modn/core/services/di.dart';
import 'package:modn/core/widgets/app_scaffold.dart';
import 'package:modn/features/authentication/cubit/login_cubit.dart';
import 'package:modn/features/events/cubit/event_cubit.dart';
import 'package:modn/features/events/widgets/event_card.dart';

import '../../../core/widgets/adaptive_loading.dart';
import '../../../core/widgets/body_widget.dart';
import '../../../core/widgets/header_widget.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      header: HeaderEvent(),
      body: BodyEvent(),
    );
  }
}

class HeaderEvent implements Header {
  const HeaderEvent({Key? key});
  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      title: context.l10n.events,
      trailing: BlocProvider(
        create: (context) => di<LoginCubit>(),
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return state is LogoutLoadingState
                ? const LoadingIndicator(
                    color: Colors.white,
                  )
                : IconButton(
                    icon: const Icon(
                      FIcons.logOut,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      context.read<LoginCubit>().logout();
                      context.go(AppNavigations.login);
                    },
                  );
          },
        ),
      ),
    );
  }
}

class BodyEvent implements Body {
  const BodyEvent({Key? key});
  @override
  Widget build(BuildContext context) {
    return BodyWidget(
      backgroundColor: const Color(0xFFF5F8FA),
      child: BlocProvider(
        create: (context) => di<EventCubit>()..loadActiveEvent(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: BlocBuilder<EventCubit, EventState>(
            builder: (context, state) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: switch (state.status) {
                    EventStatus.initial || EventStatus.loading => const Padding(
                        padding: EdgeInsets.only(top: 48),
                        child: LoadingIndicator(),
                      ),
                    EventStatus.failure => Padding(
                        padding: const EdgeInsets.only(top: 48),
                        child: Text(
                          state.message ?? 'Failed to load event',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    EventStatus.success when state.event != null => Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: EventCard(
                          title: state.event!.title,
                          dateText: _formatDateRange(
                            state.event!.date,
                            state.event!.endDate,
                          ),
                          location: state.event!.city ?? '',
                          checkedIn: state.event!.applications.length,
                          capacity: state.event!.requiredFields.length,
                          onStartScanning: () => context.go(AppNavigations.qr),
                          onViewWorkshops: () {
                            context.go(
                              AppNavigations.workshops,
                              extra: state.event!.workshops,
                            );
                          },
                        ),
                      ),
                    _ => const Padding(
                        padding: EdgeInsets.only(top: 48),
                        child: Text('No active event found'),
                      ),
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

String _formatDateRange(DateTime? start, DateTime? end) {
  if (start == null && end == null) return '';
  if (start == null) {
    return '${end!.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}';
  }
  if (end == null) {
    return '${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}';
  }
  final sameDay = start.year == end.year &&
      start.month == end.month &&
      start.day == end.day;
  final startText =
      '${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}';
  final endText =
      '${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}';
  return sameDay ? startText : '$startText - $endText';
}
