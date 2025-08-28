
import '../../../core/enums/app_enums.dart';
import '../../materiel/domain/materiel.dart';
import '../../users/domain/user.dart';

class Intervention {
  final int? id;
  final int idMateriel;
  final TypeInterventionEnum type;
  final DateTime? dateDemande;
  final DateTime dateIntervention;
  final Duration? duree;
  final int? idAdminSignataire;
  final DateTime? dateSignatureAdmin;
  final int? idSuperadminSignataire;
  final DateTime? dateSignatureSuperadmin;
  final Materiel? materiel;
  final User? adminSignataire;
  final User? superadminSignataire;

  const Intervention({
    this.id,
    required this.idMateriel,
    required this.type,
    this.dateDemande,
    required this.dateIntervention,
    this.duree,
    this.idAdminSignataire,
    this.dateSignatureAdmin,
    this.idSuperadminSignataire,
    this.dateSignatureSuperadmin,
    this.materiel,
    this.adminSignataire,
    this.superadminSignataire,
  });

  factory Intervention.fromMap(Map<String, dynamic> map) {
    return Intervention(
      id: map['id'] as int?,
      idMateriel: map['id_materiel'] as int? ?? map['idMateriel'] as int,
      type: map['type'] is TypeInterventionEnum
          ? map['type'] as TypeInterventionEnum
          : TypeInterventionEnum.values.firstWhere(
              (e) => e.name == (map['type']?.toString() ?? ''),
              orElse: () => TypeInterventionEnum.corrective,
            ),
      dateDemande: map['date_demande'] == null || (map['date_demande'] is String && (map['date_demande'] as String).isEmpty)
          ? null
          : (map['date_demande'] is String
              ? DateTime.parse(map['date_demande'] as String)
              : map['date_demande'] as DateTime),
      dateIntervention: map['date_intervention'] is String
          ? DateTime.parse(map['date_intervention'] as String)
          : map['date_intervention'] as DateTime,
      duree: map['duree'] is int
          ? Duration(minutes: map['duree'] as int)
          : map['duree'] as Duration?,
      idAdminSignataire: map['id_admin_signataire'] as int?,
      dateSignatureAdmin: map['date_signature_admin'] == null || (map['date_signature_admin'] is String && (map['date_signature_admin'] as String).isEmpty)
          ? null
          : (map['date_signature_admin'] is String
              ? DateTime.parse(map['date_signature_admin'] as String)
              : map['date_signature_admin'] as DateTime),
      idSuperadminSignataire: map['id_superadmin_signataire'] as int?,
      dateSignatureSuperadmin: map['date_signature_superadmin'] == null || (map['date_signature_superadmin'] is String && (map['date_signature_superadmin'] as String).isEmpty)
          ? null
          : (map['date_signature_superadmin'] is String
              ? DateTime.parse(map['date_signature_superadmin'] as String)
              : map['date_signature_superadmin'] as DateTime),
      materiel: map['materiel'] is Map<String, dynamic>
          ? Materiel.fromMap(map['materiel'] as Map<String, dynamic>)
          : map['materiel'] as Materiel?,
      adminSignataire: map['admin_signataire'] is Map<String, dynamic>
          ? User.fromMap(map['admin_signataire'] as Map<String, dynamic>)
          : map['admin_signataire'] as User?,
      superadminSignataire: map['superadmin_signataire'] is Map<String, dynamic>
          ? User.fromMap(map['superadmin_signataire'] as Map<String, dynamic>)
          : map['superadmin_signataire'] as User?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'id_materiel': idMateriel,
      'type': type.name,
      'date_demande': dateDemande?.toIso8601String(),
      'date_intervention': dateIntervention.toIso8601String(),
      'duree': duree?.inMinutes,
      if (idAdminSignataire != null) 'id_admin_signataire': idAdminSignataire,
      'date_signature_admin': dateSignatureAdmin?.toIso8601String(),
      if (idSuperadminSignataire != null) 'id_superadmin_signataire': idSuperadminSignataire,
      'date_signature_superadmin': dateSignatureSuperadmin?.toIso8601String(),
      if (materiel != null) 'materiel': materiel is Materiel ? (materiel as Materiel).toMap() : materiel,
      if (adminSignataire != null) 'admin_signataire': adminSignataire is User ? (adminSignataire as User).toMap() : adminSignataire,
      if (superadminSignataire != null) 'superadmin_signataire': superadminSignataire is User ? (superadminSignataire as User).toMap() : superadminSignataire,
    };
  }

  Intervention copyWith({
    int? id,
    int? idMateriel,
    TypeInterventionEnum? type,
    DateTime? dateDemande,
    DateTime? dateIntervention,
    Duration? duree,
    int? idAdminSignataire,
    DateTime? dateSignatureAdmin,
    int? idSuperadminSignataire,
    DateTime? dateSignatureSuperadmin,
    Materiel? materiel,
    User? adminSignataire,
    User? superadminSignataire,
  }) {
    return Intervention(
      id: id ?? this.id,
      idMateriel: idMateriel ?? this.idMateriel,
      type: type ?? this.type,
      dateDemande: dateDemande ?? this.dateDemande,
      dateIntervention: dateIntervention ?? this.dateIntervention,
      duree: duree ?? this.duree,
      idAdminSignataire: idAdminSignataire ?? this.idAdminSignataire,
      dateSignatureAdmin: dateSignatureAdmin ?? this.dateSignatureAdmin,
      idSuperadminSignataire: idSuperadminSignataire ?? this.idSuperadminSignataire,
      dateSignatureSuperadmin: dateSignatureSuperadmin ?? this.dateSignatureSuperadmin,
      materiel: materiel ?? this.materiel,
      adminSignataire: adminSignataire ?? this.adminSignataire,
      superadminSignataire: superadminSignataire ?? this.superadminSignataire,
    );
  }
}
