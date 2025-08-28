import '../data/repositories/departement_repository.dart';
import 'departement.dart';

import '../../users/data/repositories/user_repository.dart';
import '../../bureau/data/repositories/bureau_repository.dart';
import '../../users/domain/user.dart';

class CreateDepartement {
  final DepartementRepository repository;
  CreateDepartement(this.repository);
  Future<Departement> call(Departement departement) async {
    return await repository.createDepartement(departement);
  }
}

class GetAllDepartements {
  final DepartementRepository repository;
  GetAllDepartements(this.repository);
  Future<List<Departement>> call() async {
    return await repository.getAllDepartements();
  }
}

class AssignBureauToUser {
  final UserRepository userRepository;
  final BureauRepository bureauRepository;
  AssignBureauToUser(this.userRepository, this.bureauRepository);

  Future<User?> call({required int userId, required int bureauId}) async {
    final user = await userRepository.getUserById(userId);
    final bureau = await bureauRepository.getBureauById(bureauId);
    if (user == null || bureau == null) return null;
    final updatedUser = user.copyWith(idBureau: bureau.id, bureau: bureau);
    return await userRepository.updateUser(userId, updatedUser);
  }
}
