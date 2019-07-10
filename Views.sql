----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
-- Tworzenie perspektywy;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

CREATE OR REPLACE VIEW V_DAN_OSO_WLASCICIELA_MARVELA
AS
	SELECT w.WLAk_1_ID, d.DAN_Imie, d.DAN_Nazwisko, s.SER_nazwa, s.SER_siedziba
	FROM DANE_OSOBOWE d, WLASCICIEL w, SERIA s
		WHERE w.WLAk_1_ID = (SELECT s.WLA_ID FROM SERIA s WHERE s.SERk_1_ID = 1)
		AND s.WLA_ID = w.WLAk_1_ID
		AND d.DANk_1_ID = w.DAN_ID
WITH CHECK OPTION;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
-- Trigger dla V_DAN_OSO_WLASCICIELA_MARVELA;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

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

----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
-- Symulacja dla V_DAN_OSO_WLASCICIELA_MARVELA;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

INSERT INTO V_DAN_OSO_WLASCICIELA_MARVELA (WLAk_1_ID, DAN_Imie, DAN_Nazwisko, SER_nazwa, SER_siedziba)
VALUES (3, 'Imie wlasciceila', 'Nazwisko wlasciciela', 'Nazwa serii', 'Nowa siedziba');

/*BŁĄD w linii 1:
ORA-01779: nie można modyfikować kolumny, która odwzorowuje się do tabeli nie
zachowującej kluczy*/

UPDATE V_DAN_OSO_WLASCICIELA_MARVELA SET DAN_Imie = 'ARTEM' WHERE DAN_Nazwisko = 'Perlmutter';

SELECT * FROM V_DAN_OSO_WLASCICIELA_MARVELA;

/*
ID wlasciciela Imie       Nazwisko        Nazwa serii     Siedziba
-------------- ---------- --------------- --------------- --------------------
             1 ARTEM      Perlmutter      MARVEL          New York, U.S.
*/

DELETE FROM V_DAN_OSO_WLASCICIELA_MARVELA WHERE DAN_Imie = 'ARTEM';

/*
1 wiersz został usunięty.
*/
SELECT * FROM V_DAN_OSO_WLASCICIELA_MARVELA;
/*
ID wlasciciela Imie       Nazwisko        Nazwa serii     Siedziba
-------------- ---------- --------------- --------------- --------------------
             1 Usuniete   Perlmutter      MARVEL          New York, U.S.
*/





----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
-- Tworzenie perspektywy;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

CREATE OR REPLACE VIEW V_DAN_OSO_BOHATEROW_MARVELA
AS
	SELECT d.DAN_Imie, d.DAN_Nazwisko, b.BOH_pseudonim, b.BOH_data_stworzenia, s.SER_nazwa, s.SER_siedziba
	FROM DANE_OSOBOWE d, BOHATER b, SERIA s
		WHERE s.SER_nazwa IN (SELECT s.SER_nazwa FROM SERIA s WHERE b.SER_ID = 1)
		AND b.SER_ID = s.SERk_1_ID
		AND d.DANk_1_ID = b.DAN_ID
WITH CHECK OPTION;

SELECT * FROM V_DAN_OSO_BOHATEROW_MARVELA;

/*
Imie       Nazwisko        Pseudonim       Data stworzenia Nazwa serii
---------- --------------- --------------- --------------- ---------------
Siedziba
--------------------
Peter      Parker          Spider-Man      62/08/10        MARVEL
New York, U.S.

James      Howlett         Wolverine       74/10/18        MARVEL
New York, U.S.

Victor     Creed           Sabretooth      77/08/12        MARVEL
New York, U.S.
*/

----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
-- Trigger dla V_DAN_OSO_BOHATEROW_MARVELA;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

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

----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
-- Symulacja dla V_DAN_OSO_BOHATEROW_MARVELA;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

INSERT INTO V_DAN_OSO_BOHATEROW_MARVELA (DAN_Imie, DAN_Nazwisko, BOH_pseudonim, BOH_data_stworzenia, SER_nazwa, SER_siedziba)
VALUES ('Nowe imie', 'Nowe nazwisko', 'Nowy pseudonim', 'Nowa data', 'Nowa nazwa', 'Nowa siedziba');

/*BŁĄD w linii 1:
ORA-01779: nie można modyfikować kolumny, która odwzorowuje się do tabeli nie
zachowującej kluczy*/

UPDATE V_DAN_OSO_BOHATEROW_MARVELA SET DAN_Imie = 'WASYL' WHERE DAN_Nazwisko = 'Parker';

SELECT * FROM V_DAN_OSO_BOHATEROW_MARVELA;

/*
Imie       Nazwisko        Pseudonim       Data stworzenia Nazwa serii
---------- --------------- --------------- --------------- ---------------
Siedziba
--------------------
WASYL      Parker          Spider-Man      62/08/10        MARVEL
New York, U.S.

James      Howlett         Wolverine       74/10/18        MARVEL
New York, U.S.

Victor     Creed           Sabretooth      77/08/12        MARVEL
New York, U.S.
*/

DELETE FROM V_DAN_OSO_BOHATEROW_MARVELA WHERE DAN_Imie = 'WASYL';

/*
1 wiersz został usunięty.
*/

SELECT * FROM V_DAN_OSO_BOHATEROW_MARVELA;

/*
Imie       Nazwisko        Pseudonim       Data stworzenia Nazwa serii
---------- --------------- --------------- --------------- ---------------
Siedziba
--------------------
Usuniete   Parker          Spider-Man      62/08/10        MARVEL
New York, U.S.

James      Howlett         Wolverine       74/10/18        MARVEL
New York, U.S.

Victor     Creed           Sabretooth      77/08/12        MARVEL
New York, U.S.
*/