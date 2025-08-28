import '../../../../core/services/supabase_service.dart';
import '../../domain/user.dart';

abstract class UserRemoteDataSource {
  Future<List<User>> getAllUsers();
  Future<User?> getUserById(int id);
  Future<User> createUser(User user);
  Future<User> updateUser(int id, User user);
  Future<void> deleteUser(int id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  static const String _tableName = 'user';

  @override
  Future<List<User>> getAllUsers() async {
    final data = await SupabaseService.getAll(_tableName);
    return data.map((json) => User.fromMap(json)).toList();
  }

  @override
  Future<User?> getUserById(int id) async {
    final data = await SupabaseService.getById(_tableName, id);
    if (data == null) return null;
    return User.fromMap(data);
  }

  @override
  Future<User> createUser(User user) async {
    final data = user.toMap();
    data.remove('id');
    final result = await SupabaseService.create(_tableName, data);
    return User.fromMap(result);
  }

  @override
  Future<User> updateUser(int id, User user) async {
    final data = user.toMap();
    data.remove('id');
    final result = await SupabaseService.update(_tableName, id, data);
    return User.fromMap(result);
  }

  @override
  Future<void> deleteUser(int id) async {
    await SupabaseService.delete(_tableName, id);
  }
}
