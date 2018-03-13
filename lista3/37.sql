--Zad. 37. Napisaæ blok, który powoduje wybranie w pêtli kursorowej FOR piêciu kotów o najwy¿szym ca³kowitym przydziale myszy. 
--Wynik wyœwietliæ na ekranie.
--
--Nr  Psedonim   Zjada
----------------------
--1   TYGRYS      136
--2   LYSY         93
--3   ZOMBI        88
--4   LOLA         72
--5   PLACEK       67

DECLARE
    sa_kocury BOOLEAN DEFAULT FALSE;
    kocury_not_found EXCEPTION;
    ile NUMBER:=0;
BEGIN
  DBMS_OUTPUT.PUT_LINE(RPAD('Nr', 4) ||  RPAD('Pseudonim', 12) || 'Zjada');
  DBMS_OUTPUT.PUT_LINE(LPAD(' ', 22, '-'));
  
  FOR kot IN (SELECT 
                pseudo,
                NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) zjada
              FROM Kocury 
              ORDER BY 2 DESC)
  LOOP
    sa_kocury := TRUE;
    DBMS_OUTPUT.PUT_LINE(RPAD(ile + 1, 4) || RPAD(kot.pseudo, 12) || LPAD(kot.zjada, 5));
    ile := ile + 1;
    EXIT WHEN ile = 5;
  END LOOP;
  IF NOT sa_kocury THEN
    RAISE kocury_not_found;
  END IF;
EXCEPTION
    WHEN kocury_not_found
        THEN DBMS_OUTPUT.PUT_LINE('Nie znaleziono kocurow');
    WHEN OTHERS
        THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
  