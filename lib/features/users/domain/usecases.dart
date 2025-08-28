import '../data/repositories/user_repository.dart';
import 'user.dart';

class CreateUser {
  final UserRepository repository;
  CreateUser(this.repository);
  Future<User> call(User user) async {
    return await repository.createUser(user);
  }
}

class GetAllUsers {
  final UserRepository repository;
  GetAllUsers(this.repository);
  Future<List<User>> call() async {
    return await repository.getAllUsers();
  }
}

class UpdateUser {
  final UserRepository repository;
  UpdateUser(this.repository);
  Future<User> call(int id, User user) async {
    return await repository.updateUser(id, user);
  }
}

class DeleteUser {
  final UserRepository repository;
  DeleteUser(this.repository);
  Future<void> call(int id) async {
    await repository.deleteUser(id);
  }
}
