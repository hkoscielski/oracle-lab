--Zad. 44. Tygrysa zaniepokoi³o niewyt³umaczalne obni¿enie zapasów "myszowych". 
--Postanowi³ wiêc wprowadziæ podatek pog³ówny, który zasili³by spi¿arniê. 
--Zarz¹dzi³ wiêc, ¿e ka¿dy kot ma obowi¹zek oddawaæ 5% (zaokr¹glonych w górê) swoich ca³kowitych "myszowych" przychodów. 
--Dodatkowo od tego co pozostanie:
---  koty nie posiadaj¹ce podw³adnych oddaj¹ po dwie myszy za nieudolnoœæ w   
--   umizgach o awans,
---  koty nie posiadaj¹ce wrogów oddaj¹ po jednej myszy za zbytni¹  ugodowoœæ,
--    -  koty p³ac¹ dodatkowy podatek, którego formê okreœla wykonawca zadania.
--Napisaæ funkcjê, której parametrem jest pseudonim kota, wyznaczaj¹c¹ nale¿ny podatek pog³ówny kota. 
--Funkcjê t¹ razem z procedur¹ z zad. 40 nale¿y umieœciæ w pakiecie, a nastêpnie wykorzystaæ j¹ do okreœlenia podatku dla wszystkich kotów.

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
