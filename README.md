# moden

## Overview
`moden` is a mobile application that helps event teams manage their gatherings and validate attendee tickets through QR codes quickly and reliably, while showing the ticket status instantly on screen.

## Key Features
- **Events dashboard** The `EventsScreen` in `lib/features/events/screen/events_screen.dart` lists events with details such as date, city, and capacity, and provides a shortcut to start scanning for each one.
- **Real-time QR scanning** The `QrScreen` in `lib/features/qr/screen/qr_screen.dart` uses a `MobileScannerController` to start or stop the camera and capture results immediately.
- **Instant feedback** The `accepted_screen.dart` and `rejected_screen.dart` screens display clear visual and audio cues to indicate whether the ticket check succeeded or failed, speeding up gate decisions.
- **Consistent UI** Screens are built with shared widgets like `AppScaffold`, `BodyWidget`, and `HeaderWidget`, keeping styling consistent with adaptive controls and a unified color palette.

## User Flow
1. **Select an event** from the events screen, review its details, and tap "Start Scanning" to open the QR reader.
2. **Scan the code** with the device camera; the app pauses the camera momentarily after each scan to avoid duplicate reads.
3. **View the outcome** The user is automatically routed to the accepted or rejected screen, which clearly shows the status and allows returning for another scan.

## Technical Details
- **Framework** Flutter with a feature-based structure that organizes screens inside `lib/features/`.
- **Navigation** Powered by `GoRouter`, defined in `lib/core/routes/app_navigators.dart`, to move seamlessly between screens.
- **QR scanning** Built on the `mobile_scanner` package with a configured `MobileScannerController` to manage the camera lifecycle and deduplicate results.
- **UI components** Combines `forui` widgets with custom elements like `AdaptiveButton` and `AdaptiveQrScanner` for a platform-friendly experience.

## Current Status
- **Present capabilities** Deliver a complete ticket validation flow, from selecting events to displaying scan results, with simulated latency that represents backend verification.
- **Suggested roadmap** Integrate real ticket-validation APIs, add staff account management, and collect live attendance analytics.
