import '../domain/localisation.dart';
// import '../../materiel/domain/materiel.dart';
import '../../bureau/domain/bureau.dart';
import '../../materiel/data/repositories/materiel_mapper.dart';

class LocalisationMapper {
  /// Convertit un Map en Localisation
  static Localisation fromMap(Map<String, dynamic> map) {
    return Localisation(
      id: map['id'] as int?,
      idMateriel: map['idMateriel'] as int,
      idBureau: map['idBureau'] as int,
      dateDebut: DateTime.parse(map['dateDebut'] as String),
      dateFin: map['dateFin'] != null ? DateTime.parse(map['dateFin'] as String) : null,
  materiel: map['materiel'] != null ? MaterielMapper.fromMap(map['materiel']) : null,
  bureau: map['bureau'] != null ? Bureau.fromMap(map['bureau']) : null,
    );
  }

  /// Convertit un Localisation en Map
  static Map<String, dynamic> toMap(Localisation localisation) {
    return {
      'id': localisation.id,
      'idMateriel': localisation.idMateriel,
      'idBureau': localisation.idBureau,
      'dateDebut': localisation.dateDebut.toIso8601String(),
      'dateFin': localisation.dateFin?.toIso8601String(),
    };
  }
}

