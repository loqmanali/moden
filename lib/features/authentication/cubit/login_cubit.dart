import 'package:bloc/bloc.dart';
import 'package:modn/features/authentication/services/login_service.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginService loginService;
  LoginCubit({required this.loginService}) : super(const LoginInitial());

  void login({required String email, required String password}) {
    emit(const LoginLoadingState());
    try {
      loginService.login(email: email, password: password);
      emit(const LoginSuccessState());
    } catch (e) {
      emit(LoginErrorState(error: e.toString()));
    }
  }
}
