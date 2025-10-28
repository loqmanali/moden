part of 'event_cubit.dart';

enum EventStatus { initial, loading, success, failure }

class EventState extends Equatable {
  const EventState({
    required this.status,
    this.event,
    this.message,
  });

  const EventState.initial()
      : this(
          status: EventStatus.initial,
        );

  const EventState.loading()
      : this(
          status: EventStatus.loading,
        );

  const EventState.success({EventDetails? event})
      : this(
          status: EventStatus.success,
          event: event,
        );

  const EventState.failure({String? message})
      : this(
          status: EventStatus.failure,
          message: message,
        );

  final EventStatus status;
  final EventDetails? event;
  final String? message;

  @override
  List<Object?> get props => [status, event, message];
}
