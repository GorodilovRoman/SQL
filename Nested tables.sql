---------------------------------------;
-- Kolekcje;
---------------------------------------;
DROP TABLE STWORZONE_OSOBY;
CREATE TABLE STWORZONE_OSOBY
(
in_st_oso				varchar2(60),
tab_z_dod_inf			varchar2(40)
)TABLESPACE STUDENT_DATA;


COLUMN in_st_oso                HEADING 'Imie i nazwisko'              		FORMAT A25;
COLUMN tab_z_dod_inf            HEADING 'Nazwa tabeli'              		FORMAT A15;


DROP TABLE WPISANE_LICZBY;
CREATE TABLE WPISANE_LICZBY
(
cena				number(3),
ilosc_stron			number(4),
nazwa_tabeli		varchar2(30)
)TABLESPACE STUDENT_DATA;


COLUMN cena            	    HEADING 'Cena'              		FORMAT 9999;
COLUMN ilosc_stron          HEADING 'Ilosc stron'              	FORMAT 9999;
COLUMN nazwa_tabeli         HEADING 'Nazwa tabeli'             	FORMAT A22;


DECLARE
TYPE tabela_imion IS TABLE OF VARCHAR2(20) index by binary_integer;
TYPE tabela_nazwisk IS TABLE OF VARCHAR2(40);
TYPE tabela_liczb IS TABLE OF NUMBER;
imie tabela_imion;
nazwisko tabela_nazwisk;
liczby tabela_liczb;
i number;
r number;
osoba STWORZONE_OSOBY.in_st_oso%TYPE;
cena WPISANE_LICZBY.cena%TYPE;
ilosc_stron WPISANE_LICZBY.ilosc_stron%TYPE;
im_wyj EXCEPTION;
naz_wyj EXCEPTION;
licz_wyj EXCEPTION;
BEGIN
imie(1) := 'Kavita';
imie(3) := 'Anton';
imie(4) := 'Artem';
imie(6) := 'Wladyslaw';
nazwisko := tabela_nazwisk('Artemenko', 'Davydov', 'Loshakov', 'Yermilov', 'Hlushkov', 'Gromowoj');
liczby := tabela_liczb(36, 42, 27, 29, 55);
i := 1;
	WHILE i < 25
	LOOP
	r := dbms_random.value(1,6);
	IF imie.exists(r) THEN
		UPDATE DANE_OSOBOWE
		SET DAN_Imie = imie(r)
		WHERE DANk_1_ID = i;
	ELSE raise im_wyj;
	END IF;
	IF SQL%NOTFOUND THEN
		IF nazwisko.exists(r) then
			INSERT INTO DANE_OSOBOWE(DANk_1_ID, DAN_Imie, DAN_Nazwisko, DAN_Plec)
			VALUES (i, imie(r), nazwisko(r), 'M')
			RETURNING CONCAT(CONCAT(imie(r), ' '), nazwisko(r)) INTO osoba;
			INSERT INTO STWORZONE_OSOBY
			VALUES (osoba, 'DANE_OSOBOWE');
		ELSE raise naz_wyj;
		END IF;
	END IF;
	IF liczby.exists(r) THEN
		UPDATE POWSZECHNA_INFORMACJA
		SET POW_cena_oryginalu = liczby(r)
		WHERE POWk_1_ID = i;
	ELSE raise licz_wyj;
	END IF;
	IF SQL%NOTFOUND THEN
			INSERT INTO POWSZECHNA_INFORMACJA(POWk_1_ID, POW_cena_oryginalu, POW_ilosc_stron)
			VALUES (i, liczby(r), liczby((r+2)/2))
			RETURNING POW_cena_oryginalu, POW_ilosc_stron INTO cena, ilosc_stron;
			INSERT INTO WPISANE_LICZBY
			VALUES (cena, ilosc_stron, 'POWSZECHNA_INFORMACJA');
	END IF;
	i := i + 1;
	END LOOP;
	EXCEPTION
	WHEN im_wyj then
		DBMS_OUTPUT.PUT_LINE('Nie istnieje takiej wartosci w kolejce, zostanie wygenerowane nowe imie');
		imie(r):=imie((r+2)/2);
	WHEN naz_wyj then
		DBMS_OUTPUT.PUT_LINE('Nie istnieje takiej wartosci w kolejce, zostanie wygenerowane nowe nazwisko');
		nazwisko(r):=((r+2)/2);
	WHEN licz_wyj then
		DBMS_OUTPUT.PUT_LINE('Nie istnieje takiej wartosci w kolejce, zostanie wygenerowana nowa liczba');
		liczby(r):=liczby((r+1)/2);
END;
/



/*
Imie i nazwisko           Nazwa tabeli
------------------------- ---------------
Artem Yermilov            DANE_OSOBOWE

 Cena Ilosc stron Nazwa tabeli
----- ----------- ----------------------
   55          27 POWSZECHNA_INFORMACJA
   55          29 POWSZECHNA_INFORMACJA
   27          42 POWSZECHNA_INFORMACJA
*/

