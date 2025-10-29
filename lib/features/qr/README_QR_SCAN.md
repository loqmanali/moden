# QR Scan Feature

## Overview
This feature handles QR code scanning for event entry validation using the MODN API.

## Architecture

### Models (`models/qr_scan_model.dart`)
- **QrScanRequest**: Request model for QR scan API
  - `qrData`: JSON string containing application, event, and user IDs
  - `type`: "event" or "workshop"
  - `workshopId`: Optional workshop ID (required if type=workshop)
  - `deviceId`: Optional device identifier

- **QrScanResponse**: Response model from API
  - `success`: Boolean indicating scan success
  - `message`: Optional message from server
  - `data`: QrScanData object with scan details

- **QrData**: Parsed QR code data
  - `applicationId`: Application ID
  - `eventId`: Event ID
  - `userId`: User ID

### Service (`services/qr_scan_service.dart`)
- **QrScanService**: Handles API communication
  - `scanQrCode()`: Sends QR scan request to API endpoint

### State Management (`cubit/`)
- **QrScanCubit**: Manages QR scan state
  - `scanQrCode()`: Initiates QR scan process
  - `reset()`: Resets state to initial

- **QrScanState**: State representation
  - `initial`: Initial state
  - `loading`: Scanning in progress
  - `success`: Scan successful
  - `failure`: Scan failed

### Screens
- **QrScreen**: Main QR scanner screen
- **AcceptedScreen**: Success screen (valid QR)
- **RejectedScreen**: Failure screen (invalid QR)

## API Endpoint
```
POST /api/entry-log/scan
```

### Request Body
```json
{
  "qrData": "{\"applicationId\": \"...\", \"eventId\": \"...\", \"userId\": \"...\"}",
  "type": "event",
  "workshopId": "workshop_id",  // optional, required if type=workshop
  "deviceId": "flutter_app"      // optional
}
```

### Response
```json
{
  "success": true,
  "message": "Entry logged successfully",
  "data": {
    "entryLogId": "...",
    "applicationId": "...",
    "eventId": "...",
    "userId": "...",
    "scannedAt": "2024-01-01T00:00:00.000Z"
  }
}
```

## Navigation Flow
1. User scans QR code on `QrScreen`
2. API call is made via `QrScanCubit`
3. Based on response:
   - **Success** (`response.success == true`) → Navigate to `AcceptedScreen`
   - **Failure** → Navigate to `RejectedScreen`

## Usage Example

### Navigating to QR Screen

**For Event Scanning:**
```dart
context.go('${AppNavigations.qr}?type=event');
```

**For Workshop Scanning:**
```dart
context.go('${AppNavigations.qr}?type=workshop&workshopId=<workshop_id>');
```

### In QR Screen
```dart
// Get device ID automatically
final deviceId = await _deviceInfoService.getDeviceId();

// Scan QR code
await qrScanCubit.scanQrCode(
  qrData: scannedCode,
  type: widget.type, // 'event' or 'workshop'
  workshopId: widget.workshopId, // required if type=workshop
  deviceId: deviceId, // auto-fetched from device
);

// Navigate based on response
final state = qrScanCubit.state;
if (state.status == QrScanStatus.success && state.response?.success == true) {
  context.push('${AppNavigations.qrAccepted}$queryParams');
} else {
  context.push('${AppNavigations.qrRejected}$queryParams');
}
```

## Device Info Service
The `DeviceInfoService` automatically fetches device information:
- **Android**: Uses Android ID
- **iOS**: Uses identifierForVendor
- **Web**: Uses browser user agent hash
- **Other platforms**: Returns 'unknown_platform'

This device ID is sent with each QR scan request for tracking purposes.

## Dependencies
- `flutter_bloc`: State management
- `mobile_scanner`: QR code scanning
- `device_info_plus`: Device information
- `dio`: HTTP client (via ApiClient)
- `equatable`: Value equality

## Dependency Injection
All services and cubits are registered in `lib/core/services/di.dart`:
- `DeviceInfoService`: Lazy singleton
- `QrScanService`: Lazy singleton
- `QrScanCubit`: Factory (new instance per use)
