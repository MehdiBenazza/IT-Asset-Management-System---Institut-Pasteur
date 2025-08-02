import 'package:json_annotation/json_annotation.dart';
import '../../../core/enums/app_enums.dart';
import '../bureau/domain/bureau.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int? id;
  final String nom;
  final String prenom;
  final String email;
  final RoleEnum role;
  final DateTime? dateNaissance;
  final DateTime? dateRecrutement;
  final int? idBureau;
  final Bureau? bureau;
  final bool actif;

  const User({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.role,
    this.dateNaissance,
    this.dateRecrutement,
    this.idBureau,
    this.bureau,
    this.actif = true,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
