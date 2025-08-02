import 'package:json_annotation/json_annotation.dart';

part 'departement.g.dart';

@JsonSerializable()
class Departement {
  final int? id;
  final String nom;

  const Departement({
    this.id,
    required this.nom,
  });

  factory Departement.fromJson(Map<String, dynamic> json) =>
      _$DepartementFromJson(json);

  Map<String, dynamic> toJson() => _$DepartementToJson(this);
} 