import '../domain/localisation.dart';
import '../../../core/services/supabase_service.dart';

abstract class LocalisationRemoteDataSource {
  Future<List<Localisation>> getAllLocalisations();
  Future<Localisation?> getLocalisationById(int id);
  Future<Localisation> createLocalisation(Localisation localisation);
  Future<Localisation> updateLocalisation(int id, Localisation localisation);
  Future<void> deleteLocalisation(int id);
}

class LocalisationRemoteDataSourceImpl implements LocalisationRemoteDataSource {
  final String tableName = 'localisations';

  @override
  Future<List<Localisation>> getAllLocalisations() async {
    final data = await SupabaseService.getAll(tableName);
    return data.map<Localisation>((item) => Localisation.fromMap(item)).toList();
  }

  @override
  Future<Localisation?> getLocalisationById(int id) async {
    final data = await SupabaseService.getById(tableName, id);
    return data != null ? Localisation.fromMap(data) : null;
  }

  @override
  Future<Localisation> createLocalisation(Localisation localisation) async {
    final data = await SupabaseService.create(tableName, localisation.toMap());
    return Localisation.fromMap(data);
  }

  @override
  Future<Localisation> updateLocalisation(int id, Localisation localisation) async {
    final data = await SupabaseService.update(tableName, id, localisation.toMap());
    return Localisation.fromMap(data);
  }

  @override
  Future<void> deleteLocalisation(int id) async {
    await SupabaseService.delete(tableName, id);
  }
}
