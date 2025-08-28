import '../data/repositories/bureau_repository.dart';
import 'bureau.dart';

class CreateBureau {
  final BureauRepository repository;
  CreateBureau(this.repository);
  Future<Bureau> call(Bureau bureau) async {
    return await repository.createBureau(bureau);
  }
}

class GetAllBureaux {
  final BureauRepository repository;
  GetAllBureaux(this.repository);
  Future<List<Bureau>> call() async {
    return await repository.getAllBureaux();
  }
}
