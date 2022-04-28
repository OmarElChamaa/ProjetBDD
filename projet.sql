SET SERVEROUTPUT ON
DROP TABLE users CASCADE CONSTRAINTS;
DROP TABLE recette CASCADE CONSTRAINTS;
DROP TABLE ingredients CASCADE CONSTRAINTS;
DROP TABLE liste_dispo CASCADE CONSTRAINTS;
DROP TABLE liste_acheter CASCADE CONSTRAINTS;
DROP TABLE planning CASCADE CONSTRAINTS;
DROP TABLE recette_etape CASCADE CONSTRAINTS;
DROP TABLE recette_ingr CASCADE CONSTRAINTS;
DROP TABLE archivePlanning CASCADE CONSTRAINTS;
DROP TABLE archiveListeIngr CASCADE CONSTRAINTS;

--DROP FUNCTION modif_ingredients;
--DROP FUNCTION healthy;

CREATE TABLE users(
   id_user NUMBER GENERATED ALWAYS AS IDENTITY,
   login VARCHAR(50) NOT NULL,
   email VARCHAR(128) NOT NULL,
   password VARCHAR(50) NOT NULL,
   CONSTRAINT PK_user PRIMARY KEY(id_user),
   CONSTRAINT U_login_email UNIQUE(login, email),
   CONSTRAINT CK_email_format CHECK(email LIKE '%___@___%.__%')
);

CREATE TABLE recette(
   id_recette NUMBER GENERATED ALWAYS AS IDENTITY,
   id_user INT,
   nom_recette VARCHAR(50) NOT NULL,
   descriptif_recette CLOB,
   diffic_recette VARCHAR(50),
   prix_recette INT,
   media VARCHAR2(128),
   nb_persons INT,
   calories_recette INT,
   lipides_recette FLOAT,
   glucides_recette FLOAT,
   protides_recette FLOAT,
   conforme_regime VARCHAR(50),
   temps FLOAT NOT NULL CHECK(temps > 0),
   CONSTRAINT PK_recette PRIMARY KEY(id_recette),
   CONSTRAINT FK_recette_user FOREIGN KEY(id_user) REFERENCES users(id_user),
   CONSTRAINT CK_recette_difficulte CHECK (diffic_recette IN ('Tr�s Facile','Facile','Standard','Difficile')),
   CONSTRAINT CK_recette_prix 	CHECK (prix_recette IN (1, 2, 3, 4, 5))
);

CREATE TABLE ingredients(
   id_ingr NUMBER GENERATED ALWAYS AS IDENTITY,
   categorie_ingr VARCHAR(50),
   nom_ingr VARCHAR(100) NOT NULL,
   calories_ingr INT,
   lipides_ingr INT,
   glucides_ingr INT,
   protides_ingr INT,
   type_regime VARCHAR(50),
   CONSTRAINT PK_ingr PRIMARY KEY(id_ingr)
);

CREATE TABLE liste_dispo(
   id_listedispo NUMBER GENERATED ALWAYS AS IDENTITY,
   id_ingr INT,
   id_user INT NOT NULL,
   CONSTRAINT PK_liste_dispo PRIMARY KEY(id_listedispo),  
   CONSTRAINT FK_listdispoeach_user FOREIGN KEY(id_user) REFERENCES users(id_user),
   CONSTRAINT FK_listedispo_ingr FOREIGN KEY(id_ingr) REFERENCES ingredients(id_ingr)
);

CREATE TABLE liste_acheter(
   id_listeacheter INT,
   id_ingr INT,
   date_creation_liste_achat DATE DEFAULT SYSDATE NOT NULL,
   date_achat DATE NOT NULL,
   id_user INT NOT NULL,
   CONSTRAINT FK_listeach_user FOREIGN KEY(id_user) REFERENCES users(id_user),
   CONSTRAINT FK_listeach_ingr FOREIGN KEY(id_ingr) REFERENCES ingredients(id_ingr),
   CONSTRAINT CK_liste_achat_date 	CHECK ( date_creation_liste_achat < date_achat )
);

CREATE TABLE planning(
   id_planning INT,
   nom_planning VARCHAR(50),
   date_creation_planning DATE DEFAULT SYSDATE NOT NULL,
   date_planning DATE NOT NULL,
   id_recette INT,
   id_user INT NOT NULL,
   --CONSTRAINT PK_planning PRIMARY KEY(id_planning),
   CONSTRAINT FK_planning_user FOREIGN KEY(id_user) REFERENCES users(id_user),
   CONSTRAINT FK_planning_recette FOREIGN KEY(id_recette) REFERENCES recette(id_recette),
   CONSTRAINT CK_planning_date 	CHECK ( date_creation_planning < date_planning )
);

