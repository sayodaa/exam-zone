part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final String uId;

  LoginSuccess(this.uId);
}

class LoginFailure extends AuthState {
  final String errorMessage;
  LoginFailure(this.errorMessage);
}

class SignUpLoading extends AuthState {}

class SignUpFailure extends AuthState {
  final String errorMessage;
  SignUpFailure(this.errorMessage);
}

class CreateUserSuccess extends AuthState {
  final String uId;
  CreateUserSuccess(this.uId);
}

class CreateUserFailure extends AuthState {
  final String errorMessage;
  CreateUserFailure(this.errorMessage);
}

class PasswordVisibility extends AuthState {}
