--Zad. 25. ZnaleŸæ koty, których przydzia³ myszy jest nie mniejszy od potrojonego najwy¿szego przydzia³u 
--spoœród przydzia³ów wszystkich MILUŒ operuj¹cych w SADZIE. Nie stosowaæ funkcji MAX.
--
--IMIE       FUNKCJA    PRZYDZIAL MYSZY
------------ ---------- ---------------
--KOREK      BANDZIOR                75
--MRUCZEK    SZEFUNIO               103

SELECT
    imie,
    funkcja,
    NVL(przydzial_myszy, 0) "PRZYDZIAL MYSZY"
FROM Kocury
WHERE NVL(przydzial_myszy/3, 0) >= ALL(SELECT NVL(przydzial_myszy, 0)
                                      FROM Kocury JOIN Bandy USING(nr_bandy)
                                      WHERE 
                                        funkcja = 'MILUSIA'
                                        AND teren IN ('SAD', 'CALOSC'));
