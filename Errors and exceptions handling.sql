---------------------------------------;
-- Rekord z referencja do kursora;
---------------------------------------;

DECLARE
   TYPE dan_cur_typ1 IS REF CURSOR RETURN DANE_OSOBOWE%ROWTYPE;
   dan_cv1 dan_cur_typ1;
BEGIN
   IF NOT dan_cv1%ISOPEN THEN  -- open cursor variable
      OPEN dan_cv1 FOR SELECT * FROM DANE_OSOBOWE;
   END IF;
   CLOSE dan_cv1;
END;
/


DECLARE
   TYPE dan_cur_typ2 IS REF CURSOR RETURN DANE_OSOBOWE%ROWTYPE;
   oso dan_cur_typ2;
   PROCEDURE process_emp_cv (emp_cv IN dan_cur_typ2) IS
      osoba DANE_OSOBOWE%ROWTYPE;
   BEGIN
      DBMS_OUTPUT.PUT_LINE('--------------------------------');
      DBMS_OUTPUT.PUT_LINE
        ('Imiona i nazwiska wybranych osob');
      LOOP
         FETCH emp_cv INTO osoba;
         EXIT WHEN emp_cv%NOTFOUND;
         DBMS_OUTPUT.PUT_LINE('Osoba NR '||osoba.DANk_1_ID|| ' ' || osoba.DAN_Imie ||
                              ' ' || osoba.DAN_Nazwisko);
      END LOOP;
   END;
BEGIN
  OPEN oso FOR SELECT * FROM DANE_OSOBOWE WHERE ROWNUM < 11;
  process_emp_cv(oso);
  CLOSE oso;
  OPEN oso FOR SELECT * FROM DANE_OSOBOWE WHERE DAN_Nazwisko LIKE 'P%';
  process_emp_cv(oso);
  CLOSE oso;
END;
/

/*
--------------------------------
Imiona i nazwiska wybranych osob
Osoba NR 1 Isaac Perlmutter
Osoba NR 2 Diane Nelson
Osoba NR 3 Stan Lee
Osoba NR 4 Steve Ditko
Osoba NR 5 Leonard Wein
Osoba NR 6 John Romita
Osoba NR 7 Herbert Trimpe
Osoba NR 8 Jack Kirby
Osoba NR 9 Peter Parker
Osoba NR 10 James Howlett
--------------------------------
Imiona i nazwiska wybranych osob
Osoba NR 1 Isaac Perlmutter
Osoba NR 9 Peter Parker

PL/SQL procedure successfully completed.
*/





DECLARE
	TYPE gencurtyp IS REF CURSOR;
	zm gencurtyp;
	PROCEDURE open_cv (generic_cv IN OUT gencurtyp, choice INT) IS
	BEGIN
      IF choice = 1 THEN
         OPEN generic_cv FOR SELECT * FROM DANE_OSOBOWE;
		 DBMS_OUTPUT.PUT_LINE('Do kursora zastely wprowadzone dane z tabeli DANE_OSOBOWE');
      ELSIF choice = 2 THEN
         OPEN generic_cv FOR SELECT * FROM POWSZECHNA_INFORMACJA;
		 DBMS_OUTPUT.PUT_LINE('Do kursora zastaly wprowadzone dane z tabeli POWSZECHNA_INFORMACJA');
      ELSIF choice = 3 THEN
         OPEN generic_cv FOR SELECT * FROM SERIA;
		 DBMS_OUTPUT.PUT_LINE('Do kursora zastely wprowadzone dane z tabeli SERIA');
      END IF;
	END;
BEGIN
	OPEN zm FOR SELECT * FROM KOMIKS;
	CLOSE zm;
	open_cv(zm, 2);
END;
/

/*
Do kursora zastaly wprowadzone dane z tabeli POWSZECHNA_INFORMACJA

PL/SQL procedure successfully completed.
*/





---------------------------------------;
-- Obsluga blendow;
---------------------------------------;

DECLARE
   invalid_cursor  EXCEPTION;
   PRAGMA EXCEPTION_INIT(invalid_cursor, -1001);
BEGIN
   NULL;
EXCEPTION
   WHEN invalid_cursor  THEN
      DBMS_OUTPUT.PUT_LINE('Niepoprawna operacja na kursorze');
