-- @d:\kom1.sql
--st12k_GORODILOV_ROMAN
--ora43fw6GO5ZW
--db1

SET SERVEROUTPUT ON;

drop table GLOWNE_BOHATEROWIE;
drop table ZESTAW_TWORCZY;
drop table KOMIKS;
drop table BOHATER;
drop table SERIA;
drop table WYDANIE;
drop table TWORCA;
drop table WLASCICIEL;
drop table REDAKCJA;
drop table PRACOWNIK;
drop table AUTOR;
drop table POWSZECHNA_INFORMACJA;
drop table DANE_OSOBOWE;
drop table ZM_W_TABELACH;






----------------------------------------;
-- CREATE TABLE ZM_W_TABELACH;
----------------------------------------;

CREATE TABLE ZM_W_TABELACH (
username    		varchar2(40),
nazwa_tabeli	 	varchar2(40),
log_date 		    DATE,
action 			    varchar2(50)
);

----------------------------------------;
-- Zmiana nazw kolumn;
----------------------------------------;

COLUMN username               HEADING 'Nazwa uzytkownika'   FORMAT A25;
COLUMN nazwa_tabeli           HEADING 'Nazwa'               FORMAT A15;
COLUMN log_date               HEADING 'Data zalogowania'    FORMAT A15;
COLUMN action                 HEADING 'Akcja'               FORMAT A10;





----------------------------------------;
-- CREATE TABLE DANE_OSOBOWE;
----------------------------------------;

create table DANE_OSOBOWE(
DANk_1_ID 				       	number(4) NOT NULL,
DAN_Imie 				        varchar2(30) NOT NULL,
DAN_Nazwisko 		    	  	varchar2(60) NOT NULL,
DAN_Plec	 			        varchar2(10) NOT NULL,
DAN_data_urodzenia 		  		DATE,
DAN_miejsce_urodzenia 			varchar(70),
DAN_narodowosc 			    	varchar(30),
DAN_uwagi 				      	varchar(60)
)TABLESPACE STUDENT_DATA;

----------------------------------------;
-- Primary Key;
----------------------------------------;

alter table DANE_OSOBOWE
add constraint PK_DANE_OSOBOWE
primary key (DANk_1_ID);

----------------------------------------;
-- Sequence;
----------------------------------------;

drop sequence SEQ_DANE_OSOBOWE;
create sequence SEQ_DANE_OSOBOWE increment by 1 start with 1
maxvalue 9999999999 minvalue 1;

----------------------------------------;
-- Trigger for primary key;
----------------------------------------; 

create or replace trigger T_BI_DANE_OSOBOWE
before insert on DANE_OSOBOWE
for each row
begin
 if :new.DANk_1_ID is NULL then
 SELECT SEQ_DANE_OSOBOWE.nextval INTO :new.DANk_1_ID FROM dual;
 end if;
end;
/

----------------------------------------;
-- Trigger for insert, update and delete;
----------------------------------------; 

CREATE OR REPLACE TRIGGER T_DANE_OSOBOWE_I_U_D
  AFTER INSERT OR UPDATE OR DELETE
  ON DANE_OSOBOWE
DECLARE
  log_action  ZM_W_TABELACH.action%TYPE;
BEGIN
  IF INSERTING THEN
    log_action := 'Insert';
  ELSIF UPDATING THEN
    log_action := 'Update';
  ELSIF DELETING THEN
    log_action := 'Delete';
  ELSE
    DBMS_OUTPUT.PUT_LINE('This code is not reachable.');
  END IF;

  INSERT INTO ZM_W_TABELACH (username, nazwa_tabeli, log_date, action)
    VALUES (USER, 'DANE_OSOBOWE', SYSDATE, log_action);
END;
/

----------------------------------------;
-- Trigger for insert, update and delete;
----------------------------------------; 

DROP TABLE dan_st_wart;
CREATE TABLE dan_st_wart(
dan_id				NUMBER(4),
st_imie				VARCHAR2(30),
st_nazwisko			VARCHAR2(50),
username			VARCHAR2(60)
)TABLESPACE STUDENT_DATA;

COLUMN st_imie           HEADING 'Poprzednie imie'               FORMAT A25;
COLUMN st_nazwisko       HEADING 'Poprzednie nazwisko'           FORMAT A25;


CREATE OR REPLACE TRIGGER t_d_o_insert
AFTER INSERT
   ON DANE_OSOBOWE
   FOR EACH ROW
DECLARE
   v_username varchar2(60);
BEGIN
   SELECT user INTO v_username
   FROM dual;
   INSERT INTO dan_st_wart
   ( dan_id,
     st_imie,
     st_nazwisko,
	 username )
   VALUES
   ( :new.DANk_1_ID,
     :new.DAN_Imie,
     :new.DAN_Nazwisko,
     v_username );

END;
/

CREATE OR REPLACE TRIGGER t_d_o_update
AFTER UPDATE
   ON DANE_OSOBOWE
   FOR EACH ROW
DECLARE
   v_username varchar2(60);
BEGIN
   SELECT user INTO v_username
   FROM dual;
   INSERT INTO dan_st_wart
   ( dan_id,
     st_imie,
     st_nazwisko,
	 username )
   VALUES
   ( :new.DANk_1_ID,
     :old.DAN_Imie,
     :old.DAN_Nazwisko,
     v_username );
END;
/

select * from dan_st_wart;

/*
ID danych osobowych Poprzednie imie           Poprzednie nazwisko
------------------- ------------------------- -------------------------
Nazwa uzytkownika
-------------------------
                 13 Nowe imie NR1             Nowe nazwisko NR1
ST12K_GORODILOV_ROMAN

                 14 Nowe imie NR2             Nowe nazwisko NR2
ST12K_GORODILOV_ROMAN

                 15 Nowe imie NR3             Nowe nazwisko NR3
ST12K_GORODILOV_ROMAN


ID danych osobowych Poprzednie imie           Poprzednie nazwisko
------------------- ------------------------- -------------------------
Nazwa uzytkownika
-------------------------
                 16 Nowe imie NR4             Nowe nazwisko NR4
ST12K_GORODILOV_ROMAN

                 17 Nowe imie NR5             Nowe nazwisko NR5
ST12K_GORODILOV_ROMAN
*/

----------------------------------------------;
-- Tworzenie indeksow do tabeli DANE_OSOBOWE;
----------------------------------------------;

CREATE INDEX IX_DANE_OSOBOWE
ON DANE_OSOBOWE (DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec, DAN_data_urodzenia, DAN_miejsce_urodzenia, DAN_narodowosc)
STORAGE (INITIAL 10k NEXT 10k)
--COMPRESS 1
TABLESPACE STUDENT_INDEX;

CREATE INDEX IX_LC_DANE_OSOBOWE
ON DANE_OSOBOWE (LOWER(DAN_Imie), LOWER(DAN_Nazwisko), LOWER(DAN_Plec))
STORAGE (INITIAL 10k NEXT 10k)
TABLESPACE STUDENT_INDEX;

CREATE INDEX IX_UC_DANE_OSOBOWE
ON DANE_OSOBOWE (UPPER(DAN_Imie), UPPER(DAN_Nazwisko))
STORAGE (INITIAL 10k NEXT 10k)
TABLESPACE STUDENT_INDEX;

