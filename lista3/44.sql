--Zad. 44. Tygrysa zaniepokoi�o niewyt�umaczalne obni�enie zapas�w "myszowych". 
--Postanowi� wi�c wprowadzi� podatek pog��wny, kt�ry zasili�by spi�arni�. 
--Zarz�dzi� wi�c, �e ka�dy kot ma obowi�zek oddawa� 5% (zaokr�glonych w g�r�) swoich ca�kowitych "myszowych" przychod�w. 
--Dodatkowo od tego co pozostanie:
---  koty nie posiadaj�ce podw�adnych oddaj� po dwie myszy za nieudolno�� w   
--   umizgach o awans,
---  koty nie posiadaj�ce wrog�w oddaj� po jednej myszy za zbytni�  ugodowo��,
--    -  koty p�ac� dodatkowy podatek, kt�rego form� okre�la wykonawca zadania.
--Napisa� funkcj�, kt�rej parametrem jest pseudonim kota, wyznaczaj�c� nale�ny podatek pog��wny kota. 
--Funkcj� t� razem z procedur� z zad. 40 nale�y umie�ci� w pakiecie, a nast�pnie wykorzysta� j� do okre�lenia podatku dla wszystkich kot�w.

CREATE OR REPLACE PACKAGE Zad44 AS
    PROCEDURE wstaw_nowa_bande
        (nrb Bandy.nr_bandy%TYPE, nazwab Bandy.nazwa%TYPE, terenb Bandy.teren%TYPE);
    FUNCTION podatek_poglowny
        (pseudonim Kocury.pseudo%TYPE)
        RETURN NUMBER;
END Zad44;
/
CREATE OR REPLACE PACKAGE BODY Zad44 AS
    PROCEDURE wstaw_nowa_bande
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
    
    FUNCTION podatek_poglowny
        (pseudonim Kocury.pseudo%TYPE)
        RETURN NUMBER
    IS
        podatek NUMBER;
        ile NUMBER;
    BEGIN
        SELECT ROUND(0.05 * (NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))) INTO podatek
        FROM Kocury WHERE pseudo = pseudonim;
        
        SELECT COUNT(pseudo) INTO ile
        FROM Kocury WHERE szef = pseudonim;
        IF ile = 0 THEN 
            podatek := podatek + 2;
        END IF;
        
        SELECT COUNT(*) INTO ile 
        FROM Wrogowie_Kocurow WHERE pseudo = pseudonim;
        IF ile = 0 THEN 
            podatek := podatek + 1;
        END IF;
        
        SELECT COUNT(pseudo) INTO ile
        FROM Kocury 
        WHERE 
            pseudo = pseudonim
            AND funkcja != 'MILUSIA';
        IF ile = 0 THEN 
            podatek := podatek + 3;
        END IF;
        
        RETURN podatek;
    END;
END Zad44;

DECLARE
    ile NUMBER;
BEGIN 
    ile := Zad44.podatek_poglowny('LYSY');
    DBMS_OUTPUT.PUT_LINE(ile);
END;
