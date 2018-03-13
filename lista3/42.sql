--Zad. 42. Milusie postanowi³y zadbaæ o swoje interesy. Wynajê³y wiêc informatyka, aby zapuœci³ wirusa w system Tygrysa.
--Teraz przy ka¿dej próbie zmiany przydzia³u myszy na plus (o minusie w ogóle nie mo¿e byæ mowy) 
--o wartoœæ mniejsz¹ ni¿ 10% przydzia³u myszy Tygrysa ¿al Miluœ ma byæ utulony podwy¿k¹ ich przydzia³u o t¹ wartoœæ 
--oraz podwy¿k¹ myszy extra o 5. Tygrys ma byæ ukarany strat¹ wspomnianych 10%. Jeœli jednak podwy¿ka bêdzie satysfakcjonuj¹ca, 
--przydzia³ myszy extra Tygrysa ma wzrosn¹æ o 5.
--
--Zaproponowaæ dwa rozwi¹zania zadania, które omin¹ podstawowe ograniczenie dla wyzwalacza wierszowego aktywowanego poleceniem DML 
--tzn. brak mo¿liwoœci odczytu lub zmiany relacji, na której operacja (polecenie DML) „wyzwala” ten wyzwalacz. 
--W pierwszym rozwi¹zaniu (klasycznym) wykorzystaæ kilku wyzwalaczy i pamiêæ w postaci specyfikacji dedykowanego zadaniu pakietu, 
--w drugim wykorzystaæ wyzwalacz COMPOUND. 
--
--Podaæ przyk³ad funkcjonowania wyzwalaczy a nastêpnie zlikwidowaæ wprowadzone przez nie zmiany.
SET SERVEROUTPUT ON;
ALTER TRIGGER Zad42a_after_update ENABLE;
ALTER TRIGGER Zad42a_before_update ENABLE;
ALTER TRIGGER Zad42a_before_update_each_row ENABLE;
ALTER TRIGGER Zad42b_compound DISABLE;

CREATE OR REPLACE PACKAGE Zad42a AS
    przydzial_tygrysa NUMBER DEFAULT 0;
    kara_dla_tygrysa NUMBER DEFAULT 0;
    nagroda_dla_tygrysa NUMBER DEFAULT 0;
END;
/
CREATE OR REPLACE TRIGGER Zad42a_before_update
BEFORE UPDATE ON Kocury
BEGIN 
    SELECT NVL(przydzial_myszy, 0) INTO Zad42a.przydzial_tygrysa
    FROM Kocury WHERE pseudo = 'TYGRYS';
END;
/
CREATE OR REPLACE TRIGGER Zad42a_before_update_each_row
BEFORE UPDATE ON Kocury
FOR EACH ROW
DECLARE
    min_przydzial_fun Funkcje.min_myszy%TYPE DEFAULT 0;
    max_przydzial_fun Funkcje.max_myszy%TYPE DEFAULT 0;
    roznica NUMBER DEFAULT 0;
BEGIN
    SELECT min_myszy, max_myszy INTO min_przydzial_fun, max_przydzial_fun
    FROM Funkcje WHERE funkcja = :NEW.funkcja;    
    
    IF :NEW.funkcja = 'MILUSIA' THEN
        IF :NEW.przydzial_myszy < :OLD.przydzial_myszy THEN
            :NEW.przydzial_myszy := :OLD.przydzial_myszy;
            DBMS_OUTPUT.PUT_LINE('Nie ma mowy o obnizce na minus dla kota ' || :NEW.pseudo);
        END IF;
        
        roznica := :NEW.przydzial_myszy - :OLD.przydzial_myszy;
        IF (roznica > 0) AND (roznica < 0.1 * Zad42a.przydzial_tygrysa) THEN
            DBMS_OUTPUT.PUT_LINE('Kara dla Tygrysa za zmiane dla kota ' || :NEW.pseudo
                || ' z ' || :OLD.przydzial_myszy || ' na ' || :NEW.przydzial_myszy);
            Zad42a.kara_dla_tygrysa := Zad42a.kara_dla_tygrysa + 1;
            :NEW.przydzial_myszy := :NEW.przydzial_myszy + 0.1 * Zad42a.przydzial_tygrysa;
            :NEW.myszy_extra := :NEW.myszy_extra + 5;
        ELSIF (roznica > 0) AND (roznica >= 0.1 * Zad42a.przydzial_tygrysa) THEN
            DBMS_OUTPUT.PUT_LINE('Nagroda dla Tygrysa za satysfakcjonujaca zmiane dla kota ' || :NEW.pseudo
                || ' z ' || :OLD.przydzial_myszy || ' na ' || :NEW.przydzial_myszy);
            Zad42a.nagroda_dla_tygrysa := Zad42a.nagroda_dla_tygrysa + 1;
        END IF;
        
        IF :NEW.przydzial_myszy < min_przydzial_fun THEN
            :NEW.przydzial_myszy := min_przydzial_fun;
        ELSIF :NEW.przydzial_myszy > max_przydzial_fun THEN
            :NEW.przydzial_myszy := max_przydzial_fun;
        END IF;
    END IF;  
END;
/
CREATE OR REPLACE TRIGGER Zad42a_after_update
AFTER UPDATE ON Kocury
DECLARE
    temp NUMBER DEFAULT 0;
