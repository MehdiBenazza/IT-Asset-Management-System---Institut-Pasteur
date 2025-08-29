
import '../../domain/user.dart';
import '../datasources/user_remote_datasource.dart';
import '../../../../core/errors/exceptions.dart';

abstract class UserRepository {
	Future<List<User>> getAllUsers();
	Future<User?> getUserById(int id);
	Future<User> createUser(User user);
	Future<User> updateUser(int id, User user);
	Future<void> deleteUser(int id);
}

class UserRepositoryImpl implements UserRepository {
	final UserRemoteDataSource _remoteDataSource;

	UserRepositoryImpl({UserRemoteDataSource? remoteDataSource})
			: _remoteDataSource = remoteDataSource ?? UserRemoteDataSourceImpl();

	@override
		Future<List<User>> getAllUsers() async {
			try {
				return await _remoteDataSource.getAllUsers();
			} catch (e, stack) {
				print('Erreur getAllUsers: $e\n$stack');
				throw DataRepositoryException('Erreur lors de la récupération des utilisateurs');
			}
		}

	@override
		Future<User?> getUserById(int id) async {
			try {
				return await _remoteDataSource.getUserById(id);
			} catch (e, stack) {
				print('Erreur getUserById: $e\n$stack');
				throw DataRepositoryException('Erreur lors de la récupération de l\'utilisateur');
			}
		}

	@override
		Future<User> createUser(User user) async {
			try {
				return await _remoteDataSource.createUser(user);
			} catch (e, stack) {
				print('Erreur createUser: $e\n$stack');
				throw DataRepositoryException('Erreur lors de la création de l\'utilisateur');
			}
		}

	@override
		Future<User> updateUser(int id, User user) async {
			try {
				return await _remoteDataSource.updateUser(id, user);
			} catch (e, stack) {
				print('Erreur updateUser: $e\n$stack');
				throw DataRepositoryException('Erreur lors de la mise à jour de l\'utilisateur');
			}
		}

	@override
		Future<void> deleteUser(int id) async {
			try {
				await _remoteDataSource.deleteUser(id);
			} catch (e, stack) {
				print('Erreur deleteUser: $e\n$stack');
				throw DataRepositoryException('Erreur lors de la suppression de l\'utilisateur');
			}
		}
}
 