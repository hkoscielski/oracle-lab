--Zad. 17. Wyœwietliæ pseudonimy, przydzia³y myszy oraz nazwy band dla kotów operuj¹cych na terenie POLE 
--posiadaj¹cych przydzia³ myszy wiêkszy od 50. 
--Uwzglêdniæ fakt, ¿e s¹ w stadzie koty posiadaj¹ce prawo do polowañ na ca³ym „obs³ugiwanym” przez stado terenie. Nie stosowaæ podzapytañ.
--
--POLUJE W POLU   PRZYDZIAL MYSZY  BANDA
----------------- ---------------- --------------------
--TYGRYS                103        SZEFOSTWO
--LYSY                   72        CZARNI RYCERZE
--PLACEK                 67        CZARNI RYCERZE
--SZYBKA                 65        CZARNI RYCERZE
--RURA                   56        CZARNI RYCERZE

SELECT
  pseudo "POLUJE W POLU",
  przydzial_myszy "PRZYDZIAL MYSZY",
  nazwa "BANDA"
FROM Kocury JOIN Bandy USING(nr_bandy)
WHERE 
  przydzial_myszy > 50
  AND teren IN ('POLE','CALOSC');
  
  
  