import '../../domain/materiel.dart';
import '../../domain/bureau.dart';
import 'materiel_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MaterielRemoteDataSource {
  final SupabaseClient supabaseClient;

  MaterielRemoteDataSource(this.supabaseClient);

  // Récupérer tous les matériels
  Future<List<Materiel>> getAllMateriels() async {
    try {
      final data = await supabaseClient
          .from('materiels')
          .select();
      final list = (data as List).map((e) => Map<String, dynamic>.from(e)).toList();
      return MaterielMapper.fromMapList(list);
    } catch (e) {
      throw Exception('Erreur récupération matériels: $e');
    }
  }

  // Créer un matériel
  Future<Materiel> createMateriel(Materiel materiel) async {
    try {
      final data = await supabaseClient
          .from('materiels')
          .insert([MaterielMapper.toMap(materiel)])
          .select()
          .single();
      final map = Map<String, dynamic>.from(data);
      return MaterielMapper.fromMap(map);
    } catch (e) {
      throw Exception('Erreur création matériel: $e');
    }
  }

  // Modifier un matériel
  Future<Materiel> updateMateriel(int id, Materiel materiel) async {
    try {
      final data = await supabaseClient
          .from('materiels')
          .update(MaterielMapper.toMap(materiel))
          .eq('id', id)
          .select()
          .single();
      final map = Map<String, dynamic>.from(data);
      return MaterielMapper.fromMap(map);
    } catch (e) {
      throw Exception('Erreur modification matériel: $e');
    }
  }

  // Supprimer un matériel
  Future<void> deleteMateriel(int id) async {
    try {
      await supabaseClient
          .from('materiels')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Erreur suppression matériel: $e');
    }
  }

  // Récupère le bureau associé à un matériel donné (idMateriel)
  Future<Bureau?> getBureauByMateriel(int idMateriel) async {
    // Exemple d'implémentation avec Supabase
    final response = await supabaseClient
        .from('localisations')
        .select('bureau(*)')
        .eq('idMateriel', idMateriel)
        .single();
    if (response == null) return null;
    if (response['bureau'] != null) {
      return Bureau.fromMap(response['bureau'] as Map<String, dynamic>);
    }
    return null;
  }
}
