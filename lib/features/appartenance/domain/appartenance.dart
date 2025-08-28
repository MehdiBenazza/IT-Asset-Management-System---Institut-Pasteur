
import '../../users/domain/user.dart';
import '../../materiel/domain/materiel.dart';

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

  factory Appartenance.fromMap(Map<String, dynamic> map) {
    return Appartenance(
      id: map['id'] as int?,
      idUser: map['id_user'] as int? ?? map['idUser'] as int,
      idMateriel: map['id_materiel'] as int? ?? map['idMateriel'] as int,
      dateDebut: map['date_debut'] is String
          ? DateTime.parse(map['date_debut'] as String)
          : map['date_debut'] as DateTime,
      dateFin: map['date_fin'] == null || (map['date_fin'] is String && (map['date_fin'] as String).isEmpty)
          ? null
          : (map['date_fin'] is String
              ? DateTime.parse(map['date_fin'] as String)
              : map['date_fin'] as DateTime),
      user: map['user'] is Map<String, dynamic>
          ? User.fromMap(map['user'] as Map<String, dynamic>)
          : map['user'] as User?,
      materiel: map['materiel'] is Map<String, dynamic>
          ? Materiel.fromMap(map['materiel'] as Map<String, dynamic>)
          : map['materiel'] as Materiel?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'id_user': idUser,
      'id_materiel': idMateriel,
      'date_debut': dateDebut.toIso8601String(),
      'date_fin': dateFin?.toIso8601String(),
      if (user != null) 'user': user is User ? (user as User).toMap() : user,
      if (materiel != null) 'materiel': materiel is Materiel ? (materiel as Materiel).toMap() : materiel,
    };
  }

  Appartenance copyWith({
    int? id,
    int? idUser,
    int? idMateriel,
    DateTime? dateDebut,
    DateTime? dateFin,
    User? user,
    Materiel? materiel,
  }) {
    return Appartenance(
      id: id ?? this.id,
      idUser: idUser ?? this.idUser,
      idMateriel: idMateriel ?? this.idMateriel,
      dateDebut: dateDebut ?? this.dateDebut,
      dateFin: dateFin ?? this.dateFin,
      user: user ?? this.user,
      materiel: materiel ?? this.materiel,
    );
  }
}
