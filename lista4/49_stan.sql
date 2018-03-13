CREATE OR REPLACE PROCEDURE PRZYJMIJ_MYSZY_NA_STAN(ps Kocury.pseudo%TYPE) AS 
  max_nr_myszy NUMBER; 
  czy_istnieje NUMBER; 
  zapytanie VARCHAR2(2000); 
  
  TYPE myszy_wiersz IS RECORD (nr_myszy myszy.nr_myszy%TYPE, lowca myszy.lowca%TYPE, 
                               waga_myszy myszy.waga_myszy%TYPE, data_zlowienia Myszy.data_zlowienia%TYPE); 
  TYPE tablica_myszy IS TABLE OF myszy_wiersz INDEX BY BINARY_INTEGER; 
  dane_myszy tablica_myszy; 
  
  kocur_notfound EXCEPTION; 
BEGIN 
  SELECT COUNT(*) INTO czy_istnieje FROM kocury WHERE pseudo = ps; 
  IF czy_istnieje = 0 THEN 
    RAISE kocur_notfound; 
  END IF; 
  
  SELECT NVL(MAX(nr_myszy),0) INTO max_nr_myszy FROM myszy;
  
  zapytanie:='SELECT * FROM myszy_' || ps;
  EXECUTE IMMEDIATE zapytanie 
  BULK COLLECT INTO dane_myszy;
   
  FOR i IN 1..dane_myszy.COUNT 
  LOOP 
    max_nr_myszy:=max_nr_myszy+1;
    dane_myszy(i).nr_myszy := max_nr_myszy;       
  END LOOP; 
    
  FORALL j IN 1..dane_myszy.COUNT SAVE EXCEPTIONS 
  INSERT INTO myszy(nr_myszy, lowca, zjadacz, waga_myszy, data_zlowienia, data_wydania) 
  VALUES(dane_myszy(j).nr_myszy, dane_myszy(j).lowca, null, dane_myszy(j).waga_myszy, dane_myszy(j).data_zlowienia, null);
    
  zapytanie:='DELETE FROM myszy_' || ps;
  EXECUTE IMMEDIATE zapytanie;
EXCEPTION 
  WHEN kocur_notfound THEN DBMS_OUTPUT.PUT_LINE('Nie ma takiego kota w stadzie'); 
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM); 
END;