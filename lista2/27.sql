--Zad. 27. ZnaleŸæ koty zajmuj¹ce pierwszych n miejsc pod wzglêdem ca³kowitej liczby spo¿ywanych myszy 
--(koty o tym samym spo¿yciu zajmuj¹ to samo miejsce!). Zadanie rozwi¹zaæ na cztery sposoby:
--a.	wykorzystuj¹c podzapytanie skorelowane,
--b.	wykorzystuj¹c pseudokolumnê ROWNUM,
--c.	wykorzystuj¹c z³¹czenie relacji Kocury z relacj¹ Kocury
--d.	wykorzystuj¹c funkcje analityczne.
--
--Proszê podaæ wartoœæ dla n: 6
--
--PSEUDO               ZJADA
----------------- ----------
--TYGRYS                 136
--LYSY                    93
--ZOMBI                   88
--LOLA                    72
--PLACEK                  67
--SZYBKA                  65
--RAFA                    65
--
--7 wierszy zosta³o wybranych.
--
--a.	wykorzystuj¹c podzapytanie skorelowane:

SELECT
    pseudo,
    NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) "ZJADA"
FROM Kocury K
WHERE 
    12 > (SELECT COUNT(DISTINCT NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))
         FROM Kocury
         WHERE NVL(K.przydzial_myszy, 0) + NVL(K.myszy_extra, 0) < NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))
ORDER BY 2 DESC;

--b.	wykorzystuj¹c pseudokolumnê ROWNUM:
SELECT   
    pseudo,
    NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) "ZJADA"
FROM Kocury 
WHERE       
    NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) IN (
                SELECT przydzial
                FROM (SELECT NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) przydzial
                      FROM Kocury
                      ORDER BY 1 DESC)
                WHERE ROWNUM < 13
            );
            
--c.	wykorzystuj¹c z³¹czenie relacji Kocury z relacj¹ Kocury:
SELECT 
    pseudo,
    zjada
FROM (SELECT
          K1.pseudo,           
          MIN(NVL(K1.przydzial_myszy, 0) + NVL(K1.myszy_extra, 0)) zjada,
          COUNT(DISTINCT NVL(K2.przydzial_myszy, 0) + NVL(K2.myszy_extra, 0)) ile
      FROM Kocury K1, Kocury K2
      WHERE NVL(K1.przydzial_myszy, 0) + NVL(K1.myszy_extra, 0) <= NVL(K2.przydzial_myszy, 0) + NVL(K2.myszy_extra, 0)
      GROUP BY K1.pseudo)
WHERE ile < 12
ORDER BY 2 DESC;

--d.	wykorzystuj¹c funkcje analityczne:
SELECT
    pseudo,
    zjada
FROM (
    SELECT 
        pseudo,
        NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) zjada,
        DENSE_RANK()
        OVER (ORDER BY NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) DESC) ktory
    FROM Kocury)
WHERE ktory < 7;
    