----------------------------------------------;
-- Insert do tablicy DANE_OSOBOWE;
----------------------------------------------; 

-- WLASCICELE SERII

INSERT INTO DANE_OSOBOWE (DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec, DAN_data_urodzenia, DAN_miejsce_urodzenia, DAN_narodowosc)
VALUES (1, 'Isaac', 'Perlmutter', 'M', to_date('1942-12-01', 'YYYY-MM-DD'), 'British Mandate of Palestine', 'Israeli-American');
INSERT INTO DANE_OSOBOWE (DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec)
VALUES (2, 'Diane', 'Nelson', 'K');

--TWORCY, AUTORZE I PRACOWNIKI

INSERT INTO DANE_OSOBOWE (DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec, DAN_data_urodzenia, DAN_miejsce_urodzenia, DAN_narodowosc)
VALUES (3, 'Stan', 'Lee', 'M', to_date('1922-12-28', 'YYYY-MM-DD'), 'Los Angeles, California, U.S.', 'American');
INSERT INTO DANE_OSOBOWE (DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec, DAN_data_urodzenia, DAN_miejsce_urodzenia)
VALUES (4, 'Steve', 'Ditko', 'M', to_date('1927-11-2', 'YYYY-MM-DD'), 'Johnstown, Pennsylvania, U.S.');
INSERT INTO DANE_OSOBOWE (DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec, DAN_data_urodzenia, DAN_miejsce_urodzenia, DAN_narodowosc)
VALUES (5, 'Leonard', 'Wein', 'M', to_date('1948-06-12', 'yyyy-mm-dd'), 'New York, U.S.', 'American');
INSERT INTO DANE_OSOBOWE (DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec, DAN_data_urodzenia, DAN_miejsce_urodzenia, DAN_narodowosc)
VALUES (6, 'John', 'Romita', 'M', to_date('1930-01-24', 'yyyy-mm-dd'), 'Brooklyn, New York, U.S.', 'American');
INSERT INTO DANE_OSOBOWE (DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec, DAN_data_urodzenia, DAN_miejsce_urodzenia, DAN_narodowosc)
VALUES (7, 'Herbert', 'Trimpe', 'M', to_date('1939-05-26', 'yyyy-mm-dd'), 'Peekskill, New York, U.S.', 'American');
INSERT INTO DANE_OSOBOWE (DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec, DAN_data_urodzenia, DAN_miejsce_urodzenia, DAN_narodowosc)
VALUES (8, 'Jack', 'Kirby', 'M', to_date('1917-08-28', 'yyyy-mm-dd'), 'New York, U.S.', 'American');

-- BOHATEROWIE

INSERT INTO DANE_OSOBOWE (DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec)
VALUES (9, 'Peter', 'Parker', 'M');
INSERT INTO DANE_OSOBOWE (DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec, DAN_miejsce_urodzenia)
VALUES (10, 'James', 'Howlett', 'M', 'Alberta, Canada');
INSERT INTO DANE_OSOBOWE (DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec, DAN_miejsce_urodzenia)
VALUES (11, 'Victor', 'Creed', 'M', 'Alberta, Canada');
INSERT INTO DANE_OSOBOWE (DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec, DAN_miejsce_urodzenia)
VALUES (12, 'Bruce', 'Wayne', 'M', 'Gotham, U.S.');

----------------------------------------;
-- Zmiana nazw kolumn;
----------------------------------------;

COLUMN DANk_1_ID               HEADING 'ID danych osobowych'            FORMAT 99999;
COLUMN DAN_ID            	   HEADING 'ID danych osobowych'            FORMAT 99999;
COLUMN DAN_Imie                HEADING 'Imie'              				FORMAT A10;
COLUMN DAN_Nazwisko            HEADING 'Nazwisko'           			FORMAT A15;
COLUMN DAN_Plec                HEADING 'Plec'              				FORMAT A10;
COLUMN DAN_data_urodzenia      HEADING 'Data urodzenia'     			FORMAT A15;
COLUMN DAN_miejsce_urodzenia   HEADING 'Miejsce urodzenia'  			FORMAT A25;
COLUMN DAN_narodowosc          HEADING 'Narodowosc'         			FORMAT A15;
COLUMN DAN_uwagi               HEADING 'Uwagi'              			FORMAT A30;





----------------------------------------;
-- CREATE TABLE POWSZECHNA_INFORMACJA;
----------------------------------------;

create table POWSZECHNA_INFORMACJA(
POWk_1_ID 			           	number(4) NOT NULL,
POW_ilosc_stron		      		number(6) NOT NULL CONSTRAINT sprawdz_il_str CHECK (POW_ilosc_stron>0),
POW_cena_oryginalu	    		number(5) CONSTRAINT sprawdz_cen_or CHECK (POW_cena_oryginalu>=0.00),
POW_rodzaj_papieru	    		varchar2(30),
POW_material_okladki	    	varchar2(35),
POW_sposob_utworzenia   		varchar(40),
POW_dodatkowe_szczegoly	 	 	varchar(100)
)TABLESPACE STUDENT_DATA;

----------------------------------------;
-- Primary Key;
----------------------------------------;

alter table POWSZECHNA_INFORMACJA
add constraint PK_POWSZECHNA_INFORMACJA
primary key (POWk_1_ID);

----------------------------------------;
-- Sequence;
----------------------------------------;

drop sequence SEQ_POWSZECHNA_INFORMACJA;
create sequence SEQ_POWSZECHNA_INFORMACJA increment by 1 start with 1
maxvalue 9999999999 minvalue 1;

----------------------------------------;
-- Trigger for primary key;
----------------------------------------; 

create or replace trigger T_BI_POWSZECHNA_INFORMACJA
before insert on POWSZECHNA_INFORMACJA
for each row
begin
 if :new.POWk_1_ID is NULL then
 SELECT SEQ_POWSZECHNA_INFORMACJA.nextval INTO :new.POWk_1_ID FROM dual;
 end if;
end;
/

----------------------------------------;
-- Trigger for insert, update and delete;
----------------------------------------; 

CREATE OR REPLACE TRIGGER T_POWSZECHNA_INFORMACJA_I_U_D
  AFTER INSERT OR UPDATE OR DELETE
  ON POWSZECHNA_INFORMACJA
DECLARE
  log_action  ZM_W_TABELACH.action%TYPE;
BEGIN
  IF INSERTING THEN
    log_action := 'Insert';
  ELSIF UPDATING THEN
    log_action := 'Update';
  ELSIF DELETING THEN
    log_action := 'Delete';
  ELSE
    DBMS_OUTPUT.PUT_LINE('This code is not reachable.');
  END IF;

  INSERT INTO ZM_W_TABELACH (username, nazwa_tabeli, log_date, action)
    VALUES (USER, 'POWSZECHNA_INFORMACJA', SYSDATE, log_action);
END;
/

----------------------------------------;
-- Trigger for insert, update and delete;
----------------------------------------; 

DROP TABLE pow_st_wart;
CREATE TABLE pow_st_wart(
pow_id				NUMBER(4),
st_il_str			number(6),
st_cena				number(5),
username			VARCHAR2(60)
)TABLESPACE STUDENT_DATA;

