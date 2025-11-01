import 'package:supabase_flutter/supabase_flutter.dart';

/// login + kayıt + rol çekme için ortak sınıf
class AuthRepository {
  final SupabaseClient _client;
  AuthRepository(this._client);

  /// tek işi: email+şifre ile login ve rolü çekmek
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final res = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (res.user == null) {
      throw Exception("Kullanıcı bulunamadı");
    }

    // role tablosundan çek
    final roleRow = await _client
        .from('user_roles')
        .select('role')
        .eq('user_id', res.user!.id)
        .maybeSingle();

    print('USER ROLE ROW: $roleRow');
    final role = roleRow?['role'] as String? ?? 'unknown';

    return AuthResult(user: res.user!, role: role);
  }

  /// geliştirici panelinden “doktor / danışman / geliştirici” eklemek için
  Future<AuthResult> signUpWithRole({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String role, // doctor | advisor | developer
    String? clinicId,
  }) async {
    // 1) auth.users'a ekle
    final res = await _client.auth.signUp(email: email, password: password);

    if (res.user == null) {
      throw Exception("Kullanıcı oluşturulamadı");
    }

    final userId = res.user!.id;

    // 2) user_roles tablosuna rolü yaz
    await _client.from('user_roles').insert({'user_id': userId, 'role': role});

    // 3) profiles tablosuna ekstra bilgileri yaz (varsa)
    await _client.from('profiles').insert({
      'id': userId,
      'full_name': fullName,
      'phone': phone,
      'role': role,
      'clinic_id': clinicId,
    });

    return AuthResult(user: res.user!, role: role);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}

/// dart 2/3 farkı olmasın diye küçük model
class AuthResult {
  final User user;
  final String role;

  AuthResult({required this.user, required this.role});
}
