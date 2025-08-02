import 'package:flutter_test/flutter_test.dart';
import 'package:it_asset_management/core/models/models.dart';

void main() {
  group('Modèles Tests', () {
    group('Enums Tests', () {
      test('RoleEnum fromString', () {
        expect(RoleEnum.fromString('superadmin'), RoleEnum.superadmin);
        expect(RoleEnum.fromString('admin'), RoleEnum.admin);
        expect(RoleEnum.fromString('secretaire'), RoleEnum.secretaire);
        expect(RoleEnum.fromString('employe'), RoleEnum.employe);
        expect(() => RoleEnum.fromString('invalid'), throwsArgumentError);
      });

      test('RoleEnum displayName', () {
        expect(RoleEnum.superadmin.displayName, 'Super Administrateur');
        expect(RoleEnum.admin.displayName, 'Administrateur');
        expect(RoleEnum.secretaire.displayName, 'Secrétaire');
        expect(RoleEnum.employe.displayName, 'Employé');
      });

      test('EtatMaterielEnum fromString', () {
        expect(EtatMaterielEnum.fromString('actif'), EtatMaterielEnum.actif);
        expect(EtatMaterielEnum.fromString('en_panne'), EtatMaterielEnum.enPanne);
        expect(EtatMaterielEnum.fromString('en_reparation'), EtatMaterielEnum.enReparation);
        expect(() => EtatMaterielEnum.fromString('invalid'), throwsArgumentError);
      });

      test('EtatMaterielEnum displayName', () {
        expect(EtatMaterielEnum.actif.displayName, 'Actif');
        expect(EtatMaterielEnum.enPanne.displayName, 'En panne');
        expect(EtatMaterielEnum.enReparation.displayName, 'En réparation');
      });

      test('TypeInterventionEnum fromString', () {
        expect(TypeInterventionEnum.fromString('preventive'), TypeInterventionEnum.preventive);
        expect(TypeInterventionEnum.fromString('corrective'), TypeInterventionEnum.corrective);
        expect(() => TypeInterventionEnum.fromString('invalid'), throwsArgumentError);
      });

      test('TypeInterventionEnum displayName', () {
        expect(TypeInterventionEnum.preventive.displayName, 'Préventive');
        expect(TypeInterventionEnum.corrective.displayName, 'Corrective');
      });
    });

    group('Departement Tests', () {
      test('Departement creation', () {
        final departement = Departement(id: 1, nom: 'IT');
        expect(departement.id, 1);
        expect(departement.nom, 'IT');
      });

      test('Departement copyWith', () {
        final departement = Departement(id: 1, nom: 'IT');
        final updated = departement.copyWith(nom: 'Informatique');
        expect(updated.id, 1);
        expect(updated.nom, 'Informatique');
      });

      test('Departement equality', () {
        final departement1 = Departement(id: 1, nom: 'IT');
        final departement2 = Departement(id: 1, nom: 'IT');
        final departement3 = Departement(id: 2, nom: 'IT');
        
        expect(departement1, equals(departement2));
        expect(departement1, isNot(equals(departement3)));
      });
    });

    group('Bureau Tests', () {
      test('Bureau creation', () {
        final bureau = Bureau(
          id: 1,
          nom: 'Bureau A',
          idDepartement: 1,
        );
        expect(bureau.id, 1);
        expect(bureau.nom, 'Bureau A');
        expect(bureau.idDepartement, 1);
      });

      test('Bureau with departement relation', () {
        final departement = Departement(id: 1, nom: 'IT');
        final bureau = Bureau(
          id: 1,
          nom: 'Bureau A',
          idDepartement: 1,
          departement: departement,
        );
        expect(bureau.departement, equals(departement));
      });
    });

    group('User Tests', () {
      test('User creation', () {
        final user = User(
          id: 1,
          nom: 'Dupont',
          prenom: 'Jean',
          email: 'jean.dupont@pasteur.fr',
          role: RoleEnum.employe,
          idBureau: 1,
        );
        expect(user.id, 1);
        expect(user.nom, 'Dupont');
        expect(user.prenom, 'Jean');
        expect(user.email, 'jean.dupont@pasteur.fr');
        expect(user.role, RoleEnum.employe);
        expect(user.idBureau, 1);
        expect(user.actif, true);
      });

      test('User nomComplet', () {
        final user = User(
          nom: 'Dupont',
          prenom: 'Jean',
          email: 'jean.dupont@pasteur.fr',
          role: RoleEnum.employe,
        );
        expect(user.nomComplet, 'Jean Dupont');
      });
    });

    group('Materiel Tests', () {
      test('Materiel creation', () {
        final materiel = Materiel(
          id: 1,
          type: 'Ordinateur portable',
          modele: 'ThinkPad X1',
          etat: EtatMaterielEnum.actif,
          dateExpirationGarantie: DateTime(2025, 12, 31),
        );
        expect(materiel.id, 1);
        expect(materiel.type, 'Ordinateur portable');
        expect(materiel.modele, 'ThinkPad X1');
        expect(materiel.etat, EtatMaterielEnum.actif);
        expect(materiel.dateExpirationGarantie, DateTime(2025, 12, 31));
      });

      test('Materiel designation', () {
        final materiel1 = Materiel(
          type: 'Ordinateur portable',
          modele: 'ThinkPad X1',
        );
        final materiel2 = Materiel(
          type: 'Écran',
        );
        
        expect(materiel1.designation, 'Ordinateur portable - ThinkPad X1');
        expect(materiel2.designation, 'Écran');
      });

      test('Materiel estEnGarantie', () {
        final materiel1 = Materiel(
          type: 'Ordinateur portable',
          dateExpirationGarantie: DateTime.now().add(Duration(days: 30)),
        );
        final materiel2 = Materiel(
          type: 'Ordinateur portable',
          dateExpirationGarantie: DateTime.now().subtract(Duration(days: 30)),
        );
        final materiel3 = Materiel(
          type: 'Ordinateur portable',
        );
        
        expect(materiel1.estEnGarantie, true);
        expect(materiel2.estEnGarantie, false);
        expect(materiel3.estEnGarantie, false);
      });

      test('Materiel etat getters', () {
        final materielActif = Materiel(type: 'Test', etat: EtatMaterielEnum.actif);
        final materielPanne = Materiel(type: 'Test', etat: EtatMaterielEnum.enPanne);
        final materielReparation = Materiel(type: 'Test', etat: EtatMaterielEnum.enReparation);
        
        expect(materielActif.estActif, true);
        expect(materielPanne.estEnPanne, true);
        expect(materielReparation.estEnReparation, true);
      });
    });

    group('Appartenance Tests', () {
      test('Appartenance creation', () {
        final appartenance = Appartenance(
          id: 1,
          idUser: 1,
          idMateriel: 1,
          dateDebut: DateTime(2024, 1, 1),
        );
        expect(appartenance.id, 1);
        expect(appartenance.idUser, 1);
        expect(appartenance.idMateriel, 1);
        expect(appartenance.dateDebut, DateTime(2024, 1, 1));
        expect(appartenance.estEnCours, true);
      });

      test('Appartenance dureeFormatee', () {
        final appartenance = Appartenance(
          idUser: 1,
          idMateriel: 1,
          dateDebut: DateTime.now().subtract(Duration(days: 365)),
        );
        
        expect(appartenance.dureeFormatee, '1 an');
      });
    });

    group('Localisation Tests', () {
      test('Localisation creation', () {
        final localisation = Localisation(
          id: 1,
          idMateriel: 1,
          idBureau: 1,
          dateDebut: DateTime(2024, 1, 1),
        );
        expect(localisation.id, 1);
        expect(localisation.idMateriel, 1);
        expect(localisation.idBureau, 1);
        expect(localisation.dateDebut, DateTime(2024, 1, 1));
        expect(localisation.estEnCours, true);
      });
    });

    group('Intervention Tests', () {
      test('Intervention preventive creation', () {
        final intervention = Intervention(
          id: 1,
          idMateriel: 1,
          type: TypeInterventionEnum.preventive,
          dateIntervention: DateTime.now().add(Duration(days: 7)),
          duree: Duration(hours: 2),
        );
        expect(intervention.id, 1);
        expect(intervention.idMateriel, 1);
        expect(intervention.type, TypeInterventionEnum.preventive);
        expect(intervention.dateDemande, null);
        expect(intervention.duree, Duration(hours: 2));
      });

      test('Intervention corrective creation', () {
        final intervention = Intervention(
          id: 1,
          idMateriel: 1,
          type: TypeInterventionEnum.corrective,
          dateDemande: DateTime.now(),
          dateIntervention: DateTime.now().add(Duration(days: 1)),
        );
        expect(intervention.type, TypeInterventionEnum.corrective);
        expect(intervention.dateDemande, isNotNull);
      });

      test('Intervention validation error', () {
        expect(
          () => Intervention(
            idMateriel: 1,
            type: TypeInterventionEnum.corrective,
            dateIntervention: DateTime.now(),
            // Pas de dateDemande pour une intervention corrective
          ),
          throwsAssertionError,
        );
      });

      test('Intervention dureeFormatee', () {
        final intervention1 = Intervention(
          idMateriel: 1,
          type: TypeInterventionEnum.preventive,
          dateIntervention: DateTime.now(),
          duree: Duration(hours: 2, minutes: 30),
        );
        final intervention2 = Intervention(
          idMateriel: 1,
          type: TypeInterventionEnum.preventive,
          dateIntervention: DateTime.now(),
          duree: Duration(minutes: 45),
        );
        final intervention3 = Intervention(
          idMateriel: 1,
          type: TypeInterventionEnum.preventive,
          dateIntervention: DateTime.now(),
        );
        
        expect(intervention1.dureeFormatee, '2h 30min');
        expect(intervention2.dureeFormatee, '45min');
        expect(intervention3.dureeFormatee, 'Non définie');
      });

      test('Intervention statut', () {
        final intervention1 = Intervention(
          idMateriel: 1,
          type: TypeInterventionEnum.preventive,
          dateIntervention: DateTime.now().add(Duration(days: 7)),
        );
        final intervention2 = Intervention(
          idMateriel: 1,
          type: TypeInterventionEnum.preventive,
          dateIntervention: DateTime.now().subtract(Duration(days: 1)),
        );
        final intervention3 = Intervention(
          idMateriel: 1,
          type: TypeInterventionEnum.preventive,
          dateIntervention: DateTime.now().subtract(Duration(days: 1)),
          dateSignatureAdmin: DateTime.now(),
        );
        final intervention4 = Intervention(
          idMateriel: 1,
          type: TypeInterventionEnum.preventive,
          dateIntervention: DateTime.now().subtract(Duration(days: 1)),
          dateSignatureAdmin: DateTime.now(),
          dateSignatureSuperadmin: DateTime.now(),
        );
        
        expect(intervention1.statut, 'Planifiée');
        expect(intervention2.statut, 'En attente de signature admin');
        expect(intervention3.statut, 'En attente de validation superadmin');
        expect(intervention4.statut, 'Terminée');
      });
    });
  });
} 