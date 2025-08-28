import '../../../core/services/supabase_service.dart';
import '../domain/appartenance.dart';
import 'appartenance_mapper.dart';

class AppartenanceRemoteDataSource {
		final String table = 'appartenance';

		AppartenanceRemoteDataSource();

		Future<List<Appartenance>> getAll() async {
			final response = await SupabaseService.getAll(table);
			return response.map((e) => AppartenanceMapper.fromMap(e)).toList();
		}

		Future<Appartenance?> getById(int id) async {
			final response = await SupabaseService.getById(table, id);
			if (response == null) return null;
			return AppartenanceMapper.fromMap(response);
		}

		Future<int?> create(Appartenance appartenance) async {
			final data = AppartenanceMapper.toMap(appartenance);
			final response = await SupabaseService.create(table, data);
			return response['id'] as int?;
		}

		Future<bool> update(Appartenance appartenance) async {
			if (appartenance.id == null) return false;
			final data = AppartenanceMapper.toMap(appartenance);
			final response = await SupabaseService.update(table, appartenance.id!, data);
			return response.isNotEmpty;
		}

		Future<bool> delete(int id) async {
			try {
				await SupabaseService.delete(table, id);
				return true;
			} catch (_) {
				return false;
			}
		}
}
