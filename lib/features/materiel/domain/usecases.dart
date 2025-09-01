import 'materiel.dart';
import '../data/repositories/materiel_repository.dart';

// Use Cases pour la gestion des matériels
abstract class MaterielUseCases {
  Future<List<Materiel>> getAllMateriels();
  Future<Materiel?> getMaterielById(int id);
  Future<Materiel> createMateriel(Materiel materiel);
  Future<Materiel> updateMateriel(int id, Materiel materiel);
  Future<void> deleteMateriel(int id);
  Future<List<Materiel>> searchMateriels(String query);
  Future<List<Materiel>> getMaterielsByEtat(String etat);
  Future<List<Materiel>> getMaterielsByType(String type);
  Future<int> getMaterielsCount();
  Future<List<Materiel>> getMaterielsPaginated({int page = 1, int limit = 20});
}

// Implémentation des Use Cases
class MaterielUseCasesImpl implements MaterielUseCases {
  final MaterielRepository _repository;

  MaterielUseCasesImpl({MaterielRepository? repository})
      : _repository = repository ?? MaterielRepositoryImpl();

  @override
  Future<List<Materiel>> getAllMateriels() async {
    return await _repository.getAllMateriels();
  }

  @override
  Future<Materiel?> getMaterielById(int id) async {
    return await _repository.getMaterielById(id);
  }

  @override
  Future<Materiel> createMateriel(Materiel materiel) async {
    return await _repository.createMateriel(materiel);
  }

  @override
  Future<Materiel> updateMateriel(int id, Materiel materiel) async {
    return await _repository.updateMateriel(id, materiel);
  }

  @override
  Future<void> deleteMateriel(int id) async {
    return await _repository.deleteMateriel(id);
  }

  @override
  Future<List<Materiel>> searchMateriels(String query) async {
    return await _repository.searchMateriels(query);
  }

  @override
  Future<List<Materiel>> getMaterielsByEtat(String etat) async {
    return await _repository.getMaterielsByEtat(etat);
  }

  @override
  Future<List<Materiel>> getMaterielsByType(String type) async {
    return await _repository.getMaterielsByType(type);
  }

  @override
  Future<int> getMaterielsCount() async {
    return await _repository.getMaterielsCount();
  }

  @override
  Future<List<Materiel>> getMaterielsPaginated({int page = 1, int limit = 20}) async {
    return await _repository.getMaterielsPaginated(page: page, limit: limit);
  }
}

// Use Case spécifique pour récupérer tous les matériels
class GetAllMaterielsUseCase {
  final MaterielUseCases _materielUseCases;

  GetAllMaterielsUseCase(this._materielUseCases);

  Future<List<Materiel>> call() async {
    return await _materielUseCases.getAllMateriels();
  }
}

// Use Case spécifique pour récupérer un matériel par ID
class GetMaterielByIdUseCase {
  final MaterielUseCases _materielUseCases;

  GetMaterielByIdUseCase(this._materielUseCases);

  Future<Materiel?> call(int id) async {
    return await _materielUseCases.getMaterielById(id);
  }
}

// Use Case spécifique pour créer un matériel
class CreateMaterielUseCase {
  final MaterielUseCases _materielUseCases;

  CreateMaterielUseCase(this._materielUseCases);

  Future<Materiel> call(Materiel materiel) async {
    return await _materielUseCases.createMateriel(materiel);
  }
}

// Use Case spécifique pour mettre à jour un matériel
class UpdateMaterielUseCase {
  final MaterielUseCases _materielUseCases;

  UpdateMaterielUseCase(this._materielUseCases);

  Future<Materiel> call(int id, Materiel materiel) async {
    return await _materielUseCases.updateMateriel(id, materiel);
  }
}

// Use Case spécifique pour supprimer un matériel
class DeleteMaterielUseCase {
  final MaterielUseCases _materielUseCases;

  DeleteMaterielUseCase(this._materielUseCases);

  Future<void> call(int id) async {
    return await _materielUseCases.deleteMateriel(id);
  }
}

// Use Case spécifique pour rechercher des matériels
class SearchMaterielsUseCase {
  final MaterielUseCases _materielUseCases;

  SearchMaterielsUseCase(this._materielUseCases);

  Future<List<Materiel>> call(String query) async {
    return await _materielUseCases.searchMateriels(query);
  }
}

// Use Case spécifique pour récupérer les matériels par état
class GetMaterielsByEtatUseCase {
  final MaterielUseCases _materielUseCases;

  GetMaterielsByEtatUseCase(this._materielUseCases);

  Future<List<Materiel>> call(String etat) async {
    return await _materielUseCases.getMaterielsByEtat(etat);
  }
}

// Use Case spécifique pour récupérer les matériels par type
class GetMaterielsByTypeUseCase {
  final MaterielUseCases _materielUseCases;

  GetMaterielsByTypeUseCase(this._materielUseCases);

  Future<List<Materiel>> call(String type) async {
    return await _materielUseCases.getMaterielsByType(type);
  }
}

// Use Case spécifique pour compter les matériels
class GetMaterielsCountUseCase {
  final MaterielUseCases _materielUseCases;

  GetMaterielsCountUseCase(this._materielUseCases);

  Future<int> call() async {
    return await _materielUseCases.getMaterielsCount();
  }
}

// Use Case spécifique pour récupérer les matériels paginés
class GetMaterielsPaginatedUseCase {
  final MaterielUseCases _materielUseCases;

  GetMaterielsPaginatedUseCase(this._materielUseCases);

  Future<List<Materiel>> call({int page = 1, int limit = 20}) async {
    return await _materielUseCases.getMaterielsPaginated(page: page, limit: limit);
  }

// Use Case spécifique pour récupérer les matériels par département
class GetMaterielsByDepartementUseCase {
  final MaterielUseCases _materielUseCases;

  GetMaterielsByDepartementUseCase(this._materielUseCases);

  Future<List<Materiel>> call(String departement) async {
    return await _materielUseCases.getMaterielsByDepartement(departement);
  }
}


