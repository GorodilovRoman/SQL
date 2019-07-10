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





SELECT 		b.BOHk_1_ID,
			b.BOH_pseudonim,
			b.BOH_data_stworzenia,
			d.DAN_Imie,
			d.DAN_Nazwisko
FROM BOHATER b, DANE_OSOBOWE d
WHERE b.DAN_ID = d.DANk_1_ID
GROUP BY b.BOHk_1_ID, b.BOH_pseudonim, b.BOH_data_stworzenia, d.DAN_Imie, d.DAN_Nazwisko
HAVING b.BOHk_1_ID BETWEEN 1 AND 4
ORDER BY d.DAN_Imie;

/*
   ID Pseudonim       Data stworzenia Imie       Nazwisko
----- --------------- --------------- ---------- ---------------
    4 Batman          17-MAR-39       Bruce      Wayne
    2 Wolverine       18-OCT-74       James      Howlett
    1 Spider-Man      10-AUG-62       Peter      Parker
    3 Sabretooth      12-AUG-77       Victor     Creed
*/

SELECT	b.BOH_pseudonim,
        s.SER_nazwa,
        s.SER_data_utworzenia
FROM BOHATER b, SERIA s
WHERE b.SER_ID = s.SERk_1_ID
GROUP BY b.BOH_pseudonim, s.SER_nazwa, s.SER_data_utworzenia
HAVING SER_nazwa = 'MARVEL';

/*
Pseudonim       Nazwa serii     Data utworzenia
--------------- --------------- ---------------
Spider-Man      MARVEL          19-FEB-61
Sabretooth      MARVEL          19-FEB-61
Wolverine       MARVEL          19-FEB-61
*/





----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
-- Zapytania uzywajace zlaczenia nierownosciowe i zewnetrzne;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

SELECT 		b.BOHk_1_ID,
			b.BOH_pseudonim,
			b.BOH_data_stworzenia,
			d.DAN_Imie,
			d.DAN_Nazwisko
FROM BOHATER b, DANE_OSOBOWE d
WHERE b.DAN_ID = d.DANk_1_ID
GROUP BY b.BOHk_1_ID, b.BOH_pseudonim, b.BOH_data_stworzenia, d.DAN_Imie, d.DAN_Nazwisko
HAVING b.BOHk_1_ID BETWEEN 1 AND 4
ORDER BY d.DAN_Imie;

/*
   ID Pseudonim       Data stworzenia Imie       Nazwisko
----- --------------- --------------- ---------- ---------------
    4 Batman          17-MAR-39       Bruce      Wayne
    2 Wolverine       18-OCT-74       James      Howlett
    1 Spider-Man      10-AUG-62       Peter      Parker
    3 Sabretooth      12-AUG-77       Victor     Creed
*/




SELECT	b.BOH_pseudonim,
        s.SER_nazwa,
        s.SER_data_utworzenia
FROM BOHATER b, SERIA s
WHERE b.SER_ID = s.SERk_1_ID
GROUP BY b.BOH_pseudonim, s.SER_nazwa, s.SER_data_utworzenia
HAVING SER_nazwa = 'MARVEL';

/*
Pseudonim       Nazwa serii     Data utworzenia
--------------- --------------- ---------------
Spider-Man      MARVEL          19-FEB-61
Sabretooth      MARVEL          19-FEB-61
Wolverine       MARVEL          19-FEB-61
*/





SELECT 	b.BOH_pseudonim,
		b.BOH_data_stworzenia,
		d.DAN_Imie,
		d.DAN_Nazwisko,
		s.SER_nazwa,
		s.SER_data_utworzenia
FROM BOHATER b
	LEFT OUTER JOIN DANE_OSOBOWE d on b.DAN_ID = d.DANk_1_ID
	INNER JOIN SERIA s on b.SER_ID = s.SERk_1_ID
WHERE b.BOHk_1_ID BETWEEN 2 AND 4;

/*
Pseudonim       Data stworzenia Imie       Nazwisko        Nazwa serii
--------------- --------------- ---------- --------------- ---------------
Data utworzenia
---------------
Wolverine       18-OCT-74       James      Howlett         MARVEL
19-FEB-61

Sabretooth      12-AUG-77       Victor     Creed           MARVEL
19-FEB-61

Batman          17-MAR-39       Bruce      Wayne           DC
19-MAY-34
*/




SELECT 	s.SER_nazwa,
		s.SER_siedziba,
		w.DAN_ID,
		d.DAN_Imie,
		d.DAN_Nazwisko
FROM SERIA s
	LEFT OUTER JOIN WLASCICIEL w on s.WLA_ID=w.WLAk_1_ID
	INNER JOIN DANE_OSOBOWE d on w.DAN_ID=d.DANk_1_ID
WHERE SER_nazwa = 'MARVEL';

/*
Nazwa serii     Siedziba                 DAN_ID Imie       Nazwisko
--------------- -------------------- ---------- ---------- ---------------
MARVEL          New York, U.S.                1 Isaac      Perlmutter
*/




SELECT 	k.KOM_nazwa,
		s.SER_nazwa,
		g.BOH_ID,
		b.BOH_pseudonim,
		d.DAN_Imie,
		d.DAN_Nazwisko
FROM KOMIKS k
	FULL OUTER JOIN GLOWNE_BOHATEROWIE g on g.KOM_ID = k.KOMk_1_ID
	FULL OUTER JOIN BOHATER b on b.BOHk_1_ID = g.BOH_ID
	INNER JOIN DANE_OSOBOWE d on b.DAN_ID = d.DANk_1_ID
	INNER JOIN SERIA s on k.SER_ID = s.SERk_1_ID OR b.SER_ID = s.SERk_1_ID
WHERE b.BOHk_1_ID IN (1, 3);

/*
Nazwa komiksu        Nazwa serii     ID bohatera Pseudonim       Imie
-------------------- --------------- ----------- --------------- ----------
Nazwisko
---------------
Amazing Fantasy vol. MARVEL                    1 Spider-Man      Peter
 1 #15
Parker

                     MARVEL                      Sabretooth      Victor
Creed
*/