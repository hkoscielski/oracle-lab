CREATE OR REPLACE PROCEDURE WYPLATA AS    
  sroda DATE := (NEXT_DAY(LAST_DAY(SYSDATE) - 7, 'Œroda')); 
  l1 NUMBER := 1; 
  l2 NUMBER := 1; 
  czy_dziala BOOLEAN := true; 
  
  TYPE myszy_wiersz IS RECORD (nr_myszy Myszy.nr_myszy%TYPE, lowca Myszy.lowca%TYPE, 
                              zjadacz Myszy.zjadacz%TYPE, waga_myszy Myszy.waga_myszy%TYPE, 
                              data_zlowienia Myszy.data_zlowienia%TYPE, data_wydania Myszy.data_wydania%TYPE); 
  TYPE tablica_myszy IS TABLE OF myszy_wiersz INDEX BY BINARY_INTEGER; 
  dane_myszy tablica_myszy; 
  
  TYPE kocury_info IS RECORD (pseudo Kocury.pseudo%TYPE, myszy NUMBER(3)); 
  TYPE tablica_kotow IS TABLE OF kocury_info INDEX BY BINARY_INTEGER; 
  dane_kotow tablica_kotow; 
  
  niewlasciwy_dzien EXCEPTION;
BEGIN   
  SELECT * BULK COLLECT INTO dane_myszy 
  FROM Myszy 
  WHERE zjadacz IS NULL; 
  
  SELECT pseudo, NVL(przydzial_myszy,0) + NVL(myszy_extra, 0) 
  BULK COLLECT INTO dane_kotow 
  FROM Kocury 
  WHERE w_stadku_od <= (NEXT_DAY(LAST_DAY(ADD_MONTHS(SYSDATE, -1)) - 7, 'Œroda')) 
  START WITH szef IS NULL 
  CONNECT BY PRIOR pseudo=szef
  ORDER BY LEVEL ASC; 
  
  FOR i IN 1..dane_myszy.COUNT 
    LOOP 
      czy_dziala:=true; 
      l2:=l1; 
      WHILE czy_dziala 
        LOOP 
          IF(l1 > dane_kotow.COUNT) THEN 
            l1 := 1; 
          END IF; 
          IF dane_kotow(l1).myszy > 0 THEN 
            dane_myszy(i).zjadacz := dane_kotow(l1).pseudo; 
            dane_myszy(i).data_wydania := sroda; 
            dane_kotow(l1).myszy := dane_kotow(l1).myszy - 1; 
            czy_dziala:=false; 
          END IF; 
          l1 := l1 + 1; 
          IF l2 = l1 THEN 
            dane_myszy(i).zjadacz := 'TYGRYS'; 
            dane_myszy(i).data_wydania := sroda; 
            czy_dziala:=false; 
          END IF; 
        END LOOP; 
    END LOOP; 
    
    FORALL j IN 1..dane_myszy.COUNT SAVE EXCEPTIONS 
    UPDATE Myszy 
    SET data_wydania = dane_myszy(j).data_wydania, zjadacz = dane_myszy(j).zjadacz 
    WHERE nr_myszy = dane_myszy(j).nr_myszy;
EXCEPTION 
  WHEN niewlasciwy_dzien THEN DBMS_OUTPUT.PUT_LINE('To nie dzien wyplaty'); 
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM); 
END;