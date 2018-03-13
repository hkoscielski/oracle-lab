--Zad. 39. Napisaæ blok PL/SQL wczytuj¹cy trzy parametry reprezentuj¹ce nr bandy, nazwê bandy oraz teren polowañ. 
--Skrypt ma uniemo¿liwiaæ wprowadzenie istniej¹cych ju¿ wartoœci parametrów poprzez obs³ugê odpowiednich wyj¹tków. 
--Sytuacj¹ wyj¹tkow¹ jest tak¿e wprowadzenie numeru bandy <=0. 
--W przypadku zaistnienia sytuacji wyj¹tkowej nale¿y wyprowadziæ na ekran odpowiedni komunikat. 
--W przypadku prawid³owych parametrów nale¿y stworzyæ now¹ bandê w relacji Bandy. Zmianê nale¿y na koñcu wycofaæ.
--
--Przyk³adowe wyniki:
--
--2, CZARNI RYCERZE, POLE: juz istnieje
--
--1, SZEFOSTWO: juz istnieje
--
--SAD: juz istnieje

DECLARE 
    nrb Bandy.nr_bandy%TYPE:=&nr_bandy;
    nazwab Bandy.nazwa%TYPE:='&nazwa_bandy';
    terenb Bandy.teren%TYPE:='&teren';    
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

ROLLBACK;

SELECT * FROM Bandy;