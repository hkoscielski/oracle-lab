-- Dodawanie do indywidualnych

DECLARE
    TYPE myszy_wiersz IS RECORD (nr_myszy Myszy.nr_myszy%TYPE, lowca Myszy.lowca%TYPE, 
                                waga_myszy Myszy.waga_myszy%TYPE, data_zlowienia Myszy.data_zlowienia%TYPE); 
    TYPE tablica_myszy IS TABLE OF myszy_wiersz INDEX BY BINARY_INTEGER; 
    dane_myszy tablica_myszy; 
    
    lw NUMBER;
    aktualna DATE := SYSDATE;
    upolowane NUMBER;
    max_nr_myszy NUMBER;
    zapytanie VARCHAR2(150);
    ps VARCHAR2(15) := 'RURA';
    czy_istnieje NUMBER;    
    kocur_notfound EXCEPTION;
BEGIN
    SELECT COUNT(pseudo) INTO czy_istnieje FROM Kocury WHERE pseudo = ps; 
    IF czy_istnieje = 0 THEN 
       RAISE kocur_notfound; 
    END IF;
    upolowane := DBMS_RANDOM.VALUE(1,30);   
    SELECT NVL(MAX(nr_myszy),0) INTO max_nr_myszy FROM Myszy_Rura;
    FOR i in 1..upolowane
    LOOP
        max_nr_myszy:=max_nr_myszy+1; 
        dane_myszy(i).nr_myszy := max_nr_myszy;
        dane_myszy(i).lowca := ps;
        dane_myszy(i).waga_myszy := DBMS_RANDOM.VALUE(30,60); 
        dane_myszy(i).data_zlowienia := aktualna;                 
    END LOOP;    
    
    FORALL j IN 1..dane_myszy.COUNT SAVE EXCEPTIONS 
    INSERT INTO Myszy_Rura(nr_myszy, lowca, waga_myszy, data_zlowienia) 
    VALUES(dane_myszy(j).nr_myszy, dane_myszy(j).lowca, dane_myszy(j).waga_myszy, dane_myszy(j).data_zlowienia);
    
EXCEPTION
    WHEN kocur_notfound THEN DBMS_OUTPUT.PUT_LINE('Nie znaleziono kota o takim pseudonimie');
    lw:=SQL%BULK_EXCEPTIONS.COUNT;
       FOR i IN 1..lw
       LOOP
         DBMS_OUTPUT.PUT_LINE('Blad '||i||': myszka '||
           SQL%BULK_EXCEPTIONS(i).error_index||' - '||
           SQLERRM(-SQL%BULK_EXCEPTIONS(i).error_code));
       END LOOP;

    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM); 
END;