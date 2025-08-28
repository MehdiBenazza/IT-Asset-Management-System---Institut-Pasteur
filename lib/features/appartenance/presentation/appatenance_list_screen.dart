import 'package:flutter/material.dart';
import '../domain/appartenance.dart';
import 'appartenance_controller.dart';
import 'appartenance_form.dart';
import '../../../core/widgets/common_widgets.dart';

class AppartenanceListScreen extends StatefulWidget {
	final AppartenanceController controller;
	const AppartenanceListScreen({Key? key, required this.controller}) : super(key: key);

	@override
	State<AppartenanceListScreen> createState() => _AppartenanceListScreenState();
}

class _AppartenanceListScreenState extends State<AppartenanceListScreen> {
	@override
	void initState() {
		super.initState();
		widget.controller.loadAll();
	}

	void _showForm({Appartenance? initial}) {
		showDialog(
			context: context,
			builder: (ctx) => AlertDialog(
				content: SizedBox(
					width: 400,
					child: AppartenanceForm(
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
			appBar: AppBar(title: const Text('Liste des appartenances')),
			body: AnimatedBuilder(
				animation: widget.controller,
				builder: (context, _) {
					if (widget.controller.loading) {
						return const CenteredLoader();
					}
					if (widget.controller.error != null) {
						return Center(child: Text('Erreur: ${widget.controller.error!}', style: const TextStyle(color: Colors.red)));
					}
					if (widget.controller.appartenances.isEmpty) {
						return const Center(child: Text('Aucune appartenance trouvée.'));
					}
					return ListView.separated(
						itemCount: widget.controller.appartenances.length,
						separatorBuilder: (_, __) => const Divider(),
						itemBuilder: (context, index) {
							final appartenance = widget.controller.appartenances[index];
							return ListTile(
								title: Text('Utilisateur: ${appartenance.idUser} | Matériel: ${appartenance.idMateriel}'),
								subtitle: Text('Début: ${appartenance.dateDebut.toLocal().toString().split(' ')[0]} | Fin: ${appartenance.dateFin != null ? appartenance.dateFin!.toLocal().toString().split(' ')[0] : '-'}'),
								trailing: Row(
									mainAxisSize: MainAxisSize.min,
									children: [
										IconButton(
											icon: const Icon(Icons.edit),
											onPressed: () => _showForm(initial: appartenance),
										),
										IconButton(
											icon: const Icon(Icons.delete),
											onPressed: () async {
												final confirm = await showConfirmDialog(context, title: 'Supprimer', content: 'Confirmer la suppression ?');
												if (confirm == true) {
													await widget.controller.delete(appartenance.id!);
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
				tooltip: 'Ajouter une appartenance',
			),
		);
	}
}