CREATE TABLE recette_etape(
   id_recette INT,
   ordre_etape INT NOT NULL,
   description_etape CLOB NOT NULL,
   temps_etape FLOAT NOT NULL CHECK(temps_etape >= 0)
);


CREATE TABLE recette_ingr(
   id_recette INT,
   id_ingr INT,
   qte_ingr FLOAT NOT NULL,
   truc VARCHAR(50) NOT NULL,  
   calories INT,
   CONSTRAINT FK_recette_ingr_recette FOREIGN KEY(id_recette) REFERENCES recette(id_recette),
   CONSTRAINT FK_recette_ingr_ingr FOREIGN KEY(id_ingr) REFERENCES ingredients(id_ingr)
);

CREATE TABLE archivePlanning(
   id_Archiveplanning INT,
   nom_planning VARCHAR(50),
   date_creation_planning DATE DEFAULT SYSDATE NOT NULL,
   date_planning DATE NOT NULL,
   id_recette INT,
   id_user INT NOT NULL,
   CONSTRAINT PK_Archiveplanning PRIMARY KEY(id_Archiveplanning),
   CONSTRAINT FK_Archiveplanning_user FOREIGN KEY(id_user) REFERENCES users(id_user),
   CONSTRAINT FK_Archiveplanning_recette FOREIGN KEY(id_recette) REFERENCES recette(id_recette)
);

CREATE TABLE archiveListeIngr(
   id_listeArchive INT,
   id_ingr INT,
   date_creation_liste_achat DATE DEFAULT SYSDATE NOT NULL,
   date_achat DATE NOT NULL,
   id_user INT NOT NULL,
   CONSTRAINT PK_Archiveliste_acheter PRIMARY KEY(id_listeArchive),
   CONSTRAINT FK_Archivelisteach_user FOREIGN KEY(id_user) REFERENCES users(id_user),
   CONSTRAINT FK_Archivelisteach_ingr FOREIGN KEY(id_ingr) REFERENCES ingredients(id_ingr)
);

INSERT INTO users
(login, email, password)
VALUES
('aargyrou', 'alexandros.argyrou@etu.unistra.fr', 'alex123');

INSERT INTO users
(login, email, password)
VALUES
('John', 'john@doe.fr', 'johndoe');

--INSERT INTO users
--(login, email, password)
--VALUES
--('Jane', 'jane@doer', 'janejanejane'); --email constraint violated

INSERT INTO recette
(id_user, nom_recette, descriptif_recette, diffic_recette, prix_recette, media, nb_persons, calories_recette, lipides_recette, glucides_recette, protides_recette, conforme_regime, temps)
VALUES
(1, 'Toasted Bread', 'Slice of bread toasted in toaster', 'Tr�s Facile', '1', 'https://www.youtube.com/watch?v=PvB0kWs2IPQ', '1', 64, 0.9, 12, 3.1, 'sans gluten', 50);

INSERT INTO recette
(id_user, nom_recette, descriptif_recette, diffic_recette, prix_recette, media, nb_persons, calories_recette, lipides_recette, glucides_recette, protides_recette, conforme_regime, temps)
VALUES
(1, 'Eggs Florentine Pizza', 'Follow our easy recipe to make your own pizza dough, top with spinach and mozzarella and finish with an egg cracked in the centre', 'Standard', '2', 'https://www.bbcgoodfood.com/recipes/eggs-florentine-pizza', '4', 728, 22, 94, 35, 'Vegetarian', 15);

INSERT INTO ingredients
(categorie_ingr, nom_ingr, calories_ingr, lipides_ingr, glucides_ingr, protides_ingr, type_regime)
VALUES
('Pain', 'Pain Complet', 247, 3.4, 41, 13, 'Standard');

INSERT INTO ingredients
(categorie_ingr, nom_ingr, calories_ingr, lipides_ingr, glucides_ingr, protides_ingr, type_regime)
VALUES
('Lait', 'Lait Soja', 54, 1.8, 6, 3.3, 'lactose intolerant');

INSERT INTO ingredients
(categorie_ingr, nom_ingr, calories_ingr, lipides_ingr, glucides_ingr, protides_ingr, type_regime)
VALUES
('Fruit', 'Framboise', 44, 5, 10, 3.3, 'Standard');

INSERT INTO ingredients
(categorie_ingr, nom_ingr, calories_ingr, lipides_ingr, glucides_ingr, protides_ingr, type_regime)
VALUES
('Baie', 'Myrtille', 44, 1.9, 8, 3.3, 'Standard');

