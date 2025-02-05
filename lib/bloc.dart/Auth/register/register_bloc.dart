import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erva_vocubulary/services/auth_service.dart';
import 'package:erva_vocubulary/ui/utils/auth_validator.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthService authService;

  RegisterBloc({required this.authService}) : super(const RegisterState()) {
    on<RegisterUsernameChanged>(_onUsernameChanged);
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterSubmitted>(_onSubmitted);
    on<RegisterPasswordCheck>(_onPasswordCheck);
  }

  void _onUsernameChanged(
      RegisterUsernameChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(
        username: event.username, formStatus: const InitialFormStatus()));
  }

  void _onEmailChanged(
      RegisterEmailChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(
        email: event.email, formStatus: const InitialFormStatus()));
  }

  void _onPasswordCheck(
      RegisterPasswordCheck event, Emitter<RegisterState> emit) {
    final isMatching = event.password == event.confirmPassword;
    emit(state.copyWith(isPasswordMatching: isMatching));
  }

  void _onPasswordChanged(
      RegisterPasswordChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(
        password: event.password, formStatus: const InitialFormStatus()));
  }

  void _onSubmitted(
      RegisterSubmitted event, Emitter<RegisterState> emit) async {
    final usernameError = AuthValidators.validateUsername(state.username);
    final emailError = AuthValidators.validateEmail(state.email);
    final passwordError = AuthValidators.validatePassword(state.password);

    if (usernameError != null || emailError != null || passwordError != null) {
      final errorMessages = [
        if (usernameError != null) usernameError,
        if (emailError != null) emailError,
        if (passwordError != null) passwordError,
      ].join('\n');

      emit(state.copyWith(
        username: state.username,
        email: state.email,
        password: state.password,
        formStatus: FormSubmissionFailed(
          Exception(errorMessages),
        ),
      ));
    } else {
      emit(state.copyWith(formStatus: FormSubmitting()));

      try {
        await AuthService.register(state.username, state.password, state.email);
        emit(state.copyWith(formStatus: FormSubmissionSuccess()));
      } catch (e) {
        emit(state.copyWith(formStatus: FormSubmissionFailed(e as Exception)));
      }
    }
  }
}