/*
wynik stworzonego wyjatku:
Nie istnieje takiej wartosci w kolejce, zostanie wygenerowane nowe imie
*/



---------------------------------------;
-- Obsluga blendow;
---------------------------------------;

DECLARE
   COLLECTION_IS_NULL  EXCEPTION;
   PRAGMA EXCEPTION_INIT(COLLECTION_IS_NULL, -6531);
BEGIN
   NULL;
EXCEPTION
   WHEN COLLECTION_IS_NULL  THEN
      DBMS_OUTPUT.PUT_LINE('Kolekcja pusta');
END;
/

DECLARE
   NO_DATA_FOUND  EXCEPTION;
   PRAGMA EXCEPTION_INIT(NO_DATA_FOUND, +100);
BEGIN
   NULL;
EXCEPTION
   WHEN NO_DATA_FOUND  THEN
      DBMS_OUTPUT.PUT_LINE('Dany element nie instnieje');
END;
/





CREATE OR REPLACE TYPE t_var IS TABLE OF VARCHAR2(200);
/
CREATE OR REPLACE TYPE t_num IS TABLE OF NUMBER;
/
CREATE OR REPLACE PROCEDURE do_query_1 (
  placeholder t_var,
  bindvars t_var,
  sql_stmt VARCHAR2                    )
IS
  TYPE curtype IS REF CURSOR;
  src_cur      curtype;
  curid        NUMBER;
  bindnames    t_var;
  empnos       t_num;
  depts        t_num;
  ret          NUMBER;
  isopen       BOOLEAN;
BEGIN
  -- Open SQL cursor number:
  curid := DBMS_SQL.OPEN_CURSOR;

  -- Parse SQL cursor number: Parse sluzy do wykonania niektorych zadan przed tym jak bedzie mozna naprawde wykonac zapytanie
  DBMS_SQL.PARSE(curid, sql_stmt, DBMS_SQL.NATIVE);

  bindnames := placeholder;

  FOR i IN 1 .. bindnames.COUNT LOOP
    DBMS_SQL.BIND_VARIABLE(curid, bindnames(i), bindvars(i));
	--bindvariable jest wykorzystywany zeby zmniejszyc wykorzystanie zasobow:
	--samo analizowanie kosztuje czas procesora, a różne kursory zasypują wspólną pulę
  END LOOP;

  -- Execute SQL cursor number:
  ret := DBMS_SQL.EXECUTE(curid);

  -- Switch from DBMS_SQL to native dynamic SQL:
  src_cur := DBMS_SQL.TO_REFCURSOR(curid);
  FETCH src_cur BULK COLLECT INTO empnos, depts;

  -- ponizszy kod spowoduje blad poniewaz curid byl przetworzony do REF CURSOR:
  -- isopen := DBMS_SQL.IS_OPEN(curid);

  CLOSE src_cur;
END;
/





CREATE OR REPLACE PROCEDURE do_query_2 (sql_stmt VARCHAR2) IS
  TYPE curtype IS REF CURSOR;
  src_cur  curtype;
  curid    NUMBER;
  desctab  DBMS_SQL.DESC_TAB;
  colcnt   NUMBER;
  namevar  VARCHAR2(50);
  numvar   NUMBER;
  datevar  DATE;
  empno    NUMBER := 100;
BEGIN
  -- sql_stmt := SELECT ... FROM DANE_OSOBOWE WHERE DANk_1_ID < 10;

  -- Open REF CURSOR variable:
  OPEN src_cur FOR sql_stmt USING empno;

  -- Switch from native dynamic SQL to DBMS_SQL package:
  curid := DBMS_SQL.TO_CURSOR_NUMBER(src_cur);
  DBMS_SQL.DESCRIBE_COLUMNS(curid, colcnt, desctab);

  -- Define columns:
  FOR i IN 1 .. colcnt LOOP
    IF desctab(i).col_type = 2 THEN
      DBMS_SQL.DEFINE_COLUMN(curid, i, numvar);
    ELSIF desctab(i).col_type = 12 THEN
      DBMS_SQL.DEFINE_COLUMN(curid, i, datevar);
      -- statements
    ELSE
      DBMS_SQL.DEFINE_COLUMN(curid, i, namevar, 50);
    END IF;
  END LOOP;

  -- Fetch rows with DBMS_SQL package:
  WHILE DBMS_SQL.FETCH_ROWS(curid) > 0 LOOP
    FOR i IN 1 .. colcnt LOOP
      IF (desctab(i).col_type = 1) THEN
        DBMS_SQL.COLUMN_VALUE(curid, i, namevar);
      ELSIF (desctab(i).col_type = 2) THEN
        DBMS_SQL.COLUMN_VALUE(curid, i, numvar);
      ELSIF (desctab(i).col_type = 12) THEN
        DBMS_SQL.COLUMN_VALUE(curid, i, datevar);
        -- statements
      END IF;
    END LOOP;
  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(curid);
END;
/

BEGIN
	do_query_2('SELECT DAN_Imie FROM DANE_OSOBOWE WHERE DANk_1_ID = :b1');
END;
/