USE p2104367;
SET default_storage_engine= InnoDB;
SET SQL_SAFE_UPDATES=0;

# Habermacher Aurélien Lapierre Yohan

drop table if exists Recevoir;
drop table if exists Envoyer;
drop table if exists Echanger;
drop table if exists Inscrire;
drop table if exists Désinscription;
drop table if exists Note;
drop table if exists Absence;
drop table if exists Seance;
drop table if exists Messages;
drop table if exists Créneaux;
drop table if exists Campagne;
drop table if exists Sport;
drop table if exists Utilisateur;
drop table if exists Départements;
drop table if exists Groupes_Utilisateur;
drop table if exists UFR;

CREATE TABLE UFR(
   ID_UFR INT SERIAL DEFAULT VALUE,
   Nom VARCHAR(50) unique,
   Adresse VARCHAR(100),
   CONSTRAINT PK_UFR PRIMARY KEY(ID_UFR)
);

CREATE TABLE Groupes_Utilisateur(
   ID_Groupe INT SERIAL DEFAULT VALUE,
   Nom VARCHAR(50),
   CONSTRAINT PK_ID_Groupe PRIMARY KEY(ID_Groupe)
);

CREATE TABLE Départements(
   ID_Departement INT SERIAL DEFAULT VALUE,
   Nom VARCHAR(50),
   ID_UFR INT NOT NULL,
   CONSTRAINT PK_Département PRIMARY KEY (ID_Departement),
   CONSTRAINT FK_Département_UFR FOREIGN KEY (ID_UFR) REFERENCES UFR(ID_UFR) ON DELETE RESTRICT
);

CREATE TABLE Utilisateur(
   ID_User INT SERIAL DEFAULT VALUE,
   Nom VARCHAR(50) NOT NULL,
   Prenom VARCHAR(50) NOT NULL,
   Sexe Varchar(20) NOT NULL,
   Mail_perso VARCHAR(100) NOT NULL,
   Mail_universitaire VARCHAR(50),
   MDP VARCHAR(150) DEFAULT (concat(Prenom, ".", Nom)),
   Mail_Valide BOOL,
   Nb_Absences INT,
   Num_téléphone VARCHAR(15),
   ID_Groupe INT NOT NULL,
   ID_Departement INT NOT NULL,
   PRIMARY KEY(ID_User),
   CONSTRAINT FK_Utilisateur_Groupe FOREIGN KEY(ID_Groupe) REFERENCES Groupes_Utilisateur(ID_Groupe) ON DELETE RESTRICT,
   CONSTRAINT PK_Utilisateur FOREIGN KEY(ID_Departement) REFERENCES Départements(ID_Departement) ON DELETE RESTRICT
);

CREATE TABLE Sport(
   ID_Sport INT SERIAL DEFAULT VALUE,
   Nom VARCHAR(50),
   Noté bool default false,
   CONSTRAINT PK_Sport PRIMARY KEY(ID_Sport) 
);

CREATE TABLE Campagne(
   ID_Campagne INT SERIAL DEFAULT VALUE,
   Type VARCHAR(50),
   NB_Places INT,
   Date_Debut DATE NOT NULL,
   Date_Fin DATE NOT NULL,
   ID_UFR INT NOT NULL,
   ID_Sport INT NOT NULL,
   CONSTRAINT PK_Campagne PRIMARY KEY(ID_Campagne),
   CONSTRAINT FK_Campagne_UFR FOREIGN KEY(ID_UFR) REFERENCES UFR(ID_UFR) ON DELETE CASCADE,
   CONSTRAINT Compagne_Sport FOREIGN KEY(ID_Sport) REFERENCES Sport(ID_Sport) ON DELETE CASCADE
);

CREATE TABLE Créneaux(
   ID_Créneau INT SERIAL DEFAULT VALUE,
   Jour VARCHAR(10),
   Heure_debut TIME NOT NULL,
   Heure_fin TIME NOT NULL,
   ID_Sport INT NOT NULL,
   Enseignant int,
   CONSTRAINT FK_Créneaux_Utilisateur FOREIGN KEY (Enseignant) REFERENCES Utilisateur(ID_User) ON DELETE SET NULL,
   CONSTRAINT PK_Créneaux PRIMARY KEY(ID_Créneau),
   CONSTRAINT FK_Créneaux_Sport FOREIGN KEY(ID_Sport) REFERENCES Sport(ID_Sport)
);

CREATE TABLE Messages(
   ID_Msg INT SERIAL DEFAULT VALUE,
   ID_Envoyeur INT NOT NULL,
   Object VARCHAR(50),
   Contenu VARCHAR(2000),
   Date_Envoie TIMESTAMP default now(),
   CONSTRAINT PK_Messages PRIMARY KEY(ID_Msg)
);

