import '../../../../core/services/supabase_service.dart';
import '../../domain/departement.dart';
import '../repositories/departement_mapper.dart';

class DepartementDataSource {
	final String table = 'departement';

	Future<List<Departement>> getAll() async {
		final response = await SupabaseService.getAll(table);
		return response.map((e) => DepartementMapper.fromMap(e)).toList();
	}

	Future<Departement?> getById(int id) async {
		final response = await SupabaseService.getById(table, id);
		if (response == null) return null;
		return DepartementMapper.fromMap(response);
	}

	Future<int?> create(Departement departement) async {
		final data = DepartementMapper.toMap(departement);
		final response = await SupabaseService.create(table, data);
		return response['id'] as int?;
	}

	Future<bool> update(Departement departement) async {
		if (departement.id == null) return false;
		final data = DepartementMapper.toMap(departement);
		final response = await SupabaseService.update(table, departement.id!, data);
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
 