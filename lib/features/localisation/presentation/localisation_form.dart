import 'package:flutter/material.dart';
import '../domain/localisation.dart';
import '../../bureau/domain/bureau.dart';
import '../../materiel/domain/materiel.dart';

class LocalisationForm extends StatefulWidget {
  final Localisation? initial;
  final List<Bureau> bureaux;
  final List<Materiel> materiels;
  final void Function(Localisation localisation) onSubmit;

  const LocalisationForm({
    super.key,
    this.initial,
    required this.bureaux,
    required this.materiels,
    required this.onSubmit,
  });

  @override
  State<LocalisationForm> createState() => _LocalisationFormState();
}

class _LocalisationFormState extends State<LocalisationForm> {
  final _formKey = GlobalKey<FormState>();

  late Bureau? _bureau;
  late Materiel? _materiel;
  late DateTime _dateDebut;
  DateTime? _dateFin;

  @override
  void initState() {
    super.initState();
    _bureau = widget.initial?.bureau;
    _materiel = widget.initial?.materiel;
    _dateDebut = widget.initial?.dateDebut ?? DateTime.now();
    _dateFin = widget.initial?.dateFin;
  }

  void _saveForm() {
    if (_formKey.currentState!.validate() && _bureau != null && _materiel != null) {
      final localisation = Localisation(
        id: widget.initial?.id,
        idMateriel: _materiel!.id!,
        idBureau: _bureau!.id!,
        dateDebut: _dateDebut,
        dateFin: _dateFin,
        materiel: _materiel,
        bureau: _bureau,
      );
      widget.onSubmit(localisation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Sélecteur de bureau
          DropdownButtonFormField<Bureau>(
            value: _bureau,
            decoration: const InputDecoration(labelText: "Bureau"),
            items: widget.bureaux
                .map((b) => DropdownMenuItem(value: b, child: Text(b.nom)))
                .toList(),
            onChanged: (val) => setState(() => _bureau = val),
            validator: (val) => val == null ? "Choisir un bureau" : null,
          ),

          // Sélecteur de matériel
          DropdownButtonFormField<Materiel>(
            value: _materiel,
            decoration: const InputDecoration(labelText: "Matériel"),
            items: widget.materiels
                .map((m) => DropdownMenuItem(value: m, child: Text(m.type)))
                .toList(),
            onChanged: (val) => setState(() => _materiel = val),
            validator: (val) => val == null ? "Choisir un matériel" : null,
          ),

          // Date de début
          Row(
            children: [
              Expanded(
                child: Text("Date début : "+_dateDebut.toLocal().toString()),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dateDebut,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _dateDebut = picked);
                  }
                },
              ),
            ],
          ),

          // Date de fin (optionnelle)
          Row(
            children: [
              Expanded(
                child: Text("Date fin : "+(_dateFin?.toLocal().toString() ?? "")),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dateFin ?? _dateDebut,
                    firstDate: _dateDebut,
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _dateFin = picked);
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Boutons
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
