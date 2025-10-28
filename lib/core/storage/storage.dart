/// Storage System - Barrel File
///
/// This file exports all the necessary components for the storage system.
/// Import this file to access all storage-related classes and utilities.
///
/// **Simple Usage (Recommended):**
/// ```dart
/// import 'package:granzia_health_connect/core/storage/storage.dart';
///
/// // Save data
/// await Storage.saveUserEmail('user@example.com');
/// await Storage.saveToken('my_token');
///
/// // Read data
/// final email = await Storage.getUserEmail();
/// final isLoggedIn = await Storage.isLoggedIn();
/// ```
///
/// **Advanced Usage:**
/// ```dart
/// final repository = StorageLocator.repository;
/// await repository.saveAuthTokens(accessToken: 'token', refreshToken: 'refresh');
/// ```
library;

// Services (from core/services)
export 'cache_helper.dart';
export 'cache_helper_factory.dart';
// Repository
export 'local_storage_repository.dart';
// Keys Management
export 'storage_keys.dart';
// Dependency Injection
export 'storage_locator.dart';
// Simple API (Recommended for most use cases)
export 'storage_service.dart';
// Core Strategy
export 'storage_strategy.dart';
// Strategies
export 'strategies/hive_strategy.dart';
export 'strategies/shared_preferences_async_strategy.dart';
export 'strategies/shared_preferences_with_cache_strategy.dart';
