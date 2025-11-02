import 'dart:convert';

import 'package:equatable/equatable.dart';

/// QR Scan Request Model
class QrScanRequest extends Equatable {
  const QrScanRequest({
    required this.qrData,
    required this.type,
    this.workshopId,
    this.deviceId,
  });

  final dynamic qrData; // Can be String or Map<String, dynamic>
  final String type; // "event" or "workshop"
  final String? workshopId;
  final String? deviceId;

  Map<String, dynamic> toJson() {
    // Parse qrData if it's a JSON string
    dynamic parsedQrData = qrData;
    if (qrData is String) {
      try {
        parsedQrData = jsonDecode(qrData);
      } catch (e) {
        // If parsing fails, keep as string
        parsedQrData = qrData;
      }
    }
    
    return {
      'qrData': parsedQrData,
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
    // Backend returns 'code' and 'msg' instead of 'success' and 'message'
    final code = json['code'] as int?;
    final isSuccess = code != null && code >= 200 && code < 300;
    
    return QrScanResponse(
      success: json['success'] as bool? ?? isSuccess,
      message: json['message'] as String? ?? json['msg'] as String?,
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
    this.attendee,
    this.event,
    this.workshop,
  });

  final String? entryLogId;
  final String? applicationId;
  final String? eventId;
  final String? userId;
  final String? workshopId;
  final String? deviceId;
  final DateTime? scannedAt;
  
  // Additional fields from backend response
  final String? attendee;
  final String? event;
  final String? workshop;

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
      attendee: json['attendee'] as String?,
      event: json['event'] as String?,
      workshop: json['workshop'] as String?,
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
        attendee,
        event,
        workshop,
      ];
}
