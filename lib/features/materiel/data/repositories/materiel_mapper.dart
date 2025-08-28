import '../../domain/materiel.dart';
import '../../../../core/enums/app_enums.dart';

/// Mapper pour convertir entre les entités de domaine et les modèles de données
class MaterielMapper {
  /// Convertit un Map en entité Materiel
  static Materiel fromMap(Map<String, dynamic> map) {
    return Materiel.fromMap(map);
  }

  /// Convertit une entité Materiel en Map
  static Map<String, dynamic> toMap(Materiel materiel) {
    return materiel.toMap();
  }

  /// Convertit une liste de Maps en liste d'entités Materiel
  static List<Materiel> fromMapList(List<Map<String, dynamic>> mapList) {
    return mapList.map((map) => fromMap(map)).toList();
  }

  /// Convertit une liste d'entités Materiel en liste de Maps
  static List<Map<String, dynamic>> toMapList(List<Materiel> materiels) {
    return materiels.map((materiel) => toMap(materiel)).toList();
  }

  /// Crée une copie d'un matériel avec des modifications
  static Materiel copyWith({
    required Materiel materiel,
    int? id,
    String? type,
    String? modele,
    EtatMaterielEnum? etat,
    DateTime? dateExpirationGarantie,
  }) {
    return Materiel(
      id: id ?? materiel.id,
      type: type ?? materiel.type,
      modele: modele ?? materiel.modele,
      etat: etat ?? materiel.etat,
      dateExpirationGarantie: dateExpirationGarantie ?? materiel.dateExpirationGarantie,
    );
  }
}
