import '../../../core/enums/app_enums.dart';
import '../domain/intervention.dart';
import '../../materiel/domain/materiel.dart';
import '../../users/domain/user.dart';

class InterventionMapper {
  static Map<String, dynamic> toMap(Intervention intervention) {
    return intervention.toMap();
  }

  static Intervention fromMap(Map<String, dynamic> map) {
    return Intervention(
      id: map['id'] as int?,
      idMateriel: map['id_materiel'] as int? ?? map['idMateriel'] as int,
      type: map['type'] is TypeInterventionEnum
          ? map['type'] as TypeInterventionEnum
          : TypeInterventionEnum.values.firstWhere(
              (e) => e.name == (map['type']?.toString() ?? ''),
              orElse: () => TypeInterventionEnum.corrective,
            ),
      dateDemande: _parseDate(map['date_demande']),
      dateIntervention: _parseDate(map['date_intervention']) ?? DateTime.now(),
      duree: map['duree'] is int ? Duration(minutes: map['duree'] as int) : map['duree'] as Duration?,
      idAdminSignataire: map['id_admin_signataire'] as int?,
      dateSignatureAdmin: _parseDate(map['date_signature_admin']),
      idSuperadminSignataire: map['id_superadmin_signataire'] as int?,
      dateSignatureSuperadmin: _parseDate(map['date_signature_superadmin']),
      materiel: map['materiel'] is Map<String, dynamic> ? Materiel.fromMap(map['materiel']) : null,
      adminSignataire: map['admin_signataire'] is Map<String, dynamic> ? User.fromMap(map['admin_signataire']) : null,
      superadminSignataire: map['superadmin_signataire'] is Map<String, dynamic> ? User.fromMap(map['superadmin_signataire']) : null,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) return DateTime.tryParse(value);
    return null;
  }
}