INSERT INTO planning
(id_planning, nom_planning, date_planning, id_recette, id_user)
VALUES
(1, 'Anniversaire', TO_DATE('25072022','DDMMYYYY'), 1, 1);

INSERT INTO planning
(id_planning, nom_planning, date_planning, id_recette, id_user)
VALUES
(1, 'Anniversaire', TO_DATE('25072022','DDMMYYYY'), 2, 1);

INSERT INTO planning
(id_planning, nom_planning, date_planning, id_recette, id_user)
VALUES
(2, 'Diner', TO_DATE('25032022','DDMMYYYY'), 2, 1);

INSERT INTO recette_etape
(id_recette, ordre_etape, description_etape, temps_etape)
VALUES
(1, 1, 'Place bread in toaster and take out when ready', 20.0);

INSERT INTO recette_etape
(id_recette, ordre_etape, description_etape, temps_etape)
VALUES
(1, 2, 'Enjoy the bread :)', 30);

INSERT INTO recette_etape
(id_recette, ordre_etape, description_etape, temps_etape)
VALUES
(2, 1, 'Cook', 5);

INSERT INTO recette_etape
(id_recette, ordre_etape, description_etape, temps_etape)
VALUES
(2, 2, 'Yum', 10);

INSERT INTO recette_ingr
(id_recette, id_ingr, qte_ingr, truc, calories)
VALUES
(1, 1, 1, 'tranche', 200);

INSERT INTO recette_ingr
(id_recette, id_ingr, qte_ingr, truc, calories)
VALUES
(2, 1, 1, 'tranche', 200);

INSERT INTO recette_ingr
(id_recette, id_ingr, qte_ingr, truc, calories)
VALUES
(2, 2, 200, 'ml', 150);

INSERT INTO liste_dispo
(id_ingr, id_user)
VALUES
(1, 1);

INSERT INTO liste_acheter
(id_listeacheter, id_ingr, date_achat, id_user)
VALUES
(1, 3, TO_DATE('15012022','DDMMYYYY'), 1);




--PARTIE 2
--REQUETES SQL

SELECT recette.id_recette, recette.nom_recette from recette, planning where (recette.calories_recette/recette.nb_persons)<200 and instr(recette.conforme_regime, 'sans gluten')!=0 and recette.id_recette = planning.id_recette; 

select cnt1.id_recette from
    (select COUNT(*) as total, id_recette from planning group by id_recette) cnt1,
     (select MAX(total) as maxtotal
      from (select COUNT(*) as total, id_recette from planning group by id_recette)) cnt2
where cnt1.total = cnt2.maxtotal;

select ingredients.id_ingr, count(distinct recette_ingr.id_recette) "nombre de recettes", count(distinct ingredients.categorie_ingr) "nombre de cat�gories" from recette_ingr, ingredients where recette_ingr.id_ingr = ingredients.id_ingr group by ingredients.id_ingr order by ingredients.id_ingr;

select users.id_user, users.login from users, recette WHERE users.id_user=recette.id_user and instr(recette.conforme_regime, 'vegetarien')!=0;


select users.id_user, users.login, users.email,
count(distinct recette.id_recette)"Nombre recettes ecrites",
count(distinct liste_dispo.id_ingr)"Nombre ingredients", 
count(distinct planning.id_recette )"Nombre Recettes prevues"
from users, recette, liste_dispo, planning
where users.id_user =  recette.id_user or users.id_user = liste_dispo.id_user
or users.id_user = planning.id_user
group by users.id_user, users.login, users.email order by users.id_user;

--Proc�dures, fonctions

CREATE OR REPLACE PROCEDURE modif_ingredients(
    nom1   VARCHAR2,
    nom2   VARCHAR2,
    id_rec INT
)
IS
BEGIN
    update recette_etape set description_etape = REPLACE(description_etape, nom1, nom2) where id_recette = id_rec;
END;
/
execute modif_ingredients('bread', 'bun', 1);

CREATE OR REPLACE TYPE rec_ingr IS OBJECT
(
    id_ingr INT,
    quantite_ing INT
);
/

CREATE OR REPLACE FUNCTION modif_quantite(id_rec INT, nb_pers INT) RETURN rec_ingr
IS
    res rec_ingr;
    ratio_pers int;
