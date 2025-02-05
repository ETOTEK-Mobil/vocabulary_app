import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final FormSubmissionStatus formStatus;
  final bool isPasswordMatching;

  const RegisterState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.formStatus = const InitialFormStatus(),
    this.isPasswordMatching = true,
  });

  RegisterState copyWith({
    String? username,
    String? email,
    String? password,
    String? confirmPassword,
    FormSubmissionStatus? formStatus,
    bool? isPasswordMatching,
  }) {
    return RegisterState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      formStatus: formStatus ?? this.formStatus,
      isPasswordMatching: isPasswordMatching ?? this.isPasswordMatching,
    );
  }

  @override
  List<Object> get props => [username, email, password, formStatus];
}

abstract class FormSubmissionStatus extends Equatable {
  const FormSubmissionStatus();

  @override
  List<Object> get props => [];
}

class InitialFormStatus extends FormSubmissionStatus {
  const InitialFormStatus();
}

class FormSubmitting extends FormSubmissionStatus {}

class FormSubmissionSuccess extends FormSubmissionStatus {}

class FormSubmissionFailed extends FormSubmissionStatus {
  final Exception exception;

  const FormSubmissionFailed(this.exception);

  @override
  List<Object> get props => [exception];
}
