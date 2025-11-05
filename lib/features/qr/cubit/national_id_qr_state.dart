part of 'national_id_qr_cubit.dart';

enum NationalIdQrStatus {
  initial,
  loading,
  success,
  failure,
}

class NationalIdQrState extends Equatable {
  const NationalIdQrState._({
    required this.status,
    this.response,
    this.message,
  });

  const NationalIdQrState.initial()
      : this._(
          status: NationalIdQrStatus.initial,
        );

  const NationalIdQrState.loading()
      : this._(
          status: NationalIdQrStatus.loading,
        );

  const NationalIdQrState.success({
    required NationalIdQrResponse? response,
  }) : this._(
          status: NationalIdQrStatus.success,
          response: response,
        );

  const NationalIdQrState.failure({
    required String? message,
  }) : this._(
          status: NationalIdQrStatus.failure,
          message: message,
        );

  final NationalIdQrStatus status;
  final NationalIdQrResponse? response;
  final String? message;

  @override
  List<Object?> get props => [status, response, message];
}
