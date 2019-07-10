------------------------------------------------;
-- Procedury insert z returning oraz dbms_random;
------------------------------------------------;


CREATE or REPLACE PROCEDURE d_o_insert (ile IN number)
IS 
	licznik number(4);
	I_OSO varchar2(30);
	dane DANE_OSOBOWE%ROWTYPE;
  imie DANE_OSOBOWE.DAN_Imie%TYPE;
  IL_STR POWSZECHNA_INFORMACJA.POW_ilosc_stron%TYPE;
  cena POWSZECHNA_INFORMACJA.POW_cena_oryginalu%type;
  CURSOR D1 IS SELECT DAN_Imie FROM DANE_OSOBOWE
	WHERE DANk_1_ID > 12;
  CURSOR P1 IS SELECT POW_ilosc_stron FROM POWSZECHNA_INFORMACJA
  WHERE POWk_1_ID > 1;
BEGIN
	licznik := 1;
WHILE licznik < ile+1
	LOOP
		INSERT INTO DANE_OSOBOWE(DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec, DAN_data_urodzenia, DAN_miejsce_urodzenia)
		VALUES (12 + licznik, 'Nowe imie NR'||licznik, 'Nowe nazwisko NR'||licznik, 'P NR'||licznik,
		TO_DATE(TRUNC(DBMS_RANDOM.VALUE(2425978,2425978+364*89)),'J'), 'Nowa lokalizacja NR'||licznik)
		RETURNING DANE_OSOBOWE.DAN_Imie INTO I_OSO;
		licznik := licznik + 1;
	END LOOP;
WHILE licznik < ile+1
	LOOP
		INSERT INTO POWSZECHNA_INFORMACJA(POWk_1_ID, POW_cena_oryginalu, POW_ilosc_stron, POW_material_okladki, POW_rodzaj_papieru)
		VALUES (1 + licznik, dbms_random.value(5,38) + licznik||cena, round(dbms_random.value(150,380))+licznik||IL_STR,
		'Nowy material NR'||licznik, 'Nowy rodzaj NR'||licznik)
    RETURNING POWSZECHNA_INFORMACJA.POW_ilosc_stron INTO IL_STR;
		licznik := licznik + 1;
	END LOOP;
  OPEN D1;
	LOOP
    FETCH D1 INTO I_OSO;
    EXIT WHEN D1%NOTFOUND;
	DBMS_OUTPUT.PUT_LINE('Wprowadzono osobe '||I_OSO);
	END LOOP;
	CLOSE D1;
  OPEN P1;
	LOOP
    FETCH P1 INTO IL_STR;
    EXIT WHEN P1%NOTFOUND;
	DBMS_OUTPUT.PUT_LINE('Wprowadzono informacje z iloscia stron '||IL_STR);
	END LOOP;
	CLOSE P1;
END;
/
 
BEGIN
	d_o_insert(5);
END;
/

/*
Wprowadzono osobe Nowe imie NR1
Wprowadzono osobe Nowe imie NR2
Wprowadzono osobe Nowe imie NR3
Wprowadzono osobe Nowe imie NR4
Wprowadzono osobe Nowe imie NR5
*/





---------------------------------------;
-- Procedura update z dbms_random;
---------------------------------------;

CREATE or REPLACE PROCEDURE d_o_update (ile IN number)
IS 
	licznik number(4);
	dane DANE_OSOBOWE%ROWTYPE;
BEGIN
	licznik := 1;
WHILE licznik < ile+1
	LOOP
		UPDATE DANE_OSOBOWE
		SET DAN_data_urodzenia = TO_DATE(TRUNC(DBMS_RANDOM.VALUE(2425978,2425978+364*89)),'J')
		WHERE DANk_1_ID = 12 + licznik;
		IF SQL%NOTFOUND THEN
			INSERT INTO DANE_OSOBOWE(DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec, DAN_data_urodzenia, DAN_miejsce_urodzenia)
		VALUES (12 + licznik, 'Nowe imie NR'||licznik, 'Nowe nazwisko NR'||licznik, 'P NR'||licznik,
		TO_DATE(TRUNC(DBMS_RANDOM.VALUE(2425978,2425978+364*89)),'J'), 'Nowa lokalizacja NR'||licznik);
		END IF;
		licznik := licznik + 1;
	END LOOP;
END;
/
 
BEGIN
	d_o_update(10);
END;
/

CREATE OR REPLACE PROCEDURE kur_DO_U
IS
	data_ur DANE_OSOBOWE.DAN_data_urodzenia%TYPE;
	CURSOR D2 IS SELECT DAN_data_urodzenia FROM DANE_OSOBOWE
	WHERE DANk_1_ID > 12;
BEGIN
	OPEN D2;
	LOOP
    FETCH D2 INTO data_ur;
    EXIT WHEN D2%NOTFOUND;
	DBMS_OUTPUT.PUT_LINE( 'Nowa data urodzenia '|| data_ur);
	END LOOP;
	CLOSE D2;
END;
/

