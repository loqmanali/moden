# QR Scanner for Flutter PWA

Your QR scanner has been enhanced to work perfectly with Flutter PWA (Progressive Web App).

## Features

### ✅ PWA-Ready
- Camera permission handled automatically by browser
- HTTPS requirement enforced for security
- No auto-start on web (user must tap to start camera)
- Better error messages for web-specific issues

### ✅ Enhanced UX
- Dynamic button text based on scanner state:
  - "Start Camera & Scan" (web initial state)
  - "Scan QR Code" (mobile)
  - "Starting Camera..." (loading state)
  - "Stop Scanning" (active scanning)
  - "Processing..." (handling QR code)

### ✅ Error Handling
- Camera permission denied
- No camera found
- HTTPS requirement
- Device compatibility checks

## Usage

The QR scanner is located at `lib/features/qr/screen/qr_screen.dart` and uses your existing routing system.

### Navigation
```dart
context.push(AppNavigations.qrScreen); // Your existing route
```

### States
1. **Initial**: Shows camera preview with "Start Camera & Scan" button
2. **Scanning**: Active camera with "Stop Scanning" button
3. **Processing**: Shows loading overlay while validating QR code
4. **Result**: Navigates to success/failure screen

## PWA Requirements

### 1. HTTPS Required
Camera access requires HTTPS in browsers:
```bash
# Development with HTTPS
flutter run -d chrome --web-port 8080 --web-hostname localhost
```

### 2. Camera Permissions
Browser will automatically prompt for camera permission when user taps "Start Camera & Scan".

### 3. Supported Browsers
- Chrome/Edge: Full support
- Firefox: Full support  
- Safari: iOS 14.3+ required

## Testing

### Local Testing
```bash
# Run with web
flutter run -d chrome

# Build PWA
flutter build web --pwa-strategy offline-first
```

### PWA Installation
Users can install your app as PWA from browser menu or install prompt.

## Configuration

Your scanner is already configured in:
- `qr_screen.dart` - Main scanner logic
- `adaptive_qr_scanner.dart` - Camera widget
- `web/index.html` - Camera permissions meta tags

The scanner uses `mobile_scanner` package which provides excellent PWA compatibility.