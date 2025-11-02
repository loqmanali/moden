import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:modn/core/localization/localization.dart';
import 'package:modn/core/routes/app_navigators.dart';
import 'package:modn/core/services/di.dart';
import 'package:modn/core/widgets/app_scaffold.dart';
import 'package:modn/features/authentication/cubit/login_cubit.dart';
import 'package:modn/features/events/widgets/workshops_empty_state.dart';

import '../../../core/widgets/body_widget.dart';
import '../../../core/widgets/header_widget.dart';
import '../models/active_event_model.dart';
import '../widgets/event_card.dart';

class WorkshopsScreen extends StatelessWidget {
  const WorkshopsScreen({super.key, required this.event});
  final EventDetails event;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: const HeaderWorkshops(),
      body: BodyWorkshops(event: event),
    );
  }
}

class HeaderWorkshops implements Header {
  const HeaderWorkshops({Key? key});
  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      title: context.l10n.workshops,
      leading: GestureDetector(
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onTap: () => context.go(AppNavigations.event),
      ),
      trailing: IconButton(
        icon: const Icon(
          FIcons.logOut,
          color: Colors.white,
        ),
        onPressed: () async {
          // Create a temporary cubit for logout
          final loginCubit = di<LoginCubit>();
          await loginCubit.logout();
          loginCubit.close();
          if (context.mounted) {
            context.go(AppNavigations.login);
          }
        },
      ),
    );
  }
}

class BodyWorkshops implements Body {
  const BodyWorkshops({Key? key, required this.event});
  final EventDetails event;
  @override
  Widget build(BuildContext context) {
    return BodyWidget(
      backgroundColor: const Color(0xFFF5F8FA),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SafeArea(
          child: SingleChildScrollView(
            child: event.workshops.isEmpty
                ? const WorkshopsEmptyState()
                : Column(
                    children: List.generate(event.workshops.length, (index) {
                      final workshop = event.workshops[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: EventCard(
                          title: workshop.name.length > 16
                              ? workshop.name.substring(0, 16)
                              : workshop.name,
                          dateText:
                              _formatWorkshopSchedule(workshop, event.date),
                          location: event.city ?? '',
                          checkedIn: workshop.speakers.length,
                          capacity: workshop.speakers.length,
                          onStartScanning: () => context.go(
                            '${AppNavigations.qr}?type=workshop&workshopId=${workshop.id}',
                          ),
                        ),
                      );
                    }),
                  ),
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

String _formatWorkshopSchedule(
    EventWorkshop workshop, DateTime? eventStartDate) {
  // Prefer computing the workshop date from the event base date + (day - 1),
  // falling back to the workshop's own date if unavailable.
  DateTime? effectiveDate;
  if (eventStartDate != null && (workshop.day ?? 0) > 0) {
    final offsetDays = (workshop.day ?? 1) - 1;
    effectiveDate = eventStartDate.add(Duration(days: offsetDays));
  } else {
    effectiveDate = workshop.date;
  }

  final datePart = _formatDateRange(effectiveDate, effectiveDate);
  final timePart = _formatWorkshopTimeRange(workshop.from, workshop.to);
  final parts = <String>[];
  if (datePart.isNotEmpty) {
    parts.add(datePart);
  }
  if (timePart != null && timePart.isNotEmpty) {
    parts.add(timePart);
  }
  return parts.join(' • ');
}

String? _formatWorkshopTimeRange(String? from, String? to) {
  final start = _formatWorkshopTime(from);
  final end = _formatWorkshopTime(to);
  if (start == null && end == null) return null;
  if (start != null && end != null) {
    return start == end ? start : '$start - $end';
  }
  return start ?? end;
}

String? _formatWorkshopTime(String? raw) {
  final normalized = raw?.trim();
  if (normalized == null || normalized.isEmpty) return null;

  if (RegExp(r'^\d+$').hasMatch(normalized)) {
    final value = int.tryParse(normalized);
    if (value != null) {
      final milliseconds = normalized.length >= 13 ? value : value * 1000;
      final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
      return '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}';
    }
  }

  final parsed = DateTime.tryParse(normalized);
  if (parsed != null) {
    return '${_twoDigits(parsed.hour)}:${_twoDigits(parsed.minute)}';
  }

  final amPmMatch =
      RegExp(r'^(\d{1,2}):(\d{2})\s*(AM|PM|am|pm)$').firstMatch(normalized);
  if (amPmMatch != null) {
    final hour = int.tryParse(amPmMatch.group(1)!);
    final minute = int.tryParse(amPmMatch.group(2)!);
    if (hour != null && minute != null) {
      var adjustedHour = hour % 12;
      final period = amPmMatch.group(3)!.toUpperCase();
      if (period == 'PM') {
        adjustedHour += 12;
      }
      return '${_twoDigits(adjustedHour)}:${_twoDigits(minute)}';
    }
  }

  final timeMatch =
      RegExp(r'^(\d{1,2}):(\d{2})(?::(\d{2}))?$').firstMatch(normalized);
  if (timeMatch != null) {
    final hour = int.tryParse(timeMatch.group(1)!);
    final minute = int.tryParse(timeMatch.group(2)!);
    if (hour != null && minute != null) {
      final secondGroup = timeMatch.group(3);
      if (secondGroup != null && secondGroup != '00') {
        final second = int.tryParse(secondGroup);
        if (second != null) {
          return '${_twoDigits(hour)}:${_twoDigits(minute)}:${_twoDigits(second)}';
        }
      }
      return '${_twoDigits(hour)}:${_twoDigits(minute)}';
    }
  }

  return normalized;
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');
