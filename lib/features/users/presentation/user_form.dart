import 'package:flutter/material.dart';
import '../domain/user.dart';
import '../../../core/enums/app_enums.dart';

class UserForm extends StatefulWidget {
  final User? initial;
  final void Function(User user) onSubmit;

  const UserForm({
    super.key,
    this.initial,
    required this.onSubmit,
  });

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();

  late String _nom;
  late String _prenom;
  late String _email;
  late RoleEnum _role;
  bool _actif = true;

  @override
  void initState() {
    super.initState();
    _nom = widget.initial?.nom ?? '';
    _prenom = widget.initial?.prenom ?? '';
    _email = widget.initial?.email ?? '';
    _role = widget.initial?.role ?? RoleEnum.employe;
    _actif = widget.initial?.actif ?? true;
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final user = User(
        id: widget.initial?.id,
        nom: _nom,
        prenom: _prenom,
        email: _email,
        role: _role,
        actif: _actif,
      );
      widget.onSubmit(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initial == null ? "Ajouter un utilisateur" : "Modifier l'utilisateur"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _nom,
                decoration: const InputDecoration(labelText: "Nom"),
                validator: (val) => val == null || val.isEmpty ? "Champ obligatoire" : null,
                onChanged: (val) => setState(() => _nom = val),
              ),
              TextFormField(
                initialValue: _prenom,
                decoration: const InputDecoration(labelText: "Prénom"),
                validator: (val) => val == null || val.isEmpty ? "Champ obligatoire" : null,
                onChanged: (val) => setState(() => _prenom = val),
              ),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (val) => val == null || val.isEmpty ? "Champ obligatoire" : null,
                onChanged: (val) => setState(() => _email = val),
              ),
              DropdownButtonFormField<RoleEnum>(
                value: _role,
                decoration: const InputDecoration(labelText: "Rôle"),
                items: RoleEnum.values
                    .map((r) => DropdownMenuItem(value: r, child: Text(r.name)))
                    .toList(),
                onChanged: (val) => setState(() => _role = val!),
              ),
              SwitchListTile(
                title: const Text("Actif"),
                value: _actif,
                onChanged: (val) => setState(() => _actif = val),
              ),
              const SizedBox(height: 20),
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
        ),
      ),
    );
  }
}
