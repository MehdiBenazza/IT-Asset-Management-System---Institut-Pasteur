import '../auth_remote.dart';
import '../../domain/entities.dart';

class AuthRepository {
	final AuthRemoteDataSource remoteDataSource;

	AuthRepository({AuthRemoteDataSource? remote})
			: remoteDataSource = remote ?? AuthRemoteDataSource();

	Future<UserEntity?> login(String email, String password) async {
		return await remoteDataSource.login(email, password);
	}

	Future<UserEntity?> signup(String email, String password) async {
		return await remoteDataSource.signup(email, password);
	}

	Future<void> logout() async {
		await remoteDataSource.logout();
	}

	Future<UserEntity?> getCurrentUser() async {
		return await remoteDataSource.getCurrentUser();
	}

	Future<String?> getToken() async {
		return await remoteDataSource.getToken();
	}
}
 