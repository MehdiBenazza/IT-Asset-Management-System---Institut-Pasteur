import 'package:flutter/material.dart';
import '../../domain/materiel.dart';
import '../../domain/usecases.dart';
import '../../../../core/enums/app_enums.dart';

class MaterielController extends ChangeNotifier {
  final MaterielUseCases _materielUseCases;
  
  // États
  List<Materiel> _materiels = [];
  Materiel? _selectedMateriel;
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  int _totalCount = 0;
  bool _hasMoreData = true;
  
  // Getters
  List<Materiel> get materiels => _materiels;
  Materiel? get selectedMateriel => _selectedMateriel;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentPage => _currentPage;
  int get totalCount => _totalCount;
  bool get hasMoreData => _hasMoreData;
  
  // Constructeur
  MaterielController({MaterielUseCases? materielUseCases})
      : _materielUseCases = materielUseCases ?? MaterielUseCasesImpl();
  
  // Méthodes pour gérer l'état
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
  
  // Méthodes CRUD
  Future<void> loadMateriels({bool refresh = false}) async {
    try {
      _setLoading(true);
      _setError(null);
      
      if (refresh) {
        _currentPage = 1;
        _materiels.clear();
      }
      
      final materiels = await _materielUseCases.getAllMateriels();
      _materiels = materiels;
      _totalCount = await _materielUseCases.getMaterielsCount();
      
    } catch (e) {
      _setError('Erreur lors du chargement des matériels: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> loadMaterielsPaginated({bool refresh = false}) async {
    try {
      _setLoading(true);
      _setError(null);
      
      if (refresh) {
        _currentPage = 1;
        _materiels.clear();
      }
      
      final materiels = await _materielUseCases.getMaterielsPaginated(
        page: _currentPage,
        limit: 20,
      );
      
      if (refresh) {
        _materiels = materiels;
      } else {
        _materiels.addAll(materiels);
      }
      
      _hasMoreData = materiels.length == 20;
      if (_hasMoreData) {
        _currentPage++;
      }
      
      _totalCount = await _materielUseCases.getMaterielsCount();
      
    } catch (e) {
      _setError('Erreur lors du chargement des matériels: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> getMaterielById(int id) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final materiel = await _materielUseCases.getMaterielById(id);
      _selectedMateriel = materiel;
      
    } catch (e) {
      _setError('Erreur lors de la récupération du matériel: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> createMateriel(Materiel materiel) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final newMateriel = await _materielUseCases.createMateriel(materiel);
      _materiels.add(newMateriel);
      _totalCount++;
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Erreur lors de la création du matériel: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> updateMateriel(int id, Materiel materiel) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final updatedMateriel = await _materielUseCases.updateMateriel(id, materiel);
      
      // Mettre à jour dans la liste
      final index = _materiels.indexWhere((m) => m.id == id);
      if (index != -1) {
        _materiels[index] = updatedMateriel;
      }
      
      // Mettre à jour le matériel sélectionné si c'est le même
      if (_selectedMateriel?.id == id) {
        _selectedMateriel = updatedMateriel;
      }
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Erreur lors de la mise à jour du matériel: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> deleteMateriel(int id) async {
    try {
      _setLoading(true);
      _setError(null);
      
      await _materielUseCases.deleteMateriel(id);
      
      // Supprimer de la liste
      _materiels.removeWhere((m) => m.id == id);
      _totalCount--;
      
      // Effacer le matériel sélectionné si c'est le même
      if (_selectedMateriel?.id == id) {
        _selectedMateriel = null;
      }
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Erreur lors de la suppression du matériel: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> searchMateriels(String query) async {
    try {
      _setLoading(true);
      _setError(null);
      
      if (query.trim().isEmpty) {
        await loadMateriels(refresh: true);
        return;
      }
      
      final materiels = await _materielUseCases.searchMateriels(query);
      _materiels = materiels;
      
    } catch (e) {
      _setError('Erreur lors de la recherche: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> filterByEtat(EtatMaterielEnum etat) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final materiels = await _materielUseCases.getMaterielsByEtat(etat.name);
      _materiels = materiels;
      
    } catch (e) {
      _setError('Erreur lors du filtrage par état: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> filterByType(String type) async {
    try {
      _setLoading(true);
      _setError(null);
      
      final materiels = await _materielUseCases.getMaterielsByType(type);
      _materiels = materiels;
      
    } catch (e) {
      _setError('Erreur lors du filtrage par type: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Méthodes utilitaires
  void selectMateriel(Materiel? materiel) {
    _selectedMateriel = materiel;
    notifyListeners();
  }
  
  void clearSelection() {
    _selectedMateriel = null;
    notifyListeners();
  }
  
  void resetPagination() {
    _currentPage = 1;
    _hasMoreData = true;
  }
  
  // Méthode pour créer un nouveau matériel avec des valeurs par défaut
  Materiel createNewMateriel() {
    return const Materiel(
      type: '',
      modele: '',
      etat: EtatMaterielEnum.actif,
      dateExpirationGarantie: null,
    );
  }
  
  // Méthode pour valider un matériel
  String? validateMateriel(Materiel materiel) {
    if (materiel.type.trim().isEmpty) {
      return 'Le type de matériel est requis';
    }
    return null;
  }
} 