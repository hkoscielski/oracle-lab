--Zad. 45. Tygrys zauwa¿y³ dziwne zmiany wartoœci swojego prywatnego przydzia³u myszy (patrz zadanie 42). 
--Nie niepokoi³y go zmiany na plus ale te na minus by³y, jego zdaniem, niedopuszczalne. 
--Zmotywowa³ wiêc jednego ze swoich szpiegów do dzia³ania i dziêki temu odkry³ niecne praktyki Miluœ (zadanie 42). 
--Poleci³ wiêc swojemu informatykowi skonstruowanie mechanizmu zapisuj¹cego w relacji Dodatki_extra (patrz Wyk³ady - cz. 2) 
--dla ka¿dej z Miluœ -10 (minus dziesiêæ) myszy dodatku extra przy zmianie na plus któregokolwiek z przydzia³ów myszy Miluœ, 
--wykonanej przez innego operatora ni¿ on sam. Zaproponowaæ taki mechanizm, w zastêpstwie za informatyka Tygrysa. 
--W rozwi¹zaniu wykorzystaæ funkcjê LOGIN_USER zwracaj¹c¹ nazwê u¿ytkownika aktywuj¹cego wyzwalacz oraz elementy dynamicznego SQL'a.

CREATE TABLE Dodatki_extra (
    id_dodatku NUMBER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) 
        CONSTRAINT dodatki_id_pk PRIMARY KEY,
    pseudo VARCHAR(15) CONSTRAINT dodatki_ps_fk REFERENCES Kocury(pseudo),
    dod_extra NUMBER(3) CONSTRAINT dodatki_dod_nn NOT NULL
);

CREATE OR REPLACE TRIGGER Zad45
AFTER UPDATE OF przydzial_myszy ON Kocury
FOR EACH ROW
DECLARE 
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN 
    IF :NEW.przydzial_myszy > :OLD.przydzial_myszy
        AND :NEW.funkcja = 'MILUSIA'
        AND LOGIN_USER != 'TYGRYS' THEN
        EXECUTE IMMEDIATE '
            DECLARE                    
                CURSOR milusie IS
                    SELECT pseudo FROM Kocury WHERE funkcja = ''MILUSIA'';
                BEGIN 
                    FOR milusia IN milusie
                    LOOP
                        INSERT INTO Dodatki_extra(pseudo, dod_extra)
                        VALUES (milusia.pseudo, -10);
                    END LOOP;
                 END;';
        COMMIT;
    END IF;
END;

SELECT * FROM Dodatki_extra;
DELETE FROM Dodatki_extra;
COMMIT;
ROLLBACK;