import 'package:flutter/material.dart';
import '../data/auth_repository.dart';
import '../domain/entities.dart';

class AuthController extends ChangeNotifier {
	final AuthRepository repository;

	UserEntity? currentUser;
	bool loading = false;
	String? error;
	String? token;

	AuthController({required this.repository});

	Future<bool> login(String email, String password) async {
		loading = true;
		error = null;
		notifyListeners();
		try {
			currentUser = await repository.login(email, password);
			token = await repository.getToken();
			loading = false;
			notifyListeners();
			return currentUser != null;
		} catch (e) {
			error = e.toString();
			loading = false;
			notifyListeners();
			return false;
		}
	}

	Future<bool> signup(String email, String password) async {
		loading = true;
		error = null;
		notifyListeners();
		try {
			currentUser = await repository.signup(email, password);
			token = await repository.getToken();
			loading = false;
			notifyListeners();
			return currentUser != null;
		} catch (e) {
			error = e.toString();
			loading = false;
			notifyListeners();
			return false;
		}
	}

	Future<void> logout() async {
		loading = true;
		error = null;
		notifyListeners();
		try {
			await repository.logout();
			currentUser = null;
			token = null;
		} catch (e) {
			error = e.toString();
		}
		loading = false;
		notifyListeners();
	}

	Future<void> fetchCurrentUser() async {
		loading = true;
		error = null;
		notifyListeners();
		try {
			currentUser = await repository.getCurrentUser();
			token = await repository.getToken();
		} catch (e) {
			error = e.toString();
		}
		loading = false;
		notifyListeners();
	}

		Future<void> resetPassword(String email) async {
			loading = true;
			error = null;
			notifyListeners();
			try {
				await repository.sendPasswordResetEmail(email);
			} catch (e) {
				error = e.toString();
			}
			loading = false;
			notifyListeners();
		}
}

