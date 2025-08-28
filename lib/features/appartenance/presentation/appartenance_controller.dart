import 'package:flutter/material.dart';
import '../domain/appartenance.dart';
import '../domain/usecases.dart';

class AppartenanceController extends ChangeNotifier {
	final GetAllAppartenances getAllUsecase;
	final GetAppartenanceById getByIdUsecase;
	final CreateAppartenance createUsecase;
	final UpdateAppartenance updateUsecase;
	final DeleteAppartenance deleteUsecase;

	List<Appartenance> appartenances = [];
	Appartenance? selected;
	bool loading = false;
	String? error;

	AppartenanceController({
		required this.getAllUsecase,
		required this.getByIdUsecase,
		required this.createUsecase,
		required this.updateUsecase,
		required this.deleteUsecase,
	});

	Future<void> loadAll() async {
		loading = true;
		error = null;
		notifyListeners();
		try {
			appartenances = await getAllUsecase();
		} catch (e) {
			error = e.toString();
		}
		loading = false;
		notifyListeners();
	}

	Future<void> loadById(int id) async {
		loading = true;
		error = null;
		notifyListeners();
		try {
			selected = await getByIdUsecase(id);
		} catch (e) {
			error = e.toString();
		}
		loading = false;
		notifyListeners();
	}

	Future<bool> create(Appartenance appartenance) async {
		loading = true;
		error = null;
		notifyListeners();
		try {
			final id = await createUsecase(appartenance);
			await loadAll();
			return id != null;
		} catch (e) {
			error = e.toString();
			loading = false;
			notifyListeners();
			return false;
		}
	}

	Future<bool> update(Appartenance appartenance) async {
		loading = true;
		error = null;
		notifyListeners();
		try {
			final success = await updateUsecase(appartenance);
			await loadAll();
			return success;
		} catch (e) {
			error = e.toString();
			loading = false;
			notifyListeners();
			return false;
		}
	}

	Future<bool> delete(int id) async {
		loading = true;
		error = null;
		notifyListeners();
		try {
			final success = await deleteUsecase(id);
			await loadAll();
			return success;
		} catch (e) {
			error = e.toString();
			loading = false;
			notifyListeners();
			return false;
		}
	}
}
