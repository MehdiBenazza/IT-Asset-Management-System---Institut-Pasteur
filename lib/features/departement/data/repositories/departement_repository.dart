import '../../../core/exceptions.dart';
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
			try {
				return await _remoteDataSource.getAllDepartements();
			} catch (e, stack) {
				print('Erreur getAllDepartements: $e\n$stack');
				throw DataRepositoryException('Erreur lors de la récupération des départements');
			}
		}

	@override
		Future<Departement?> getDepartementById(int id) async {
			try {
				return await _remoteDataSource.getDepartementById(id);
			} catch (e, stack) {
				print('Erreur getDepartementById: $e\n$stack');
				throw DataRepositoryException('Erreur lors de la récupération du département');
			}
		}

	@override
		Future<Departement> createDepartement(Departement departement) async {
			try {
				return await _remoteDataSource.createDepartement(departement);
			} catch (e, stack) {
				print('Erreur createDepartement: $e\n$stack');
				throw DataRepositoryException('Erreur lors de la création du département');
			}
		}

	@override
		Future<Departement> updateDepartement(int id, Departement departement) async {
			try {
				return await _remoteDataSource.updateDepartement(id, departement);
			} catch (e, stack) {
				print('Erreur updateDepartement: $e\n$stack');
				throw DataRepositoryException('Erreur lors de la mise à jour du département');
			}
		}

	@override
		Future<void> deleteDepartement(int id) async {
			try {
				await _remoteDataSource.deleteDepartement(id);
			} catch (e, stack) {
				print('Erreur deleteDepartement: $e\n$stack');
				throw DataRepositoryException('Erreur lors de la suppression du département');
			}
		}
}
