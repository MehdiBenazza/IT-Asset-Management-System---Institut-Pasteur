import '../data/intervention_repository.dart';
import 'intervention.dart';

class PlanifierIntervention {
	final InterventionRepository repository;
	PlanifierIntervention(this.repository);
	Future<Intervention> call(Intervention intervention) async {
		return await repository.createIntervention(intervention);
	}
}

class GetInterventionsByMateriel {
	final InterventionRepository repository;
	GetInterventionsByMateriel(this.repository);
	Future<List<Intervention>> call(int idMateriel) async {
		// Ajoute ici la logique pour filtrer par idMateriel si disponible dans le repository
		final all = await repository.getAllInterventions();
		return all.where((i) => i.idMateriel == idMateriel).toList();
	}
}

class CloseIntervention {
	final InterventionRepository repository;
	CloseIntervention(this.repository);
	Future<Intervention> call(int id, Intervention intervention) async {
		// Ajoute ici la logique métier pour clôturer une intervention
		return await repository.updateIntervention(id, intervention);
	}
}

