import 'package:json_annotation/json_annotation.dart';
import '../materiel/domain/materiel.dart';
import '../bureau/domain/bureau.dart';

part 'localisation.g.dart';

@JsonSerializable()
class Localisation {
  final int? id;
  final int idMateriel;
  final int idBureau;
  final DateTime dateDebut;
  final DateTime? dateFin;
  final Materiel? materiel;
  final Bureau? bureau;

  const Localisation({
    this.id,
    required this.idMateriel,
    required this.idBureau,
    required this.dateDebut,
    this.dateFin,
    this.materiel,
    this.bureau,
  });

  factory Localisation.fromJson(Map<String, dynamic> json) =>
      _$LocalisationFromJson(json);

  Map<String, dynamic> toJson() => _$LocalisationToJson(this);
}
