import '../domain/intervention.dart';
import 'intervention_remote_datasource.dart';

abstract class InterventionRepository {
	Future<List<Intervention>> getAllInterventions();
	Future<Intervention?> getInterventionById(int id);
	Future<Intervention> createIntervention(Intervention intervention);
	Future<Intervention> updateIntervention(int id, Intervention intervention);
	Future<void> deleteIntervention(int id);
}

class InterventionRepositoryImpl implements InterventionRepository {
	final InterventionRemoteDataSource _remoteDataSource;

	InterventionRepositoryImpl({InterventionRemoteDataSource? remoteDataSource})
			: _remoteDataSource = remoteDataSource ?? InterventionRemoteDataSourceImpl();

	@override
	Future<List<Intervention>> getAllInterventions() async {
		return await _remoteDataSource.getAllInterventions();
	}

	@override
	Future<Intervention?> getInterventionById(int id) async {
		return await _remoteDataSource.getInterventionById(id);
	}

	@override
	Future<Intervention> createIntervention(Intervention intervention) async {
		return await _remoteDataSource.createIntervention(intervention);
	}

	@override
	Future<Intervention> updateIntervention(int id, Intervention intervention) async {
		return await _remoteDataSource.updateIntervention(id, intervention);
	}

	@override
	Future<void> deleteIntervention(int id) async {
		await _remoteDataSource.deleteIntervention(id);
	}
}
