import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:modn/core/routes/app_navigators.dart';
import 'package:modn/features/events/widgets/event_card.dart';
import 'package:modn/shared/widgets/app_scaffold.dart';

import '../../../shared/widgets/body_widget.dart';
import '../../../shared/widgets/header_widget.dart';

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
      title: 'Events',
      trailing: IconButton(
        icon: const Icon(
          FIcons.logOut,
          color: Colors.white,
        ),
        onPressed: () {
          context.go(AppNavigations.login);
        },
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                // AppSpacing.height(32),
                ...List.generate(
                  10,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: EventCard(
                      title: 'Medical Conference 2025',
                      dateText: 'July 25-26, 2025',
                      location: 'Riyadh',
                      checkedIn: 10,
                      capacity: 20,
                      onStartScanning: () {
                        context.go(AppNavigations.qr);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
