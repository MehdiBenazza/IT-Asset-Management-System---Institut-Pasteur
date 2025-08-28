import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
	final SupabaseClient _client = Supabase.instance.client;

	Future<AuthResponse> signIn(String email, String password) async {
		return await _client.auth.signInWithPassword(email: email, password: password);
	}

	Future<AuthResponse> signUp(String email, String password) async {
		return await _client.auth.signUp(email: email, password: password);
	}

	Future<void> signOut() async {
		await _client.auth.signOut();
	}

	User? get currentUser => _client.auth.currentUser;

	String? get accessToken => _client.auth.currentSession?.accessToken;
	String? get refreshToken => _client.auth.currentSession?.refreshToken;
}
 