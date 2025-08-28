import 'appartenance_remote.dart';
import '../domain/appartenance.dart';

class AppartenanceRepository {
	final AppartenanceRemoteDataSource remoteDataSource;

	AppartenanceRepository({AppartenanceRemoteDataSource? remote})
			: remoteDataSource = remote ?? AppartenanceRemoteDataSource();

	Future<List<Appartenance>> getAll() async {
		return await remoteDataSource.getAll();
	}

	Future<Appartenance?> getById(int id) async {
		return await remoteDataSource.getById(id);
	}

	Future<int?> create(Appartenance appartenance) async {
		return await remoteDataSource.create(appartenance);
	}

	Future<bool> update(Appartenance appartenance) async {
		return await remoteDataSource.update(appartenance);
	}

	Future<bool> delete(int id) async {
		return await remoteDataSource.delete(id);
	}
}
