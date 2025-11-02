import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client;
  AuthRepository(this._client);

  /// -------------------------
  /// 1) LOGIN (email + şifre)
  /// -------------------------
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = res.user;
      if (user == null) {
        throw Exception("Kullanıcı bulunamadı");
      }

      // user_roles tablosundan rolü çek
      final roleRow = await _client
          .from('user_roles')
          .select('role')
          .eq('user_id', user.id)
          .maybeSingle();

      // boş gelirse developer diyelim
      final role = (roleRow?['role'] as String? ?? 'developer').trim();

      return AuthResult(user: user, role: role);
    } on AuthException catch (e) {
      // Supabase'in kendi hatası
      throw AuthException(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw Exception("Giriş sırasında hata: $e");
    }
  }

  /// ------------------------------------------------
  /// 2) SIGN UP (geliştirici panelinden kullanıcı ekle)
  ///    - auth.users'a user ekler
  ///    - user_roles tablosuna rol yazar
  ///    - (varsa) profiles tablosuna extra info yazar
  /// ------------------------------------------------
  Future<AuthResult> signUpWithRole({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String role, // "doctor" | "advisor" | "developer"
    String? clinicId,
  }) async {
    // 1) önce auth'a kaydet
    final res = await _client.auth.signUp(
      email: email.trim().toLowerCase(),
      password: password.trim(),
      data: {
        'full_name': fullName,
        'phone': phone,
        'role': role.trim().toLowerCase(),
      },
    );

    final user = res.user;
    if (user == null) {
      throw Exception("Kullanıcı oluşturulamadı (email doğrulama açık olabilir)");
    }

    final userId = user.id;

    // 2) user_roles tablosuna yaz
    await _client.from('user_roles').insert({
      'user_id': userId,
      'role': role.trim().toLowerCase(),
      if (clinicId != null) 'clinic_id': clinicId,
    });

    // 3) profiles tablosuna da yazmak istersen (RLS açıksa hata verebilir)
    try {
      await _client.from('profiles').insert({
        'id': userId,
        'full_name': fullName,
        'phone': phone,
        'role': role.trim().toLowerCase(),
        'clinic_id': clinicId,
      });
    } catch (e) {
      // profiles kapalıysa app patlamasın
      // debug için bakarsın
      // print('profiles insert error: $e');
    }

    return AuthResult(user: user, role: role.trim().toLowerCase());
  }

  /// -------------------------
  /// 3) LOGOUT
  /// -------------------------
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}

/// küçük model
class AuthResult {
  final User user;
  final String role;
  AuthResult({required this.user, required this.role});
}
