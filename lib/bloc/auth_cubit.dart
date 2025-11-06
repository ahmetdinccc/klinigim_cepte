import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 🔥 EKLE
import '../repository/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _userRepository;

  AuthCubit(this._userRepository) : super(AuthInitial());

  Future<void> getSignIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await _userRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = response.user!.uid;
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!snap.exists) {
        emit(AuthError('Kullanıcı profili bulunamadı (users/{uid}).'));
        return;
      }

      final role = (snap.data()?['role'] as String?)?.trim();
      if (role == null || role.isEmpty) {
        emit(AuthError('Kullanıcı rolü boş veya tanımsız.'));
        return;
      }

      emit(LoggedIn(userCredential: response, role: role));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String role, // "doctor" | "advisor" | "developer"
    required String phone,
    required String clinicname,
  }) async {
    emit(AuthLoading());
    try {
      final userCredential = await _userRepository.signUp(
        clinicname: clinicname,
        name: name,
        email: email,
        password: password,
        phone: phone,
        role: role, // 🔥 repo Firestore'a bu role'ü yazmalı
      );
      emit(SignedUp(userCredential: userCredential));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(AuthError('Bu e-posta adresi zaten kullanılıyor.'));
      } else {
        emit(AuthError(e.message ?? 'Kayıt başarısız.'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithGitHub(String accessToken) async {
    emit(AuthLoading());
    try {
      final credential = GithubAuthProvider.credential(accessToken);
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      // GitHub ile girişte de rolü çek
      final uid = userCredential.user!.uid;
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final role = (snap.data()?['role'] as String?)?.trim() ?? 'unknown';

      emit(LoggedIn(userCredential: userCredential, role: role));
    } catch (e) {
      emit(AuthError("GitHub ile giriş başarısız: $e"));
    }
  }

  Future<void> getsignOut() async {
    emit(AuthLoading());
    try {
      await _userRepository.loggedOut();
      emit(LoggedOut());
    } catch (e) {
      emit(AuthError("hata oluştu: $e"));
    }
  }
}
