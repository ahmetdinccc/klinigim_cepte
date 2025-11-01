import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class LoggedIn extends AuthState {
  final User user;
  final String role; // developer / advisor / doctor / unknown

  LoggedIn({required this.user, required this.role});

  @override
  List<Object?> get props => [user, role];
}

class SignedUp extends AuthState {
  final User user;
  final String role;

  SignedUp({required this.user, required this.role});

  @override
  List<Object?> get props => [user, role];
}

class LoggedOut extends AuthState {}
