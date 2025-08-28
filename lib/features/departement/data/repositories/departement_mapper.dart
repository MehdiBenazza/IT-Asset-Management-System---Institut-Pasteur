import '../../domain/departement.dart';

class DepartementMapper {
  static Departement fromMap(Map<String, dynamic> map) {
    return Departement(
      id: map['id'] as int?,
      nom: map['nom'] as String? ?? '',
    );
  }

  static Map<String, dynamic> toMap(Departement departement) {
    return {
      if (departement.id != null) 'id': departement.id,
      'nom': departement.nom,
    };
  }
}
