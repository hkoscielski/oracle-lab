-- Tworzenie relacji Myszy

DECLARE 
    myszy VARCHAR2(1500);
BEGIN
    myszy := 'CREATE TABLE Myszy (
			    nr_myszy NUMBER CONSTRAINT myszy_nr_myszy_pk PRIMARY KEY,
			    lowca VARCHAR2(15) CONSTRAINT myszy_lowca_fk REFERENCES Kocury(pseudo),
			    zjadacz VARCHAR2(15) CONSTRAINT myszy_zjadacz_fk REFERENCES Kocury(pseudo),
			    waga_myszy NUMBER(2) CONSTRAINT myszy_waga_myszy_ch CHECK (waga_myszy BETWEEN 30 AND 60),
			    data_zlowienia DATE CONSTRAINT myszy_data_zlowienia_nn NOT NULL,
			    data_wydania DATE CONSTRAINT myszy_data_wydania_ch CHECK (data_wydania = (NEXT_DAY(LAST_DAY(data_wydania) - 7, ''Wednesday''))),
			    CONSTRAINT myszy_daty_ch CHECK (data_zlowienia <= data_wydania))';
	EXECUTE IMMEDIATE myszy;
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

-- Tworzenie indywidualnej dla kazdego kota relacji myszy

DECLARE 
  myszy_pseudo VARCHAR2(3000); 
BEGIN 
  FOR kot IN (SELECT pseudo FROM Kocury) 
    LOOP       
      myszy_pseudo:='CREATE TABLE Myszy_' || kot.pseudo ||'( 
                      nr_myszy NUMBER CONSTRAINT myszy_' || kot.pseudo || '_nr_myszy_pk PRIMARY KEY,
                      lowca VARCHAR2(15) CONSTRAINT myszy_' || kot.pseudo || '_lowca_fk REFERENCES KOCURY(pseudo), 
                      waga_myszy NUMBER(3) CONSTRAINT myszy_' || kot.pseudo || '_waga_ch CHECK (waga_myszy BETWEEN 30 AND 60), 
                      data_zlowienia DATE CONSTRAINT myszy_' || kot.pseudo || '_data_nn NOT NULL)'; 
      EXECUTE IMMEDIATE myszy_pseudo;       
    END LOOP;
EXCEPTION 
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM); 
END;

-- Usuniecie indywidualnych

DECLARE 
  myszy_pseudo VARCHAR2(3000); 
BEGIN 
  FOR kot IN (SELECT pseudo FROM Kocury ORDER BY 1 ASC) 
    LOOP 
      myszy_pseudo:='DROP TABLE Myszy_' || kot.pseudo;
      EXECUTE IMMEDIATE myszy_pseudo; 
    END LOOP;
EXCEPTION 
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM); 
END;