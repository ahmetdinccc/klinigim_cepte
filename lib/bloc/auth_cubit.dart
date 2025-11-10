import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../repository/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _userRepository;
  final FirebaseFirestore _firestore;

  AuthCubit(this._userRepository, {FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      super(AuthInitial());

  /// GİRİŞ

  /// developers / doctors / advisors koleksiyonlarında rolü bulur.
  Future<void> getSignIn(String email, String password) async {
    emit(AuthLoading());

    try {
      // Firebase Auth login
      final response = await _userRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = response.user!.uid;

      // DEVELOPER
      final devDoc = await _firestore.collection('developers').doc(uid).get();
      if (devDoc.exists) {
        emit(LoggedIn(userCredential: response, role: 'developer'));
        return;
      }

      // DOCTOR
      final doctorDoc = await _firestore.collection('doctors').doc(uid).get();
      if (doctorDoc.exists) {
        emit(LoggedIn(userCredential: response, role: 'doctor'));
        return;
      }

      // ADVISOR
      final advisorDoc = await _firestore.collection('advisors').doc(uid).get();
      if (advisorDoc.exists) {
        emit(LoggedIn(userCredential: response, role: 'advisor'));
        return;
      }

      // Hiçbirinde yoksa:
      emit(AuthError('Kullanıcı rolü bulunamadı'));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Giriş başarısız.'));
    } on FirebaseException catch (e) {
      emit(AuthError('Firestore hatası: ${e.message}'));
    } catch (e) {
      emit(
        AuthError(
          'email ve şifre alanları yanlış lüften doğru bilgileri giriniz',
        ),
      );
    }
  }

  /// KAYIT
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
        role: role,
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