COLUMN st_il_str       HEADING 'Poprzednia ilosc stron'            FORMAT 9999;
COLUMN st_cena	       HEADING 'Poprzednia cena'        		   FORMAT 9999;


CREATE OR REPLACE TRIGGER t_p_i_insert
AFTER INSERT
   ON POWSZECHNA_INFORMACJA
   FOR EACH ROW
DECLARE
   v_username varchar2(60);
BEGIN
   SELECT user INTO v_username
   FROM dual;
   INSERT INTO pow_st_wart
   ( pow_id,
     st_il_str,
     st_cena,
	 username )
   VALUES
   ( :new.POWk_1_ID,
     :new.POW_ilosc_stron,
     :new.POW_cena_oryginalu,
     v_username );
END;
/

CREATE OR REPLACE TRIGGER t_p_i_update
AFTER UPDATE
   ON POWSZECHNA_INFORMACJA
   FOR EACH ROW
DECLARE
   v_username varchar2(60);
BEGIN
   SELECT user INTO v_username
   FROM dual;
   INSERT INTO pow_st_wart
   ( pow_id,
     st_il_str,
     st_cena,
	 username )
   VALUES
   ( :new.POWk_1_ID,
     :old.POW_ilosc_stron,
     :old.POW_cena_oryginalu,
     v_username );
END;
/

--select * from pow_st_wart;

/*
ID informacji Poprzednia ilosc stron Poprzednia cena Nazwa uzytkownika
------------- ---------------------- --------------- -------------------------
            1                     24               0 ST12K_GORODILOV_ROMAN
*/

-----------------------------------------------------;
-- Tworzenie indeksow do tabeli POWSZECHNA_INFORMACJA;
-----------------------------------------------------;

CREATE INDEX IX_POWSZECHNA_INFORMACJA
ON POWSZECHNA_INFORMACJA (POWk_1_ID, POW_cena_oryginalu, POW_dodatkowe_szczegoly, POW_ilosc_stron, POW_material_okladki, POW_rodzaj_papieru, POW_sposob_utworzenia)
STORAGE (INITIAL 10k NEXT 10k)
TABLESPACE STUDENT_INDEX;

------------------------------------------;
-- Insert do tablicy POWSZECHNA_INFORMACJA;
------------------------------------------;

INSERT INTO POWSZECHNA_INFORMACJA (POWk_1_ID, POW_ilosc_stron, POW_cena_oryginalu, POW_dodatkowe_szczegoly)
VALUES (1, 24, 0.12, 'Na okladce jest nadpis: The magazine that respects your intelligence');

COLUMN POWk_1_ID		HEADING 'ID informacji'            FORMAT 99999;
COLUMN POW_ID			HEADING 'ID informacji'            FORMAT 99999;





----------------------------------------;
-- CREATE TABLE AUTOR;
----------------------------------------;

create table AUTOR(
AUTk_1_ID 						number(4) NOT NULL,
DAN_ID				  			number(4) NOT NULL
)TABLESPACE STUDENT_DATA;

----------------------------------------;
-- Primary Key;
----------------------------------------;

alter table AUTOR
add constraint PK_AUTOR
primary key (AUTk_1_ID);

----------------------------------------;
-- Foreign Key;
----------------------------------------;

alter table AUTOR add constraint FK_AUTOR
foreign key (DAN_ID)
references DANE_OSOBOWE (DANk_1_ID);

----------------------------------------;
-- Sequence;
----------------------------------------;

drop sequence SEQ_AUTOR;
create sequence SEQ_AUTOR increment by 1 start with 1
maxvalue 9999999999 minvalue 1;

----------------------------------------;
-- Trigger for primary key;
----------------------------------------;

create or replace trigger T_BI_AUTOR
before insert on AUTOR
for each row
begin
 if :new.AUTk_1_ID is NULL then
 SELECT SEQ_AUTOR.nextval INTO :new.AUTk_1_ID FROM dual;
 end if;
end;
/

----------------------------------------;
-- Trigger for insert, update and delete;
----------------------------------------;

CREATE OR REPLACE TRIGGER T_AUTOR_I_U_D
  AFTER INSERT OR UPDATE OR DELETE
  ON AUTOR
DECLARE
  log_action  ZM_W_TABELACH.action%TYPE;
BEGIN
  IF INSERTING THEN
    log_action := 'Insert';
  ELSIF UPDATING THEN
    log_action := 'Update';
  ELSIF DELETING THEN
    log_action := 'Delete';
  ELSE
    DBMS_OUTPUT.PUT_LINE('This code is not reachable.');
  END IF;

  INSERT INTO ZM_W_TABELACH (username, nazwa_tabeli, log_date, action)
    VALUES (USER, 'AUTOR', SYSDATE, log_action);
END;
/

----------------------------------------;
-- Insert do tablicy AUTOR;
----------------------------------------;

INSERT INTO AUTOR (AUTk_1_ID, DAN_ID)
VALUES (1, 2);





----------------------------------------;
-- CREATE TABLE PRACOWNIK;
----------------------------------------;

create table PRACOWNIK(
PRAk_1_ID 				    	number(4) NOT NULL,
PRA_data_zatrudnienia			DATE NOT NULL,
DAN_ID					        number(4) NOT NULL
)TABLESPACE STUDENT_DATA;

----------------------------------------;
-- Primary Key;
----------------------------------------;

alter table PRACOWNIK
add constraint PK_PRACOWNIK
primary key (PRAk_1_ID);

----------------------------------------;
-- Foreign Key;
----------------------------------------;

alter table PRACOWNIK add constraint FK_PRACOWNIK
foreign key (DAN_ID)
references DANE_OSOBOWE (DANk_1_ID);

----------------------------------------;
-- Sequence;
----------------------------------------;

drop sequence SEQ_PRACOWNIK;
create sequence SEQ_PRACOWNIK increment by 1 start with 1
maxvalue 9999999999 minvalue 1;

----------------------------------------;
-- Trigger for primary key;
----------------------------------------;

create or replace trigger T_BI_PRACOWNIK
before insert on PRACOWNIK
for each row
begin
 if :new.PRAk_1_ID is NULL then
 SELECT SEQ_PRACOWNIK.nextval INTO :new.PRAk_1_ID FROM dual;
 end if;
end;
/

----------------------------------------;
-- Trigger for insert, update and delete;
----------------------------------------;

CREATE OR REPLACE TRIGGER T_PRACOWNIK_I_U_D
  AFTER INSERT OR UPDATE OR DELETE
  ON PRACOWNIK
DECLARE
  log_action  ZM_W_TABELACH.action%TYPE;
BEGIN
  IF INSERTING THEN
    log_action := 'Insert';
  ELSIF UPDATING THEN
    log_action := 'Update';
  ELSIF DELETING THEN
    log_action := 'Delete';
  ELSE
    DBMS_OUTPUT.PUT_LINE('This code is not reachable.');
  END IF;

  INSERT INTO ZM_W_TABELACH (username, nazwa_tabeli, log_date, action)
    VALUES (USER, 'PRACOWNIK', SYSDATE, log_action);
END;
/

----------------------------------------------;
-- Tworzenie indeksow do tabeli PRACOWNIK;
----------------------------------------------;

