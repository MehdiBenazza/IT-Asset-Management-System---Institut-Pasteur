
import '../../../core/enums/app_enums.dart';
import '../../bureau/domain/bureau.dart';

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

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      nom: map['nom'] as String? ?? '',
      prenom: map['prenom'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: map['role'] is RoleEnum
          ? map['role'] as RoleEnum
          : RoleEnum.values.firstWhere(
              (e) => e.name == (map['role']?.toString() ?? ''),
              orElse: () => RoleEnum.employe,
            ),
      dateNaissance: map['date_naissance'] == null || (map['date_naissance'] is String && (map['date_naissance'] as String).isEmpty)
          ? null
          : (map['date_naissance'] is String
              ? DateTime.parse(map['date_naissance'] as String)
              : map['date_naissance'] as DateTime),
      dateRecrutement: map['date_recrutement'] == null || (map['date_recrutement'] is String && (map['date_recrutement'] as String).isEmpty)
          ? null
          : (map['date_recrutement'] is String
              ? DateTime.parse(map['date_recrutement'] as String)
              : map['date_recrutement'] as DateTime),
      idBureau: map['id_bureau'] as int?,
      bureau: map['bureau'] is Map<String, dynamic>
          ? Bureau.fromMap(map['bureau'] as Map<String, dynamic>)
          : map['bureau'] as Bureau?,
      actif: map['actif'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'role': role.name,
      'date_naissance': dateNaissance?.toIso8601String(),
      'date_recrutement': dateRecrutement?.toIso8601String(),
      if (idBureau != null) 'id_bureau': idBureau,
      if (bureau != null) 'bureau': bureau is Bureau ? (bureau as Bureau).toMap() : bureau,
      'actif': actif,
    };
  }

  User copyWith({
    int? id,
    String? nom,
    String? prenom,
    String? email,
    RoleEnum? role,
    DateTime? dateNaissance,
    DateTime? dateRecrutement,
    int? idBureau,
    Bureau? bureau,
    bool? actif,
  }) {
    return User(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      email: email ?? this.email,
      role: role ?? this.role,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      dateRecrutement: dateRecrutement ?? this.dateRecrutement,
      idBureau: idBureau ?? this.idBureau,
      bureau: bureau ?? this.bureau,
      actif: actif ?? this.actif,
    );
  }
}
