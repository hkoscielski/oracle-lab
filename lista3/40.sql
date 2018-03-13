--Zad. 40. Przerobiæ blok z zadania 39 na procedurê umieszczon¹ w bazie danych.

CREATE OR REPLACE PROCEDURE wstaw_nowa_bande
    (nrb Bandy.nr_bandy%TYPE, nazwab Bandy.nazwa%TYPE, terenb Bandy.teren%TYPE)
IS
    ile NUMBER:=0;
    blad VARCHAR2(256):='';
    niewlasciwy_nr EXCEPTION;
    powtorzone_dane EXCEPTION;
BEGIN
    IF nrb <= 0
        THEN RAISE niewlasciwy_nr;
    END IF;
    
    SELECT COUNT(*) INTO ile
    FROM Bandy
    WHERE nr_bandy = nrb;
    IF ile > 0 THEN
        blad := TO_CHAR(nrb);
    END IF;
    
    SELECT COUNT(*) INTO ile
    FROM Bandy
    WHERE nazwa = nazwab;    
    IF ile > 0 THEN
        IF LENGTH(blad) > 0 THEN
            blad := blad || ', ' || nazwab;
        ELSE
            blad := nazwab;
        END IF;
    END IF;
    
    SELECT COUNT(*) INTO ile
    FROM Bandy
    WHERE teren = terenb;    
    IF ile > 0 THEN
        IF LENGTH(blad) > 0 THEN
            blad := blad || ', ' || terenb;
        ELSE
            blad := terenb;
        END IF;
    END IF;
    
    IF LENGTH(blad) > 0
        THEN RAISE powtorzone_dane;
    END IF;
    
    INSERT INTO Bandy (nr_bandy, nazwa, teren)
    VALUES (nrb, nazwab, terenb);    
EXCEPTION
    WHEN niewlasciwy_nr 
        THEN DBMS_OUTPUT.PUT_LINE('Numer bandy musi byc wiekszy od 0');
    WHEN powtorzone_dane
        THEN DBMS_OUTPUT.PUT_LINE(blad || ': juz istnieje');
    WHEN OTHERS 
        THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

BEGIN
    wstaw_nowa_bande(5,'BANDA','MORZE');
END;

ROLLBACK;

SELECT * FROM Bandy;