import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:modn/core/network/api_client.dart';
import 'package:modn/core/network/api_constants.dart';
import 'package:modn/core/network/network_info.dart';
import 'package:modn/features/authentication/cubit/login_cubit.dart';
import 'package:modn/features/authentication/services/login_service.dart';

final GetIt di = GetIt.instance;

void setupDependencies() {
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
        baseUrl: ApiConstants.baseUrl,
        timeout: ApiConstants.timeout,
      ),
    );
  }

  if (!di.isRegistered<LoginService>()) {
    di.registerLazySingleton<LoginService>(
      () => LoginService(apiClient: di<ApiClient>()),
    );
  }

  if (!di.isRegistered<LoginCubit>()) {
    di.registerFactory<LoginCubit>(
      () => LoginCubit(loginService: di<LoginService>()),
    );
  }
}
