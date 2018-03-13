--Zad. 38. Napisaæ blok, który zrealizuje wersjê a. lub wersjê b. zad. 19 w sposób uniwersalny 
--(bez koniecznoœci uwzglêdniania wiedzy o g³êbokoœci drzewa). 
--Dan¹ wejœciow¹ ma byæ maksymalna liczba wyœwietlanych prze³o¿onych.
--
--Przyk³ady wynik dla liczby prze³o¿onych = 5
--
--Imie           |  Szef 1         |  Szef 2         |  Szef 3
--------------- --- ------------- --- ------------- --- -------------
--RUDA           |  MRUCZEK        |                 |
--BELA           |  BOLEK          |  MRUCZEK        |
--MICKA          |  MRUCZEK        |                 |
--LUCEK          |  PUNIA          |  KOREK          |  MRUCZEK
--SONIA          |  KOREK          |  MRUCZEK        |
--LATKA          |  PUCEK          |  MRUCZEK        |
--DUDEK          |  PUCEK          |  MRUCZEK        |
--
--Przyk³ady wynik dla liczby prze³o¿onych = 2
--
--Imie           |  Szef 1         |  Szef 2
--------------- --- ------------- --- -------------
--RUDA           |  MRUCZEK        |
--BELA           |  BOLEK          |  MRUCZEK
--MICKA          |  MRUCZEK        |
--LUCEK          |  PUNIA          |  KOREK
--SONIA          |  KOREK          |  MRUCZEK
--LATKA          |  PUCEK          |  MRUCZEK
--DUDEK          |  PUCEK          |  MRUCZEK

DECLARE
    poziom NUMBER:=&lvl;    
    current_lvl NUMBER DEFAULT 1;
    max_lvl NUMBER DEFAULT 0;
    niepoprawny_poziom EXCEPTION;
    kot Kocury%ROWTYPE;
BEGIN
    SELECT MAX(level)-1 INTO max_lvl
    FROM Kocury
    CONNECT BY PRIOR pseudo = szef
    START WITH SZEF IS NULL;
    
    IF poziom < 0 THEN 
        RAISE niepoprawny_poziom;
    END IF;    
    
    DBMS_OUTPUT.PUT_LINE('Przykladowy wynik dla liczby przelozonych = ' || poziom);
    DBMS_OUTPUT.PUT_LINE(' ');
    
    IF poziom > max_lvl THEN 
        poziom:=max_lvl;
    END IF;
    
    DBMS_OUTPUT.PUT(RPAD('Imie', 14));
    
    FOR i IN 1..poziom
    LOOP
        DBMS_OUTPUT.PUT(' | ' || RPAD(' Szef ' || i, 15));        
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(' ');    
    DBMS_OUTPUT.PUT(LPAD(' ', 14, '-'));
    
    FOR i IN 1..poziom
    LOOP
        DBMS_OUTPUT.PUT(LPAD(' ', 4, '-') || LPAD(' ', 14, '-'));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(' ');  
    
    FOR rekord IN (SELECT * FROM Kocury
                WHERE funkcja IN ('KOT', 'MILUSIA'))
    LOOP
        current_lvl:=1;
        DBMS_OUTPUT.PUT(RPAD(rekord.imie, 14));   
        kot:=rekord;
        WHILE current_lvl <= poziom
        LOOP            
            IF kot.szef IS NULL THEN
                DBMS_OUTPUT.PUT(' | ' || RPAD(' ', 15));
            ELSE
                SELECT * INTO kot FROM Kocury WHERE pseudo = kot.szef;
                DBMS_OUTPUT.PUT(' | ' || RPAD(' ' || kot.imie, 15));
            END IF;
            current_lvl:=current_lvl + 1;            
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
    
EXCEPTION
    WHEN niepoprawny_poziom
        THEN DBMS_OUTPUT.PUT_LINE('Wprowadzono niewlasciwa liczbe przelozonych');
    WHEN OTHERS 
        THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
