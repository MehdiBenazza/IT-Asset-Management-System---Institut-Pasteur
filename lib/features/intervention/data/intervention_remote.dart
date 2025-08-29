// lib/features/intervention/data/intervention_remote.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/intervention.dart';
import '../data/intervention_mapper.dart';

class InterventionRemote {
  final SupabaseClient _client;

  InterventionRemote(this._client);

  /// 🔹 CREATE
  Future<Intervention> createIntervention(Intervention intervention) async {
    final response = await _client
        .from('interventions')
        .insert(InterventionMapper.toMap(intervention))
        .select()
        .single();

    return InterventionMapper.fromMap(response);
  }

  /// 🔹 READ ALL
  Future<List<Intervention>> getAllInterventions() async {
    final response = await _client
        .from('interventions')
        .select('*, materiel(*), admin_signataire(*), superadmin_signataire(*)');

    return (response as List)
        .map((map) => InterventionMapper.fromMap(map))
        .toList();
  }

  /// 🔹 READ BY ID
  Future<Intervention?> getInterventionById(int id) async {
    final response = await _client
        .from('interventions')
        .select('*, materiel(*), admin_signataire(*), superadmin_signataire(*)')
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return InterventionMapper.fromMap(response);
  }

  /// 🔹 UPDATE
  Future<Intervention> updateIntervention(Intervention intervention) async {
    final response = await _client
        .from('interventions')
        .update(InterventionMapper.toMap(intervention))
        .eq('id', intervention.id!)
        .select()
        .single();

    return InterventionMapper.fromMap(response);
  }

  /// 🔹 DELETE
  Future<void> deleteIntervention(int id) async {
    await _client.from('interventions').delete().eq('id', id);
  }

  /// 🔹 EXTRA : Récupérer les interventions par matériel
  Future<List<Intervention>> getInterventionsByMateriel(int idMateriel) async {
    final response = await _client
        .from('interventions')
        .select('*, materiel(*), admin_signataire(*), superadmin_signataire(*)')
        .eq('id_materiel', idMateriel);

    return (response as List)
        .map((map) => InterventionMapper.fromMap(map))
        .toList();
  }
}
