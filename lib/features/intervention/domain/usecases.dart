import '../data/intervention_repository.dart';
import 'intervention.dart';

// Toutes les directives d'importation sont maintenant en haut du fichier

class GetAllInterventions {
	final InterventionRepository repository;
	GetAllInterventions(this.repository);
	Future<List<Intervention>> call() async => await repository.getAllInterventions();
}

class CreateIntervention {
	final InterventionRepository repository;
	CreateIntervention(this.repository);
	Future<Intervention> call(Intervention intervention) async => await repository.createIntervention(intervention);
}

class UpdateIntervention {
	final InterventionRepository repository;
	UpdateIntervention(this.repository);
	Future<Intervention> call(int id, Intervention intervention) async => await repository.updateIntervention(id, intervention);
}

class DeleteIntervention {
	final InterventionRepository repository;
	DeleteIntervention(this.repository);
	Future<void> call(int id) async => await repository.deleteIntervention(id);
}

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

