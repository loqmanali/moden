import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:modn/features/qr/models/qr_scan_model.dart';
import 'package:modn/features/qr/services/qr_scan_service.dart';

part 'qr_scan_state.dart';

class QrScanCubit extends Cubit<QrScanState> {
  QrScanCubit({required this.qrScanService})
      : super(const QrScanState.initial());

  final QrScanService qrScanService;

  Future<void> scanQrCode({
    required String qrData,
    required String type,
    String? workshopId,
    String? deviceId,
  }) async {
    emit(const QrScanState.loading());

    final request = QrScanRequest(
      qrData: qrData,
      type: type,
      workshopId: workshopId,
      deviceId: deviceId,
    );

    final response = await qrScanService.scanQrCode(request: request);

    if (response.isSuccess && response.data != null) {
      emit(QrScanState.success(response: response.data));
    } else {
      emit(QrScanState.failure(message: response.errorMessage));
    }
  }

  void reset() {
    emit(const QrScanState.initial());
  }
}