BEGIN
	kur_DO_U;
END;
/

/*
Nowa data urodzenia 13-OCT-41
Nowa data urodzenia 16-JAN-42
Nowa data urodzenia 13-MAR-60
Nowa data urodzenia 28-SEP-70
Nowa data urodzenia 08-FEB-50
Nowa data urodzenia 20-SEP-78
Nowa data urodzenia 14-JUL-84
Nowa data urodzenia 20-APR-61
Nowa data urodzenia 07-NOV-03
Nowa data urodzenia 15-APR-94
*/





---------------------------------------;
-- Procedura do generowania danych, ich weryfikacji i wykorzystania do wstawiania;
---------------------------------------;

CREATE or REPLACE PROCEDURE d_o_update_2
(	id IN DANE_OSOBOWE.DANk_1_ID%TYPE,
	imie_p IN DANE_OSOBOWE.DAN_Imie%TYPE,
	nazwisko_p IN DANE_OSOBOWE.DAN_Nazwisko%TYPE,
	plec_p IN DANE_OSOBOWE.DAN_Plec%TYPE)
	IS
BEGIN
		UPDATE DANE_OSOBOWE
		SET DAN_Imie = imie_p,
		DAN_Nazwisko = nazwisko_p,
		DAN_Plec = plec_p
		WHERE DANk_1_ID = id;
		IF SQL%NOTFOUND THEN
			INSERT INTO DANE_OSOBOWE(DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec, DAN_data_urodzenia, DAN_miejsce_urodzenia)
		VALUES (id, 'Nowe imie o ID '||id, 'Nowe nazwisko o ID '||id, 'P o ID'||id,
		TO_DATE(TRUNC(DBMS_RANDOM.VALUE(2425978,2425978+364*89)),'J'), 'Nowa lokalizacja o ID'||id);
		END IF;
END;
/

CREATE OR REPLACE PROCEDURE generacja_random
IS
	id number(4);
	random_plec NUMBER(1);
	plec_p DANE_OSOBOWE.DAN_Plec%TYPE;
	random_imie NUMBER(2);
	imie_p DANE_OSOBOWE.DAN_Imie%TYPE;
	random_nazwisko NUMBER(2);
	nazwisko_p DANE_OSOBOWE.DAN_Nazwisko%TYPE;
	/*ilosc_wpr_rek number(4);*/
	oso_p varchar2(100);
	CURSOR kurOso
	IS
	SELECT DAN_Imie FROM DANE_OSOBOWE
	WHERE DAN_Imie = imie_p AND DAN_Nazwisko = nazwisko_p AND DAN_Plec = plec_p;
BEGIN
	id := dbms_random.value(1,20);
	random_plec := dbms_random.value(0,1);
	IF random_plec=0 THEN
		plec_p := 'K';
	ELSE
		plec_p := 'M';
	END IF;
	random_imie := dbms_random.value(0,7);
	IF random_imie = 0 THEN
	imie_p := 'Artem';
	ELSIF random_imie = 1 THEN
	imie_p := 'Anton';
	ELSIF random_imie = 2 THEN
	imie_p := 'Arek';
	ELSIF random_imie = 3 THEN
	imie_p := 'Vasyl';
	ELSIF random_imie = 4 THEN
	imie_p := 'Vladyslav';
	ELSIF random_imie = 5 THEN
	imie_p := 'Roman';
	ELSIF random_imie = 6 THEN
	imie_p := 'Pawel';
	ELSIF random_imie = 7 THEN
	imie_p := 'Oleh';
	END IF;
	random_nazwisko := dbms_random.value(0,4);
	IF random_nazwisko = 0 THEN
	nazwisko_p := 'Hlushkov';
	ELSIF random_nazwisko = 1 THEN
	nazwisko_p := 'Gorodilov';
	ELSIF random_nazwisko = 2 THEN
	nazwisko_p := 'Yermilov';
	ELSIF random_nazwisko = 3 THEN
	nazwisko_p := 'Loshakov';
	ELSIF random_nazwisko = 4 THEN
	nazwisko_p := 'Muliarchuk';
	END IF;
	/*ilosc_wpr_rek := dbms_random.value(3,6);
	licznik := 1;
	WHILE licznik < ilosc_wpr_rek
	LOOP
		random_plec := dbms_random.value(0,1);
		random_imie := dbms_random.value(0,7);
		random_nazwisko := dbms_random.value(0,4);*/
		oso_p := CONCAT(CONCAT(imie_p, ' '), nazwisko_p);
		d_o_update_2(id, imie_p, nazwisko_p, plec_p);
	/*licznik := licznik + 1;
	END LOOP;*/
	OPEN kurOso;
	LOOP
    FETCH kurOso INTO oso_p;
    EXIT WHEN kurOso%NOTFOUND;
	DBMS_OUTPUT.PUT_LINE('Nowa osoba: ' ||oso_p);
	END LOOP;
	CLOSE kurOso;
END;
/

BEGIN
	generacja_random;
END;
/

/*
Nowa osoba: Roman
*/