CREATE INDEX IX_PRACOWNIK
ON PRACOWNIK (PRA_data_zatrudnienia)
STORAGE (INITIAL 10k NEXT 10k)
TABLESPACE STUDENT_INDEX;

----------------------------------------;
-- Insert do tablicy PRACOWNIK;
----------------------------------------;

INSERT INTO PRACOWNIK (PRAk_1_ID, PRA_data_zatrudnienia, DAN_ID)
VALUES (1, to_date('1956-04-13', 'yyyy-mm-dd'), 4);
INSERT INTO PRACOWNIK (PRAk_1_ID, PRA_data_zatrudnienia, DAN_ID)
VALUES (2, to_date('1958-01-27', 'yyyy-mm-dd'), 8);





----------------------------------------;
-- CREATE TABLE REDAKCJA;
----------------------------------------;

create table REDAKCJA(
REDk_1_ID 					    number(4) NOT NULL,
RED_ilosc_pracownikow			number(8) NOT NULL CONSTRAINT sprawdz_il_pra CHECK (RED_ilosc_pracownikow>0),
PRA1_ID					    	number(4) NOT NULL,
PRA2_ID						    number(4)
)TABLESPACE STUDENT_DATA;

----------------------------------------;
-- Primary Key;
----------------------------------------;

alter table REDAKCJA
add constraint PK_REDAKCJA
primary key (REDk_1_ID);

----------------------------------------;
-- Foreign Key;
----------------------------------------;

alter table REDAKCJA add constraint FK_REDAKCJA
foreign key (PRA1_ID)
references PRACOWNIK (PRAk_1_ID);

----------------------------------------;
-- Foreign Key;
----------------------------------------;

alter table REDAKCJA add constraint FK1_REDAKCJA
foreign key (PRA2_ID)
references PRACOWNIK (PRAk_1_ID);

----------------------------------------;
-- Sequence;
----------------------------------------;

drop sequence SEQ_REDAKCJA;
create sequence SEQ_REDAKCJA increment by 1 start with 1
maxvalue 9999999999 minvalue 1;

----------------------------------------;
-- Trigger for primary key;
----------------------------------------;

create or replace trigger T_BI_REDAKCJA
before insert on REDAKCJA
for each row
begin
 if :new.REDk_1_ID is NULL then
 SELECT SEQ_REDAKCJA.nextval INTO :new.REDk_1_ID FROM dual;
 end if;
end;
/

----------------------------------------;
-- Trigger for insert, update and delete;
----------------------------------------;

CREATE OR REPLACE TRIGGER T_REDAKCJA_I_U_D
  AFTER INSERT OR UPDATE OR DELETE
  ON REDAKCJA
DECLARE
  log_action  ZM_W_TABELACH.action%TYPE;
BEGIN
  IF INSERTING THEN
    log_action := 'Insert';
  ELSIF UPDATING THEN
    log_action := 'Update';
  ELSIF DELETING THEN
    log_action := 'Delete';
  ELSE
    DBMS_OUTPUT.PUT_LINE('This code is not reachable.');
  END IF;

  INSERT INTO ZM_W_TABELACH (username, nazwa_tabeli, log_date, action)
    VALUES (USER, 'REDAKCJA', SYSDATE, log_action);
END;
/

----------------------------------------------;
-- Tworzenie indeksow do tabeli REDAKCJA;
----------------------------------------------;

CREATE INDEX IX_REDAKCJA
ON REDAKCJA (RED_ilosc_pracownikow)
STORAGE (INITIAL 10k NEXT 10k)
TABLESPACE STUDENT_INDEX;

----------------------------------------;
-- Insert do tablicy REDAKCJA;
----------------------------------------;

INSERT INTO REDAKCJA (REDk_1_ID, RED_ilosc_pracownikow, PRA1_ID, PRA2_ID)
VALUES (1, 2, 1, 2);





----------------------------------------;
-- CREATE TABLE WLASCICIEL;
----------------------------------------;

create table WLASCICIEL(
WLAk_1_ID 		      			number(4) NOT NULL,
DAN_ID				          	number(4) NOT NULL
)TABLESPACE STUDENT_DATA;

----------------------------------------;
-- Primary Key;
----------------------------------------;

alter table WLASCICIEL
add constraint PK_WLASCICIEL
primary key (WLAk_1_ID);

----------------------------------------;
-- Foreign Key;
----------------------------------------;

alter table WLASCICIEL add constraint FK_WLASCICIEL
foreign key (DAN_ID)
references DANE_OSOBOWE (DANk_1_ID);

----------------------------------------;
-- Sequence;
----------------------------------------;

drop sequence SEQ_WLASCICIEL;
create sequence SEQ_WLASCICIEL increment by 1 start with 1
maxvalue 9999999999 minvalue 1;

----------------------------------------;
-- Trigger for primary key;
----------------------------------------;

create or replace trigger T_BI_WLASCICIEL
before insert on WLASCICIEL
for each row
begin
 if :new.WLAk_1_ID is NULL then
 SELECT SEQ_WLASCICIEL.nextval INTO :new.WLAk_1_ID FROM dual;
 end if;
end;
/

----------------------------------------;
-- Trigger for insert, update and delete;
----------------------------------------;

CREATE OR REPLACE TRIGGER T_WLASCICIEL_I_U_D
  AFTER INSERT OR UPDATE OR DELETE
  ON WLASCICIEL
DECLARE
  log_action  ZM_W_TABELACH.action%TYPE;
BEGIN
  IF INSERTING THEN
    log_action := 'Insert';
  ELSIF UPDATING THEN
    log_action := 'Update';
  ELSIF DELETING THEN
    log_action := 'Delete';
  ELSE
    DBMS_OUTPUT.PUT_LINE('This code is not reachable.');
  END IF;

  INSERT INTO ZM_W_TABELACH (username, nazwa_tabeli, log_date, action)
    VALUES (USER, 'WLASCICIEL', SYSDATE, log_action);
END;
/

----------------------------------------;
-- Insert do tablicy WLASCICIEL;
----------------------------------------; 

INSERT INTO WLASCICIEL (WLAk_1_ID, DAN_ID)
VALUES (1, 1);
INSERT INTO WLASCICIEL (WLAk_1_ID, DAN_ID)
VALUES (2, 2);

---------------------------------------;
-- Zmiana nazw kolumn;
---------------------------------------;

COLUMN WLAk_1_ID		HEADING 'ID wlasciciela'		FORMAT 9999;
COLUMN WLA_ID			HEADING 'ID wlasciciela'		FORMAT 9999;





----------------------------------------;
-- CREATE TABLE TWORCA;
----------------------------------------;

create table TWORCA(
TWOk_1_ID 					        number(4) NOT NULL,
TWO_ilosc_stworz_bohaterow			number(5) NOT NULL CONSTRAINT sprawdz_il_boh CHECK (TWO_ilosc_stworz_bohaterow>0),
DAN_ID						        number(4) NOT NULL
)TABLESPACE STUDENT_DATA;

----------------------------------------;
-- Primary Key;
----------------------------------------;

alter table TWORCA
add constraint PK_TWORCA
primary key (TWOk_1_ID);

----------------------------------------;
-- Foreign Key;
----------------------------------------;

