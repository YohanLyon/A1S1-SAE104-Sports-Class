USE p2104367;
SET default_storage_engine= InnoDB;
SET SQL_SAFE_UPDATES=0;

#Habermacher Aurélien Lapierre Yohan

INSERT INTO UFR (Nom, Adresse) VALUES ("IUT Lyon1", "71 Rue Peter Fink, 01000 Bourg-En-Bresse"),("IFSI", "900 Route de Paris, 01440 Viriat"),("IUT Lyon3", "1 Av. des Frères Lumières, 69008 Lyon");

INSERT INTO Départements (Nom, ID_UFR) VALUES ("IUT BIO 2A", (select ID_UFR from UFR where Nom Like "IUT Lyon1")), ("IUT BIO 1A", (select ID_UFR from UFR where Nom Like "IUT Lyon1")), ("INFO 1A", (select ID_UFR from UFR where Nom Like "IUT Lyon1")), ("INFO 2A", (select ID_UFR from UFR where Nom Like "IUT Lyon1")), ("BIO 1A", (select ID_UFR from UFR where Nom Like "IUT Lyon3")), ("BIO 2A", (select ID_UFR from UFR where Nom Like "IUT Lyon3"));

INSERT INTO Groupes_Utilisateur (nom) VALUES ("Etudiant"), ("Enseignant"), ("Admin"), ("Super-Admin");

UPDATE Groupes_Utilisateur SET ID_Groupe = 1 where Nom like "Etudiant";
UPDATE Groupes_Utilisateur SET ID_Groupe = 50 where Nom like "Enseignant";
UPDATE Groupes_Utilisateur SET ID_Groupe = 100 where Nom like "Admin";
UPDATE Groupes_Utilisateur SET ID_Groupe = 200 where Nom like "Super-Admin";

INSERT INTO Utilisateur (Nom, Prenom, Sexe, Mail_perso, ID_Groupe, ID_Departement) VALUES ("Habermacher","Aurelien", "H","aurelienhabermacher@gmail.com",(select ID_Groupe from Groupes_Utilisateur where Nom LIKE "Etudiant"), (select ID_Departement from Départements where Nom Like "INFO 1A")), 
																					("Buathier","Lionel", "H","BuathierLionel@gmail.com",(select ID_Groupe from Groupes_Utilisateur where Nom LIKE "Super-Admin"), (select ID_Departement from Départements where Nom Like "INFO 1A")),
                                                                                    ("BENOUARET","KARIM", "H","BENOUARETKARIM@gmail.com",(select ID_Groupe from Groupes_Utilisateur where Nom LIKE "Enseignant"), (select ID_Departement from Départements where Nom Like "INFO 1A")),
                                                                                    ("Lapierre","Yohan", "H","LapierreYohan@gmail.com",(select ID_Groupe from Groupes_Utilisateur where Nom LIKE "Etudiant"), (select ID_Departement from Départements where Nom Like "INFO 1A"));
                                                                                    
INSERT INTO Utilisateur (Nom, Prenom, Sexe, MDP, Mail_perso, ID_Groupe, ID_Departement) VALUES("Lagraa","Hamida", "F", "1234","LagraaHamida@gmail.com",(select ID_Groupe from Groupes_Utilisateur where Nom LIKE "Admin"), (select ID_UFR from UFR where Nom Like "IUT Lyon1"));

INSERT INTO Sport (Nom, Noté) VALUES ("AquaPoney", true),("Escalade", false),("Course", false),("Judo", false),("Tennis de table", false);

INSERT INTO Campagne (Type, NB_Places, Date_Debut, Date_Fin, ID_UFR, ID_Sport) VALUES ("Quotas", 12, now(), adddate(now(), 15), (select ID_UFR from UFR where Nom LIKE "IUT Lyon1"), (select ID_Sport from Sport where Nom LIKE "AquaPoney"));

INSERT INTO Créneaux (ID_Sport, Jour, Heure_debut, Heure_fin, Enseignant) VALUES ((select ID_Sport from Sport where Nom like "AquaPoney"), "Mardi", '21:00:00', '22:30:00',  (select ID_User from Utilisateur where lower(Nom) LIKE lower("BENOUARET") AND lower(Prenom) LIKE lower("Karim") AND ID_Groupe = (select ID_Groupe from Groupes_Utilisateur where Nom LIKE "Enseignant"))), ((select ID_Sport from Sport where Nom like "Escalade"), "Mardi", '21:00:00', '22:30:00', NULL),((select ID_Sport from Sport where Nom like "Tennis de table"), "Jeudi", '14:00:00', '18:00:00', NULL);

