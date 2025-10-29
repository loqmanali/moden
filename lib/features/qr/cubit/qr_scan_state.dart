part of 'qr_scan_cubit.dart';

enum QrScanStatus { initial, loading, success, failure }

class QrScanState extends Equatable {
  const QrScanState({
    required this.status,
    this.response,
    this.message,
  });

  const QrScanState.initial()
      : this(
          status: QrScanStatus.initial,
        );

  const QrScanState.loading()
      : this(
          status: QrScanStatus.loading,
        );

  const QrScanState.success({QrScanResponse? response})
      : this(
          status: QrScanStatus.success,
          response: response,
        );

  const QrScanState.failure({String? message})
      : this(
          status: QrScanStatus.failure,
          message: message,
        );

  final QrScanStatus status;
  final QrScanResponse? response;
  final String? message;

  @override
  List<Object?> get props => [status, response, message];
}
