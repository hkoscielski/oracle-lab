-- Wypelnij danymi

DECLARE
    TYPE dane_kota IS RECORD (pseudo kocury.pseudo%TYPE, myszy NUMBER(3)); 
    TYPE tablica_kotow IS TABLE OF dane_kota INDEX BY BINARY_INTEGER; 
    koty tablica_kotow;
    
    TYPE myszy_wiersz IS RECORD (nr_myszy myszy.nr_myszy%TYPE, lowca myszy.lowca%TYPE, 
                                zjadacz myszy.zjadacz%TYPE, waga_myszy myszy.waga_myszy%TYPE, 
                                data_zlowienia Myszy.data_zlowienia%TYPE, data_wydania Myszy.data_wydania%TYPE); 
    TYPE tablica_myszy IS TABLE OF myszy_wiersz INDEX BY BINARY_INTEGER; 
    dane_myszy tablica_myszy; 
    
    sroda DATE := '04/01/01'; 
    nastepny_dzien DATE; 
    ile_poluja NUMBER; 
    l_myszy BINARY_INTEGER := 1; 
    przydzielone BINARY_INTEGER := 1; 
BEGIN 
    WHILE sroda < SYSDATE 
    LOOP 
        nastepny_dzien := sroda+1; 
        sroda := (NEXT_DAY(LAST_DAY(ADD_MONTHS(sroda, 1)) - 7, 'Œroda')); 
        
        SELECT pseudo, NVL(przydzial_myszy,0) + NVL(myszy_extra,0) 
        BULK COLLECT INTO koty 
        FROM Kocury 
        WHERE w_stadku_od <= nastepny_dzien;
        
        SELECT ROUND(AVG(NVL(przydzial_myszy,0) + NVL(myszy_extra,0))+0.5) 
        INTO ile_poluja
        FROM kocury 
        WHERE w_stadku_od <= nastepny_dzien; 
        
        przydzielone:=l_myszy;
        FOR j IN 1..koty.COUNT 
            LOOP 
            FOR k IN 1..ile_poluja
            LOOP 
                dane_myszy(l_myszy).nr_myszy := l_myszy;
                dane_myszy(l_myszy).lowca := koty(j).pseudo;
                dane_myszy(l_myszy).waga_myszy := DBMS_RANDOM.VALUE(30,60); 
                dane_myszy(l_myszy).data_zlowienia := nastepny_dzien + DBMS_RANDOM.VALUE(0,28); 
                dane_myszy(l_myszy).data_wydania := sroda; 
                l_myszy:=l_myszy+1; 
            END LOOP;
        END LOOP; 
    
        FOR j IN 1..koty.COUNT 
        LOOP 
            FOR k IN 1..koty(j).myszy 
            LOOP 
                dane_myszy(przydzielone).zjadacz := koty(j).pseudo; 
                przydzielone:=przydzielone+1; 
            END LOOP; 
        END LOOP;
    
        WHILE przydzielone < l_myszy 
        LOOP 
            dane_myszy(przydzielone).zjadacz := 'TYGRYS'; 
            przydzielone:=przydzielone+1; 
        END LOOP; 
    END LOOP; 

    FORALL j IN 1..dane_myszy.COUNT SAVE EXCEPTIONS 
    INSERT INTO myszy(nr_myszy, lowca, zjadacz, waga_myszy, data_zlowienia, data_wydania) 
    VALUES(dane_myszy(j).nr_myszy, dane_myszy(j).lowca, dane_myszy(j).zjadacz, dane_myszy(j).waga_myszy, dane_myszy(j).data_zlowienia, dane_myszy(j).data_wydania);

EXCEPTION 
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM); 
END;
