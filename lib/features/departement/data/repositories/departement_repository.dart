import '../../domain/departement.dart';
import '../datasources/departement_remote_datasource.dart';

abstract class DepartementRepository {
	Future<List<Departement>> getAllDepartements();
	Future<Departement?> getDepartementById(int id);
	Future<Departement> createDepartement(Departement departement);
	Future<Departement> updateDepartement(int id, Departement departement);
	Future<void> deleteDepartement(int id);
}

class DepartementRepositoryImpl implements DepartementRepository {
	final DepartementRemoteDataSource _remoteDataSource;

	DepartementRepositoryImpl({DepartementRemoteDataSource? remoteDataSource})
			: _remoteDataSource = remoteDataSource ?? DepartementRemoteDataSourceImpl();

	@override
			Future<List<Departement>> getAllDepartements() async {
				return await _remoteDataSource.getAllDepartements();
			}

	@override
			Future<Departement?> getDepartementById(int id) async {
				return await _remoteDataSource.getDepartementById(id);
			}

	@override
			Future<Departement> createDepartement(Departement departement) async {
				return await _remoteDataSource.createDepartement(departement);
			}

	@override
			Future<Departement> updateDepartement(int id, Departement departement) async {
				return await _remoteDataSource.updateDepartement(id, departement);
			}

	@override
			Future<void> deleteDepartement(int id) async {
				await _remoteDataSource.deleteDepartement(id);
			}
}
