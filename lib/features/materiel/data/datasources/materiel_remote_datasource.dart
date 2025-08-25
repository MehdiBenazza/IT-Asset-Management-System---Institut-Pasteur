import '../../../../core/services/supabase_service.dart';
import '../../domain/materiel.dart';

abstract class MaterielRemoteDataSource {
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

class MaterielRemoteDataSourceImpl implements MaterielRemoteDataSource {
  static const String _tableName = 'materiel';

  @override
  Future<List<Materiel>> getAllMateriels() async {
    try {
      final data = await SupabaseService.getAll(_tableName);
      return data.map((json) => Materiel.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des matériels: $e');
    }
  }

  @override
  Future<Materiel?> getMaterielById(int id) async {
    try {
      final data = await SupabaseService.getById(_tableName, id);
      if (data == null) return null;
      return Materiel.fromMap(data);
    } catch (e) {
      throw Exception('Erreur lors de la récupération du matériel: $e');
    }
  }

  @override
  Future<Materiel> createMateriel(Materiel materiel) async {
    try {
      final data = materiel.toMap();
      // Supprimer l'id s'il existe pour la création
      data.remove('id');
      
      final result = await SupabaseService.create(_tableName, data);
      return Materiel.fromMap(result);
    } catch (e) {
      throw Exception('Erreur lors de la création du matériel: $e');
    }
  }

  @override
  Future<Materiel> updateMateriel(int id, Materiel materiel) async {
    try {
      final data = materiel.toMap();
      // Supprimer l'id pour la mise à jour
      data.remove('id');
      
      final result = await SupabaseService.update(_tableName, id, data);
      return Materiel.fromMap(result);
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du matériel: $e');
    }
  }

  @override
  Future<void> deleteMateriel(int id) async {
    try {
      await SupabaseService.delete(_tableName, id);
    } catch (e) {
      throw Exception('Erreur lors de la suppression du matériel: $e');
    }
  }

  @override
  Future<List<Materiel>> searchMateriels(String query) async {
    try {
      // Recherche OR côté base pour éviter les doublons et améliorer les perfs
      final data = await SupabaseService.searchOr(
        _tableName,
        conditions: {
          'type': query,
          'modele': query,
        },
      );
      return data.map((json) => Materiel.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la recherche de matériels: $e');
    }
  }

  @override
  Future<List<Materiel>> getMaterielsByEtat(String etat) async {
    try {
      final normalizedEtat = etat == 'en_panne' ? 'enPanne' : etat == 'en_reparation' ? 'enReparation' : etat;
      final data = await SupabaseService.filter(_tableName, {'etat': normalizedEtat});
      return data.map((json) => Materiel.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des matériels par état: $e');
    }
  }

  @override
  Future<List<Materiel>> getMaterielsByType(String type) async {
    try {
      final data = await SupabaseService.filter(_tableName, {'type': type});
      return data.map((json) => Materiel.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des matériels par type: $e');
    }
  }

  @override
  Future<int> getMaterielsCount() async {
    try {
      return await SupabaseService.getCount(_tableName);
    } catch (e) {
      throw Exception('Erreur lors du comptage des matériels: $e');
    }
  }

  @override
  Future<List<Materiel>> getMaterielsPaginated({int page = 1, int limit = 20}) async {
    try {
      final data = await SupabaseService.getPaginated(_tableName, page: page, limit: limit);
      return data.map((json) => Materiel.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la pagination des matériels: $e');
    }
  }
}
