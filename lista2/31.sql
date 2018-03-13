--Zad. 31. Zdefiniowa� perspektyw� wybieraj�c� nast�puj�ce dane: 
--nazw� bandy, �redni, maksymalny i minimalny przydzia� myszy w bandzie, 
--ca�kowit� liczb� kot�w w bandzie oraz liczb� kot�w pobieraj�cych w bandzie przydzia�y dodatkowe. 
--Pos�uguj�c si� zdefiniowan� perspektyw� wybra� nast�puj�ce dane o kocie, 
--kt�rego pseudonim podawany jest interaktywnie z klawiatury: pseudonim, imi�, funkcja, przydzia� myszy, 
--minimalny i maksymalny przydzia� myszy w jego bandzie oraz dat� wst�pienia do stada.
--
--Zawarto�� perspektywy:
--
--NAZWA_BANDY            SRE_SPOZ   MAX_SPOZ   MIN_SPOZ       KOTY KOTY_Z_DOD
---------------------- ---------- ---------- ---------- ---------- ----------
--SZEFOSTWO                    50        103         22          4          3
--BIALI LOWCY               49,75         75         20          4          2
--CZARNI RYCERZE             56,8         72         24          5          2
--LACIACI MYSLIWI            49,4         65         40          5          0
--
--Wynik dla pseudonimu PLACEK:
--
--PSEUDONIM           IMIE       FUNKCJA    ZJADA GRANICE SPOZYCIA LOWI OD
--------------------- ---------- ---------- ----- ---------------- ----------
--PLACEK              JACEK      LOWCZY        67   OD 24 DO  72   2008-12-01

CREATE OR REPLACE VIEW PrzydzialyBand(nazwa_bandy, sre_spoz, max_spoz, min_spoz, koty, koty_z_dod)
AS SELECT
        nazwa,
        AVG(NVL(przydzial_myszy,0)),
        MAX(NVL(przydzial_myszy,0)),
        MIN(NVL(przydzial_myszy,0)),
        COUNT(pseudo),
        COUNT(myszy_extra)
    FROM Kocury JOIN Bandy USING(nr_bandy)
    GROUP BY nazwa;

SELECT 
    pseudo "PSEUDONIM",
    imie,
    funkcja,
    NVL(przydzial_myszy,0) "ZJADA",
    'OD ' || min_spoz || ' DO ' || max_spoz "GRANICE SPOZYCIA",
    w_stadku_od "LOWI OD"
FROM Bandy B JOIN PrzydzialyBand PB ON B.nazwa = PB.nazwa_bandy
     JOIN Kocury USING(nr_bandy)
WHERE pseudo = '&pseudonim';     
