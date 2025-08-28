import 'package:flutter/material.dart';
import '../../data/auth_repository.dart';
import '../../../../core/widgets/common_widgets.dart';

class ResetPasswordPage extends StatefulWidget {
  final AuthRepository authRepository;
  const ResetPasswordPage({Key? key, required this.authRepository}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool loading = false;
  String? error;
  String? success;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      loading = true;
      error = null;
      success = null;
    });
    try {
      // TODO: Implémenter la logique d'envoi de mail de réinitialisation via Supabase
      // Exemple : await widget.authRepository.sendPasswordResetEmail(emailController.text);
      success = 'Un email de réinitialisation a été envoyé.';
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
      appBar: AppBar(title: const Text('Réinitialiser le mot de passe')),
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
                const SizedBox(height: 24),
                if (loading)
                  const CenteredLoader()
                else
                  PrimaryButton(label: 'Envoyer', onPressed: _resetPassword),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(error!, style: const TextStyle(color: Colors.red)),
                  ),
                if (success != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(success!, style: const TextStyle(color: Colors.green)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