INSERT INTO Inscrire (ID_User, ID_Créneau) VALUES ((select ID_User from Utilisateur where lower(Nom) LIKE lower("habermachEr") and lower(Prenom) LIKE lower("AurEliEn")), (select ID_Créneau from Créneaux inner join Sport on Sport.ID_Sport = Créneaux.ID_Sport where Jour LIKE "Mardi" and Créneaux.Heure_debut LIKE '21:00:00' and Sport.Nom LIKE "AquaPoney")), ((select ID_User from Utilisateur where lower(Nom) LIKE lower("BENOUAreT") and lower(Prenom) LIKE lower("Karim")), (select ID_Créneau from Créneaux inner join Sport on Sport.ID_Sport = Créneaux.ID_Sport where Jour LIKE "Mardi" and Créneaux.Heure_debut LIKE '21:00:00' and Sport.Nom LIKE "AquaPoney"));

INSERT INTO Seance (Date_séance, ID_Créneau) VALUES (now(), ((select ID_Créneau from Créneaux inner join Sport on Sport.ID_Sport = Créneaux.ID_Sport where Jour LIKE "Mardi" and Créneaux.Heure_debut LIKE '21:00:00' and Sport.Nom LIKE "AquaPoney"))), ('2021-01-11', ((select ID_Créneau from Créneaux inner join Sport on Sport.ID_Sport = Créneaux.ID_Sport where Jour LIKE "Mardi" and Créneaux.Heure_debut LIKE '21:00:00' and Sport.Nom LIKE "AquaPoney"))), ('2021-11-28', ((select ID_Créneau from Créneaux inner join Sport on Sport.ID_Sport = Créneaux.ID_Sport where Jour LIKE "Mardi" and Créneaux.Heure_debut LIKE '21:00:00' and Sport.Nom LIKE "AquaPoney")));

INSERT INTO Absence (ID_Seance, ID_User, Justificatif, Justification, Validation) VALUES ("1", (select ID_User from Utilisateur where lower(nom) LIKE lower("HaberMachEr") AND lower(Prenom) LIKE lower("AurelIen")), "C:/Justificatif/Ordonnance.png", "Rendez-vous médical.", true), ("1", (select ID_User from Utilisateur where lower(nom) LIKE lower("Benouaret") AND lower(Prenom) LIKE lower("Karim")), NULL, NULL, false);

INSERT INTO Désinscription (Justificatif, Validé, ID_Seance, ID_User) VALUES ("C:/Justificatif/Ordonnance2.png", true, (select ID_Seance from Seance where '2021-01-11' LIKE Date_séance AND Seance.ID_Créneau = (select  ID_Créneau from Créneaux inner join Sport on Sport.ID_Sport = Créneaux.ID_Sport where Jour LIKE "Mardi" and Créneaux.Heure_debut LIKE '21:00:00' and Sport.Nom LIKE "AquaPoney")), (select ID_User from Utilisateur where lower(nom) LIKE lower("HaberMachEr") AND lower(Prenom) LIKE lower("AurelIen")));

INSERT INTO Note (Note, ID_User, ID_Seance) VALUES (15, (select ID_User from Utilisateur where lower(Nom) LIKE lower("habermachEr") and lower(Prenom) LIKE lower("AurEliEn")), (select ID_Seance from Seance where '2021-11-28' LIKE Date_séance AND Seance.ID_Créneau = (select  ID_Créneau from Créneaux inner join Sport on Sport.ID_Sport = Créneaux.ID_Sport where Jour LIKE "Mardi" and Créneaux.Heure_debut LIKE '21:00:00' and Sport.Nom LIKE "AquaPoney")));

UPDATE Utilisateur SET Nb_Absences = (select count(ID_Absence) from Absence where Utilisateur.ID_User = Absence.ID_User AND Validation = false);

INSERT INTO Messages (ID_Envoyeur, Object, Contenu) VALUES ((select ID_User from Utilisateur where lower(Nom) LIKE lower("BENOUARET") AND lower(Prenom) LIKE lower("Karim")), "Absence", "Bonjour /n Je vous prie de justifier vôtre absence du 28-11-2021 au plus vite. /n Cordialement, /n Benhouaret Karim");

INSERT INTO Echanger VALUES ((select ID_User from Utilisateur where lower(Nom) LIKE lower("BENOUARET") AND lower(Prenom) LIKE lower("Karim")), 1), ((select ID_User from Utilisateur where lower(Nom) LIKE lower("HABERMACHER") AND lower(Prenom) LIKE lower("aurelien")), 1);

INSERT INTO Envoyer VALUES ((select ID_Sport from Sport where lower(Nom) LIKE lower("AquaPoney")), 1);

INSERT INTO Recevoir VALUES ((select ID_Créneau from Créneaux inner join Sport on Sport.ID_Sport = Créneaux.ID_Sport where Jour LIKE "Mardi" and Créneaux.Heure_debut LIKE '21:00:00' and Sport.Nom LIKE "AquaPoney"), 1);