BEGIN
    select (recette.nb_persons/nb_pers) into ratio_pers from recette where id_recette = id_rec;
    if (ratio_pers >= 1) THEN
        select rec_ingr(id_ingr, (qte_ingr/ratio_pers)) into res from recette_ingr where id_recette = id_rec;
    ELSE
        select rec_ingr(id_ingr, (qte_ingr*ratio_pers)) into res from recette_ingr where id_recette = id_rec;
    END IF;
    RETURN res;
END;
/


CREATE OR REPLACE PROCEDURE copie_rec_modif(
    id_ingr_old   INT, 
    id_ingr_new INT,
    nb_pers INT,
    id_rec INT
)
IS
CURSOR c_ingr(id_ingre INT) IS
select nom_ingr from ingredients where id_ingr = id_ingre;

nom1 varchar2(50);
nom2 varchar2(50);
BEGIN
OPEN c_ingr(id_ingr_old);
FETCH c_ingr into nom1;
CLOSE c_ingr;

OPEN c_ingr(id_ingr_new);
FETCH c_ingr into nom2;
CLOSE c_ingr;

insert into recette(ID_USER, NOM_RECETTE, DESCRIPTIF_RECETTE, DIFFIC_RECETTE, 
PRIX_RECETTE, MEDIA, NB_PERSONS, CALORIES_RECETTE, LIPIDES_RECETTE, GLUCIDES_RECETTE,
PROTIDES_RECETTE, CONFORME_REGIME, TEMPS)
SELECT ID_USER, NOM_RECETTE, DESCRIPTIF_RECETTE, DIFFIC_RECETTE, PRIX_RECETTE, 
MEDIA, nb_pers, CALORIES_RECETTE, LIPIDES_RECETTE, GLUCIDES_RECETTE, PROTIDES_RECETTE,
CONFORME_REGIME, TEMPS  FROM recette WHERE recette.id_recette = id_rec;
modif_ingredients(nom1, nom2, id_rec);

END;
/

CREATE OR REPLACE FUNCTION compatible(regime VARCHAR, id_rec INT)
RETURN INT
IS
    CURSOR c_ingr(id_rec INT) IS
    select id_ingr from recette_ingr where id_rec = recette_ingr.id_recette;
    
    id_ingr INT;
    
    total INT;
begin
    OPEN c_ingr(id_rec); 
    LOOP
        FETCH c_ingr into id_ingr;
        EXIT WHEN c_ingr%notfound;
        SELECT instr(ingredients.type_regime, regime) into total from ingredients where ingredients.id_ingr = id_ingr; 
    END LOOP;
    CLOSE c_ingr;
    IF (total>0) THEN
        return 1;
    END IF;
    Return 0;
end;
/


CREATE OR REPLACE FUNCTION generate_liste(user_id INT, planning_id INT, listedispo_id INT, date_est DATE)
RETURN INT 
IS
    CURSOR c_recettes(user_id INT, planning_id INT) IS
    select id_recette from planning where planning.id_planning = planning_id and planning.id_user = user_id;    
    id_rec INT;
    
    CURSOR c_ingr(id_rec INT) IS
    select id_ingr from recette_ingr where id_recette = id_rec;
    id_ingre INT;
    
    count_t INT;
    nouv_id INT;
begin
    SELECT id_listeacheter into nouv_id FROM liste_acheter ORDER BY id_listeacheter DESC FETCH FIRST ROW ONLY;
    nouv_id := nouv_id +1;
    OPEN c_recettes(user_id, planning_id);
    LOOP
        FETCH c_recettes into id_rec;
        OPEN c_ingr(id_rec);
        FETCH c_ingr into id_ingre;
        select count(*) into count_t from liste_dispo where liste_dispo.id_ingr = id_ingre;
        IF count_t = 0 THEN
            INSERT INTO liste_acheter
            (id_listeacheter, id_ingr, date_achat, id_user)
            VALUES
            (nouv_id, id_ingre, TO_DATE(date_est,'DDMMYYYY'), user_id);
        END IF;
        EXIT WHEN c_ingr%notfound;
        EXIT WHEN c_recettes%notfound;
               
    END LOOP;
    CLOSE c_ingr;
    CLOSE c_recettes;
    RETURN nouv_id;
end;
/


--Contraintes

CREATE OR REPLACE TRIGGER max_ingredients
BEFORE INSERT OR UPDATE 
ON  recette_ingr
FOR EACH ROW
DECLARE
	nb_ingr INT;
BEGIN
	Select count(id_recette) into nb_ingr from recette_ingr where id_recette = :new.id_recette; 
 
	IF nb_ingr >= 20
	THEN
		RAISE_APPLICATION_ERROR(-20105,'Nombre max (20) des ingredients atteint') ;
	END IF ;
END;
/


