# QR Scan API Usage Guide

## Changes Made

### 1. Fixed Endpoint URL
- **Before**: `https://modn-api.semicolonsa.dev/api//entry-log/scan` (double slash)
- **After**: `https://modn-api.semicolonsa.dev/api/entry-log/scan` (single slash)

### 2. Fixed Token Headers
The API now sends both required headers:
- `token: Bearer <token>`
- `Authorization: Bearer <token>`

Both headers are automatically added by the `AuthInterceptor` when a valid token is stored.

### 3. Updated QR Data Format
The `qrData` field now supports both:
- **String format**: Simple QR code string
- **Object format**: Structured data with `applicationId`, `eventId`, `userId`

## Usage Example

### Option 1: Using QR Data as Object (Recommended for your API)

```dart
import 'dart:convert';

// Parse QR code data
final qrDataObject = {
  "applicationId": "690091bf3c98596e1031fffd",
  "eventId": "672285e320a551888fea83ce",
  "userId": "66fd32138caf25acddd33eeb"
};

// Call the cubit
await qrScanCubit.scanQrCode(
  qrData: qrDataObject,  // Pass as object
  type: "event",
  workshopId: "workshop_id",
  deviceId: "test",
);
```

### Option 2: Using QR Data as String

```dart
// If QR code is a simple string
await qrScanCubit.scanQrCode(
  qrData: "simple_qr_string",  // Pass as string
  type: "event",
  workshopId: null,
  deviceId: "device_123",
);
```

## Request Format

The API will send:

```json
{
  "qrData": {
    "applicationId": "690091bf3c98596e1031fffd",
    "eventId": "672285e320a551888fea83ce",
    "userId": "66fd32138caf25acddd33eeb"
  },
  "type": "event",
  "workshopId": "workshop_id",
  "deviceId": "test"
}
```

## Headers Sent Automatically

```
Content-Type: application/json
Accept: application/json
token: Bearer <your_token>
Authorization: Bearer <your_token>
```

## Notes

- The token is automatically retrieved from storage via `Storage.getToken()`
- Both `token` and `Authorization` headers are added automatically
- The endpoint URL is correctly formatted without double slashes
- `qrData` can be either a String or a Map<String, dynamic>
