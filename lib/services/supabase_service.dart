import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/health_record.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;
  static const String _table = 'health_records';

  static User? get currentUser => _client.auth.currentUser;

  static Stream<AuthState> get authStream => _client.auth.onAuthStateChange;

  static Future<AuthResponse> register({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signUp(email: email, password: password);
  }

  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> logout() async {
    await _client.auth.signOut();
  }

  static Future<List<HealthRecord>> getRecords() async {
    final userId = currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from(_table)
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => HealthRecord.fromJson(json))
        .toList();
  }

  static Future<void> addRecord(HealthRecord record) async {
    await _client.from(_table).insert(record.toJson());
  }

  static Future<void> updateRecord(HealthRecord record) async {
    await _client.from(_table).update(record.toJson()).eq('id', record.id);
  }

  static Future<void> deleteRecord(String id) async {
    await _client.from(_table).delete().eq('id', id);
  }
}
