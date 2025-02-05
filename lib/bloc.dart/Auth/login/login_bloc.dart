import 'package:erva_vocubulary/bloc.dart/Auth/login/login.state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erva_vocubulary/services/auth_service.dart';
import 'package:erva_vocubulary/ui/utils/auth_validator.dart';
import 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService authService;

  LoginBloc({required this.authService}) : super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
        email: event.email, formStatus: const InitialFormStatus()));
  }

  void _onPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
        password: event.password, formStatus: const InitialFormStatus()));
  }

  void _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    final emailError = AuthValidators.validateEmail(state.email);
    final passwordError = AuthValidators.validatePassword(state.password);

    if (emailError != null || passwordError != null) {
      final errorMessages = [
        if (emailError != null) emailError,
        if (passwordError != null) passwordError,
      ].join('\n');

      emit(state.copyWith(
        email: state.email,
        password: state.password,
        formStatus: FormSubmissionFailed(
          Exception(errorMessages),
        ),
      ));
    } else {
      emit(state.copyWith(formStatus: FormSubmitting()));

      try {
        await AuthService.login(state.email, state.password);
        emit(state.copyWith(formStatus: FormSubmissionSuccess()));
      } catch (e) {
        emit(state.copyWith(formStatus: FormSubmissionFailed(e as Exception)));
      }
    }
  }
}
