import 'package:equatable/equatable.dart';

/// National ID QR Request Model
class NationalIdQrRequest extends Equatable {
  const NationalIdQrRequest({
    required this.nationalId,
    required this.eventId,
  });

  final String nationalId;
  final String eventId;

  Map<String, dynamic> toJson() {
    return {
      'national_id': nationalId,
      // 'eventId': '66d9d045141cdfb65e69b0d8',
      'eventId': eventId,
    };
  }

  @override
  List<Object?> get props => [nationalId, eventId];
}

/// National ID QR Response Model
class NationalIdQrResponse extends Equatable {
  const NationalIdQrResponse({
    required this.qrCode,
  });

  final QrCodeData qrCode;

  factory NationalIdQrResponse.fromJson(Map<String, dynamic> json) {
    return NationalIdQrResponse(
      qrCode: QrCodeData.fromJson(json['qrCode'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [qrCode];
}

/// QR Code Data Model
class QrCodeData extends Equatable {
  const QrCodeData({
    required this.eventId,
    required this.applicationId,
    required this.qrCode,
    this.userId,
  });

  final String eventId;
  final String applicationId;
  final String qrCode; // Base64 encoded PNG image
  final String? userId;

  factory QrCodeData.fromJson(Map<String, dynamic> json) {
    return QrCodeData(
      eventId: json['eventId'] as String,
      applicationId: json['applicationId'] as String,
      qrCode: json['qrCode'] as String,
      userId: json['userId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'applicationId': applicationId,
      'qrCode': qrCode,
      if (userId != null) 'userId': userId,
    };
  }

  @override
  List<Object?> get props => [eventId, applicationId, qrCode, userId];
}
