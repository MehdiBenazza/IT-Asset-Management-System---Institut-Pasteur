
class Departement {
  final int? id;
  final String nom;

  const Departement({
    this.id,
    required this.nom,
  });

  factory Departement.fromMap(Map<String, dynamic> map) {
    return Departement(
      id: map['id'] as int?,
      nom: map['nom'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'nom': nom,
    };
  }

  Departement copyWith({
    int? id,
    String? nom,
  }) {
    return Departement(
      id: id ?? this.id,
      nom: nom ?? this.nom,
    );
  }
}