import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {
  AuthState();
}

class AuthInitial extends AuthState {
  AuthInitial();
}

class AuthLoading extends AuthState {
  AuthLoading();
}

class LoggedIn extends AuthState {
  final UserCredential userCredential;
  final String role; // 'developer', 'doctor', 'advisor'

  LoggedIn({required this.userCredential, required this.role});
}

class LoggedOut extends AuthState {
  LoggedOut();
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class SignedUp extends AuthState {
  final UserCredential userCredential;

  SignedUp({required this.userCredential});
}