alter table TWORCA add constraint FK_TWORCA
foreign key (DAN_ID)
references DANE_OSOBOWE (DANk_1_ID);

----------------------------------------;
-- Sequence;
----------------------------------------;

drop sequence SEQ_TWORCA;
create sequence SEQ_TWORCA increment by 1 start with 1
maxvalue 9999999999 minvalue 1;

----------------------------------------;
-- Trigger for primary key;
----------------------------------------;

create or replace trigger T_BI_TWORCA
before insert on TWORCA
for each row
begin
 if :new.TWOk_1_ID is NULL then
 SELECT SEQ_TWORCA.nextval INTO :new.TWOk_1_ID FROM dual;
 end if;
end;
/

----------------------------------------;
-- Trigger for insert, update and delete;
----------------------------------------;

CREATE OR REPLACE TRIGGER T_TWORCA_I_U_D
  AFTER INSERT OR UPDATE OR DELETE
  ON TWORCA
DECLARE
  log_action  ZM_W_TABELACH.action%TYPE;
BEGIN
  IF INSERTING THEN
    log_action := 'Insert';
  ELSIF UPDATING THEN
    log_action := 'Update';
  ELSIF DELETING THEN
    log_action := 'Delete';
  ELSE
    DBMS_OUTPUT.PUT_LINE('This code is not reachable.');
  END IF;

  INSERT INTO ZM_W_TABELACH (username, nazwa_tabeli, log_date, action)
    VALUES (USER, 'TWORCA', SYSDATE, log_action);
END;
/

----------------------------------------------;
-- Tworzenie indeksow do tabeli TWORCA;
----------------------------------------------;

CREATE INDEX IX_TWORCA
ON TWORCA (TWO_ilosc_stworz_bohaterow)
STORAGE (INITIAL 10k NEXT 10k)
TABLESPACE STUDENT_INDEX;

----------------------------------------;
-- Insert do tablicy TWORCA;
----------------------------------------;

INSERT INTO TWORCA (TWOk_1_ID, TWO_ilosc_stworz_bohaterow, DAN_ID)
VALUES (1, 14, 2);
INSERT INTO TWORCA (TWOk_1_ID, TWO_ilosc_stworz_bohaterow, DAN_ID)
VALUES (2, 8, 4);





----------------------------------------;
-- CREATE TABLE WYDANIE;
----------------------------------------;

create table WYDANIE(
WYDk_1_ID 						    number(4) NOT NULL,
WYD_data_wydania				  	DATE NOT NULL,
WYD_ilosc_ekzemplarow				number(8) NOT NULL CONSTRAINT sprawdz_il_ekz CHECK (WYD_ilosc_ekzemplarow>0),
WYD_oryginalnosc				  	varchar2(11),
POW_ID						        number(4) NOT NULL,
AUT_ID						        number(4) NOT NULL,
RED_ID						        number(4) NOT NULL
)TABLESPACE STUDENT_DATA;

----------------------------------------;
-- Primary Key;
----------------------------------------;

alter table WYDANIE
add constraint PK_WYDANIE
primary key (WYDk_1_ID);

----------------------------------------;
-- Foreign Key;
----------------------------------------;

alter table WYDANIE add constraint FK_WYDANIE
foreign key (POW_ID)
references POWSZECHNA_INFORMACJA (POWk_1_ID);

----------------------------------------;
-- Foreign Key;
----------------------------------------;

alter table WYDANIE add constraint FK1_WYDANIE
foreign key (AUT_ID)
references AUTOR (AUTk_1_ID);

----------------------------------------;
-- Foreign Key;
----------------------------------------;

alter table WYDANIE add constraint FK2_WYDANIE
foreign key (RED_ID)
references REDAKCJA (REDk_1_ID);

----------------------------------------;
-- Sequence;
----------------------------------------;

drop sequence SEQ_WYDANIE;
create sequence SEQ_WYDANIE increment by 1 start with 1
maxvalue 9999999999 minvalue 1;

----------------------------------------;
-- Trigger for primary key;
----------------------------------------;

create or replace trigger T_BI_WYDANIE
before insert on WYDANIE
for each row
begin
 if :new.WYDk_1_ID is NULL then
 SELECT SEQ_WYDANIE.nextval INTO :new.WYDk_1_ID FROM dual;
 end if;
end;
/

----------------------------------------;
-- Trigger for insert, update and delete;
----------------------------------------;

CREATE OR REPLACE TRIGGER T_WYDANIE_I_U_D
  AFTER INSERT OR UPDATE OR DELETE
  ON WYDANIE
DECLARE
  log_action  ZM_W_TABELACH.action%TYPE;
BEGIN
  IF INSERTING THEN
    log_action := 'Insert';
  ELSIF UPDATING THEN
    log_action := 'Update';
  ELSIF DELETING THEN
    log_action := 'Delete';
  ELSE
    DBMS_OUTPUT.PUT_LINE('This code is not reachable.');
  END IF;

  INSERT INTO ZM_W_TABELACH (username, nazwa_tabeli, log_date, action)
    VALUES (USER, 'WYDANIE', SYSDATE, log_action);
END;
/

----------------------------------------------;
-- Tworzenie indeksow do tabeli WYDANIE;
----------------------------------------------;

CREATE INDEX IX_WYDANIE
ON WYDANIE (WYD_data_wydania, WYD_ilosc_ekzemplarow, WYD_oryginalnosc)
STORAGE (INITIAL 10k NEXT 10k)
TABLESPACE STUDENT_INDEX;

----------------------------------------;
-- Insert do tablicy WYDANIE;
----------------------------------------; 

INSERT INTO WYDANIE (WYDk_1_ID, WYD_data_wydania, WYD_ilosc_ekzemplarow, WYD_oryginalnosc, RED_ID, AUT_ID, POW_ID)
VALUES (1, to_date('1962-08-15', 'yyyy-mm-dd'), 18, 'original', 1, 1, 1);





----------------------------------------;
-- CREATE TABLE SERIA;
----------------------------------------;

create table SERIA(
SERk_1_ID 					    	number(4) NOT NULL,
SER_nazwa					        varchar2(30) NOT NULL,
SER_data_utworzenia					DATE NOT NULL,
SER_siedziba				      	varchar2(40),
WLA_ID					      	  	number(4) NOT NULL
)TABLESPACE STUDENT_DATA;

----------------------------------------;
-- Primary Key;
----------------------------------------;

alter table SERIA
add constraint PK_SERIA
primary key (SERk_1_ID);

----------------------------------------;
-- Foreign Key;
----------------------------------------;

alter table SERIA add constraint FK1_SERIA
foreign key (WLA_ID)
references WLASCICIEL (WLAk_1_ID);

----------------------------------------;
-- Sequence;
----------------------------------------;

drop sequence SEQ_SERIA;
create sequence SEQ_SERIA increment by 1 start with 1
maxvalue 9999999999 minvalue 1;

----------------------------------------;
-- Trigger for primary key;
----------------------------------------;

create or replace trigger T_BI_SERIA
before insert on SERIA
for each row
begin
 if :new.SERk_1_ID is NULL then
 SELECT SEQ_SERIA.nextval INTO :new.SERk_1_ID FROM dual;
 end if;
end;
/

