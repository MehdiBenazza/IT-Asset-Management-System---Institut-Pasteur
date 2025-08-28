import 'package:flutter/material.dart';

/// Bouton principal réutilisable
class PrimaryButton extends StatelessWidget {
	final String label;
	final VoidCallback onPressed;
	final bool loading;
	final IconData? icon;

	const PrimaryButton({
		Key? key,
		required this.label,
		required this.onPressed,
		this.loading = false,
		this.icon,
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return ElevatedButton.icon(
			icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
			label: loading
					? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
					: Text(label),
			onPressed: loading ? null : onPressed,
			style: ElevatedButton.styleFrom(minimumSize: const Size(120, 40)),
		);
	}
}

/// Loader circulaire centré
class CenteredLoader extends StatelessWidget {
	const CenteredLoader({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return const Center(child: CircularProgressIndicator());
	}
}

/// Champ de texte personnalisé
class CustomTextField extends StatelessWidget {
	final String label;
	final TextEditingController controller;
	final bool obscureText;

	const CustomTextField({
		Key? key,
		required this.label,
		required this.controller,
		this.obscureText = false,
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return TextField(
			controller: controller,
			obscureText: obscureText,
			decoration: InputDecoration(
				labelText: label,
				border: const OutlineInputBorder(),
			),
		);
	}
}

/// Dialogue de confirmation
Future<bool?> showConfirmDialog(BuildContext context, {required String title, required String content}) {
	return showDialog<bool>(
		context: context,
		builder: (ctx) => AlertDialog(
			title: Text(title),
			content: Text(content),
			actions: [
				TextButton(child: const Text('Annuler'), onPressed: () => Navigator.of(ctx).pop(false)),
				ElevatedButton(child: const Text('Confirmer'), onPressed: () => Navigator.of(ctx).pop(true)),
			],
		),
	);
}
 