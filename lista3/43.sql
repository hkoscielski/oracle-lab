--Zad. 43. Napisaæ blok, który zrealizuje zad. 33 w sposób uniwersalny 
--(bez koniecznoœci uwzglêdniania wiedzy o funkcjach pe³nionych przez koty). 

DECLARE
    CURSOR pelnione_funkcje IS
        SELECT DISTINCT funkcja
        FROM Kocury;
    CURSOR obsadzone_bandy IS
        SELECT DISTINCT Bandy.nr_bandy, Bandy.nazwa
        FROM Kocury LEFT JOIN Bandy ON Kocury.nr_bandy = Bandy.nr_bandy
        ORDER BY 2;
    plec_k Kocury.plec%TYPE;
    ile NUMBER;
    suma NUMBER;
BEGIN
    DBMS_OUTPUT.PUT(RPAD('NAZWA BANDY',18) || RPAD('PLEC',7) || LPAD('ILE',4));
    FOR funkcja IN pelnione_funkcje
    LOOP
        DBMS_OUTPUT.PUT(LPAD(funkcja.funkcja, 10));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(LPAD('SUMA', 8));
    DBMS_OUTPUT.PUT(LPAD(' ',18,'-') || LPAD(' ',7,'-') || LPAD(' ',5,'-'));
    FOR funkcja IN pelnione_funkcje
    LOOP
        DBMS_OUTPUT.PUT(LPAD(' ',10,'-'));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(LPAD(' ',8,'-'));
    
    FOR banda IN obsadzone_bandy
    LOOP        
        FOR i IN 1..2
        LOOP            
            IF i = 1 THEN
                plec_k := 'D';
                DBMS_OUTPUT.PUT(RPAD(banda.nazwa, 18));
                DBMS_OUTPUT.PUT(RPAD('Kotka', 7));
            ELSE
                plec_k := 'M';
                DBMS_OUTPUT.PUT(RPAD(' ', 18));
                DBMS_OUTPUT.PUT(RPAD('Kocur', 7));
            END IF;
            
            SELECT COUNT(*) INTO ile
            FROM Kocury 
            WHERE 
                Kocury.nr_bandy = banda.nr_bandy
                AND Kocury.plec = plec_k;            
            DBMS_OUTPUT.PUT(LPAD(ile, 4));
            
            FOR funkcja IN pelnione_funkcje
            LOOP
                SELECT SUM( CASE 
                                WHEN Kocury.funkcja = funkcja.funkcja THEN NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)
                                ELSE 0
                            END ) INTO suma
                FROM Kocury
                WHERE 
                    Kocury.nr_bandy = banda.nr_bandy
                    AND Kocury.plec = plec_k;
                DBMS_OUTPUT.PUT(LPAD(suma,10,' '));
            END LOOP;
                
            SELECT SUM(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)) INTO suma
                FROM Kocury
                WHERE 
                    Kocury.nr_bandy = banda.nr_bandy
                    AND Kocury.plec = plec_k;
                DBMS_OUTPUT.PUT_LINE(LPAD(suma,8,' '));               
        END LOOP;        
    END LOOP;    
    
    DBMS_OUTPUT.PUT(RPAD('Z',17,'-') || RPAD(' ',7,'-') || RPAD(' ',5,'-'));    
    FOR funkcja IN pelnione_funkcje
    LOOP
        DBMS_OUTPUT.PUT(RPAD(' ',10,'-'));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(RPAD(' ',8,'-'));
    
    DBMS_OUTPUT.PUT(RPAD('ZJADA RAZEM',17) || RPAD(' ',7) || RPAD(' ',5));
    FOR funkcja IN pelnione_funkcje
    LOOP
        SELECT SUM(NVL(przydzial_myszy,0) + NVL(myszy_extra,0)) INTO suma
        FROM Kocury WHERE Kocury.funkcja = funkcja.funkcja;
        DBMS_OUTPUT.PUT(LPAD(suma,10));
    END LOOP;
    SELECT SUM(NVL(przydzial_myszy,0) + NVL(myszy_extra,0)) INTO suma FROM Kocury;
    DBMS_OUTPUT.PUT_LINE(LPAD(suma,8));
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;