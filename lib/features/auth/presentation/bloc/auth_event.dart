import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String? name;

  RegisterRequested({required this.email, required this.password, this.name});

  @override
  List<Object?> get props => [email, password, name];
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}
