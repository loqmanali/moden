# Modn

## Overview

Modn is a Flutter application built for event operations teams to manage attendee lists and validate tickets via QR codes. It combines staff authentication, live event data fetched from the backend API, and instant ticket feedback while supporting phones and a PWA experience on the web.

## What the App Delivers

- **Staff sign-in**: The `LoginScreen` (`lib/features/authentication/views/login_screen.dart`) lets event staff authenticate with email and password, storing tokens securely through `LocalStorageRepository` to enable auto-login.
- **Active event dashboard**: `EventsScreen` pulls the active event from the `event/active` endpoint and displays the date, city, and attendance metrics with direct shortcuts to start scanning or browse workshops.
- **Workshop and session management**: `WorkshopsScreen` lists event workshops and allows scanning for each session separately, formatting times and dates based on the event schedule.
- **Fast QR scanning**: `QrScreen` uses `mobile_scanner` to control the camera, send scan payloads to `entry-log/scan`, and pass the `deviceId` so the backend can track which device performed the validation.
- **Clear feedback loop**: `AcceptedScreen` and `RejectedScreen` give instant visual cues with quick actions to scan the next ticket or jump back to events.
- **Web and mobile parity**: On the web the UI is constrained to a 450px wide layout and relies on `dynamic_path_url_strategy` for clean PWA routing, while mobile devices force portrait mode for consistent scanning.

## Architecture

- **Feature-first structure**: Each feature (authentication, events, QR, splash) lives inside `lib/features/` with its own screens, cubits, models, and services.
- **State management with BLoC**: `flutter_bloc` and `hydrated_bloc` drive the login, active event, and QR scanning flows with centralized monitoring via `AppBlocObserver`.
- **Dependency injection**: `GetIt` is configured in `lib/core/services/di.dart` to prepare API clients, storage, and helpers before the app starts.
- **Networking layer**: `ApiClient` wraps `dio` with soft interceptors (e.g., `AuthInterceptor`) and normalized error handling through `NetworkExceptions`, while endpoints are defined in `ApiEndpoint`.
- **Cloud and observability**: 
  - `Firebase.initializeApp` enables Firebase services such as messaging and Remote Config.
  - `RemoteConfigService` tunes behavior per environment.
  - `SentryFlutter` integration captures crashes, traces, and session replay for full visibility.

## Key Dependencies

- Flutter SDK 3.5.0 or later.
- `firebase_core`, `firebase_remote_config`, `firebase_messaging` for Firebase integration.
- `mobile_scanner` for QR scanning across Android, iOS, and web.
- `forui` and `forui_assets` for the design system, alongside custom widgets like `AdaptiveButton` and `AppScaffold` in `lib/core/widgets`.
- `hydrated_bloc`, `get_it`, `dio`, `shared_preferences`, and `flutter_secure_storage` to build the application infrastructure.

## Run the App Locally

1. **Prerequisites**  
   - Install Flutter (3.5.0 or newer) and confirm with `flutter doctor`.  
   - Enable required platforms (`flutter config --enable-web`, set up Xcode/Android Studio).

2. **Initial setup**  
   ```bash
   flutter pub get
   ```
   - Reconfigure Firebase with `flutterfire configure` if linking to a different Firebase project, and ensure `lib/firebase_options.dart` exists.
   - Update the base API URL in `lib/core/network/api_endpoint.dart` if you need an environment other than the default development endpoint.

3. **Start the app**  
   - Android:  
     ```bash
     flutter run -d android
     ```  
   - iOS:  
     ```bash
     flutter run -d ios
     ```  
   - Web (PWA):  
     ```bash
     flutter run -d chrome
     ```

   > Note: Browsers require HTTPS to grant camera access. On the web build, users must grant permission and manually start the camera before scanning.

4. **Run tests**  
   ```bash
   flutter test
   ```

## Daily Workflow

1. A staff member signs in with email and password.  
2. Upon success, they land on `EventsScreen`, which loads and shows the active event details.  
3. They choose `Start Scanning` to open the QR scanner or browse workshops and select a session-specific scanner.  
4. After each scan, the app posts data to the backend and navigates automatically to the accepted or rejected screen, with a shortcut to resume scanning.  
5. A logout action is always available in the header to terminate the session and clear stored credentials.

## Key File Layout

- `lib/main.dart`: Initializes Sentry, Firebase, Remote Config, and dependency injection before launching the UI.
- `lib/app/`: Contains `app.dart`, which wires up theming, localization, and routing with `GoRouter`.
- `lib/core/`: Shared utilities such as networking, storage, design tokens, localization, and reusable widgets.
- `lib/features/`: Feature domains (authentication, events, QR, splash) with their dedicated UI, BLoC logic, models, and services.
- `assets/`: Logos, icons, and fonts used by the design system.

## Observability and Ops Support

- `SentryFlutter` captures crashes and performance metrics with `tracesSampleRate` and `profilesSampleRate` set to 100% during development to provide full coverage.  
- `RemoteConfigService` allows toggling features or adjusting behavior per environment without shipping a new binary.  
- `DeviceInfoService` gathers device metadata for each scan to support device monitoring or abuse prevention.

## Suggested Roadmap

- Enable environment switching by letting `RemoteConfigService` pick the appropriate `baseUrl` dynamically.
- Display ticket metadata on the acceptance screen (name, ticket type, etc.) when the API response includes it.
- Embed live attendance stats inside `EventsScreen` showing accepted vs rejected checks.
- Support limited offline mode by caching pending scans and replaying them once connectivity returns.

## Cross-Team Collaboration

- The backend team can provide documentation for the `entry-log/scan` endpoint to streamline API testing.  
- The design team can supply additional error states (duplicate ticket, expired ticket, etc.) to enrich the rejection screen.  
- The QA team should cover scenarios around role-based access, network interruptions during scanning, and device permission handling.
