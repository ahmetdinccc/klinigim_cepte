import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hasta_takip/bloc/my_auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repository/auth_repository.dart';
import 'my_auth_state.dart' as my;


class AuthCubit extends Cubit<my.AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(my.AuthInitial());

  /// danışman / doktor / geliştirici hepsi buradan login olacak
  Future<void> getSignIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(LoggedIn(user: result.user, role: result.role));
    } on AuthException catch (e) {
      // supabase'ten gelen auth hatası
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  

  /// geliştirici panelinden kullanıcı oluşturma
  Future<void> createUserFromDeveloper({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String role, // doctor | advisor | developer
    String? clinicId,
  }) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.signUpWithRole(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        role: role,
        clinicId: clinicId,
      );

      emit(SignedUp(user: result.user, role: result.role));
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(LoggedOut());
    } catch (e) {
      emit(AuthError("Çıkış yapılamadı: $e"));
    }
  }
}