----------------------------------------;
-- Trigger for insert, update and delete;
----------------------------------------;

CREATE OR REPLACE TRIGGER T_SERIA_I_U_D
  AFTER INSERT OR UPDATE OR DELETE
  ON SERIA
DECLARE
  log_action  ZM_W_TABELACH.action%TYPE;
BEGIN
  IF INSERTING THEN
    log_action := 'Insert';
  ELSIF UPDATING THEN
    log_action := 'Update';
  ELSIF DELETING THEN
    log_action := 'Delete';
  ELSE
    DBMS_OUTPUT.PUT_LINE('This code is not reachable.');
  END IF;

  INSERT INTO ZM_W_TABELACH (username, nazwa_tabeli, log_date, action)
    VALUES (USER, 'SERIA', SYSDATE, log_action);
END;
/

----------------------------------------------;
-- Tworzenie indeksow do tabeli SERIA;
----------------------------------------------;

CREATE INDEX IX_SERIA
ON SERIA (SER_data_utworzenia, SER_nazwa, SER_siedziba)
STORAGE (INITIAL 10k NEXT 10k)
TABLESPACE STUDENT_INDEX;

----------------------------------------;
-- Insert do tablicy SERIA;
----------------------------------------; 

INSERT INTO SERIA (SERk_1_ID, SER_nazwa, SER_data_utworzenia, SER_siedziba, WLA_ID)
VALUES (1, 'MARVEL', to_date('1961-02-19', 'yyyy-mm-dd'), 'New York, U.S.', 1);
INSERT INTO SERIA (SERk_1_ID, SER_nazwa, SER_data_utworzenia, SER_siedziba, WLA_ID)
VALUES (2, 'DC', to_date('1934-05-19', 'yyyy-mm-dd'), 'Burbank, California, U.S.', 2);

----------------------------------------;
-- Zmiana nazw kolumn;
----------------------------------------; 

COLUMN SERk_1_ID				HEADING 'ID serii'					FORMAT 9999;
COLUMN SER_ID					HEADING 'ID serii'					FORMAT 9999;
COLUMN SER_nazwa 				HEADING 'Nazwa serii'               FORMAT A15;
COLUMN SER_data_utworzenia		HEADING 'Data utworzenia'			FORMAT A15;
COLUMN SER_siedziba				HEADING 'Siedziba'					FORMAT A20;

----------------------------------------;
-- Tworzenie perspektywy;
----------------------------------------;

CREATE OR REPLACE VIEW V_DAN_OSO_WLASCICIELA_MARVELA
AS
	SELECT w.WLAk_1_ID, d.DAN_Imie, d.DAN_Nazwisko, s.SER_nazwa, s.SER_siedziba
	FROM DANE_OSOBOWE d, WLASCICIEL w, SERIA s
		WHERE w.WLAk_1_ID = (SELECT s.WLA_ID FROM SERIA s WHERE s.SERk_1_ID = 1)
		AND s.WLA_ID = w.WLAk_1_ID
		AND d.DANk_1_ID = w.DAN_ID
WITH CHECK OPTION;

---------------------------------------------;
-- Trigger dla V_DAN_OSO_WLASCICIELA_MARVELA;
---------------------------------------------;

CREATE OR REPLACE TRIGGER T_INST_OF_V_D_O_W_M
INSTEAD OF UPDATE OR DELETE
ON V_DAN_OSO_WLASCICIELA_MARVELA
for each row
DECLARE
  log_action  ZM_W_TABELACH.action%TYPE;
BEGIN
  IF UPDATING THEN
	UPDATE DANE_OSOBOWE
	SET DAN_Imie = :NEW.DAN_Imie
	WHERE DAN_Nazwisko = :OLD.DAN_Nazwisko;
    log_action := 'Update';
  ELSIF DELETING THEN
	DELETE FROM DANE_OSOBOWE
	WHERE DAN_Imie = :NEW.DAN_Imie OR DAN_Nazwisko = :NEW.DAN_Nazwisko;
	UPDATE DANE_OSOBOWE
	SET DAN_Imie = 'Usuniete'
	WHERE DAN_Imie = :OLD.DAN_Imie;
    log_action := 'Delete';
  ELSE
    DBMS_OUTPUT.PUT_LINE('Ten kod nieosiagalny');
  END IF;

  INSERT INTO ZM_W_TABELACH (username, nazwa_tabeli, log_date, action)
    VALUES (USER, 'V_DAN_OSO_BOHATEROW_MARVELA', SYSDATE, log_action);
end;
/





----------------------------------------;
-- CREATE TABLE BOHATER;
----------------------------------------;

create table BOHATER(
BOHk_1_ID 				    	  	number(4) NOT NULL,
BOH_data_stworzenia					DATE NOT NULL,
BOH_pseudonim					    varchar(35) NOT NULL,
BOH_sily					        varchar2(150) NOT NULL,
BOH_uwagi					        varchar2(40),
SER_ID					        	number(4) NOT NULL,
DAN_ID						        number(4) NOT NULL
)TABLESPACE STUDENT_DATA;

----------------------------------------;
-- Primary Key;
----------------------------------------;

alter table BOHATER
add constraint PK_BOHATER
primary key (BOHk_1_ID);

----------------------------------------;
-- Unique Key;
----------------------------------------;

alter table BOHATER
add constraint UQ_BOHATER
unique (BOH_pseudonim);

----------------------------------------;
-- Foreign Key;
----------------------------------------;

alter table BOHATER add constraint FK_BOHATER
foreign key (SER_ID)
references SERIA (SERk_1_ID);

----------------------------------------;
-- Foreign Key;
----------------------------------------;

alter table BOHATER add constraint FK1_BOHATER
foreign key (DAN_ID)
references DANE_OSOBOWE (DANk_1_ID);

----------------------------------------;
-- Sequence;
----------------------------------------;

drop sequence SEQ_BOHATER;
create sequence SEQ_BOHATER increment by 1 start with 1
maxvalue 9999999999 minvalue 1;

----------------------------------------;
-- Trigger for primary key;
----------------------------------------;

create or replace trigger T_BI_BOHATER
before insert on BOHATER
for each row
begin
 if :new.BOHk_1_ID is NULL then
 SELECT SEQ_BOHATER.nextval INTO :new.BOHk_1_ID FROM dual;
 end if;
end;
/

----------------------------------------;
-- Trigger for insert, update and delete;
----------------------------------------;

CREATE OR REPLACE TRIGGER T_BOHATER_I_U_D
  AFTER INSERT OR UPDATE OR DELETE
  ON BOHATER
DECLARE
  log_action  ZM_W_TABELACH.action%TYPE;
BEGIN
  IF INSERTING THEN
    log_action := 'Insert';
  ELSIF UPDATING THEN
    log_action := 'Update';
  ELSIF DELETING THEN
    log_action := 'Delete';
  ELSE
    DBMS_OUTPUT.PUT_LINE('This code is not reachable.');
  END IF;

  INSERT INTO ZM_W_TABELACH (username, nazwa_tabeli, log_date, action)
    VALUES (USER, 'BOHATER', SYSDATE, log_action);
END;
/

----------------------------------------------;
-- Tworzenie indeksow do tabeli BOHATER;
----------------------------------------------;

