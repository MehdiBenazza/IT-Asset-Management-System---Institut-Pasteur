
import '../../departement/domain/departement.dart';

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

  factory Bureau.fromMap(Map<String, dynamic> map) {
    return Bureau(
      id: map['id'] as int?,
      nom: map['nom'] as String? ?? '',
      idDepartement: map['id_departement'] as int? ?? map['idDepartement'] as int,
      departement: map['departement'] is Map<String, dynamic>
          ? Departement.fromMap(map['departement'] as Map<String, dynamic>)
          : map['departement'] as Departement?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'nom': nom,
      'id_departement': idDepartement,
      if (departement != null) 'departement': departement is Departement ? (departement as Departement).toMap() : departement,
    };
  }

  Bureau copyWith({
    int? id,
    String? nom,
    int? idDepartement,
    Departement? departement,
  }) {
    return Bureau(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      idDepartement: idDepartement ?? this.idDepartement,
      departement: departement ?? this.departement,
    );
  }
}