--Zad. 17. Wy�wietli� pseudonimy, przydzia�y myszy oraz nazwy band dla kot�w operuj�cych na terenie POLE 
--posiadaj�cych przydzia� myszy wi�kszy od 50. 
--Uwzgl�dni� fakt, �e s� w stadzie koty posiadaj�ce prawo do polowa� na ca�ym �obs�ugiwanym� przez stado terenie. Nie stosowa� podzapyta�.
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
  
  
  