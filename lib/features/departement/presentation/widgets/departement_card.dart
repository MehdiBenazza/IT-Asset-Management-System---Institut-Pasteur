import 'package:flutter/material.dart';
import '../../domain/departement.dart';

class DepartementCard extends StatelessWidget {
	final Departement departement;
	final VoidCallback? onEdit;
	final VoidCallback? onDelete;
	final VoidCallback? onTap;

	const DepartementCard({
		Key? key,
		required this.departement,
		this.onEdit,
		this.onDelete,
		this.onTap,
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Card(
			margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
			child: ListTile(
				title: Text(departement.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
				onTap: onTap,
				trailing: Row(
					mainAxisSize: MainAxisSize.min,
					children: [
						if (onEdit != null)
							IconButton(
								icon: const Icon(Icons.edit),
								onPressed: onEdit,
								tooltip: 'Modifier',
							),
						if (onDelete != null)
							IconButton(
								icon: const Icon(Icons.delete),
								onPressed: onDelete,
								tooltip: 'Supprimer',
							),
					],
				),
			),
		);
	}
}
 