CREATE OR REPLACE TRIGGER achete_ing 
BEFORE INSERT OR UPDATE 
ON liste_acheter
FOR EACH ROW
BEGIN
   IF (trunc(:new.date_achat,'MM') >= trunc(add_months(sysdate, 1) ,'MM') )  
      THEN
         RAISE_APPLICATION_ERROR(-20105,'Il est trop tot pour generer la liste dachat') ;
   END IF ;
END;
/


CREATE or REPLACE TRIGGER itstTmeToStop
before INSERT or update 
on recette
FOR EACH ROW
DECLARE 
   Temps_total FLOAT ; 
begin 
   Select temps_etape into Temps_total from recette_etape 
   WHERE :new.id_recette = recette_etape.id_recette ;
   
   if Temps_total > :new.temps
      THEN 
         RAISE_APPLICATION_ERROR(-20105,'Temps cumules etapes > que temps recette') ;
   END IF  ; 
END ;
/


create or replace TRIGGER caloriCount 
BEFORE Insert or update 
on recette
FOR EACH ROW
DECLARE 
   TotalCal INT ;
BEGIN
   Select sum(calories) into TotalCal 
   from recette_ingr where recette_ingr.id_recette = :new.id_recette; --not sure here  if :new.id or rectte.id

   if TotalCal not between :new.calories_recette * 0.8 and :new.calories_recette * 1.2
      then
         RAISE_APPLICATION_ERROR(-20105,'Calories cumules etapes > que temps recette') ;
   end if ;
end ; 
/

Create or replace trigger toArchivePlanning
BEFORE delete on planning
FOR EACH ROW
BEGIN
    INSERT INTO archivePlanning(id_Archiveplanning,
   nom_planning,
   date_creation_planning,
   date_planning,
   id_recette,
   id_user)
   VALUES
   ( :old.id_planning,
     :old.nom_planning,
     :old.date_creation_planning,
     :old.date_planning,
     :old.id_recette,
     :old.id_user );
end ;
/

Create or replace trigger toArchiveListe
BEFORE delete on liste_acheter
FOR EACH ROW
BEGIN
    INSERT INTO archiveListeIngr(
    id_listeArchive,
    id_ingr,
    date_creation_liste_achat,
    date_achat,
    id_user)
   VALUES
   ( :old.id_listeacheter,
     :old.id_ingr,
     :old.date_creation_liste_achat,
     :old.date_achat,
     :old.id_user 
    );
end ;
/

create or replace procedure arch_pl is
begin
  insert into archivePlanning
    select * from planning
    where  date_planning > sysdate;
    
  delete planning
  where  date_planning > sysdate;
end arch_pl;
/


--BEGIN
  --  DBMS_SCHEDULER.CREATE_JOB (
    --        job_name => 'ARCH_JOB',
      --      job_type => 'STORED_PROCEDURE',
        --    job_action => 'ARCH_PL',
          --  number_of_arguments => 0,
          --  start_date => NULL,
            --repeat_interval => 'FREQ=WEEKLY',
            --end_date => NULL,
            --enabled => FALSE,
            --auto_drop => FALSE,
            --comments => '');
    
    --DBMS_SCHEDULER.enable(
            -- name => 'ARCH_JOB');
--END;
--/

--INDEX

--liste d'ingr�dients pour chaque recette
CREATE INDEX ingr_rec_idx ON recette_ingr(id_recette);

/*Commentaires
Nous avons modifi� comment on stocke le temps d'une recette, de string 
� FLOAT, et en rajoutant le champs temps � chaque �tape, pour pouvoir le comparer
aux temps individuels de chaque �tape de la recette.

Pour pouvoir mieux gerer les quantit�s d'ingredient qui peuvent changer en fonction 
de la recette, on a aussi chang� comment les stocker en impl�mentant un champ "quantit�" 
et un champ "suffixe" pour pouvoir diff�rencier entre les diff�rentes mesures 
(grammes, cuill�res, etc..).

Nous avons d�cid� de modifier notre fa�on d'archiver les plannings et les liste 
d'achats en cr�ant  deux nouvelles tables, archiveListeIngr et archivePlanning, 
qui sont quasi-identiques � celle d'origine. On stocke alors un duplicata de 
la table d'origine, avant de la supprimer.
Pour v�rifier si les dates associ�es avec chaque planning et/ou liste des courses
sont depass�s, on a essay� d'implementer une proc�dure par le Scheduler. Cela 
nous permet de planifier des contr�les quotidiens, vu que les deux triggers ne 
sont pas declench�s sans action sur leurs tables.

*/
