--Zad. 46. Napisaæ wyzwalacz, który uniemo¿liwi wpisanie kotu przydzia³u myszy spoza przedzia³u (min_myszy, max_myszy) 
--okreœlonego dla ka¿dej funkcji w relacji Funkcje. Ka¿da próba wykroczenia poza obowi¹zuj¹cy przedzia³ ma byæ 
--dodatkowo monitorowana w osobnej relacji (kto, kiedy, jakiemu kotu, jak¹ operacj¹).

DROP TABLE Zad46_historia;
CREATE TABLE Zad46_historia (
    id_zmiany NUMBER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) 
        CONSTRAINT historia_id_pk PRIMARY KEY,
    uzytkownik VARCHAR2(30),
    data_zmiany DATE,
    pseudo VARCHAR2(15) CONSTRAINT historia_ps_fk REFERENCES Kocury(pseudo),
    polecenie VARCHAR2(20)
);

CREATE OR REPLACE TRIGGER Zad46
BEFORE UPDATE OF przydzial_myszy ON Kocury
FOR EACH ROW
DECLARE
    min_przydzial_fun Funkcje.min_myszy%TYPE DEFAULT 0;
    max_przydzial_fun Funkcje.max_myszy%TYPE DEFAULT 0;
    userr Zad46_historia.uzytkownik%TYPE;
    dataZm Zad46_historia.data_zmiany%TYPE;
    pol Zad46_historia.polecenie%TYPE;    
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    SELECT min_myszy, max_myszy INTO min_przydzial_fun, max_przydzial_fun
    FROM Funkcje WHERE funkcja = :NEW.funkcja;  
    
    IF :NEW.przydzial_myszy > max_przydzial_fun
        OR :NEW.przydzial_myszy < min_przydzial_fun THEN
            userr := SYS.LOGIN_USER;
            dataZm := SYSDATE;   
            pol := 'UPDATE';
            INSERT INTO Zad46_historia (uzytkownik, data_zmiany, pseudo, polecenie)
                VALUES (userr, dataZm, :NEW.pseudo, pol);
            COMMIT;
            RAISE_APPLICATION_ERROR(-20105, :NEW.pseudo || ' nie moze miec przydzialu myszy rownego ' || :NEW.przydzial_myszy ||
                                            '. Nie miesci sie on w przedziale od ' || min_przydzial_fun || ' do ' || max_przydzial_fun);
    END IF;
END;

SELECT pseudo, funkcja, NVL(przydzial_myszy, 0), NVL(myszy_extra, 0) FROM Kocury ORDER BY 3 DESC ,4 DESC;
SELECT * FROM Funkcje;
UPDATE Kocury SET przydzial_myszy = 56 WHERE pseudo = 'BOLEK';
SELECT * FROM Zad46_historia;
DELETE FROM Zad46_historia;
ROLLBACK;
COMMIT;
