import '../../../../core/services/supabase_service.dart';
import '../../domain/bureau.dart';

abstract class BureauRemoteDataSource {
  Future<List<Bureau>> getAllBureaux();
  Future<Bureau?> getBureauById(int id);
  Future<Bureau> createBureau(Bureau bureau);
  Future<Bureau> updateBureau(int id, Bureau bureau);
  Future<void> deleteBureau(int id);
  Future<List<Bureau>> getBureauxByDepartement(int departementId);
}

class BureauRemoteDataSourceImpl implements BureauRemoteDataSource {
  @override
  Future<List<Bureau>> getBureauxByDepartement(int departementId) async {
    final data = await SupabaseService.search(
      _tableName,
      'id_departement',
      departementId.toString(),
    );
    return data.map((json) => Bureau.fromMap(json)).toList();
  }
  static const String _tableName = 'bureau';

  @override
  Future<List<Bureau>> getAllBureaux() async {
    final data = await SupabaseService.getAll(_tableName);
    return data.map((json) => Bureau.fromMap(json)).toList();
  }

  @override
  Future<Bureau?> getBureauById(int id) async {
    final data = await SupabaseService.getById(_tableName, id);
    if (data == null) return null;
    return Bureau.fromMap(data);
  }

  @override
  Future<Bureau> createBureau(Bureau bureau) async {
    final data = bureau.toMap();
    data.remove('id');
    final result = await SupabaseService.create(_tableName, data);
    return Bureau.fromMap(result);
  }

  @override
  Future<Bureau> updateBureau(int id, Bureau bureau) async {
    final data = bureau.toMap();
    data.remove('id');
    final result = await SupabaseService.update(_tableName, id, data);
    return Bureau.fromMap(result);
  }

  @override
  Future<void> deleteBureau(int id) async {
    await SupabaseService.delete(_tableName, id);
  }
}