CREATE TABLE Seance(
   ID_Seance INT SERIAL DEFAULT VALUE,
   Date_séance DATE NOT NULL,
   ID_Créneau INT NOT NULL,
   CONSTRAINT PK_Seance PRIMARY KEY(ID_Seance),
   CONSTRAINT FK_Seance_Créneaux FOREIGN KEY(ID_Créneau) REFERENCES Créneaux(ID_Créneau) ON DELETE CASCADE
);

CREATE TABLE Absence(
   ID_Absence INT SERIAL DEFAULT VALUE,
   ID_User int,
   Justification VARCHAR(50),
   Justificatif VARCHAR(100),
   Validation bool default false,
   ID_Seance INT NOT NULL,
   CONSTRAINT PK_Absence PRIMARY KEY(ID_Absence),
   CONSTRAINT FK_Absence_Seance FOREIGN KEY(ID_Seance) REFERENCES Seance(ID_Seance),
   CONSTRAINT FK_Absence_Utilisateur FOREIGN KEY(ID_User) REFERENCES Utilisateur(ID_User) ON DELETE CASCADE
);

CREATE TABLE Note(
   ID_Note INT SERIAL DEFAULT VALUE,
   Note DECIMAL(4,2),
   ID_User INT NOT NULL,
   ID_Seance INT NOT NULL,
   Commentaire Varchar(200),
   CONSTRAINT PK_Note PRIMARY KEY(ID_Note),
   CONSTRAINT FK_Note_Utilisateur FOREIGN KEY(ID_User) REFERENCES Utilisateur(ID_User) ON DELETE CASCADE,
   CONSTRAINT FK_Note_Seance FOREIGN KEY(ID_Seance) REFERENCES Seance(ID_Seance)
);

CREATE TABLE Désinscription(
   ID_Desinscription INT SERIAL DEFAULT VALUE,
   Justificatif VARCHAR(100),
   Validé bool default false,
   ID_Seance INT NOT NULL,
   ID_User INT NOT NULL,
   CONSTRAINT PK_Désinscription PRIMARY KEY(ID_Desinscription),
   CONSTRAINT FK_Désinscription_Seance FOREIGN KEY(ID_Seance) REFERENCES Seance(ID_Seance) ON DELETE CASCADE,
   CONSTRAINT FK_Désinscription_Utilisateur FOREIGN KEY(ID_User) REFERENCES Utilisateur(ID_User) ON DELETE CASCADE
);

CREATE TABLE Inscrire(
   ID_User INT,
   ID_Créneau INT,
   CONSTRAINT PK_Inscrire PRIMARY KEY(ID_User, ID_Créneau),
   CONSTRAINT FK_Inscrire_Utilisateur FOREIGN KEY(ID_User) REFERENCES Utilisateur(ID_User) ON DELETE CASCADE,
   CONSTRAINT FK_Inscrire_Créneaux FOREIGN KEY(ID_Créneau) REFERENCES Créneaux(ID_Créneau) ON DELETE CASCADE
);

CREATE TABLE Echanger(
   ID_User INT,
   ID_Msg INT,
   CONSTRAINT PK_Echanger PRIMARY KEY(ID_User, ID_Msg),
   CONSTRAINT FK_Echanger_Utilisateur FOREIGN KEY(ID_User) REFERENCES Utilisateur(ID_User) ON DELETE CASCADE,
   CONSTRAINT FK_Echanger_Messages FOREIGN KEY(ID_Msg) REFERENCES Messages(ID_Msg) ON DELETE CASCADE
);

CREATE TABLE Envoyer(
   ID_Msg INT,
   ID_Sport INT,
   CONSTRAINT PK_Envoyer PRIMARY KEY(ID_Msg, ID_Sport),
   CONSTRAINT FK_Envoyer_Messages FOREIGN KEY(ID_Msg) REFERENCES Messages(ID_Msg) ON DELETE CASCADE,
   CONSTRAINT FK_Envoyer_Sport FOREIGN KEY(ID_Sport) REFERENCES Sport(ID_Sport) ON DELETE CASCADE
);

CREATE TABLE Recevoir(
   ID_Créneau INT,
   ID_Msg INT,
   CONSTRAINT PK_Recevoir PRIMARY KEY(ID_Créneau, ID_Msg),
   CONSTRAINT FK_Recevoir_Créneau FOREIGN KEY(ID_Créneau) REFERENCES Créneaux(ID_Créneau) ON DELETE CASCADE,
   CONSTRAINT FK_Recevoir_Messages FOREIGN KEY(ID_Msg) REFERENCES Messages(ID_Msg) ON DELETE CASCADE
);


