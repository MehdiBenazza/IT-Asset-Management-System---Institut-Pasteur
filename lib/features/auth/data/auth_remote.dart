import '../../../core/sevices/supabase_client.dart';
import '../domain/entities.dart';

class AuthRemoteDataSource {
	Future<void> sendPasswordResetEmail(String email) async {
		await SupabaseClientService.client.auth.resetPasswordForEmail(email);
	}
		Future<UserEntity?> login(String email, String password) async {
			final response = await SupabaseClientService.client.auth.signInWithPassword(email: email, password: password);
			final user = response.user;
			if (user == null) return null;
			return UserEntity(id: user.id, email: user.email ?? '', name: user.userMetadata?['name'] as String?);
		}

		Future<UserEntity?> signup(String email, String password) async {
			final response = await SupabaseClientService.client.auth.signUp(email: email, password: password);
			final user = response.user;
			if (user == null) return null;
			return UserEntity(id: user.id, email: user.email ?? '', name: user.userMetadata?['name'] as String?);
		}

		Future<void> logout() async {
			await SupabaseClientService.signOut();
		}

		Future<UserEntity?> getCurrentUser() async {
			final user = SupabaseClientService.currentUser;
			if (user == null) return null;
			return UserEntity(id: user.id, email: user.email ?? '', name: user.userMetadata?['name'] as String?);
		}

		Future<String?> getToken() async {
			return SupabaseClientService.accessToken;
		}
}

