part of 'login_cubit.dart';

sealed class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoadingState extends LoginState {
  const LoginLoadingState();
}

class LoginSuccessState extends LoginState {
  final AuthenticationModel authentication;
  const LoginSuccessState({required this.authentication});
}

class LoginErrorState extends LoginState {
  final String error;
  const LoginErrorState({required this.error});
}

class LogoutLoadingState extends LoginState {
  const LogoutLoadingState();
}

class LogoutSuccessState extends LoginState {
  const LogoutSuccessState();
}

class LogoutErrorState extends LoginState {
  final String error;
  const LogoutErrorState({required this.error});
}
