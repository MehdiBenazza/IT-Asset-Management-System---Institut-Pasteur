import '../data/appartenance_repository.dart';
import 'appartenance.dart';

class GetAllAppartenances {
	final AppartenanceRepository repository;
	GetAllAppartenances(this.repository);
	Future<List<Appartenance>> call() async => await repository.getAll();
}

class GetAppartenanceById {
	final AppartenanceRepository repository;
	GetAppartenanceById(this.repository);
	Future<Appartenance?> call(int id) async => await repository.getById(id);
}

class CreateAppartenance {
	final AppartenanceRepository repository;
	CreateAppartenance(this.repository);
	Future<int?> call(Appartenance appartenance) async => await repository.create(appartenance);
}

class UpdateAppartenance {
	final AppartenanceRepository repository;
	UpdateAppartenance(this.repository);
	Future<bool> call(Appartenance appartenance) async => await repository.update(appartenance);
}

class DeleteAppartenance {
	final AppartenanceRepository repository;
	DeleteAppartenance(this.repository);
	Future<bool> call(int id) async => await repository.delete(id);
}

