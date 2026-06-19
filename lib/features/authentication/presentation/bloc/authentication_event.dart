part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class SignInRequested extends AuthenticationEvent {
  final String email;
  final String password;

  const SignInRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignUpRequested extends AuthenticationEvent {
  final String email;
  final String password;
  final String fullName;

  const SignUpRequested(this.email, this.password, this.fullName);

  @override
  List<Object> get props => [email, password, fullName];
}

class LogoutRequested extends AuthenticationEvent {}

class ForgotPasswordRequested extends AuthenticationEvent {
  final String email;

  const ForgotPasswordRequested(this.email);

  @override
  List<Object> get props => [email];
}

class VerifyEmailRequested extends AuthenticationEvent {}

class UpdateProfileNameRequested extends AuthenticationEvent {
  final String fullName;

  const UpdateProfileNameRequested(this.fullName);

  @override
  List<Object> get props => [fullName];
}

class UpdatePasswordRequested extends AuthenticationEvent {
  final String currentPassword;
  final String newPassword;

  const UpdatePasswordRequested(this.currentPassword, this.newPassword);

  @override
  List<Object> get props => [currentPassword, newPassword];
}

class BiometricAuthenticationSuccessful extends AuthenticationEvent {}
