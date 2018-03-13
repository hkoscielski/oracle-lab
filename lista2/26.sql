--Zad. 26. Znale�� funkcje (pomijaj�c SZEFUNIA), z kt�rymi zwi�zany jest najwy�szy i najni�szy �redni ca�kowity przydzia� myszy. 
--Nie u�ywa� operator�w zbiorowych (UNION, INTERSECT, MINUS).
--
--Funkcja    Srednio najw. i najm. myszy
------------ ---------------------------
--KOT                                 41
--BANDZIOR                            91

SELECT
    funkcja,
    ROUND(AVG(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))) "Srednio najw. i najm. myszy"
FROM Kocury NATURAL JOIN Funkcje
GROUP BY funkcja
HAVING 
    AVG(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)) IN (
      (SELECT MIN(AVG(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)))
       FROM Kocury NATURAL JOIN Funkcje
       WHERE funkcja != 'SZEFUNIO'
       GROUP BY funkcja),
      (SELECT MAX(AVG(NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0)))
       FROM Kocury NATURAL JOIN Funkcje
       WHERE funkcja != 'SZEFUNIO'
       GROUP BY funkcja)
    );
    
--OK
