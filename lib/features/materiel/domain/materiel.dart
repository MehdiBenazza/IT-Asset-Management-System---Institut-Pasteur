import 'package:json_annotation/json_annotation.dart';
import '../../../core/enums/app_enums.dart';

part 'materiel.g.dart';

@JsonSerializable()
class Materiel {
  final int? id;
  final String type;
  final String? modele;
  final EtatMaterielEnum etat;
  final DateTime? dateExpirationGarantie;

  const Materiel({
    this.id,
    required this.type,
    this.modele,
    this.etat = EtatMaterielEnum.actif,
    this.dateExpirationGarantie,
  });

  factory Materiel.fromJson(Map<String, dynamic> json) =>
      _$MaterielFromJson(json);

  Map<String, dynamic> toJson() => _$MaterielToJson(this);
}
