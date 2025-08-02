import 'package:json_annotation/json_annotation.dart';
import '../departement/domain/departement.dart';

part 'bureau.g.dart';

@JsonSerializable()
class Bureau {
  final int? id;
  final String nom;
  final int idDepartement;
  final Departement? departement;

  const Bureau({
    this.id,
    required this.nom,
    required this.idDepartement,
    this.departement,
  });

  factory Bureau.fromJson(Map<String, dynamic> json) =>
      _$BureauFromJson(json);

  Map<String, dynamic> toJson() => _$BureauToJson(this);
} 