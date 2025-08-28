import 'package:flutter/material.dart';
import 'auth_controller.dart';
import '../data/auth_repository.dart';
import 'pages/login_page.dart';

class LoginScreen extends StatefulWidget {
	final AuthRepository authRepository;
	const LoginScreen({Key? key, required this.authRepository}) : super(key: key);

	@override
	State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
	late AuthController controller;

	@override
	void initState() {
		super.initState();
		controller = AuthController(repository: widget.authRepository);
	}

	void _onLoginSuccess() {
		// Naviguer vers la page principale ou dashboard après connexion
		Navigator.of(context).pushReplacementNamed('/home');
	}

	@override
	Widget build(BuildContext context) {
		return AnimatedBuilder(
			animation: controller,
			builder: (context, _) {
				return LoginPage(
					authRepository: widget.authRepository,
					onLoginSuccess: _onLoginSuccess,
				);
			},
		);
	}
}

