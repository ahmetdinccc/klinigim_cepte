import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repository/auth_repository.dart';
import 'my_auth_state.dart' as my;

class AuthCubit extends Cubit<my.AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(my.AuthInitial());

  /// danışman / doktor / geliştirici hepsi buradan login olacak
  Future<void> getSignIn(String email, String password) async {
    emit(my.AuthLoading());
    try {
      // ufak normalizasyon
      final result = await _authRepository.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password.trim(),
      );

      // burada rolü de normalize edip gönderelim
      final normalizedRole = result.role.trim(); // developer , developer  gibi durumlar için
      // ignore: avoid_print
      print('✅ AuthCubit -> giriş başarılı. ROLE: "$normalizedRole"');

      emit(my.LoggedIn(user: result.user, role: normalizedRole));
    } on AuthException catch (e) {
      // supabase'ten gelen auth hatası
      emit(my.AuthError(e.message));
    } catch (e) {
      emit(my.AuthError(e.toString()));
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
    emit(my.AuthLoading());
    try {
      final result = await _authRepository.signUpWithRole(
        email: email.trim().toLowerCase(),
        password: password.trim(),
        fullName: fullName,
        phone: phone,
        role: role.trim().toLowerCase(), // backend hep ingilizce tutsun
        clinicId: clinicId,
      );

      emit(my.SignedUp(user: result.user, role: result.role));
    } on AuthException catch (e) {
      emit(my.AuthError(e.message));
    } catch (e) {
      emit(my.AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(my.AuthLoading());
    try {
      await _authRepository.signOut();
      emit(my.LoggedOut());
    } catch (e) {
      emit(my.AuthError("Çıkış yapılamadı: $e"));
    }
  }
}
