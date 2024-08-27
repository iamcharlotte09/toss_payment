import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient supabase;

  AuthRepository({required this.supabase});

  Stream<AuthState>? get authState => supabase.auth.onAuthStateChange;

  login({required String email, required String password}) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  logout() async {
    return await supabase.auth.signOut();
  }

  signUp({required String email, required String password}) async {
    return await supabase.auth.signUp(
      email: email,
      password: password,
    );
  }
}
