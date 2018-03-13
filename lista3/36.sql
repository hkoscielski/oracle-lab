--Zad. 36. W zwi�zku z du�� wydajno�ci� w �owieniu myszy SZEFUNIO postanowi� wynagrodzi� swoich podw�adnych. 
--Og�osi� wi�c, �e podwy�sza indywidualny przydzia� myszy ka�dego kota o 10% poczynaj�c od kot�w o najni�szym przydziale. 
--Je�li w kt�rym� momencie suma wszystkich przydzia��w przekroczy 1050, �aden inny kot nie dostanie podwy�ki. 
--Je�li przydzia� myszy po podwy�ce przekroczy maksymaln� warto�� nale�n� dla pe�nionej funkcji (relacja Funkcje), 
--przydzia� myszy po podwy�ce ma by� r�wny tej warto�ci. Napisa� blok PL/SQL z kursorem, 
--kt�ry wyznacza sum� przydzia��w przed podwy�k� a realizuje to zadanie. 
--Blok ma dzia�a� tak d�ugo, a� suma wszystkich przydzia��w rzeczywi�cie przekroczy 1050 
--(liczba �obieg�w podwy�kowych� mo�e by� wi�ksza od 1 a wi�c i podwy�ka mo�e by� wi�ksza ni� 10%). 
--Wy�wietli� na ekranie sum� przydzia��w myszy po wykonaniu zadania wraz z liczb� podwy�ek (liczb� zmian w relacji Kocury). 
--Na ko�cu wycofa� wszystkie zmiany.
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
