import '../../../../core/services/supabase_service.dart';
import '../../domain/departement.dart';

abstract class DepartementRemoteDataSource {
  Future<List<Departement>> getAllDepartements();
  Future<Departement?> getDepartementById(int id);
  Future<Departement> createDepartement(Departement departement);
  Future<Departement> updateDepartement(int id, Departement departement);
  Future<void> deleteDepartement(int id);
}

class DepartementRemoteDataSourceImpl implements DepartementRemoteDataSource {
  static const String _tableName = 'departement';

  @override
  Future<List<Departement>> getAllDepartements() async {
    final data = await SupabaseService.getAll(_tableName);
    return data.map((json) => Departement.fromMap(json)).toList();
  }

  @override
  Future<Departement?> getDepartementById(int id) async {
    final data = await SupabaseService.getById(_tableName, id);
    if (data == null) return null;
    return Departement.fromMap(data);
  }

  @override
  Future<Departement> createDepartement(Departement departement) async {
    final data = departement.toMap();
    data.remove('id');
    final result = await SupabaseService.create(_tableName, data);
    return Departement.fromMap(result);
  }

  @override
  Future<Departement> updateDepartement(int id, Departement departement) async {
    final data = departement.toMap();
    data.remove('id');
    final result = await SupabaseService.update(_tableName, id, data);
    return Departement.fromMap(result);
  }

  @override
  Future<void> deleteDepartement(int id) async {
    await SupabaseService.delete(_tableName, id);
  }
}
