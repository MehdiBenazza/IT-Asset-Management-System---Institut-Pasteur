import 'package:flutter/foundation.dart';
import '../domain/localisation.dart';
import '../domain/usecases.dart';

class LocalisationController extends ChangeNotifier {
  final GetAllLocalisations getAllLocalisations;
  final CreateLocalisation createLocalisation;
  final UpdateLocalisation updateLocalisation;
  final DeleteLocalisation deleteLocalisation;

  List<Localisation> _localisations = [];
  Localisation? _selected;
  bool _isLoading = false;
  String? _error;

  // Getters pour la vue
  List<Localisation> get localisations => _localisations;
  Localisation? get selected => _selected;
  bool get isLoading => _isLoading;
  String? get error => _error;

  LocalisationController({
    required this.getAllLocalisations,
    required this.createLocalisation,
    required this.updateLocalisation,
    required this.deleteLocalisation,
  });

  // Charger toutes les localisations
  Future<void> fetchLocalisations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _localisations = await getAllLocalisations();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  // Sélectionner une localisation
  void selectLocalisation(Localisation localisation) {
    _selected = localisation;
    notifyListeners();
  }

  // Ajouter une localisation
  Future<void> addLocalisation(Localisation localisation) async {
    try {
      final newLocalisation = await createLocalisation(localisation);
      _localisations.add(newLocalisation);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Modifier une localisation
  Future<void> editLocalisation(Localisation localisation) async {
    try {
      if (localisation.id == null) {
        throw Exception("La localisation doit avoir un id pour être modifiée.");
      }
      final updated = await updateLocalisation(localisation.id!, localisation);
      final index = _localisations.indexWhere((l) => l.id == updated.id);
      if (index != -1) {
        _localisations[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Supprimer une localisation
  Future<void> deleteLocalisationById(int id) async {
    try {
      await deleteLocalisation(id);
      _localisations.removeWhere((l) => l.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
