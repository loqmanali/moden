import 'package:equatable/equatable.dart';

/// QR Scan Request Model
class QrScanRequest extends Equatable {
  const QrScanRequest({
    required this.qrData,
    required this.type,
    this.workshopId,
    this.deviceId,
  });

  final String qrData;
  final String type; // "event" or "workshop"
  final String? workshopId;
  final String? deviceId;

  Map<String, dynamic> toJson() {
    return {
      'qrData': qrData,
      'type': type,
      if (workshopId != null) 'workshopId': workshopId,
      if (deviceId != null) 'deviceId': deviceId,
    };
  }

  @override
  List<Object?> get props => [qrData, type, workshopId, deviceId];
}

/// QR Data Model (parsed from qrData string)
class QrData extends Equatable {
  const QrData({
    required this.applicationId,
    required this.eventId,
    required this.userId,
  });

  final String applicationId;
  final String eventId;
  final String userId;

  factory QrData.fromJson(Map<String, dynamic> json) {
    return QrData(
      applicationId: json['applicationId'] as String,
      eventId: json['eventId'] as String,
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'applicationId': applicationId,
      'eventId': eventId,
      'userId': userId,
    };
  }

  @override
  List<Object?> get props => [applicationId, eventId, userId];
}

/// QR Scan Response Model
class QrScanResponse extends Equatable {
  const QrScanResponse({
    required this.success,
    this.message,
    this.data,
  });

  final bool success;
  final String? message;
  final QrScanData? data;

  factory QrScanResponse.fromJson(Map<String, dynamic> json) {
    return QrScanResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: json['data'] != null
          ? QrScanData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [success, message, data];
}

/// QR Scan Data Model
class QrScanData extends Equatable {
  const QrScanData({
    this.entryLogId,
    this.applicationId,
    this.eventId,
    this.userId,
    this.workshopId,
    this.deviceId,
    this.scannedAt,
  });

  final String? entryLogId;
  final String? applicationId;
  final String? eventId;
  final String? userId;
  final String? workshopId;
  final String? deviceId;
  final DateTime? scannedAt;

  factory QrScanData.fromJson(Map<String, dynamic> json) {
    return QrScanData(
      entryLogId: json['entryLogId'] as String?,
      applicationId: json['applicationId'] as String?,
      eventId: json['eventId'] as String?,
      userId: json['userId'] as String?,
      workshopId: json['workshopId'] as String?,
      deviceId: json['deviceId'] as String?,
      scannedAt: json['scannedAt'] != null
          ? DateTime.parse(json['scannedAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        entryLogId,
        applicationId,
        eventId,
        userId,
        workshopId,
        deviceId,
        scannedAt,
      ];
}
