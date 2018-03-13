--Zad. 26. ZnaleŸæ funkcje (pomijaj¹c SZEFUNIA), z którymi zwi¹zany jest najwy¿szy i najni¿szy œredni ca³kowity przydzia³ myszy. 
--Nie u¿ywaæ operatorów zbiorowych (UNION, INTERSECT, MINUS).
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
