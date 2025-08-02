import 'package:json_annotation/json_annotation.dart';
import '../../../core/enums/app_enums.dart';
import '../materiel/domain/materiel.dart';
import '../users/domain/user.dart';

part 'intervention.g.dart';

@JsonSerializable()
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

  factory Intervention.fromJson(Map<String, dynamic> json) =>
      _$InterventionFromJson(json);

  Map<String, dynamic> toJson() => _$InterventionToJson(this);
}
