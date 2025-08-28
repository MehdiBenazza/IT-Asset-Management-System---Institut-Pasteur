import '../domain/localisation.dart';
import 'localisation_remote_datasource.dart';

abstract class LocalisationRepository {
	Future<List<Localisation>> getAllLocalisations();
	Future<Localisation?> getLocalisationById(int id);
	Future<Localisation> createLocalisation(Localisation localisation);
	Future<Localisation> updateLocalisation(int id, Localisation localisation);
	Future<void> deleteLocalisation(int id);
}

class LocalisationRepositoryImpl implements LocalisationRepository {
	final LocalisationRemoteDataSource _remoteDataSource;

	LocalisationRepositoryImpl({LocalisationRemoteDataSource? remoteDataSource})
			: _remoteDataSource = remoteDataSource ?? LocalisationRemoteDataSourceImpl();

	@override
	Future<List<Localisation>> getAllLocalisations() async {
		return await _remoteDataSource.getAllLocalisations();
	}

	@override
	Future<Localisation?> getLocalisationById(int id) async {
		return await _remoteDataSource.getLocalisationById(id);
	}

	@override
	Future<Localisation> createLocalisation(Localisation localisation) async {
		return await _remoteDataSource.createLocalisation(localisation);
	}

	@override
	Future<Localisation> updateLocalisation(int id, Localisation localisation) async {
		return await _remoteDataSource.updateLocalisation(id, localisation);
	}

	@override
	Future<void> deleteLocalisation(int id) async {
		await _remoteDataSource.deleteLocalisation(id);
	}
}
