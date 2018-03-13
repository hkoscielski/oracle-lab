--Zad. 36. W zwi¹zku z du¿¹ wydajnoœci¹ w ³owieniu myszy SZEFUNIO postanowi³ wynagrodziæ swoich podw³adnych. 
--Og³osi³ wiêc, ¿e podwy¿sza indywidualny przydzia³ myszy ka¿dego kota o 10% poczynaj¹c od kotów o najni¿szym przydziale. 
--Jeœli w którymœ momencie suma wszystkich przydzia³ów przekroczy 1050, ¿aden inny kot nie dostanie podwy¿ki. 
--Jeœli przydzia³ myszy po podwy¿ce przekroczy maksymaln¹ wartoœæ nale¿n¹ dla pe³nionej funkcji (relacja Funkcje), 
--przydzia³ myszy po podwy¿ce ma byæ równy tej wartoœci. Napisaæ blok PL/SQL z kursorem, 
--który wyznacza sumê przydzia³ów przed podwy¿k¹ a realizuje to zadanie. 
--Blok ma dzia³aæ tak d³ugo, a¿ suma wszystkich przydzia³ów rzeczywiœcie przekroczy 1050 
--(liczba „obiegów podwy¿kowych” mo¿e byæ wiêksza od 1 a wiêc i podwy¿ka mo¿e byæ wiêksza ni¿ 10%). 
--Wyœwietliæ na ekranie sumê przydzia³ów myszy po wykonaniu zadania wraz z liczb¹ podwy¿ek (liczb¹ zmian w relacji Kocury). 
--Na koñcu wycofaæ wszystkie zmiany.
--
--Calk. przydzial w stadku 1057  Zmian - 30
--
--IMIE            Myszki po podwyzce
----------------- ------------------
--MRUCZEK                        110
--CHYTRY                          55
--KOREK                           90
--BOLEK                           87
--ZUZIA                           70
--RUDA                            26
--PUCEK                           70
--PUNIA                           70
--BELA                            29
--KSAWERY                         60
--MELA                            60
--JACEK                           70
--BARI                            60
--MICKA                           30
--LUCEK                           50
--SONIA                           24
--LATKA                           48
--DUDEK                           48

DECLARE
    CURSOR do_podwyzki IS
        SELECT * 
        FROM Kocury K JOIN Funkcje F ON K.funkcja = F.funkcja 
        ORDER BY przydzial_myszy
        FOR UPDATE OF przydzial_myszy;
    rekord do_podwyzki%ROWTYPE;
    ile_zmian NUMBER DEFAULT 0;
    suma_przydzialow NUMBER;    
    nowy_przydzial Kocury.przydzial_myszy%TYPE;
BEGIN
    SELECT SUM(przydzial_myszy) INTO suma_przydzialow FROM Kocury;
    <<zewn>>LOOP
        OPEN do_podwyzki;        
        LOOP
            IF suma_przydzialow > 1050 THEN
                EXIT zewn;
            END IF;
            
            FETCH do_podwyzki INTO rekord;
            EXIT WHEN do_podwyzki%NOTFOUND;
            
            nowy_przydzial := 1.1 * NVL(rekord.przydzial_myszy, 0);
            IF nowy_przydzial > rekord.max_myszy THEN
                nowy_przydzial := rekord.max_myszy;
            END IF;
            
            IF rekord.przydzial_myszy != nowy_przydzial THEN
                UPDATE Kocury SET przydzial_myszy = nowy_przydzial WHERE CURRENT OF do_podwyzki;
                ile_zmian := ile_zmian + 1;
            END IF;            
            
            SELECT SUM(przydzial_myszy) INTO suma_przydzialow FROM Kocury;
        END LOOP;
        CLOSE do_podwyzki;
    END LOOP zewn;
    
    DBMS_OUTPUT.PUT_LINE('Calk. przydzial w stadku ' || suma_przydzialow || '  Zmian - ' || ile_zmian);
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE(RPAD('IMIE', 15) || ' Myszki po podwyzce');
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 15, '-') || ' ' || LPAD('-', 18, '-'));
    FOR kocur IN (SELECT 
                    imie, 
                    NVL(przydzial_myszy, 0) przydzial
                  FROM Kocury 
                  ORDER BY 2 DESC)
    LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(kocur.imie, 15) || ' ' || LPAD(kocur.przydzial, 18));
    END LOOP;
    
EXCEPTION
    WHEN OTHERS
        THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

ROLLBACK;

SELECT pseudo, NVL(przydzial_myszy, 0) FROM Kocury ORDER BY 2;
