import '../../../core/enums/app_enums.dart';

class Materiel {
  final int? id;
  final String type;
  final String? modele;
  final EtatMaterielEnum etat;
  final DateTime? dateExpirationGarantie;
  final String? os;

  const Materiel({
    this.id,
    required this.type,
    this.modele,
    this.etat = EtatMaterielEnum.actif,
    this.dateExpirationGarantie,
    this.os
  });

  factory Materiel.fromMap(Map<String, dynamic> map) {
    final dynamic etatValue = map['etat'];
    final EtatMaterielEnum parsedEtat = _parseEtat(etatValue);
    final dynamic dateValue = map['date_expiration_garantie'];
    return Materiel(
      id: map['id'] as int?,
      type: (map['type'] ?? '') as String,
      modele: map['modele'] as String?,
      etat: parsedEtat,
      dateExpirationGarantie: dateValue == null || (dateValue is String && dateValue.isEmpty)
          ? null
          : DateTime.parse(dateValue as String),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'type': type,
      'modele': modele,
      'etat': etat.name,
      'date_expiration_garantie': dateExpirationGarantie?.toIso8601String(),
      'os': os,
    };
  }

  Materiel copyWith({
    int? id,
    String? type,
    String? modele,
    EtatMaterielEnum? etat,
    DateTime? dateExpirationGarantie,
  }) {
    return Materiel(
      id: id ?? this.id,
      type: type ?? this.type,
      modele: modele ?? this.modele,
      etat: etat ?? this.etat,
      dateExpirationGarantie: dateExpirationGarantie ?? this.dateExpirationGarantie,
      os: os ?? this.os,
    );
  }

  static EtatMaterielEnum _parseEtat(dynamic value) {
    if (value == null) return EtatMaterielEnum.actif;
    if (value is EtatMaterielEnum) return value;
    final String asString = value.toString();
    // Normalize common snake_case to enum names
    switch (asString) {
      case 'en_panne':
        return EtatMaterielEnum.enPanne;
      case 'en_reparation':
        return EtatMaterielEnum.enReparation;
      default:
        try {
          return EtatMaterielEnum.values.firstWhere((e) => e.name == asString);
        } catch (_) {
          return EtatMaterielEnum.actif;
        }
    }
  }
}
