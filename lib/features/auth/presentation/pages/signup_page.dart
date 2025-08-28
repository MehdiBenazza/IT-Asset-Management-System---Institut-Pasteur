import 'package:flutter/material.dart';
import '../../data/auth_repository.dart';
import '../../../../core/widgets/common_widgets.dart';

class SignupPage extends StatefulWidget {
  final AuthRepository authRepository;
  const SignupPage({Key? key, required this.authRepository}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final user = await widget.authRepository.signup(emailController.text, passwordController.text);
      if (user != null) {
        Navigator.of(context).pop();
      } else {
        setState(() => error = 'Erreur lors de la création du compte');
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
      appBar: AppBar(title: const Text('Créer un compte')),
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
                  PrimaryButton(label: 'Créer le compte', onPressed: _signup),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(error!, style: const TextStyle(color: Colors.red)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
