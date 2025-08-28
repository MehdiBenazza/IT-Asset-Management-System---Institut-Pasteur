import 'package:flutter/material.dart';
import '../../domain/departement.dart';
import '../../data/datasources/departement_datasource.dart';

class DepartementController extends ChangeNotifier {
	final DepartementDataSource dataSource;

	List<Departement> departements = [];
	Departement? selected;
	bool loading = false;
	String? error;

	DepartementController({DepartementDataSource? dataSource})
			: dataSource = dataSource ?? DepartementDataSource();

	Future<void> loadAll() async {
		loading = true;
		error = null;
		notifyListeners();
		try {
			departements = await dataSource.getAll();
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
			selected = await dataSource.getById(id);
		} catch (e) {
			error = e.toString();
		}
		loading = false;
		notifyListeners();
	}

	Future<bool> create(Departement departement) async {
		loading = true;
		error = null;
		notifyListeners();
		try {
			final id = await dataSource.create(departement);
			await loadAll();
			return id != null;
		} catch (e) {
			error = e.toString();
			loading = false;
			notifyListeners();
			return false;
		}
	}

	Future<bool> update(Departement departement) async {
		loading = true;
		error = null;
		notifyListeners();
		try {
			final success = await dataSource.update(departement);
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
			final success = await dataSource.delete(id);
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
 