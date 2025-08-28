import '../domain/intervention.dart';
import '../../../core/services/supabase_service.dart';

abstract class InterventionRemoteDataSource {
  Future<List<Intervention>> getAllInterventions();
  Future<Intervention?> getInterventionById(int id);
  Future<Intervention> createIntervention(Intervention intervention);
  Future<Intervention> updateIntervention(int id, Intervention intervention);
  Future<void> deleteIntervention(int id);
}

class InterventionRemoteDataSourceImpl implements InterventionRemoteDataSource {
  final String tableName = 'interventions';

  @override
  Future<List<Intervention>> getAllInterventions() async {
    final data = await SupabaseService.getAll(tableName);
    return data.map<Intervention>((item) => Intervention.fromMap(item)).toList();
  }

  @override
  Future<Intervention?> getInterventionById(int id) async {
    final data = await SupabaseService.getById(tableName, id);
    return data != null ? Intervention.fromMap(data) : null;
  }

  @override
  Future<Intervention> createIntervention(Intervention intervention) async {
    final data = await SupabaseService.create(tableName, intervention.toMap());
    return Intervention.fromMap(data);
  }

  @override
  Future<Intervention> updateIntervention(int id, Intervention intervention) async {
    final data = await SupabaseService.update(tableName, id, intervention.toMap());
    return Intervention.fromMap(data);
  }

  @override
  Future<void> deleteIntervention(int id) async {
    await SupabaseService.delete(tableName, id);
  }
}
