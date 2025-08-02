import 'package:json_annotation/json_annotation.dart';
import '../users/domain/user.dart';
import '../materiel/domain/materiel.dart';

part 'appartenance.g.dart';

@JsonSerializable()
class Appartenance {
  final int? id;
  final int idUser;
  final int idMateriel;
  final DateTime dateDebut;
  final DateTime? dateFin;
  final User? user;
  final Materiel? materiel;

  const Appartenance({
    this.id,
    required this.idUser,
    required this.idMateriel,
    required this.dateDebut,
    this.dateFin,
    this.user,
    this.materiel,
  });

  factory Appartenance.fromJson(Map<String, dynamic> json) =>
      _$AppartenanceFromJson(json);

  Map<String, dynamic> toJson() => _$AppartenanceToJson(this);
}