CREATE INDEX IX_BOHATER
ON BOHATER (BOHk_1_ID, BOH_data_stworzenia, BOH_pseudonim, BOH_sily)
STORAGE (INITIAL 10k NEXT 10k)
TABLESPACE STUDENT_INDEX;

----------------------------------------;
-- Insert do tablicy BOHATER;
----------------------------------------;

INSERT INTO BOHATER (BOHk_1_ID, BOH_data_stworzenia, BOH_pseudonim, BOH_sily, SER_ID, DAN_ID)
VALUES (1, to_date('1962-08-10', 'yyyy-mm-dd'), 'Spider-Man',
'Zdolnosc chodzenia po scianach, duza inteligencja, nadludzka sila, wystrzeliwanie sztucznej pajeczyny', 1, 9);
INSERT INTO BOHATER (BOHk_1_ID, BOH_data_stworzenia, BOH_pseudonim, BOH_sily, SER_ID, DAN_ID)
VALUES (2, to_date('1974-10-18', 'yyyy-mm-dd'), 'Wolverine',
'Nadludzka sila, kondycja i zrecznosc, wyostrzone zmysly, regeneracja, wysuwane pazury i szkielet wzmocnione adamantium', 1, 10);
INSERT INTO BOHATER (BOHk_1_ID, BOH_data_stworzenia, BOH_pseudonim, BOH_sily, SER_ID, DAN_ID)
VALUES (3, to_date('1977-08-12', 'yyyy-mm-dd'), 'Sabretooth',
'Nadludzka sila, szybkosc, refleksy, kondycja, zrecznosc, regeneracja, cechy zwierzece, ostre zeby i pazury', 1, 11);
INSERT INTO BOHATER (BOHk_1_ID, BOH_data_stworzenia, BOH_pseudonim, BOH_sily, SER_ID, DAN_ID)
VALUES (4, to_date('1939-03-17', 'yyyy-mm-dd'), 'Batman',
'Umiejetnosci atletyczne, detektywistyczne i taktyczne, ekspert w walce wrecz i szermierce, korzystanie z wysoce zaawansowanych gadzetow', 2, 12);

----------------------------------------;
-- Zmiana nazw kolumn;
----------------------------------------;

COLUMN BOHk_1_ID				HEADING 'ID bohatera'				FORMAT 9999;
COLUMN BOH_ID					HEADING 'ID bohatera'				FORMAT 9999;
COLUMN BOH_pseudonim 			HEADING 'Pseudonim'                 FORMAT A15;
COLUMN BOH_data_stworzenia		HEADING 'Data stworzenia'			FORMAT A15;
COLUMN BOH_sily					HEADING 'Sily bohatera'				FORMAT A150;

----------------------------------------;
-- Tworzenie perspektywy;
----------------------------------------;

CREATE OR REPLACE VIEW V_DAN_OSO_BOHATEROW_MARVELA
AS
	SELECT d.DAN_Imie, d.DAN_Nazwisko, b.BOH_pseudonim, b.BOH_data_stworzenia, s.SER_nazwa, s.SER_siedziba
	FROM DANE_OSOBOWE d, BOHATER b, SERIA s
		WHERE s.SER_nazwa IN (SELECT s.SER_nazwa FROM SERIA s WHERE b.SER_ID = 1)
		AND b.SER_ID = s.SERk_1_ID
		AND d.DANk_1_ID = b.DAN_ID
WITH CHECK OPTION;

------------------------------------------;
-- Trigger dla V_DAN_OSO_BOHATEROW_MARVELA;
------------------------------------------;

CREATE OR REPLACE TRIGGER T_INST_OF_V_D_O_B_M
INSTEAD OF UPDATE OR DELETE
ON V_DAN_OSO_BOHATEROW_MARVELA
for each row
DECLARE
  log_action  ZM_W_TABELACH.action%TYPE;
BEGIN
  IF UPDATING THEN
	UPDATE DANE_OSOBOWE
	SET DAN_Imie = :NEW.DAN_Imie
	WHERE DAN_Nazwisko = :OLD.DAN_Nazwisko;
    log_action := 'Update';
  ELSIF DELETING THEN
	DELETE FROM DANE_OSOBOWE
	WHERE DAN_Imie = :NEW.DAN_Imie OR DAN_Nazwisko = :NEW.DAN_Nazwisko;
	UPDATE DANE_OSOBOWE
	SET DAN_Imie = 'Usuniete'
	WHERE DAN_Imie = :OLD.DAN_Imie;
    log_action := 'Delete';
  ELSE
    DBMS_OUTPUT.PUT_LINE('Ten kod nieosiagalny');
  END IF;

  INSERT INTO ZM_W_TABELACH (username, nazwa_tabeli, log_date, action)
    VALUES (USER, 'V_DAN_OSO_BOHATEROW_MARVELA', SYSDATE, log_action);
end;
/





----------------------------------------;
-- CREATE TABLE KOMIKS;
----------------------------------------;

create table KOMIKS(
KOMk_1_ID 						number(4) NOT NULL,
KOM_nazwa						varchar2(30) NOT NULL,
SER_ID							number(4) NOT NULL,
WYD_ID							number(4) NOT NULL
)TABLESPACE STUDENT_DATA;

----------------------------------------;
-- Primary Key;
----------------------------------------;

alter table KOMIKS
add constraint PK_KOMIKS
primary key (KOMk_1_ID);

----------------------------------------;
-- Foreign Key;
----------------------------------------;

alter table KOMIKS add constraint FK_KOMIKS
foreign key (SER_ID)
references SERIA (SERk_1_ID);

----------------------------------------;
-- Foreign Key;
----------------------------------------;

alter table KOMIKS add constraint FK1_KOMIKS
foreign key (WYD_ID)
references WYDANIE (WYDk_1_ID);

----------------------------------------;
-- Sequence;
----------------------------------------;

drop sequence SEQ_KOMIKS;
create sequence SEQ_KOMIKS increment by 1 start with 1
maxvalue 9999999999 minvalue 1;

----------------------------------------;
-- Trigger for primary key;
----------------------------------------;

create or replace trigger T_BI_KOMIKS
before insert on KOMIKS
for each row
begin
 if :new.KOMk_1_ID is NULL then
 SELECT SEQ_KOMIKS.nextval INTO :new.KOMk_1_ID FROM dual;
 end if;
end;
/

----------------------------------------;
-- Trigger for insert, update and delete;
----------------------------------------;

CREATE OR REPLACE TRIGGER T_KOMIKS_I_U_D
  AFTER INSERT OR UPDATE OR DELETE
  ON KOMIKS
DECLARE
  log_action  ZM_W_TABELACH.action%TYPE;
BEGIN
  IF INSERTING THEN
    log_action := 'Insert';
  ELSIF UPDATING THEN
    log_action := 'Update';
  ELSIF DELETING THEN
    log_action := 'Delete';
  ELSE
    DBMS_OUTPUT.PUT_LINE('This code is not reachable.');
  END IF;

  INSERT INTO ZM_W_TABELACH (username, nazwa_tabeli, log_date, action)
    VALUES (USER, 'KOMIKS', SYSDATE, log_action);
END;
/

----------------------------------------------;
-- Tworzenie indeksow do tabeli KOMIKS;
----------------------------------------------;

