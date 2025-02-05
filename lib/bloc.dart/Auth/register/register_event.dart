import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterPasswordCheck extends RegisterEvent {
  final String password;
  final String confirmPassword;

  RegisterPasswordCheck(
      {required this.password, required this.confirmPassword});
}

class RegisterUsernameChanged extends RegisterEvent {
  final String username;

  const RegisterUsernameChanged({required this.username});

  @override
  List<Object> get props => [username];
}

class RegisterEmailChanged extends RegisterEvent {
  final String email;

  const RegisterEmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  const RegisterPasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}

class RegisterSubmitted extends RegisterEvent {}
