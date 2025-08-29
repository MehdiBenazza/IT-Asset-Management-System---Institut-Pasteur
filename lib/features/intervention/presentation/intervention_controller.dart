import 'package:flutter/foundation.dart';
import '../domain/intervention.dart';
import '../domain/usecases.dart';

class InterventionController extends ChangeNotifier {
  final GetAllInterventions getAllInterventions;
  final CreateIntervention createIntervention;
  final UpdateIntervention updateIntervention;
  final DeleteIntervention deleteIntervention;

  /// État interne
  List<Intervention> _interventions = [];
  List<Intervention> get interventions => _interventions;

  Intervention? _selected;
  Intervention? get selected => _selected;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  InterventionController({
    required this.getAllInterventions,
    required this.createIntervention,
    required this.updateIntervention,
    required this.deleteIntervention,
  });

  /// Charger toutes les interventions
  Future<void> fetchInterventions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _interventions = await getAllInterventions();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Sélectionner une intervention
  void selectIntervention(Intervention intervention) {
    _selected = intervention;
    notifyListeners();
  }

  /// Ajouter une intervention
  Future<void> addIntervention(Intervention intervention) async {
    try {
      final newIntervention = await createIntervention(intervention);
      _interventions.add(newIntervention);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Mettre à jour une intervention
  Future<void> editIntervention(Intervention intervention) async {
    try {
      if (intervention.id == null) {
        throw Exception('L\'intervention doit avoir un id pour être modifiée.');
      }
      final updated = await updateIntervention(intervention.id!, intervention);
      final index =
          _interventions.indexWhere((i) => i.id == updated.id);
      if (index != -1) {
        _interventions[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Supprimer une intervention
  Future<void> removeIntervention(int id) async {
    try {
      await deleteIntervention(id);
      _interventions.removeWhere((i) => i.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
