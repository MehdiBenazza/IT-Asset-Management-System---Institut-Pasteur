
import '../../materiel/domain/materiel.dart';
import '../../bureau/domain/bureau.dart';

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

  factory Localisation.fromMap(Map<String, dynamic> map) {
    return Localisation(
      id: map['id'] as int?,
      idMateriel: map['id_materiel'] as int? ?? map['idMateriel'] as int,
      idBureau: map['id_bureau'] as int? ?? map['idBureau'] as int,
      dateDebut: map['date_debut'] is String
          ? DateTime.parse(map['date_debut'] as String)
          : map['date_debut'] as DateTime,
      dateFin: map['date_fin'] == null || (map['date_fin'] is String && (map['date_fin'] as String).isEmpty)
          ? null
          : (map['date_fin'] is String
              ? DateTime.parse(map['date_fin'] as String)
              : map['date_fin'] as DateTime),
      materiel: map['materiel'] is Map<String, dynamic>
          ? Materiel.fromMap(map['materiel'] as Map<String, dynamic>)
          : map['materiel'] as Materiel?,
      bureau: map['bureau'] is Map<String, dynamic>
          ? Bureau.fromMap(map['bureau'] as Map<String, dynamic>)
          : map['bureau'] as Bureau?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'id_materiel': idMateriel,
      'id_bureau': idBureau,
      'date_debut': dateDebut.toIso8601String(),
      'date_fin': dateFin?.toIso8601String(),
      if (materiel != null) 'materiel': materiel is Materiel ? (materiel as Materiel).toMap() : materiel,
      if (bureau != null) 'bureau': bureau is Bureau ? (bureau as Bureau).toMap() : bureau,
    };
  }

  Localisation copyWith({
    int? id,
    int? idMateriel,
    int? idBureau,
    DateTime? dateDebut,
    DateTime? dateFin,
    Materiel? materiel,
    Bureau? bureau,
  }) {
    return Localisation(
      id: id ?? this.id,
      idMateriel: idMateriel ?? this.idMateriel,
      idBureau: idBureau ?? this.idBureau,
      dateDebut: dateDebut ?? this.dateDebut,
      dateFin: dateFin ?? this.dateFin,
      materiel: materiel ?? this.materiel,
      bureau: bureau ?? this.bureau,
    );
  }
}
