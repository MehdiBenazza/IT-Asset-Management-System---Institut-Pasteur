import 'package:flutter/material.dart';
import '../domain/appartenance.dart';
import 'appartenance_controller.dart';
import '../../../core/widgets/common_widgets.dart';

class AppartenanceForm extends StatefulWidget {
	final AppartenanceController controller;
	final Appartenance? initial;
	final VoidCallback? onSuccess;

	const AppartenanceForm({
		Key? key,
		required this.controller,
		this.initial,
		this.onSuccess,
	}) : super(key: key);

	@override
	State<AppartenanceForm> createState() => _AppartenanceFormState();
}

class _AppartenanceFormState extends State<AppartenanceForm> {
	late TextEditingController userController;
	late TextEditingController materielController;
	DateTime? dateDebut;
	DateTime? dateFin;
	final _formKey = GlobalKey<FormState>();

	@override
	void initState() {
		super.initState();
		userController = TextEditingController(text: widget.initial?.idUser.toString() ?? '');
		materielController = TextEditingController(text: widget.initial?.idMateriel.toString() ?? '');
		dateDebut = widget.initial?.dateDebut;
		dateFin = widget.initial?.dateFin;
	}

	@override
	void dispose() {
		userController.dispose();
		materielController.dispose();
		super.dispose();
	}

	Future<void> _submit() async {
		if (!_formKey.currentState!.validate()) return;
		final appartenance = Appartenance(
			id: widget.initial?.id,
			idUser: int.tryParse(userController.text) ?? 0,
			idMateriel: int.tryParse(materielController.text) ?? 0,
			dateDebut: dateDebut ?? DateTime.now(),
			dateFin: dateFin,
		);
		bool success;
		if (widget.initial == null) {
			success = await widget.controller.create(appartenance);
		} else {
			success = await widget.controller.update(appartenance);
		}
		if (success && widget.onSuccess != null) widget.onSuccess!();
	}

	@override
	Widget build(BuildContext context) {
		return Form(
			key: _formKey,
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					CustomTextField(
						label: 'ID Utilisateur',
						controller: userController,
					),
					const SizedBox(height: 12),
					CustomTextField(
						label: 'ID Matériel',
						controller: materielController,
					),
					const SizedBox(height: 12),
					Row(
						children: [
							Expanded(
								child: Text('Date début: ${dateDebut != null ? dateDebut!.toLocal().toString().split(' ')[0] : ''}'),
							),
							TextButton(
								child: const Text('Sélectionner'),
								onPressed: () async {
									final picked = await showDatePicker(
										context: context,
										initialDate: dateDebut ?? DateTime.now(),
										firstDate: DateTime(2000),
										lastDate: DateTime(2100),
									);
									if (picked != null) setState(() => dateDebut = picked);
								},
							),
						],
					),
					const SizedBox(height: 12),
					Row(
						children: [
							Expanded(
								child: Text('Date fin: ${dateFin != null ? dateFin!.toLocal().toString().split(' ')[0] : ''}'),
							),
							TextButton(
								child: const Text('Sélectionner'),
								onPressed: () async {
									final picked = await showDatePicker(
										context: context,
										initialDate: dateFin ?? DateTime.now(),
										firstDate: DateTime(2000),
										lastDate: DateTime(2100),
									);
									if (picked != null) setState(() => dateFin = picked);
								},
							),
						],
					),
					const SizedBox(height: 20),
					if (widget.controller.loading)
						const CenteredLoader()
					else
						PrimaryButton(
							label: widget.initial == null ? 'Créer' : 'Modifier',
							onPressed: _submit,
						),
					if (widget.controller.error != null)
						Padding(
							padding: const EdgeInsets.only(top: 8.0),
							child: Text(widget.controller.error!, style: const TextStyle(color: Colors.red)),
						),
				],
			),
		);
	}
}
