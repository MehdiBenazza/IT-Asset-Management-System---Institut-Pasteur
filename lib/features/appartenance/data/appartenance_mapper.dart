import '../domain/appartenance.dart';
import '../../users/domain/user.dart';
import '../../materiel/domain/materiel.dart';

class AppartenanceMapper {
	/// Convertit un objet Appartenance en Map<String, dynamic> pour la base de données
	static Map<String, dynamic> toMap(Appartenance appartenance) {
		return {
			if (appartenance.id != null) 'id': appartenance.id,
			'id_user': appartenance.idUser,
			'id_materiel': appartenance.idMateriel,
			'date_debut': appartenance.dateDebut.toIso8601String(),
			'date_fin': appartenance.dateFin?.toIso8601String(),
			if (appartenance.user != null) 'user': appartenance.user is User ? (appartenance.user as User).toMap() : appartenance.user,
			if (appartenance.materiel != null) 'materiel': appartenance.materiel is Materiel ? (appartenance.materiel as Materiel).toMap() : appartenance.materiel,
		};
	}

	/// Crée un objet Appartenance à partir d'un Map<String, dynamic> (depuis la base)
		static Appartenance fromMap(Map<String, dynamic> map) {
			final dateDebut = _parseDate(map['date_debut']);
			return Appartenance(
				id: map['id'] as int?,
				idUser: map['id_user'] as int? ?? map['idUser'] as int,
				idMateriel: map['id_materiel'] as int? ?? map['idMateriel'] as int,
				dateDebut: dateDebut ?? DateTime.now(),
				dateFin: _parseDate(map['date_fin']),
				user: map['user'] is Map<String, dynamic> ? User.fromMap(map['user']) : null,
				materiel: map['materiel'] is Map<String, dynamic> ? Materiel.fromMap(map['materiel']) : null,
			);
		}

	/// Helper pour parser les dates
	static DateTime? _parseDate(dynamic value) {
		if (value == null) return null;
		if (value is DateTime) return value;
		if (value is String && value.isNotEmpty) return DateTime.parse(value);
		return null;
	}
}
