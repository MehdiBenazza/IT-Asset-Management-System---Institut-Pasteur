import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';

class SupabaseClientService {
  static SupabaseClient? _client;
  
  // Getter pour accéder au client Supabase
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase client not initialized. Call initialize() first.');
    }
    return _client!;
  }
  
  // Initialiser le client Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
    _client = Supabase.instance.client;
  }
  
  // Méthode pour obtenir l'utilisateur actuel
  static User? get currentUser => client.auth.currentUser;
  
  // Méthode pour vérifier si l'utilisateur est connecté
  static bool get isAuthenticated => currentUser != null;
  
  // Méthode pour se déconnecter
  static Future<void> signOut() async {
    await client.auth.signOut();
  }
  
  // Méthode pour obtenir le token d'accès
  static String? get accessToken => currentUser?.accessToken;
  
  // Méthode pour écouter les changements d'authentification
  static Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
  
  // Méthode pour obtenir une table spécifique
  static SupabaseQueryBuilder from(String table) {
    return client.from(table);
  }
  
  // Méthode pour exécuter des requêtes RPC (Remote Procedure Call)
  static SupabaseQueryBuilder rpc(String function, {Map<String, dynamic>? params}) {
    return client.rpc(function, params: params);
  }
  
  // Méthode pour gérer le stockage de fichiers
  static SupabaseStorageClient get storage => client.storage;
}