BEGIN
    IF Zad42a.kara_dla_tygrysa > 0 THEN
        temp := Zad42a.kara_dla_tygrysa;
        Zad42a.kara_dla_tygrysa := 0;
        UPDATE Kocury SET przydzial_myszy = przydzial_myszy * (1 - (0.1 * temp))
        WHERE pseudo = 'TYGRYS';
    END IF;
    
    IF Zad42a.nagroda_dla_tygrysa > 0 THEN
        temp := Zad42a.nagroda_dla_tygrysa;
        Zad42a.nagroda_dla_tygrysa := 0;
        UPDATE Kocury SET myszy_extra = myszy_extra + (temp * 5)
        WHERE pseudo = 'TYGRYS';
    END IF;
END;

SELECT pseudo, funkcja, NVL(przydzial_myszy, 0), NVL(myszy_extra, 0) FROM Kocury ORDER BY 3 DESC ,4 DESC;
SELECT * FROM Funkcje;
UPDATE Kocury SET przydzial_myszy = przydzial_myszy + 1 WHERE pseudo = 'LOLA';
ROLLBACK;

--b. COUMPOUND TRIGGER

ALTER TRIGGER Zad42a_after_update DISABLE;
ALTER TRIGGER Zad42a_before_update DISABLE;
ALTER TRIGGER Zad42a_before_update_each_row DISABLE;
ALTER TRIGGER Zad42b_compound ENABLE;

CREATE OR REPLACE TRIGGER Zad42b_compound
FOR UPDATE ON Kocury
COMPOUND TRIGGER
    przydzial_tygrysa NUMBER DEFAULT 0;
    kara_dla_tygrysa NUMBER DEFAULT 0;
    nagroda_dla_tygrysa NUMBER DEFAULT 0;
    min_przydzial_fun Funkcje.min_myszy%TYPE DEFAULT 0;
    max_przydzial_fun Funkcje.max_myszy%TYPE DEFAULT 0;
    roznica NUMBER DEFAULT 0;
    temp NUMBER DEFAULT 0;
    
    BEFORE STATEMENT IS
    BEGIN
        SELECT NVL(przydzial_myszy, 0) INTO przydzial_tygrysa
        FROM Kocury WHERE pseudo = 'TYGRYS';
    END BEFORE STATEMENT;
    
    BEFORE EACH ROW IS
    BEGIN 
        SELECT min_myszy, max_myszy INTO min_przydzial_fun, max_przydzial_fun
        FROM Funkcje WHERE funkcja = :NEW.funkcja;    
        
        IF :NEW.funkcja = 'MILUSIA' THEN
            IF :NEW.przydzial_myszy < :OLD.przydzial_myszy THEN
                :NEW.przydzial_myszy := :OLD.przydzial_myszy;
                DBMS_OUTPUT.PUT_LINE('Nie ma mowy o obnizce na minus dla kota ' || :NEW.pseudo);
            END IF;
            
            roznica := :NEW.przydzial_myszy - :OLD.przydzial_myszy;
            IF (roznica > 0) AND (roznica < 0.1 * przydzial_tygrysa) THEN
                DBMS_OUTPUT.PUT_LINE('Kara dla Tygrysa za zmiane dla kota ' || :NEW.pseudo
                    || ' z ' || :OLD.przydzial_myszy || ' na ' || :NEW.przydzial_myszy);
                kara_dla_tygrysa := kara_dla_tygrysa + 1;
                :NEW.przydzial_myszy := :NEW.przydzial_myszy + 0.1 * przydzial_tygrysa;
                :NEW.myszy_extra := :NEW.myszy_extra + 5;
            ELSIF (roznica > 0) AND (roznica >= 0.1 * przydzial_tygrysa) THEN
                DBMS_OUTPUT.PUT_LINE('Nagroda dla Tygrysa za satysfakcjonujaca zmiane dla kota ' || :NEW.pseudo
                    || ' z ' || :OLD.przydzial_myszy || ' na ' || :NEW.przydzial_myszy);
                nagroda_dla_tygrysa := nagroda_dla_tygrysa + 1;
            END IF;
            
            IF :NEW.przydzial_myszy < min_przydzial_fun THEN
                :NEW.przydzial_myszy := min_przydzial_fun;
            ELSIF :NEW.przydzial_myszy > max_przydzial_fun THEN
                :NEW.przydzial_myszy := max_przydzial_fun;
            END IF;
        END IF;  
    END BEFORE EACH ROW;
    
    AFTER STATEMENT IS 
    BEGIN 
        IF kara_dla_tygrysa > 0 THEN
            temp := kara_dla_tygrysa;
            kara_dla_tygrysa := 0;
            UPDATE Kocury SET przydzial_myszy = przydzial_myszy * (1 - (0.1 * temp))
            WHERE pseudo = 'TYGRYS';
        END IF;
        
        IF nagroda_dla_tygrysa > 0 THEN
            temp := nagroda_dla_tygrysa;
            nagroda_dla_tygrysa := 0;
            UPDATE Kocury SET myszy_extra = myszy_extra + (temp * 5)
            WHERE pseudo = 'TYGRYS';
        END IF;
    END AFTER STATEMENT;    
END Zad42b_compound;  

SELECT pseudo, funkcja, NVL(przydzial_myszy, 0), NVL(myszy_extra, 0) FROM Kocury ORDER BY 3 DESC ,4 DESC;
SELECT * FROM Funkcje;
UPDATE Kocury SET przydzial_myszy = przydzial_myszy + 1 WHERE pseudo = 'PUSZYSTA';
ROLLBACK;
