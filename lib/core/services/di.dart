import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:modn/core/network/api_client.dart';
import 'package:modn/core/network/api_endpoint.dart';
import 'package:modn/core/network/network_info.dart';
import 'package:modn/core/storage/cache_helper.dart';
import 'package:modn/core/storage/cache_helper_factory.dart';
import 'package:modn/core/storage/local_storage_repository.dart';
import 'package:modn/features/authentication/cubit/login_cubit.dart';
import 'package:modn/features/authentication/services/login_service.dart';
import 'package:modn/features/events/cubit/event_cubit.dart';
import 'package:modn/features/events/services/event_service.dart';

final GetIt di = GetIt.instance;

/// Setup all app dependencies
/// Call this before runApp()
Future<void> setupDependencies() async {
  // ==================== Storage ====================
  if (!di.isRegistered<CacheHelper>()) {
    final cacheHelper = CacheHelperFactory.createAsync();
    await cacheHelper.init();
    di.registerSingleton<CacheHelper>(cacheHelper);
  }

  if (!di.isRegistered<LocalStorageRepository>()) {
    di.registerSingleton<LocalStorageRepository>(
      LocalStorageRepository(di<CacheHelper>()),
    );
  }

  // ==================== Network ====================
  if (!di.isRegistered<InternetConnectionChecker>()) {
    di.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker.instance,
    );
  }

  if (!di.isRegistered<NetworkInfo>()) {
    di.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(di<InternetConnectionChecker>()),
    );
  }

  if (!di.isRegistered<ApiClient>()) {
    di.registerLazySingleton<ApiClient>(
      () => ApiClient(
        timeout: ApiEndpoint.timeout,
      ),
    );
  }

  // ==================== Authentication ====================
  if (!di.isRegistered<LoginService>()) {
    di.registerLazySingleton<LoginService>(
      () => LoginService(apiClient: di<ApiClient>()),
    );
  }

  if (!di.isRegistered<LoginCubit>()) {
    di.registerFactory<LoginCubit>(
      () => LoginCubit(
        loginService: di<LoginService>(),
        storageRepository: di<LocalStorageRepository>(),
      ),
    );
  }

  // ==================== Events ====================
  if (!di.isRegistered<EventService>()) {
    di.registerLazySingleton<EventService>(
      () => EventService(apiClient: di<ApiClient>()),
    );
  }

  if (!di.isRegistered<EventCubit>()) {
    di.registerFactory<EventCubit>(
      () => EventCubit(eventService: di<EventService>()),
    );
  }
}
