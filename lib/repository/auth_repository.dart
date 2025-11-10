import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthRepository {

  final FirebaseAuth auth;

  AuthRepository({required this.auth});

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (kDebugMode) print('Kullanıcı girişi başarılı');
      return userCredential;
    } catch (e) {
      if (kDebugMode) print('Giriş hatası: $e');
      throw Exception('Giriş başarısız: Email veya şifre yanlış.');
    }
  }


Future<UserCredential> signUp({
 required String clinicname,
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,

  }) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
'clinicName':clinicname,
        'name': name,
        'email': email,
        'password':password,
        'phone':phone,
      
        'role':role,

      });

      if (kDebugMode) print('Kullanıcı oluşturuldu');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print('FirebaseAuthException: ${e.code}');
      rethrow;
    } catch (e) {
      if (kDebugMode) print('Hata: $e');
      throw Exception('Kayıt başarısız');
    }
  }


  Future<void> loggedOut() async {
    try {
      await auth.signOut();
      if (kDebugMode) print('Çıkış yapıldı');
    } catch (e) {
      if (kDebugMode) print('Çıkış hatası: $e');
    }
  }

}
