// lib/features/intervention/presentation/widgets/intervention_form.dart

import 'package:flutter/material.dart';
import '../domain/intervention.dart';
import '../../../core/enums/app_enums.dart';
import '../../materiel/domain/materiel.dart';

class InterventionForm extends StatefulWidget {
  final Intervention? initial;
  final List<Materiel> materiels; // Liste des matériels disponibles
  final void Function(Intervention intervention) onSubmit;

  const InterventionForm({
    super.key,
    this.initial,
    required this.materiels,
    required this.onSubmit,
  });

  @override
  State<InterventionForm> createState() => _InterventionFormState();
}

class _InterventionFormState extends State<InterventionForm> {
  final _formKey = GlobalKey<FormState>();

  late Materiel? _materiel;
  late TypeInterventionEnum _type;
  late DateTime _dateIntervention;
  Duration? _duree;

  @override
  void initState() {
    super.initState();
    _materiel = widget.initial?.materiel;
  _type = widget.initial?.type ?? TypeInterventionEnum.corrective;
    _dateIntervention = widget.initial?.dateIntervention ?? DateTime.now();
    _duree = widget.initial?.duree;
  }

  void _saveForm() {
    if (_formKey.currentState!.validate() && _materiel != null) {
      final intervention = Intervention(
        id: widget.initial?.id,
        idMateriel: _materiel!.id!,
        type: _type,
        dateDemande: widget.initial?.dateDemande ?? DateTime.now(),
        dateIntervention: _dateIntervention,
        duree: _duree,
        idAdminSignataire: null, // ajouté plus tard
        idSuperadminSignataire: null, // ajouté plus tard
        materiel: _materiel,
      );

      widget.onSubmit(intervention);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          /// Sélecteur de matériel
          DropdownButtonFormField<Materiel>(
            value: _materiel,
            decoration: const InputDecoration(labelText: "Matériel"),
            items: widget.materiels
        .map((m) =>
          DropdownMenuItem(value: m, child: Text(m.type)))
                .toList(),
            onChanged: (val) => setState(() => _materiel = val),
            validator: (val) => val == null ? "Choisir un matériel" : null,
          ),

          /// Type d’intervention
          DropdownButtonFormField<TypeInterventionEnum>(
            value: _type,
            decoration:
                const InputDecoration(labelText: "Type d'intervention"),
            items: TypeInterventionEnum.values
                .map((t) => DropdownMenuItem(
                      value: t,
                      child: Text(t.name),
                    ))
                .toList(),
            onChanged: (val) => setState(() => _type = val!),
          ),

          /// Date d’intervention
          Row(
            children: [
              Expanded(
                child: Text("Date : ${_dateIntervention.toLocal()}"),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dateIntervention,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _dateIntervention = picked);
                  }
                },
              ),
            ],
          ),

          /// Durée (optionnelle)
          TextFormField(
            initialValue: _duree?.inHours.toString() ?? '',
            decoration: const InputDecoration(labelText: "Durée (heures)"),
            keyboardType: TextInputType.number,
            onChanged: (val) {
              final hours = int.tryParse(val);
              if (hours != null) {
                _duree = Duration(hours: hours);
              }
            },
          ),

          const SizedBox(height: 20),

          /// Boutons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Annuler"),
              ),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text("Enregistrer"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
