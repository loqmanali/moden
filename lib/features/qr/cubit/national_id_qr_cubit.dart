import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:modn/features/qr/models/national_id_qr_model.dart';
import 'package:modn/features/qr/services/national_id_qr_service.dart';

part 'national_id_qr_state.dart';

class NationalIdQrCubit extends Cubit<NationalIdQrState> {
  NationalIdQrCubit({required this.nationalIdQrService})
      : super(const NationalIdQrState.initial());

  final NationalIdQrService nationalIdQrService;

  Future<void> getUserQrCode({
    required String nationalId,
    required String eventId,
  }) async {
    emit(const NationalIdQrState.loading());

    final request = NationalIdQrRequest(
      nationalId: nationalId,
      eventId: eventId,
    );

    final response = await nationalIdQrService.getUserQrCode(request: request);

    if (response.isSuccess && response.data != null) {
      emit(NationalIdQrState.success(response: response.data));
    } else {
      emit(NationalIdQrState.failure(message: response.errorMessage));
    }
  }

  void reset() {
    emit(const NationalIdQrState.initial());
  }
}
