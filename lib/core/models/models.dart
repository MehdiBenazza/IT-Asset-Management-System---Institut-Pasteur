

// Enums and Models
export '../enums/app_enums.dart';
export '../../features/departement/domain/departement.dart';
export '../../features/bureau/domain/bureau.dart';
export '../../features/users/domain/user.dart';
export '../../features/materiel/domain/materiel.dart';
export '../../features/appartenance/domain/appartenance.dart';
export '../../features/localisation/domain/localisation.dart';
export '../../features/intervention/domain/intervention.dart';

import '../enums/app_enums.dart';

// Extensions for displayName for enums
extension RoleEnumExtension on RoleEnum {
	String get displayName {
		switch (this) {
			case RoleEnum.superadmin:
				return 'Super Administrateur';
			case RoleEnum.admin:
				return 'Administrateur';
			case RoleEnum.secretaire:
				return 'Secrétaire';
			case RoleEnum.employe:
				return 'Employé';
		}
	}
}

RoleEnum roleEnumFromString(String value) {
	switch (value) {
		case 'superadmin':
			return RoleEnum.superadmin;
		case 'admin':
			return RoleEnum.admin;
		case 'secretaire':
			return RoleEnum.secretaire;
		case 'employe':
			return RoleEnum.employe;
		default:
			throw ArgumentError('Invalid RoleEnum value: $value');
	}
}

extension EtatMaterielEnumExtension on EtatMaterielEnum {
	String get displayName {
		switch (this) {
			case EtatMaterielEnum.actif:
				return 'Actif';
			case EtatMaterielEnum.enPanne:
				return 'En panne';
			case EtatMaterielEnum.enReparation:
				return 'En réparation';
		}
	}
}

EtatMaterielEnum etatMaterielEnumFromString(String value) {
	switch (value) {
		case 'actif':
			return EtatMaterielEnum.actif;
		case 'en_panne':
			return EtatMaterielEnum.enPanne;
		case 'en_reparation':
			return EtatMaterielEnum.enReparation;
		default:
			throw ArgumentError('Invalid EtatMaterielEnum value: $value');
	}
}

extension TypeInterventionEnumExtension on TypeInterventionEnum {
	String get displayName {
		switch (this) {
			case TypeInterventionEnum.preventive:
				return 'Préventive';
			case TypeInterventionEnum.corrective:
				return 'Corrective';
		}
	}
}

TypeInterventionEnum typeInterventionEnumFromString(String value) {
	switch (value) {
		case 'preventive':
			return TypeInterventionEnum.preventive;
		case 'corrective':
			return TypeInterventionEnum.corrective;
		default:
			throw ArgumentError('Invalid TypeInterventionEnum value: $value');
	}
}

// ...existing code...