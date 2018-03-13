--Zad. 45. Tygrys zauwa�y� dziwne zmiany warto�ci swojego prywatnego przydzia�u myszy (patrz zadanie 42). 
--Nie niepokoi�y go zmiany na plus ale te na minus by�y, jego zdaniem, niedopuszczalne. 
--Zmotywowa� wi�c jednego ze swoich szpieg�w do dzia�ania i dzi�ki temu odkry� niecne praktyki Milu� (zadanie 42). 
--Poleci� wi�c swojemu informatykowi skonstruowanie mechanizmu zapisuj�cego w relacji Dodatki_extra (patrz Wyk�ady - cz. 2) 
--dla ka�dej z Milu� -10 (minus dziesi��) myszy dodatku extra przy zmianie na plus kt�regokolwiek z przydzia��w myszy Milu�, 
--wykonanej przez innego operatora ni� on sam. Zaproponowa� taki mechanizm, w zast�pstwie za informatyka Tygrysa. 
--W rozwi�zaniu wykorzysta� funkcj� LOGIN_USER zwracaj�c� nazw� u�ytkownika aktywuj�cego wyzwalacz oraz elementy dynamicznego SQL'a.

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