CREATE INDEX IX_KOMIKS
ON KOMIKS (KOM_nazwa)
STORAGE (INITIAL 10k NEXT 10k)
TABLESPACE STUDENT_INDEX;

----------------------------------------;
-- Insert do tablicy KOMIKS;
----------------------------------------; 

INSERT INTO KOMIKS (KOMk_1_ID, KOM_nazwa, SER_ID, WYD_ID)
VALUES (1, 'Amazing Fantasy vol. 1 #15', 1, 1);

----------------------------------------;
-- Zmiana nazwy kolumn;
----------------------------------------;

COLUMN KOMk_1_ID	HEADING 'ID komiksu'		FORMAT 9999;
COLUMN KOM_ID		HEADING 'ID komiksu'		FORMAT 9999;
COLUMN KOM_nazwa	HEADING 'Nazwa komiksu'		FORMAT A20;





----------------------------------------;
-- CREATE TABLE ZESTAW_TWORCZY;
----------------------------------------;

create table ZESTAW_TWORCZY(
ZESk_1_ID				    		number(4) NOT NULL,
BOH_ID						  		number(4) NOT NULL,
TWO1_ID						  		number(4) NOT NULL,
TWO2_ID						  		number(4)
)TABLESPACE STUDENT_DATA;

----------------------------------------;
-- Primary Key;
----------------------------------------;

alter table ZESTAW_TWORCZY
add constraint PK_ZESTAW_TWORCZY
primary key (ZESk_1_ID);

----------------------------------------;
-- Foreign Key;
----------------------------------------;

alter table ZESTAW_TWORCZY add constraint FK_ZESTAW_TWORCZY
foreign key (BOH_ID)
references BOHATER (BOHk_1_ID);

----------------------------------------;
-- Foreign Key;
----------------------------------------;

alter table ZESTAW_TWORCZY add constraint FK1_ZESTAW_TWORCZY
foreign key (TWO1_ID)
references TWORCA (TWOk_1_ID);

----------------------------------------;
-- Foreign Key;
----------------------------------------;

alter table ZESTAW_TWORCZY add constraint FK3_ZESTAW_TWORCZY
foreign key (TWO2_ID)
references TWORCA (TWOk_1_ID);

----------------------------------------;
-- Sequence;
----------------------------------------;

drop sequence SEQ_ZESTAW_TWORCZY;
create sequence SEQ_ZESTAW_TWORCZY increment by 1 start with 1
maxvalue 9999999999 minvalue 1;

----------------------------------------;
-- Trigger for primary key;
----------------------------------------;

create or replace trigger T_ZESTAW_TWORCZY
before insert on ZESTAW_TWORCZY
for each row
begin
 if :new.ZESk_1_ID is NULL then
 SELECT SEQ_ZESTAW_TWORCZY.nextval INTO :new.ZESk_1_ID FROM dual;
 end if;
end;
/

----------------------------------------;
-- Trigger for insert, update and delete;
----------------------------------------;

CREATE OR REPLACE TRIGGER T_ZESTAW_TWORCZY_I_U_D
  AFTER INSERT OR UPDATE OR DELETE
  ON ZESTAW_TWORCZY
DECLARE
  log_action  ZM_W_TABELACH.action%TYPE;
BEGIN
  IF INSERTING THEN
    log_action := 'Insert';
  ELSIF UPDATING THEN
    log_action := 'Update';
  ELSIF DELETING THEN
    log_action := 'Delete';
  ELSE
    DBMS_OUTPUT.PUT_LINE('This code is not reachable.');
  END IF;

  INSERT INTO ZM_W_TABELACH (username, nazwa_tabeli, log_date, action)
    VALUES (USER, 'ZESTAW_TWORCZY', SYSDATE, log_action);
END;
/

----------------------------------------;
-- Insert do tablicy ZESTAW_TWORCZY;
----------------------------------------; 

INSERT INTO ZESTAW_TWORCZY (ZESk_1_ID, BOH_ID, TWO1_ID, TWO2_ID)
VALUES (1, 1, 1, 2);





----------------------------------------;
-- CREATE TABLE GLOWNE_BOHATEROWIE;
----------------------------------------;

create table GLOWNE_BOHATEROWIE(
GLOk_1_ID 							number(4) NOT NULL,
BOH_ID						  		number(4) NOT NULL,
KOM_ID						  		number(4) NOT NULL
)TABLESPACE STUDENT_DATA;

----------------------------------------;
-- Primary Key;
----------------------------------------;

alter table GLOWNE_BOHATEROWIE
add constraint PK_GLOWNE_BOHATEROWIE
primary key (GLOk_1_ID);

----------------------------------------;
-- Foreign Key;
----------------------------------------;

alter table GLOWNE_BOHATEROWIE add constraint FK_GLOWNE_BOHATEROWIE
foreign key (BOH_ID)
references BOHATER (BOHk_1_ID);

----------------------------------------;
-- Foreign Key;
----------------------------------------;

alter table GLOWNE_BOHATEROWIE add constraint FK1_GLOWNE_BOHATEROWIE
foreign key (KOM_ID)
references KOMIKS (KOMk_1_ID);

----------------------------------------;
-- Sequence;
----------------------------------------;

drop sequence SEQ_GLOWNE_BOHATEROWIE;
create sequence SEQ_GLOWNE_BOHATEROWIE increment by 1 start with 1
maxvalue 9999999999 minvalue 1;

----------------------------------------;
-- Trigger for primary key;
----------------------------------------;

create or replace trigger T_BI_GLOWNE_BOHATEROWIE
before insert on GLOWNE_BOHATEROWIE
for each row
begin
 if :new.GLOk_1_ID is NULL then
 SELECT SEQ_GLOWNE_BOHATEROWIE.nextval INTO :new.GLOk_1_ID FROM dual;
 end if;
end;
/

----------------------------------------;
-- Trigger for insert, update and delete;
----------------------------------------;

CREATE OR REPLACE TRIGGER T_GLOWNE_BOHATEROWIE_I_U_D
  AFTER INSERT OR UPDATE OR DELETE
  ON GLOWNE_BOHATEROWIE
DECLARE
  log_action  ZM_W_TABELACH.action%TYPE;
BEGIN
  IF INSERTING THEN
    log_action := 'Insert';
  ELSIF UPDATING THEN
    log_action := 'Update';
  ELSIF DELETING THEN
    log_action := 'Delete';
  ELSE
    DBMS_OUTPUT.PUT_LINE('This code is not reachable.');
  END IF;

  INSERT INTO ZM_W_TABELACH (username, nazwa_tabeli, log_date, action)
    VALUES (USER, 'GLOWNE_BOHATEROWIE', SYSDATE, log_action);
END;
/

----------------------------------------;
-- Insert do tablicy GLOWNE_BOHATEROWIE;
----------------------------------------; 

INSERT INTO GLOWNE_BOHATEROWIE (GLOk_1_ID, BOH_ID, KOM_ID)
VALUES (1, 1, 1);

---------------------------------------;
-- Zmiana nazw kolumn;
---------------------------------------;

COLUMN GLOk_1_ID		HEADING 'ID zestawu bohaterow'			FORMAT 9999;





---------------------------------------;
-- End of script;
---------------------------------------;