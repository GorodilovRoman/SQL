------------------------------------------------;
-- Indeksy do tabeli DANE_OSOBOWE;
------------------------------------------------;

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

----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
-- Zapytania do indeksow funkcyjnych;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

SELECT DAN_Imie, DAN_Nazwisko, DAN_Plec, DAN_data_urodzenia
FROM DANE_OSOBOWE
WHERE LOWER(DAN_Plec) = 'm';

/*
Imie       Nazwisko        Plec       Data urodzenia
---------- --------------- ---------- ---------------
Usuniete   Perlmutter      M          01-DEC-42
Stan       Lee             M          28-DEC-22
Steve      Ditko           M          02-NOV-27
Leonard    Wein            M          12-JUN-48
John       Romita          M          24-JAN-30
Herbert    Trimpe          M          26-MAY-39
Jack       Kirby           M          28-AUG-17
Usuniete   Parker          M
James      Howlett         M
Victor     Creed           M
Bruce      Wayne           M

11 rows selected.
*/

SELECT DAN_Imie, DAN_Nazwisko
FROM DANE_OSOBOWE
WHERE UPPER(DAN_Imie) LIKE '%E';

/*
Imie       Nazwisko
---------- ---------------
Usuniete   Perlmutter
Diane      Nelson
Steve      Ditko
Usuniete   Parker
Bruce      Wayne
*/

---------------------------------------------------------------------------------------------------------------------------------------;
-- Sprawdzamy dzialanie COMMIT, ROLLBACK, SAVEPOINT i ROLLBACK TO SAVEPOINT;
---------------------------------------------------------------------------------------------------------------------------------------;

INSERT INTO DANE_OSOBOWE (DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec)
VALUES (13, 'Nowa osoba 1', 'Nowe nazwisko oso 1', 'M');

COMMIT;

SELECT DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec FROM DANE_OSOBOWE WHERE DANk_1_ID > 12;

/*
ID danych osobowych Imie       Nazwisko        Plec
------------------- ---------- --------------- ----------
                 13 Nowa osoba Nowe nazwisko o M
                     1         so 1
*/

INSERT INTO DANE_OSOBOWE (DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec)
VALUES (14, 'Nowa osoba 2', 'Nowe nazwisko oso 2', 'K');

ROLLBACK;

SELECT DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec FROM DANE_OSOBOWE WHERE DANk_1_ID > 12;

/*
ID danych osobowych Imie       Nazwisko        Plec
------------------- ---------- --------------- ----------
                 13 Nowa osoba Nowe nazwisko o M
                     1         so 1
*/

INSERT INTO DANE_OSOBOWE (DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec)
VALUES (15, 'Nowa osoba 3', 'Nowe nazwisko oso 3', 'M');

SAVEPOINT punkt_kontrolny_1;

INSERT INTO DANE_OSOBOWE (DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec)
VALUES (16, 'Nowa osoba 4', 'Nowe nazwisko oso 4', 'K');

INSERT INTO DANE_OSOBOWE (DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec)
VALUES (17, 'Nowa osoba 5', 'Nowe nazwisko oso 5', 'M');

ROLLBACK TO SAVEPOINT punkt_kontrolny_1;

SELECT DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec FROM DANE_OSOBOWE WHERE DANk_1_ID > 12;

/*
ID danych osobowych Imie       Nazwisko        Plec
------------------- ---------- --------------- ----------
                 13 Nowa osoba Nowe nazwisko o M
                     1         so 1

                 15 Nowa osoba Nowe nazwisko o M
                     3         so 3
*/

----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
-- Zapytania do perspektyw slownika danych;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

/*sprawdzenia istniecia tabeli
SELECT *
  2  FROM all_objects
  3  WHERE object_type IN ('TABLE','VIEW')
  4  AND object_name = 'DANE_OSOBOWE';
*/

-- jakie indeksy sa zalozone na podanej tabeli;
SELECT table_name , index_name, index_type , uniqueness, partitioned FROM
user_indexes WHERE table_name = 'DANE_OSOBOWE';

/*
TABLE_NAME
--------------------------------------------------------------------------------
INDEX_NAME
--------------------------------------------------------------------------------
INDEX_TYPE                  UNIQUENES PAR
--------------------------- --------- ---
DANE_OSOBOWE
PK_DANE_OSOBOWE
NORMAL                      UNIQUE    NO

DANE_OSOBOWE
IX_DANE_OSOBOWE
NORMAL                      NONUNIQUE NO

TABLE_NAME
--------------------------------------------------------------------------------
INDEX_NAME
--------------------------------------------------------------------------------
INDEX_TYPE                  UNIQUENES PAR
--------------------------- --------- ---

DANE_OSOBOWE
IX_LC_DANE_OSOBOWE
FUNCTION-BASED NORMAL       NONUNIQUE NO

DANE_OSOBOWE
IX_UC_DANE_OSOBOWE

TABLE_NAME
--------------------------------------------------------------------------------
INDEX_NAME
--------------------------------------------------------------------------------
INDEX_TYPE                  UNIQUENES PAR
--------------------------- --------- ---
FUNCTION-BASED NORMAL       NONUNIQUE NO
*/


-- z jakich kolumn zbudowany jest indeks;
SELECT * FROM user_ind_columns WHERE table_name = 'BOHATER' ORDER BY
index_name, column_position;

/*
INDEX_NAME
--------------------------------------------------------------------------------
TABLE_NAME
--------------------------------------------------------------------------------
COLUMN_NAME
--------------------------------------------------------------------------------
COLUMN_POSITION COLUMN_LENGTH CHAR_LENGTH DESC
--------------- ------------- ----------- ----
IX_BOHATER
BOHATER
BOHK_1_ID
              1            22           0 ASC


INDEX_NAME
--------------------------------------------------------------------------------
TABLE_NAME
--------------------------------------------------------------------------------
COLUMN_NAME
--------------------------------------------------------------------------------
COLUMN_POSITION COLUMN_LENGTH CHAR_LENGTH DESC
--------------- ------------- ----------- ----
IX_BOHATER
BOHATER
BOH_DATA_STWORZENIA
              2             7           0 ASC



...
INDEX_NAME
--------------------------------------------------------------------------------
TABLE_NAME
--------------------------------------------------------------------------------
COLUMN_NAME
--------------------------------------------------------------------------------
COLUMN_POSITION COLUMN_LENGTH CHAR_LENGTH DESC
--------------- ------------- ----------- ----
UQ_BOHATER
BOHATER
BOH_PSEUDONIM
              1            35          35 ASC


6 rows selected.
*/

--jakie jest rozmieszczenie indeksu ( nie partycjonowanego ) w stosunku do tabeli;
SELECT ut.table_name, ut.tablespace_name, ui.index_name, ui.tablespace_name
FROM user_tables ut, user_indexes ui
WHERE ut.table_name = ui.table_name and
ui.table_owner = user;

/*
TABLE_NAME
--------------------------------------------------------------------------------
TABLESPACE_NAME
------------------------------
INDEX_NAME
--------------------------------------------------------------------------------
TABLESPACE_NAME
------------------------------
AUTOR
STUDENT_DATA
PK_AUTOR
STUDENT_DATA

...

TABLE_NAME
--------------------------------------------------------------------------------
TABLESPACE_NAME
------------------------------
INDEX_NAME
--------------------------------------------------------------------------------
TABLESPACE_NAME
------------------------------
ZESTAW_TWORCZY
STUDENT_DATA
PK_ZESTAW_TWORCZY
STUDENT_DATA


26 rows selected.
*/