END;
/

DECLARE
	TYPE gencurtyp IS REF CURSOR;
	zm gencurtyp;
	TYPE dan_cur_typ2 IS REF CURSOR RETURN DANE_OSOBOWE%ROWTYPE;
	oso dan_cur_typ2;
BEGIN
	IF zm%ISOPEN THEN
		raise_application_error(-6511, 'Kursor już został otwarty');
	ELSE
		NULL;
	END IF;
	IF oso%ISOPEN THEN
		raise_application_error(-6511, 'Kursor już został otwarty');
	ELSE
		NULL;
	END IF;
END;
/




----------------------------------------------;
-- Obsluga blendow za pomocy format_call_stack;
----------------------------------------------;

BEGIN
	DBMS_OUTPUT.PUT_LINE(dbms_utility.format_call_stack());
END;
/

DECLARE
  myException EXCEPTION;
  FUNCTION innerFunction
  RETURN BOOLEAN IS
    retval BOOLEAN := FALSE;
BEGIN
  RAISE myException;
  RETURN retval;
END;
BEGIN
 IF innerFunction THEN
   dbms_output.put_line('No raised exception');
 END IF;
EXCEPTION
 WHEN others THEN
   dbms_output.put_line('DBMS_UTILITY.FORMAT_ERROR_STACK');
   dbms_output.put_line(dbms_utility.format_error_stack);
END;
/

declare
    type vcArray is table of varchar2(30);
	l_types vcArray := vcArray( null, null, null, null, 'synonym',null, 'procedure', 'function','package' );
	l_schema   varchar2(30);
	l_part1    varchar2(30);
	l_part2    varchar2(30);
	l_dblink   varchar2(30);
    l_type     number;
    l_obj#     number;
begin
    dbms_utility.name_resolve( name => 'DBMS_UTILITY',
                               context       => 1,
                               schema        => l_schema,
                               part1         => l_part1,
                               part2         => l_part2,
                               dblink        => l_dblink,
                               part1_type    => l_type,
                               object_number => l_obj# );
    if l_obj# IS NULL
    then
      dbms_output.put_line('Object not found or not valid.');
    else
      dbms_output.put( l_schema || '.' || nvl(l_part1,l_part2) );
      if l_part2 is not null and l_part1 is not null
      then
          dbms_output.put( '.' || l_part2 );
      end if;
      dbms_output.put_line( ' is a ' || l_types( l_type ) ||
                            ' with object id ' || l_obj# ||
                            ' and dblink "' || l_dblink || '"' );
    end if;
end;
/

/*
SYS.DBMS_UTILITY is a package with object id 8104 and dblink ""
*/

DECLARE
     local_exception EXCEPTION;
     FUNCTION nested_local_function
     RETURN BOOLEAN IS
       retval BOOLEAN := FALSE;
BEGIN
       RAISE local_exception;
       RETURN retval;
END;
BEGIN
       IF nested_local_function THEN
         dbms_output.put_line('No raised exception');
       END IF;
     EXCEPTION
       WHEN others THEN
         dbms_output.put_line('DBMS_UTILITY.FORMAT_CALL_STACK');
         dbms_output.put_line('------------------------------');
         dbms_output.put_line(dbms_utility.format_call_stack);
         dbms_output.put_line('DBMS_UTILITY.FORMAT_ERROR_BACKTRACE');
         dbms_output.put_line('-----------------------------------');
         dbms_output.put_line(dbms_utility.format_error_backtrace);
         dbms_output.put_line('DBMS_UTILITY.FORMAT_ERROR_STACK');
         dbms_output.put_line('-------------------------------');
         dbms_output.put_line(dbms_utility.format_error_stack);
END;
/

/*
DBMS_UTILITY.FORMAT_CALL_STACK
------------------------------
----- PL/SQL Call Stack -----
  object      line  object
  handle    number
name
0xf85e7b948        18  anonymous block

DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
-----------------------------------
ORA-06512: at line 7
ORA-06512: at line 11

DBMS_UTILITY.FORMAT_ERROR_STACK
-------------------------------
ORA-06510: PL/SQL: unhandled user-defined exception*/