import 'package:flutter/material.dart';
import '../controllers/departement_controller.dart';
import '../../domain/departement.dart';
import '../../../../core/widgets/common_widgets.dart';

class DepartementListPage extends StatefulWidget {
	final DepartementController controller;
	const DepartementListPage({Key? key, required this.controller}) : super(key: key);

	@override
	State<DepartementListPage> createState() => _DepartementListPageState();
}

class _DepartementListPageState extends State<DepartementListPage> {
	@override
	void initState() {
		super.initState();
		widget.controller.loadAll();
	}

	void _showForm({Departement? initial}) {
		showDialog(
			context: context,
			builder: (ctx) => AlertDialog(
				content: SizedBox(
					width: 400,
					child: DepartementForm(
						controller: widget.controller,
						initial: initial,
						onSuccess: () {
							Navigator.of(ctx).pop();
							widget.controller.loadAll();
						},
					),
				),
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Liste des départements')),
			body: AnimatedBuilder(
				animation: widget.controller,
				builder: (context, _) {
					if (widget.controller.loading) {
						return const CenteredLoader();
					}
					if (widget.controller.error != null) {
						return Center(child: Text('Erreur: ${widget.controller.error!}', style: const TextStyle(color: Colors.red)));
					}
					if (widget.controller.departements.isEmpty) {
						return const Center(child: Text('Aucun département trouvé.'));
					}
					return ListView.separated(
						itemCount: widget.controller.departements.length,
						separatorBuilder: (_, __) => const Divider(),
						itemBuilder: (context, index) {
							final departement = widget.controller.departements[index];
							return ListTile(
								title: Text(departement.nom),
								trailing: Row(
									mainAxisSize: MainAxisSize.min,
									children: [
										IconButton(
											icon: const Icon(Icons.edit),
											onPressed: () => _showForm(initial: departement),
										),
										IconButton(
											icon: const Icon(Icons.delete),
											onPressed: () async {
												final confirm = await showConfirmDialog(context, title: 'Supprimer', content: 'Confirmer la suppression ?');
												if (confirm == true) {
													await widget.controller.delete(departement.id!);
												}
											},
										),
									],
								),
							);
						},
					);
				},
			),
			floatingActionButton: FloatingActionButton(
				onPressed: () => _showForm(),
				child: const Icon(Icons.add),
				tooltip: 'Ajouter un département',
			),
		);
	}
}

// Formulaire à créer dans le même dossier ou à importer
class DepartementForm extends StatefulWidget {
	final DepartementController controller;
	final Departement? initial;
	final VoidCallback? onSuccess;

	const DepartementForm({Key? key, required this.controller, this.initial, this.onSuccess}) : super(key: key);

	@override
	State<DepartementForm> createState() => _DepartementFormState();
}

class _DepartementFormState extends State<DepartementForm> {
	late TextEditingController nomController;
	final _formKey = GlobalKey<FormState>();

	@override
	void initState() {
		super.initState();
		nomController = TextEditingController(text: widget.initial?.nom ?? '');
	}

	@override
	void dispose() {
		nomController.dispose();
		super.dispose();
	}

	Future<void> _submit() async {
		if (!_formKey.currentState!.validate()) return;
		final departement = Departement(
			id: widget.initial?.id,
			nom: nomController.text,
		);
		bool success;
		if (widget.initial == null) {
			success = await widget.controller.create(departement);
		} else {
			success = await widget.controller.update(departement);
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
						label: 'Nom du département',
						controller: nomController,
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
 