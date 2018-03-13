--Zad. 27. Znale�� koty zajmuj�ce pierwszych n miejsc pod wzgl�dem ca�kowitej liczby spo�ywanych myszy 
--(koty o tym samym spo�yciu zajmuj� to samo miejsce!). Zadanie rozwi�za� na cztery sposoby:
--a.	wykorzystuj�c podzapytanie skorelowane,
--b.	wykorzystuj�c pseudokolumn� ROWNUM,
--c.	wykorzystuj�c z��czenie relacji Kocury z relacj� Kocury
--d.	wykorzystuj�c funkcje analityczne.
--
--Prosz� poda� warto�� dla n: 6
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
--7 wierszy zosta�o wybranych.
--
--a.	wykorzystuj�c podzapytanie skorelowane:

SELECT
    pseudo,
    NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) "ZJADA"
FROM Kocury K
WHERE 
    12 > (SELECT COUNT(DISTINCT NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))
         FROM Kocury
         WHERE NVL(K.przydzial_myszy, 0) + NVL(K.myszy_extra, 0) < NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0))
ORDER BY 2 DESC;

--b.	wykorzystuj�c pseudokolumn� ROWNUM:
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
            
--c.	wykorzystuj�c z��czenie relacji Kocury z relacj� Kocury:
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

--d.	wykorzystuj�c funkcje analityczne:
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
    