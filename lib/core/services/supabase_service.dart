import '../sevices/supabase_client.dart';

class SupabaseService {
  // Méthode générique pour récupérer tous les enregistrements d'une table
  static Future<List<Map<String, dynamic>>> getAll(String table) async {
    try {
      final response = await SupabaseClientService.from(table).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Erreur lors de la récupération des données: $e');
    }
  }
  
  // Méthode générique pour récupérer un enregistrement par ID
  static Future<Map<String, dynamic>?> getById(String table, int id) async {
    try {
      final response = await SupabaseClientService.from(table)
          .select()
          .eq('id', id)
          .single();
      return response;
    } catch (e) {
      if (e.toString().contains('No rows found')) {
        return null;
      }
      throw Exception('Erreur lors de la récupération de l\'enregistrement: $e');
    }
  }
  
  // Méthode générique pour créer un enregistrement
  static Future<Map<String, dynamic>> create(String table, Map<String, dynamic> data) async {
    try {
      final response = await SupabaseClientService.from(table).insert(data).select().single();
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la création: $e');
    }
  }
  
  // Méthode générique pour mettre à jour un enregistrement
  static Future<Map<String, dynamic>> update(String table, int id, Map<String, dynamic> data) async {
    try {
      final response = await SupabaseClientService.from(table)
          .update(data)
          .eq('id', id)
          .select()
          .single();
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour: $e');
    }
  }
  
  // Méthode générique pour supprimer un enregistrement
  static Future<void> delete(String table, int id) async {
    try {
      await SupabaseClientService.from(table).delete().eq('id', id);
    } catch (e) {
      throw Exception('Erreur lors de la suppression: $e');
    }
  }
  
  // Méthode pour rechercher des enregistrements
  static Future<List<Map<String, dynamic>>> search(
    String table, 
    String column, 
    String value
  ) async {
    try {
      final response = await SupabaseClientService.from(table)
          .select()
          .ilike(column, '%$value%');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Erreur lors de la recherche: $e');
    }
  }
  
  // Méthode pour rechercher avec des conditions OR sur plusieurs colonnes (ilike)
  static Future<List<Map<String, dynamic>>> searchOr(
    String table, {
    required Map<String, String> conditions,
  }) async {
    try {
      if (conditions.isEmpty) {
        return getAll(table);
      }
      final orFragments = conditions.entries
          .map((entry) => "${entry.key}.ilike.%${entry.value}%")
          .join(',');
      final response = await SupabaseClientService.from(table)
          .select()
          .or(orFragments);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Erreur lors de la recherche OR: $e');
    }
  }
  
  // Méthode pour paginer les résultats
  static Future<List<Map<String, dynamic>>> getPaginated(
    String table, 
    {int page = 1, int limit = 20}
  ) async {
    try {
      final from = (page - 1) * limit;
      final to = from + limit - 1;
      
      final response = await SupabaseClientService.from(table)
          .select()
          .range(from, to);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Erreur lors de la pagination: $e');
    }
  }
  
  // Méthode pour obtenir le nombre total d'enregistrements
  static Future<int> getCount(String table) async {
    try {
      // Note: SDK count meta may vary by version; fallback to simple length of ids
      final response = await SupabaseClientService.from(table)
          .select('id');
      return (response as List).length;
    } catch (e) {
      throw Exception('Erreur lors du comptage: $e');
    }
  }
  
  // Méthode pour filtrer les enregistrements
  static Future<List<Map<String, dynamic>>> filter(
    String table, 
    Map<String, dynamic> filters
  ) async {
    try {
      var query = SupabaseClientService.from(table).select();
      
      filters.forEach((key, value) {
        if (value != null) {
          query = query.eq(key, value);
        }
      });
      
      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Erreur lors du filtrage: $e');
    }
  }
} 