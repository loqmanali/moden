import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:modn/features/events/models/active_event_model.dart';
import 'package:modn/features/events/services/event_service.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit({required this.eventService}) : super(const EventState.initial());

  final EventService eventService;

  Future<void> loadActiveEvent() async {
    emit(const EventState.loading());

    final response = await eventService.getActiveEvent();

    if (response.isSuccess) {
      emit(EventState.success(event: response.data));
    } else {
      emit(EventState.failure(message: response.errorMessage));
    }
  }
}
