import '../data/localisation_repository.dart';
import 'localisation.dart';

class GetAllLocalisations {
	final LocalisationRepository repository;
	GetAllLocalisations(this.repository);
	Future<List<Localisation>> call() async {
		return await repository.getAllLocalisations();
	}
}

class GetLocalisationById {
	final LocalisationRepository repository;
	GetLocalisationById(this.repository);
	Future<Localisation?> call(int id) async {
		return await repository.getLocalisationById(id);
	}
}

class CreateLocalisation {
	final LocalisationRepository repository;
	CreateLocalisation(this.repository);
	Future<Localisation> call(Localisation localisation) async {
		return await repository.createLocalisation(localisation);
	}
}

class UpdateLocalisation {
	final LocalisationRepository repository;
	UpdateLocalisation(this.repository);
	Future<Localisation> call(int id, Localisation localisation) async {
		return await repository.updateLocalisation(id, localisation);
	}
}

class DeleteLocalisation {
	final LocalisationRepository repository;
	DeleteLocalisation(this.repository);
	Future<void> call(int id) async {
		await repository.deleteLocalisation(id);
	}
}
