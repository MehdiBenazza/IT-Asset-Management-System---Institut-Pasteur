import 'supabase_service.dart';
import '../config/app_config.dart';

class DatabaseTestService {
  // Test de connexion à la base de données
  static Future<bool> testConnection() async {
    try {
      // Test simple pour vérifier la connexion
      await SupabaseService.getAll(AppConfig.usersTable);
      print('Connexion à la base de données réussie');
      return true;
    } catch (e) {
      print('Erreur de connexion à la base de données: $e');
      return false;
    }
  }
  
  // Test de création d'un enregistrement de test
  static Future<bool> testCreate() async {
    try {
      final testData = {
        'name': 'Test User',
        'email': 'test@example.com',
        'created_at': DateTime.now().toIso8601String(),
      };
      
      await SupabaseService.create(AppConfig.usersTable, testData);
      print('Test de création réussi');
      return true;
    } catch (e) {
      print('Erreur lors du test de création: $e');
      return false;
    }
  }
  
  // Test de lecture d'enregistrements
  static Future<bool> testRead() async {
    try {
      final data = await SupabaseService.getAll(AppConfig.usersTable);
      print('Test de lecture réussi. Nombre d\'enregistrements: ${data.length}');
      return true;
    } catch (e) {
      print('Erreur lors du test de lecture: $e');
      return false;
    }
  }
  
  // Test complet de la base de données
  static Future<void> runAllTests() async {
    print('Démarrage des tests de base de données...');
    
    final connectionTest = await testConnection();
    if (!connectionTest) {
      print('Test de connexion échoué. Arrêt des tests.');
      return;
    }
    
    final readTest = await testRead();
    if (!readTest) {
      print('Test de lecture échoué.');
    }
    
    final createTest = await testCreate();
    if (!createTest) {
      print('Test de création échoué.');
    }
    
    if (connectionTest && readTest && createTest) {
      print('Tous les tests de base de données ont réussi !');
    } else {
      print('Certains tests ont échoué. Vérifiez votre configuration.');
    }
  }
} 