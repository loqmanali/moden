import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:modn/core/network/models/api_response.dart';
import 'package:modn/core/storage/local_storage_repository.dart';
import 'package:modn/features/authentication/models/authentication_model.dart';
import 'package:modn/features/authentication/services/login_service.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginService loginService;
  final LocalStorageRepository storageRepository;

  /// Hardcoded flag to enable/disable auto-login feature
  /// Set to true to keep user logged in, false to require login each time
  static const bool enableAutoLogin = true;

  LoginCubit({
    required this.loginService,
    required this.storageRepository,
  }) : super(const LoginInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const LoginLoadingState());

    final ApiResponse<AuthenticationModel> response = await loginService.login(
      email: email,
      password: password,
    );

    if (response.isSuccess && response.data != null) {
      // Persist tokens if auto-login is enabled
      if (enableAutoLogin) {
        await _persistAuthTokens(response.data!);
      }

      emit(LoginSuccessState(authentication: response.data!));
      return;
    }

    emit(
      LoginErrorState(
        error: response.errorMessage,
      ),
    );
  }

  Future<void> _persistAuthTokens(AuthenticationModel authModel) async {
    try {
      await storageRepository.saveAuthTokens(
        accessToken: authModel.token,
        refreshToken: authModel.user.refreshToken ?? '',
      );
      await storageRepository.saveUserId(authModel.user.id);
      await storageRepository.saveUserEmail(authModel.user.email);
    } catch (_) {
      // Ignore persistence errors to avoid blocking login success flow
    }
  }

  /// Check if user is already logged in (auto-login)
  Future<bool> checkAutoLogin() async {
    if (!enableAutoLogin) return false;

    try {
      final isLoggedIn = await storageRepository.isLoggedIn();
      final token = await storageRepository.getAccessToken();
      return isLoggedIn && token != null && token.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Logout and clear stored credentials
  Future<void> logout() async {
    try {
      emit(const LogoutLoadingState());
      await Future.delayed(const Duration(seconds: 1), () async {
        await storageRepository.clearAuthData();
        emit(const LogoutSuccessState());
      });
    } catch (_) {
      emit(const LogoutErrorState(error: 'Logout failed'));
    }
  }
}
