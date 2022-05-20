USE p2104367;
SET default_storage_engine= InnoDB;
SET SQL_SAFE_UPDATES=0;

#Habermacher Aurélien Lapierre Yohan

#Requêtes de suppression

#DELETE FROM Utilisateur where lower(nom) LIKE lower("HABERMACHER") AND lower(Prenom) LIKE lower("AURELIEN");
#DELETE FROM Messages where ID_Envoyeur = 3;
#DELETE FROM UFR where ID_UFR = 1;
#DELETE FROM Départements where ID_Departement = 3;

/* Vérifiaction des données supprimées

select * from Utilisateur;
select * from Echanger;
select * from Messages;
select * from Envoyer;
select * from Recevoir;
select * from Inscrire;
select * from Note;
select * from Absence;
select * from Départements;
select * from UFR;
select * from Campagne;
select * from Créneaux;
select * from Seance;
select * from Désinscription;
select * from Sport;
select * from Groupes_Utilisateur;
*/

#Requètes de sélections pour le format donné en exemple sur ClarolineConnect

#Requète admin
SELECT Utilisateur.ID_User as "N°étudiant", Utilisateur.Nom, Utilisateur.Prenom, Utilisateur.Sexe, UFR.Nom as "UFR", Départements.Nom as "Filière", Utilisateur.Mail_universitaire as "Email_univ", Utilisateur.Num_téléphone as "Mobile", Sport.Nom, (select Nom from Utilisateur where Utilisateur.ID_User = Créneaux.Enseignant) as Enseignant, Créneaux.Jour, concat(left(Créneaux.Heure_Debut, 5), "-", left(Créneaux.Heure_Fin, 5)) as "Heure", Utilisateur.Nb_Absences as "Abs Non Justif.", Note.Note, Note.Commentaire From Utilisateur inner join Note on Note.ID_User = Utilisateur.ID_User inner join Inscrire on Inscrire.ID_User = Utilisateur.ID_User inner join Créneaux on Créneaux.ID_Créneau = Inscrire.ID_Créneau  inner join Sport on Sport.ID_Sport = Créneaux.ID_Sport inner join Départements on Départements.ID_Departement = Utilisateur.ID_Departement inner join UFR on UFR.ID_UFR = Départements.ID_UFR where Utilisateur.ID_Groupe = (select ID_Groupe from Groupes_Utilisateur where Nom like "Etudiant");

#Requète prof
SELECT Utilisateur.ID_User as "N°étudiant", Utilisateur.Nom, Utilisateur.Prenom, UFR.Nom as "UFR", Départements.Nom as "Filière", Utilisateur.Mail_universitaire as "Mail étudiant", Utilisateur.Mail_perso as "Mail étudiant", Utilisateur.Num_téléphone as "Téléphone", Note.Note, Note.Commentaire, Utilisateur.Nb_Absences as "Absences Non Justif.", Sport.ID_Sport as "num Activité" from Utilisateur inner join Groupes_Utilisateur on Groupes_Utilisateur.ID_Groupe = Utilisateur.ID_Groupe inner join Inscrire on Inscrire.ID_User = Utilisateur.ID_User inner join Créneaux on Inscrire.ID_Créneau = Créneaux.ID_Créneau inner join Seance on Seance.ID_Créneau = Créneaux.ID_Créneau inner join Note on Note.ID_Seance = Seance.ID_Seance inner join Sport on Sport.ID_Sport = Créneaux.ID_Sport inner join Départements on Utilisateur.ID_Departement = Départements.ID_Departement inner join UFR on UFR.ID_UFR = Départements.ID_UFR WHERE Créneaux.Enseignant = (Select ID_User from Utilisateur where lower(Utilisateur.Nom) = lower("Benouaret") AND lower(Utilisateur.Prenom) = lower("Karim")) AND Utilisateur.ID_Groupe = (Select Groupes_Utilisateur.ID_Groupe from Groupes_Utilisateur where Groupes_Utilisateur.Nom LIKE "Etudiant");