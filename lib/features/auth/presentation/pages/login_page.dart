import 'signup_page.dart';
import 'reset_password_page.dart';
import 'package:flutter/material.dart';
import '../../data/auth_repository.dart';
import '../../../../core/widgets/common_widgets.dart';

class LoginPage extends StatefulWidget {
	final AuthRepository authRepository;
	final VoidCallback? onLoginSuccess;

	const LoginPage({Key? key, required this.authRepository, this.onLoginSuccess}) : super(key: key);

	@override
	State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
	final _formKey = GlobalKey<FormState>();
	final emailController = TextEditingController();
	final passwordController = TextEditingController();
	bool loading = false;
	String? error;

	@override
	void dispose() {
		emailController.dispose();
		passwordController.dispose();
		super.dispose();
	}

	Future<void> _login() async {
		if (!_formKey.currentState!.validate()) return;
		setState(() {
			loading = true;
			error = null;
		});
		try {
			final user = await widget.authRepository.login(emailController.text, passwordController.text);
			if (user != null) {
				if (widget.onLoginSuccess != null) widget.onLoginSuccess!();
			} else {
				setState(() => error = 'Identifiants invalides');
			}
		} catch (e) {
			setState(() => error = e.toString());
		}
		setState(() {
			loading = false;
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Connexion')),
			body: Center(
				child: SizedBox(
					width: 400,
					child: Form(
						key: _formKey,
						child: Column(
							mainAxisSize: MainAxisSize.min,
							children: [
								CustomTextField(
									label: 'Email',
									controller: emailController,
								),
								const SizedBox(height: 16),
								CustomTextField(
									label: 'Mot de passe',
									controller: passwordController,
									obscureText: true,
								),
								const SizedBox(height: 24),
								if (loading)
									const CenteredLoader()
								else
									PrimaryButton(label: 'Se connecter', onPressed: _login),
								if (error != null)
									Padding(
										padding: const EdgeInsets.only(top: 8.0),
										child: Text(error!, style: const TextStyle(color: Colors.red)),
									),
								const SizedBox(height: 16),
												TextButton(
													child: const Text('Créer un compte'),
													onPressed: () {
														Navigator.of(context).push(
															MaterialPageRoute(
																builder: (_) => SignupPage(authRepository: widget.authRepository),
															),
														);
													},
												),
												TextButton(
													child: const Text('Mot de passe oublié ?'),
													onPressed: () {
														Navigator.of(context).push(
															MaterialPageRoute(
																builder: (_) => ResetPasswordPage(authRepository: widget.authRepository),
															),
														);
													},
												),
							],
						),
					),
				),
			),
		);
	}
}
 