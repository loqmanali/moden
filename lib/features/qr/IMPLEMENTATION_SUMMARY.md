# QR Scan Implementation Summary

## Overview
تم تحديث QR scan feature لدعم نوعين من المسح:
- **Event Scanning**: مسح QR codes للأحداث
- **Workshop Scanning**: مسح QR codes لورش العمل

## التغييرات الرئيسية

### 1. إضافة Device Info Package
- أضفنا `device_info_plus: ^11.2.0` في `pubspec.yaml`
- يتم استخدامه للحصول على معرف الجهاز تلقائياً

### 2. Device Info Service
**الملف:** `lib/core/services/device_info_service.dart`

يوفر:
- `getDeviceId()`: يحصل على معرف فريد للجهاز
  - Android: Android ID
  - iOS: identifierForVendor
  - Web: Browser user agent hash
- `getDeviceModel()`: اسم موديل الجهاز
- `getDeviceInfo()`: معلومات كاملة عن الجهاز

### 3. تحديث QR Screen
**الملف:** `lib/features/qr/screen/qr_screen.dart`

التغييرات:
- إضافة parameters: `type` و `workshopId`
- استخدام `DeviceInfoService` للحصول على device ID تلقائياً
- تمرير `type` و `workshopId` للـ API
- تمرير الـ parameters للشاشات التالية (accepted/rejected)

```dart
QrScreen(
  type: 'event', // or 'workshop'
  workshopId: 'workshop_id', // required if type=workshop
)
```

### 4. تحديث Routes
**الملف:** `lib/core/routes/app_navigators.dart`

- QR route يقبل query parameters: `type` و `workshopId`
- Accepted/Rejected routes تقبل نفس الـ parameters

### 5. تحديث Navigation Calls

**Events Screen:**
```dart
context.go('${AppNavigations.qr}?type=event')
```

**Workshops Screen:**
```dart
context.go('${AppNavigations.qr}?type=workshop&workshopId=${workshop.id}')
```

### 6. تحديث Accepted/Rejected Screens
**الملفات:**
- `lib/features/qr/screen/accepted_screen.dart`
- `lib/features/qr/screen/rejected_screen.dart`

التغييرات:
- إضافة parameters: `type` و `workshopId`
- الحفاظ على الـ parameters عند العودة للـ QR screen

### 7. Dependency Injection
**الملف:** `lib/core/services/di.dart`

أضفنا:
```dart
DeviceInfoService: Lazy singleton
```

## API Request Structure

### Event Scan
```json
{
  "qrData": "{\"applicationId\": \"...\", \"eventId\": \"...\", \"userId\": \"...\"}",
  "type": "event",
  "deviceId": "android_abc123"
}
```

### Workshop Scan
```json
{
  "qrData": "{\"applicationId\": \"...\", \"eventId\": \"...\", \"userId\": \"...\"}",
  "type": "workshop",
  "workshopId": "workshop_id_here",
  "deviceId": "ios_xyz789"
}
```

## Navigation Flow

```
Events Screen → QR Screen (type=event)
                    ↓
                Scan QR
                    ↓
            API Call with type
                    ↓
        Success → Accepted Screen
        Failure → Rejected Screen
                    ↓
            Back to QR Screen
            (preserves type)
```

```
Workshops Screen → QR Screen (type=workshop, workshopId=xxx)
                        ↓
                    Scan QR
                        ↓
            API Call with type & workshopId
                        ↓
            Success → Accepted Screen
            Failure → Rejected Screen
                        ↓
                Back to QR Screen
        (preserves type & workshopId)
```

## Testing Checklist

- [ ] Event scanning يعمل بشكل صحيح
- [ ] Workshop scanning يعمل بشكل صحيح
- [ ] Device ID يتم إرساله مع كل request
- [ ] Navigation يحافظ على الـ parameters
- [ ] Accepted screen تعود للـ QR screen بنفس الـ type
- [ ] Rejected screen تعود للـ QR screen بنفس الـ type
- [ ] Workshop ID يتم إرساله فقط عندما type=workshop

## ملاحظات مهمة

1. **Device ID**: يتم جلبه تلقائياً عند فتح QR screen
2. **Type Parameter**: إلزامي، القيمة الافتراضية 'event'
3. **Workshop ID**: إلزامي فقط عندما type='workshop'
4. **Query Parameters**: يتم تمريرها عبر URL للحفاظ على الحالة

## الملفات المتأثرة

### ملفات جديدة:
- `lib/core/services/device_info_service.dart`

### ملفات محدثة:
- `pubspec.yaml`
- `lib/core/services/di.dart`
- `lib/core/routes/app_navigators.dart`
- `lib/features/qr/screen/qr_screen.dart`
- `lib/features/qr/screen/accepted_screen.dart`
- `lib/features/qr/screen/rejected_screen.dart`
- `lib/features/events/screen/events_screen.dart`
- `lib/features/events/screen/workshops_screen.dart`
- `lib/features/qr/README_QR_SCAN.md`
