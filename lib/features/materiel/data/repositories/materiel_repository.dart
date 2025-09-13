import '../../domain/materiel.dart';
import '../datasources/materiel_remote_datasource.dart';


abstract class MaterielRepository {
  Future<List<Materiel>> getAllMateriels();
  Future<Materiel?> getMaterielById(int id);
  Future<Materiel> createMateriel(Materiel materiel);
  Future<Materiel> updateMateriel(int id, Materiel materiel);
  Future<void> deleteMateriel(int id);
  Future<List<Materiel>> searchMateriels(String query);
  Future<List<Materiel>> getMaterielsByEtat(String etat);
  Future<List<Materiel>> getMaterielsByType(String type);
  Future<List<Materiel>> getMaterielsByOS(String os);
  Future<List<Materiel>> getMaterielsByBureau(int bureauId);
  Future<List<Materiel>> getMaterielsByDepartement(int departementId);
  Future<int> getMaterielsCount();
  Future<List<Materiel>> getMaterielsPaginated({int page = 1, int limit = 20});
}

class MaterielRepositoryImpl implements MaterielRepository {
  final MaterielRemoteDataSource _remoteDataSource;

  MaterielRepositoryImpl({MaterielRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? MaterielRemoteDataSourceImpl();

  @override
  Future<List<Materiel>> getAllMateriels() async {
    try {
      return await _remoteDataSource.getAllMateriels();
    } catch (e) {
      throw Exception('Erreur repository: Impossible de récupérer les matériels - $e');
    }
  }

  @override
  Future<Materiel?> getMaterielById(int id) async {
    try {
      return await _remoteDataSource.getMaterielById(id);
    } catch (e) {
      throw Exception('Erreur repository: Impossible de récupérer le matériel avec l\'ID $id - $e');
    }
  }

  @override
  Future<Materiel> createMateriel(Materiel materiel) async {
    try {
      // Validation basique côté repository
      if (materiel.type.trim().isEmpty) {
        throw Exception('Le type de matériel ne peut pas être vide');
      }
      
      return await _remoteDataSource.createMateriel(materiel);
    } catch (e) {
      throw Exception('Erreur repository: Impossible de créer le matériel - $e');
    }
  }

  @override
  Future<Materiel> updateMateriel(int id, Materiel materiel) async {
    try {
      // Validation basique côté repository
      if (materiel.type.trim().isEmpty) {
        throw Exception('Le type de matériel ne peut pas être vide');
      }
      
      return await _remoteDataSource.updateMateriel(id, materiel);
    } catch (e) {
      throw Exception('Erreur repository: Impossible de mettre à jour le matériel avec l\'ID $id - $e');
    }
  }

  @override
  Future<void> deleteMateriel(int id) async {
    try {
      await _remoteDataSource.deleteMateriel(id);
    } catch (e) {
      throw Exception('Erreur repository: Impossible de supprimer le matériel avec l\'ID $id - $e');
    }
  }

  @override
  Future<List<Materiel>> searchMateriels(String query) async {
    try {
      if (query.trim().isEmpty) {
        return await getAllMateriels();
      }
      return await _remoteDataSource.searchMateriels(query);
    } catch (e) {
      throw Exception('Erreur repository: Impossible de rechercher les matériels - $e');
    }
  }

  @override
  Future<List<Materiel>> getMaterielsByEtat(String etat) async {
    try {
      return await _remoteDataSource.getMaterielsByEtat(etat);
    } catch (e) {
      throw Exception('Erreur repository: Impossible de récupérer les matériels par état - $e');
    }
  }

  @override
  Future<List<Materiel>> getMaterielsByType(String type) async {
    try {
      return await _remoteDataSource.getMaterielsByType(type);
    } catch (e) {
      throw Exception('Erreur repository: Impossible de récupérer les matériels par type - $e');
    }
  }

  @override
  Future<int> getMaterielsCount() async {
    try {
      return await _remoteDataSource.getMaterielsCount();
    } catch (e) {
      throw Exception('Erreur repository: Impossible de compter les matériels - $e');
    }
  }

  @override
  Future<List<Materiel>> getMaterielsByOS(String os) async {
    try {
      return await _remoteDataSource.getMaterielsByOS(os);
    } catch (e) {
      throw Exception('Erreur repository: Impossible de récupérer les matériels par OS - $e');
    }
  }

  @override
  Future<List<Materiel>> getMaterielsByBureau(int bureauId) async {
    try {
      return await _remoteDataSource.getMaterielsByBureau(bureauId);
    } catch (e) {
      throw Exception('Erreur repository: Impossible de récupérer les matériels par bureau - $e');
    }
  }

  @override
  Future<List<Materiel>> getMaterielsByDepartement(int departementId) async {
    try {
      return await _remoteDataSource.getMaterielsByDepartement(departementId);
    } catch (e) {
      throw Exception('Erreur repository: Impossible de récupérer les matériels par département - $e');
    }
  }

  @override
  Future<List<Materiel>> getMaterielsPaginated({int page = 1, int limit = 20}) async {
    try {
      if (page < 1) page = 1;
      if (limit < 1) limit = 20;
      if (limit > 100) limit = 100; // Limite pour éviter les requêtes trop lourdes
      
      return await _remoteDataSource.getMaterielsPaginated(page: page, limit: limit);
    } catch (e) {
      throw Exception('Erreur repository: Impossible de récupérer les matériels paginés - $e');
    }
  }
}
